// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Interfaces/IERC3156Lender.sol';
import './Interfaces/IERC20.sol';
import 'hardhat/console.sol';

/* 
Created by Yannick Roy, for a basic Flashloan example.
Code taken/inspired from the Ethereum EIP-3156
https://eips.ethereum.org/EIPS/eip-3156 
*/

contract Borrower is IERC3156Borrower {
    IERC3156Lender lenderPool;
    address tokenToBorrow;

    constructor(IERC3156Lender lender, address token) {
        lenderPool = lender;
        tokenToBorrow = token;
    }

    function action() external {
        console.log('Asking for Loan!');

        uint256 currentAmount = IERC20(tokenToBorrow).balanceOf(address(this));
        string tokenSymbol = IERC20(tokenToBorrow).symbol;
        console.log('I currently have: ');
        console.log(currentAmount);
        console.log(tokenSymbol);

        lenderPool.flashLoan(
            IERC3156Borrower(this),
            tokenToBorrow,
            1,
            abi.encodePacked(keccak256('ERC3156Borrower.onFlashLoan'))
        );
    }

    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external override returns (bytes32) {
        // Some sort of a handshake confirmation that the 2 contracts talking
        // to one another don't get highjacked by a third (unwanted/untrusted) agent.
        require(msg.sender == address(lenderPool), 'IERC3156: Untrusted lender.');
        require(initiator == address(this), 'IERC3156: Untrusted borrower.');

        // Confirming the loan has been deposited.
        uint256 currentAmount = IERC20(tokenToBorrow).balanceOf(address(this));
        string tokenSymbol = IERC20(tokenToBorrow).symbol;
        console.log('I currently have: ');
        console.log(currentAmount);
        console.log(tokenSymbol);

        // Do Stuff...
        console.log('I can Arbitrage now! About to be rich!');

        return keccak256('ERC3156FlashBorrower.onFlashLoan');
    }
}
