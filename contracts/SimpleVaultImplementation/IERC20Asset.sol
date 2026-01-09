// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IERC20Asset {
    function balanceOf(address account) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view virtual returns (uint256);

    function approve(
        address spender,
        uint256 value
    ) external virtual returns (bool);

    //we use this to process user to contract transfers
    //of course users need to approve spedning before interacting with my contract so its best we use this function
    //we use since this transfer function needs approval
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external virtual returns (bool);

    //we dot need no approval for sending tokens from vault to user because the contract itself is doing
    //contract to user so we use this no approval needed
    function transfer(address to, uint256 value) external returns (bool);
}
