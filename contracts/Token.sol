// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Interfaces/IERC20.sol"

contract Token is IERC20 {
    string public constant name = "My Token";
    string public constant symbol = "MTK";
    uint8 public constant decimals = 18;
    uint256 public constant totalSupply_ = 10 ether;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor() {
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint)
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    ) public override returns (bool) {
        console.log("Trying to Transfer Tokens!");
        require(numTokens <= balances[owner], "Owner Insufficient Funds.");
        //require(numTokens <= allowed[owner][msg.sender]);
        console.log("Trying to Transfer Tokens! Requires: CHECKED!");

        balances[owner] = balances[owner] - numTokens;
        //allowed[owner][msg.sender] = allowed[owner][msg.sender] - numTokens;
        balances[buyer] = balances[buyer] + numTokens;

        console.log("Trying to Transfer Tokens! Transactions: DONE!");

        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
