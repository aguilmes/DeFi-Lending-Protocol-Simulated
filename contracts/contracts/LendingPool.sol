// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./MockERC20.sol";

contract LendingPool {
    MockERC20 public token;

    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrows;

    // 👉 Definí los eventos:
    event Deposit(address indexed user, uint256 amount);
    event Borrow(address indexed user, uint256 amount);

    constructor(address _token) {
        token = MockERC20(_token);
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be > 0");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        deposits[msg.sender] += amount;
        emit Deposit(msg.sender, amount); // 🚩 Emite el evento
    }

    function borrow(uint256 amount) external {
        require(amount > 0, "Borrow amount must be > 0");
        require(amount <= deposits[msg.sender], "Borrow limit exceeded");
        require(token.balanceOf(address(this)) >= amount, "Not enough liquidity in pool");

        borrows[msg.sender] += amount;
        require(token.transfer(msg.sender, amount), "Token transfer failed");
        emit Borrow(msg.sender, amount); // 🚩 Emite el evento
    }

    function getHealthFactor(address user) public view returns (uint256) {
        if (borrows[user] == 0) {
            return type(uint256).max;
        }
        return (deposits[user] * 100) / borrows[user];
    }
}
