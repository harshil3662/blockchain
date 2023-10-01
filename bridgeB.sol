// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeB {
    address public owner;
    IERC20 public tokenB;

    constructor(address _tokenB) {
        owner = msg.sender;
        tokenB = IERC20(_tokenB);
    }

    function receiveTokens(address _from, uint256 _amount) external {
        require(msg.sender == owner, "Only owner can receive tokens");

        require(tokenB.transfer(_from, _amount), "Token transfer failed");

        emit TokensReceived(msg.sender, _from, _amount);
    }

    event TokensReceived(address indexed sender, address indexed from, uint256 amount);
}
