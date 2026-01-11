// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

//we use the is ERC20 so we can use all the functions in the ERC20 contract straightforward
//EVERYTHING IS DONE ALL WE GOTTA DO IS TEST AND DEBUG!

contract AToken is ERC20 {
    uint256 _initialSuply;
    event _tokensMinted(uint256 _amount, uint256 _timestamp);
    event _tokensTransferred(address _to, uint256 _amount);
    struct TokenInfo {
        string _name;
        string _symbol;
    }

    TokenInfo _tokenInfo;
    address private _owner;

    modifier OnlyOwner() {
        require(msg.sender == _owner, "Only owner can call this function!");

        _;
    }

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 initialSupply_
    ) ERC20(name_, symbol_) {
        _tokenInfo = TokenInfo(name_, symbol_);
        _owner = msg.sender;
        _mint(msg.sender, initialSupply_);

        emit _tokensMinted(initialSupply_, block.timestamp);
    }

    function _mintTokens(uint256 _amountToMint) public OnlyOwner {
        _mint(_owner, _amountToMint);
        emit _tokensMinted(_amountToMint, block.timestamp);
    }

    //we use calldata since the values wil be read only so it makes the excecution process more gas efficient for users
    //pay less gas for the transaction
    function _batchTransfer(
        address[] calldata _addresses,
        uint256[] calldata _amounts
    ) public {
        for (uint256 i = 0; i < _addresses.length; i++) {
            //to, value
            //transfers tokens at given index for address and given index for amount
            //i think we need another transfer function to call this examine openzepplins github repo
            //we use transfer from it automatically updates approvals for spending
            //logic anyone  can send to multiple wallets at once
            transferFrom(msg.sender, _addresses[i], _amounts[i]);

            //emits event that tokens were indeed transferred to the wallet at the given index
            emit _tokensTransferred(_addresses[i], _amounts[i]);
        }
    }
}
