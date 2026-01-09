// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./IERC20Asset.sol";

contract SimpleVault {
    //u can use multiple modifiers in a function make a modifier for verifying if spending approval is active before doing deposits

    address _owner;
    IERC20Asset _asset;
    address _vaultAddress;
    //tracks tvl for vault
    uint256 _tvl;
    mapping(address => uint256) _vaultBalance;

    event AssetDeposited(uint256 _amount, uint256 _depositTimestamp);

    event AssetWithdrawn(uint256 _amount, uint256 _withdrawTimestamp);
    modifier OnlyOwner() {
        require(
            msg.sender == _owner,
            "Unathorized! Must be owner to complete transaction!"
        );

        _;
    }

    modifier HasDepositAmount(uint256 _amount) {
        //get balance of using the deployed contracts interface
        uint256 __userBalance = _asset.balanceOf(msg.sender);
        require(
            __userBalance > 0,
            "No Assets deposited in vault must deposit before withdawing!"
        );
        require(
            _amount <= __userBalance,
            "Not enough tokens to deposit into vault!"
        );

        _;
    }

    modifier HaveWithdrawAmount(uint256 _amount) {
        uint256 _amountDeposited = _vaultBalance[msg.sender];
        require(
            _amount <= _amountDeposited,
            "Withdrawl amount is larger than amount available!"
        );

        _;
    }

    modifier HasUserDeposited() {
        uint256 _amountDeposited = _vaultBalance[msg.sender];
        require(
            _amountDeposited > 0,
            "You have no tokens deposited in the vault!"
        );

        _;
    }

    modifier IsApproved(uint256 _amount) {
        uint256 _allowance = _asset.allowance(msg.sender, _vaultAddress);
        require(
            _allowance >= _amount,
            "Allwance is not enough to complete transaction"
        );

        _;
    }

    constructor(address _vaultAsset) {
        //set owner to contract deployer
        _owner = msg.sender;
        _asset = IERC20Asset(_vaultAsset);
        //store this contracts address
        _vaultAddress = address(this);
    }

    //uses Has amount modifier to determine if user has the amount they intended to deposit
    //if they dont error is thrown and transaction reverts
    function _deposit(
        uint256 _amount
    ) public HasDepositAmount(_amount) IsApproved(_amount) {
        //transfer from user to contact wallet mmust be approved to spend first by this contract before doing deposit  or tx reverts from   modifier
        _asset.transferFrom(msg.sender, _vaultAddress, _amount);
        //update vault balance for address calling
        _vaultBalance[msg.sender] += _amount;
        _tvl += _amount;

        //emit event assets was deposited
        emit AssetDeposited(_amount, block.timestamp);
    }

    //withdraw from vault uses HaveWithdrawlAmount
    //ensures users dont withdrawl more than they have deposited or esle transaction will revert
    function _withdraw(uint256 _amount) public HaveWithdrawAmount(_amount) {
        //do this before to prevent hacks and exploits prevent rentrancy
        _vaultBalance[msg.sender] -= _amount;
        _tvl -= _amount;
        //transfer to wallet withdrawing if they have that amount or greater deposited
        _asset.transfer(msg.sender, _amount);

        emit AssetWithdrawn(_amount, block.timestamp);
    }

    //withdraw all tokens user deposited into vault
    // uses the HasUserDeposited to make sure user has actually deposited into vault
    //if modifier  doesnt have param passed in u dont need the parenthesis
    function _withdrawAll() public HasUserDeposited {
        //store temporarilt current deposited aount before updating vault balances
        uint256 _amountDeposited = _vaultBalance[msg.sender];
        //prevents rentrancy
        _vaultBalance[msg.sender] = 0;
        _tvl -= _amountDeposited;
        //withdraw all tokens
        _asset.transfer(msg.sender, _amountDeposited);
        //emits event asseets was withdrawn
        emit AssetWithdrawn(_amountDeposited, block.timestamp);
    }

    function _getVaultBalance(address _account) public view returns (uint256) {
        return _vaultBalance[_account];
    }

    function _vaultTotalHoldings() public view returns (uint256) {
        return _tvl;
    }
}

// CONTRACT 2: VAULT
// VAULT PROJECT

// Build a vault contract that:

// Accepts an ERC20 token address (like USDC) in the constructor  DONE
// Allows users to deposit that specific token into the vault   DONE
// Tracks each user's deposited balance in the vault  DONE
// Allows users to withdraw their deposited tokens DONE
// Emits an event when deposits happen DONE
// Emits an event when withdrawals happen DONE
// Has a function to check any user's current balance in the vault   DONE
// Has a function to check the vault's total token holdings DONE
// Calls the external ERC20 token contract to transfer tokens in and out  DONE
// Uses appropriate visibility modifiers (public, private, internal, external) CHECK BEFORE TSTING
// Uses appropriate data locations (storage, memory, calldata) where needed CHECK BEOFRE TESTING
// Persists all balances and state between transactions  DONE
// Handles the ERC20 approval pattern correctly (users approve before depositing)  DONE

// The contract should have these capabilities:

// User calls deposit(amount) → vault transfers tokens from user → updates user balance → emits event
// User calls withdraw(amount) → vault checks balance → transfers tokens back → updates user balance → emits event
// Anyone can view balances and vault totals
// State data never resets between function calls
