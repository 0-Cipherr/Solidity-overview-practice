// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

//1e18 means 1 times 10 raised to the 18
contract YieldVault is ERC4626 {
    //vault asset is the asset users can deposit and withdraw
    IERC20 _vaultAsset;

    uint256 _yieldPerBlock = 190259; // 0.00000190259

    constructor(
        IERC20 vaultAsset_,
        string memory name_,
        string memory symbol_
    ) ERC4626(_vaultAsset) ERC20(name_, symbol_) {
        _vaultAsset = vaultAsset_;
    }

    //beofore we do any withdraw or deposit we gonna test the equations prevent any underflow or overflow
    //precise arethmetic

    function testCalculation() public returns (uint256) {
        //test calculation
        return _yieldPerBlock * 1e18;
    }
}
