// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenB is ERC20 {
    uint256 _fixedRate;

    //again struct is useful less variable overload
    struct TokenInfo {
        string _name;
        string _symbol;
    }

    TokenInfo _tokenInfo;

    constructor(
        string memory name_,
        string memory symbol_
    ) ERC20(name_, symbol_) {
        _tokenInfo = TokenInfo(name_, symbol_);
    }
}
