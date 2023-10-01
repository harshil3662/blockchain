// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Lending {
    address public owner;
    IERC20 public token;
    uint256 public totalLiquidity;
    mapping(address => uint256) public balances;

    constructor(address _token) {
        owner = msg.sender;
        token = IERC20(_token);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function deposit(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        balances[msg.sender] += _amount;
        totalLiquidity += _amount;
    }

    function borrow(uint256 _amount) external {
        require(_amount > 0, "Amount must be greater than 0");
        require(_amount <= totalLiquidity, "Insufficient liquidity");
        balances[msg.sender] -= _amount;
        totalLiquidity -= _amount;
    }
}
