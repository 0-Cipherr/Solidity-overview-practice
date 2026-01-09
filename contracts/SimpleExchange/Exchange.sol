// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Exchange {
    mapping(address => uint256) _assetReserves;
    //info of the asset better way of storing its info then a bunch of variables wasting space honestly
    //if we did not use the struct approach we would have 4 extra duplicate variables which is no good gas wise
    struct AssetInfo {
        string _name;
        address _asset;
        uint256 _fixedRate;
    }

    //events for two core fucntionalities of the excange
    event SwapExcecuted(uint256 _swapTimestamp);
    event LiquidityAdded(uint256 _LPAddTimestamp);

    AssetInfo _assetA;
    AssetInfo _assetB;

    constructor(AssetInfo memory assetA_, AssetInfo memory assetB_) {
        _assetA = assetA_;
        _assetB = assetB_;
    }

    function _addLiquidity(
        uint256 _amountA,
        uint256 _amountB
    ) public returns (bool) {}

    function _swapAForB() public returns (bool) {}

    function _swapBForA() public returns (bool) {}

    function _getReserves() public {}
}

// Build a simple swap where:

// Constructor takes 2 token addresses + fixed exchange rate DONE (used structs to make constructor parameters simpler and easier)
// addLiquidity() - owner deposits both tokens to contract
// swapAforB(uint256) - user sends TokenA, gets TokenB back at fixed rate
// swapBforA(uint256) - reverse swap
// getReserves() - view function returns both token balances
// Track both token reserves in state
// Emit events for swaps and liquidity adds
// Use internal helper for updating reserves
// Owner-only modifier for admin functions

// Done when:

// Can swap both directions
// Reserves update correctly
// Can't swap more than available
// Events emit
// Tests pass
