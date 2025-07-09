// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./MockERC20.sol";

contract LendingPool {
    MockERC20 public token;

    mapping(address => uint256) public deposits;
    mapping(address => uint256) public borrows;

    constructor(address _token) {
        token = MockERC20(_token);
    }

    // Depositar tokens al pool
    function deposit(uint256 amount) external {
        require(amount > 0, "Deposit amount must be > 0");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        deposits[msg.sender] += amount;
    }

    // Pedir prestado tokens (básico, sin colateral real por ahora)
    function borrow(uint256 amount) external {
        require(amount > 0, "Borrow amount must be > 0");
        // Chequeo simplificado: solo podés pedir prestado hasta el monto que depositaste
        require(amount <= deposits[msg.sender], "Borrow limit exceeded");
        require(token.balanceOf(address(this)) >= amount, "Not enough liquidity in pool");

        borrows[msg.sender] += amount;
        require(token.transfer(msg.sender, amount), "Token transfer failed");
    }

    // Factor de salud simple: depósito / deuda (x100 para evitar decimales)
    function getHealthFactor(address user) public view returns (uint256) {
        if (borrows[user] == 0) {
            return type(uint256).max; // Salud infinita si no debe nada
        }
        return (deposits[user] * 100) / borrows[user];
    }
}
