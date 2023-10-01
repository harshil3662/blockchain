// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BridgeA {
    address public owner;
    IERC20 public tokenA;
    address public bridgeB;

    constructor(address _tokenA, address _bridgeB) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        bridgeB = _bridgeB;
    }

    function lockTokens(uint256 _amount) external {
        tokenA.transferFrom(msg.sender, address(this), _amount);
    }

    function unlockTokens(uint256 _amount) external {
        require(msg.sender == owner, "Only owner can unlock tokens");
    
        require(tokenA.transfer(bridgeB, _amount), "Token transfer failed");

        emit TokensUnlocked(msg.sender, bridgeB, _amount);
    }

    event TokensUnlocked(address indexed sender, address indexed bridgeB, uint256 amount);
}
