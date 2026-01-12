// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//1e18 means 1 times 10 raised to the 18
contract YieldVault is ERC4626 {
    //vault asset is the asset users can deposit and withdraw
    IERC20 _vaultAsset;

    constructor(
        IERC20 vaultAsset_,
        string memory name_,
        string memory symbol_
    ) ERC4626(_vaultAsset) ERC20(name_, symbol_) {
        _vaultAsset = vaultAsset_;
    }

    //beofore we do any withdraw or deposit we gonna test the equations prevent any underflow or overflow
    //precise arethmetic

    //keep function for reference when  u need
    function testCalculation() public pure returns (uint256) {
        uint256 _yieldPerBlock = 190259000000; // 0.00000190259

        uint256 _totalAssets = 1200;
        //handling decimals and whole number arethmetic involves scaling  both valuess to the similar scale when adding
        //when multiplying a decimal by  a whole number the whole number doesnt have to be scaled the  decimal only  has to be scaled
        uint256 __anualBlocks = 2628000;
        uint256 _calculation = (((_yieldPerBlock) * (__anualBlocks)) *
            _totalAssets);
        //test calculation
        //still small error present gets wrong value recalculate make sure right value gets   printed but scaled version

        return _calculation;
        //result we are supposed to get 5.00000652× 1200 = 6000.078
        //our  functions result 600000782400000000000000000000000n
    }
}
