// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//this just goes over the concept of updating yield block bsed as oposed to using a bot on the fronted
//to me this is a easier approach
//in our real project we track alot of stuff in structs so we can update yield for each deposit properly and accuratley
//do waht the phase tells u dont do extra shit
//for our real project this will be a different approach uupdating each users yield  earned as opposed to all in one
//because deposits vary so earnings cant be proportional would be unfair and no point in depositing a big amount
contract ERC4626Vault is ERC4626 {
    //we basically increase the value on each block passed update accured yield each block (each time someone calls a function)
    // to prevent earning right away off rip ill store block user deposited
    //500%fixed apy
    //block number  cawas deployed we refer to this to update assets value
    //last block number where we did yield update
    uint256 _lastYieldUpdate;
    // uint256 _fixedApy = 500;
    uint256 _secondsPerBlock = 12;
    //12 seconds per block
    //7200 blocks per day (8600 seconds)
    //we are setting a fixed amount of yield ebecause yield here is fake not real
    //dont need _fixedApy anymore since this is yield per block for 500% apy typa yield
    //when we make our real project yield cant be fixed tll update itself over time blocknumber based no frontend bot needed
    uint256 _yieldPerBlock = 1902590000000000; // (0.00000190259 × 1e18) but had to make whole number because decimals tricky in soldiity
    //yield per block (every 12 seconds) 0.00000190259
    //holds balances for deposits in the vault
    //has built in function to read for users to use
    mapping(address => uint256) _vaultBalances;

    event _assetsDeposited(uint256 _amount, uint256 _depositTimestamp);

    event _assetsWithdrawn(uint256 _amount, uint256 _witdrawTimestamp);

    //stroe the erc20 that we can deposit into the vault
    IERC20 _vaultAsset;

    address private _vaultAddress;

    address public _owner;
    uint256 public _totalAssets;
    uint256 public _totalShares;

    //check this modifier weird bug here

    modifier _isApproved(uint256 _amount) {
        uint256 _approvalAmount = _vaultAsset.allowance(
            msg.sender,
            _vaultAddress
        );
        require(
            _approvalAmount >= _amount,
            "Not enough approved to proceed with TX"
        );
        _;
    }

    modifier _onlyOwner() {
        require(msg.sender == _owner, "Only owner can call this funciton!");

        _;
    }

    modifier _hasDepositBalance() {
        //before withdrawing user must acutally hold the amount of shares tracked
        //the shares token for the 4626 is a erc20 so we can use the shares token built in balance of function
        uint256 _sharesBalanceWallet = balanceOf(msg.sender);
        require(
            _sharesBalanceWallet > 0,
            "No assets deposited in wallet  reverting TX!"
        );
        _;
    }

    //u use an existing erc20 and u deploy a erc20 as well for the erc4626 vault which u gve to usrs on each deposit
    //even tho the 4626 constructor doesnt show it it inherits erc20 so we need a initialization of erc20
    //no need to minto tokens for this asset 4626 automatically handles everything
    //gonna have to send a shit ton of minted tokens to this contract so withdraw doesnt revert since it grows tokens deposited
    constructor(
        IERC20 asset_,
        string memory name_,
        string memory symbol_
    ) ERC4626(asset_) ERC20(name_, symbol_) {
        _vaultAsset = asset_;
        _vaultAddress = address(this);
        _owner = msg.sender;
        _lastYieldUpdate = block.number;
        _totalAssets = 0;
    }

    function _depositAssets(uint256 _amount) public _isApproved(_amount) {
        //deposit
        //params explained: first person calling the function which is user,
        //second : the entity which recieves  the users tokens its gonna deposit which in this case is this vault
        //third : amount we will transfer into our vault
        //fourth: the amount of shares the user will recieve which should be the same as they deposit should be proportional 1:1
        _deposit(msg.sender, _vaultAddress, _amount, _amount);
        //update the total amount user has deposited into the vault in the _vaultBalances mapping
        _vaultBalances[msg.sender] += _amount;
        _totalAssets += _amount;
        _totalShares += _amount;

        _updateYield();
    }

    //how to handle decimals in solidity decimals dont wokr here buddy:
    // -> The easiest approach is to FIRST get both numbers to the same number of decimals and then divide them by the number of decimals at the end of the calculation.
    //each asset has different decimals so check how much decimals ach asset has before handling
    function _updateYield() private {
        //determine any changes in block numbr since lst yield updat
        //see if time has passed since last update
        uint256 _blocksPassed = block.number - _lastYieldUpdate;
        //use if else block to update only if time has passed
        if (_blocksPassed > 0) {
            //tokens here have 18 decimals for shares and erc20
            uint256 _convertedTokensTvl = _totalAssets * 1e18;
            //i alrady converted yieldperblock to 1e18 initially so no need to convert
            //we  dvide by the decimals both yield per block and converted total tvl to return it to regular number format
            uint256 _yieldAcurred = ((_blocksPassed * _yieldPerBlock) *
                (_convertedTokensTvl)) / 1e18;

            //update yield accured
            //yea we do add it
            _totalAssets += _yieldAcurred;
        }
    }

    //witthdra
    function _withdrawAll() public _hasDepositBalance {
        //shares balances of users wallet
        //we are gonna check shares wallet baalnce instead of shares deposited because that means
        //if i use shares dposited and they transferred out tokens and have less im giving more money
        //than what there supposed to be getting
        uint256 _sharesWalletBalance = balanceOf(msg.sender);
        //read comment above for reference why i commented this out
        // uint256 _sharesDeposited = _vaultBalances[msg.sender];
        //calculation to get how much to withdraw
        uint256 _amountToWithdraw = (_sharesWalletBalance * _totalAssets) /
            _totalShares;

        //perform withdraw from  the 4626 vault
        //thrid param is owner this is the owner of the shares one holding the shares that will be burned which is the user
        //last two params: first   is the amount we are gonna end to the user, second is the amount of shares they currently hold
        //prevent rentrancy

        _withdraw(
            _vaultAddress,
            msg.sender,
            msg.sender,
            _amountToWithdraw,
            _sharesWalletBalance
        );

        //update mapping value for user to zero
        _vaultBalances[msg.sender] = 0;
        _totalShares -= _sharesWalletBalance;
        _totalAssets -= _amountToWithdraw;

        //update yield check if blocks have passed (time has passed since last update)
        _updateYield();

        emit _assetsWithdrawn(_amountToWithdraw, block.timestamp);
    }

    function _getDepositBalance() public returns (uint256) {
        //even though mappings has  fucntion made this to update yield on each check for vault
        _updateYield();
        return _vaultBalances[msg.sender];
    }
}
