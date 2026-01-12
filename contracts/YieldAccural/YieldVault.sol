// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//1e18 means 1 times 10 raised to the 18
contract YieldVault is ERC4626 {
    mapping(address => uint256) _vaultBalance;
    string _name;
    string _symbol;
    // using uint256 for Math;
    //vault asset is the asset users can deposit and withdraw
    IERC20 _vaultAsset;
    address _vaultAddress;
    uint256 _yieldPerBL = 1902590000000; // 0.00000190259 x 1e18 (erc20 scale 18 decimals 10^18)

    event assetDeposited(uint256 _amount, uint256 _depositTimestamp);
    event assetWithdrawn(uint256 _amount, uint256 _withdrawTimeStamp);

    struct UserVaultBalances {
        uint256 _assetsDeposited;
        uint256 _sharesBalance;
    }

    //some modifiers can  be uesecery but it makes tx cheaper as it checks before doing tx
    modifier isApproved(uint256 _amount) {
        uint256 _allowance = _vaultAsset.allowance(msg.sender, _vaultAddress);
        _;
    }

    uint256 _totalAssets;
    uint256 _totalShares;

    constructor(
        IERC20 vaultAsset_,
        string memory name_,
        string memory symbol_
    ) ERC4626(_vaultAsset) ERC20(name_, symbol_) {
        _vaultAsset = vaultAsset_;
        _vaultAddress = address(this);
        _name = name_;
        _symbol = symbol_;
    }

    //beofore we do any withdraw or deposit we gonna test the equations prevent any underflow or overflow
    //precise arethmetic

    //keep function for reference when  u need
    function testCalculation() public pure returns (uint256[2] memory) {
        uint256 _yieldPerBlock = 1902590000000; // 0.00000190259

        uint256 _totalAssets = 1200;
        //handling decimals and whole number arethmetic involves scaling  both valuess to the similar scale when adding
        //when multiplying a decimal by  a whole number the whole number doesnt have to be scaled the  decimal only  has to be scaled
        uint256 __anualBlocks = 2628000;
        uint256 _calculation = (((_yieldPerBlock) * (__anualBlocks)) *
            _totalAssets);
        //test calculation
        //still small error present gets wrong value recalculate make sure right value gets   printed but scaled version
        //the calculation dived by the scale returns the rounded down whole number
        return [_calculation, _calculation / 1e18];
        //result we are supposed to get 5.00000652× 1200 = 6000.078
        //our  functions result 600000782400000000000000000000000n
        ////6000007824000000000000n /1e18 = 6000 (rounded down cuz decmals dont exist in solidity)
    }

    function _depositAssets(uint256 _amount) public isApproved(_amount) {
        //all first two params are the owners
        _deposit(msg.sender, msg.sender, _amount, _amount);
        _vaultBalance[msg.sender] += _amount;
        _totalAssets += _amount;
        _totalShares += _amount;
    }

    function _withdrawAssets() public {}

    function _getVaultBalances() public view {
        uint256 _sharesBalance = balanceOf(msg.sender);
        //retuurns how much user has depsited into the vault and how many shares they own
        UserVaultBalances memory _balances = UserVaultBalances(
            _vaultBalance[msg.sender],
            _sharesBalance
        );
    }

    function _updateYield() private {}
}
