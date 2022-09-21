// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'hardhat/console.sol';
import './Interfaces/IERC3156Lender.sol';
import {IERC20, Token} from './Token.sol';

/* 
Created by Yannick Roy, for a basic Flashloan example.
Code taken/inspired from the Ethereum EIP-3156
https://eips.ethereum.org/EIPS/eip-3156 
*/

contract Lender is IERC3156Lender {
    uint256 private _loanFee;
    uint256 private _loanMax;
    Token _token;

    constructor(
        address token,
        uint256 loanFee,
        uint256 loanMax
    ) {
        _loanFee = loanFee;
        _loanMax = loanMax;
        _token = Token(token);
    }

    function maxFlashLoan(address token) external view override returns (uint256) {
        return _loanMax;
    }

    /**
     * @dev The fee to be charged for a given loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @return The amount of `token` to be charged for the loan, on top of the returned principal.
     */
    function flashFee(address token, uint256 amount) public view override returns (uint256) {
        return _loanFee;
    }

    /**
     * @dev Initiate a flash loan.
     * @param receiver The receiver of the tokens in the loan, and the receiver of the callback.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @param data Arbitrary data structure, intended to contain user-defined parameters.
     */
    function flashLoan(
        IERC3156Borrower receiver,
        address token,
        uint256 amount,
        bytes calldata data
    ) external returns (bool) {
        console.log('Received a Loan Request...');

        require(amount <= _loanMax, 'IERC3156: Loan requested too big...');
        require(address(receiver) == msg.sender, 'IERC3156: Untrusted borrower.');

        uint256 fee = flashFee(token, amount);
        console.log('Transferring Money!');
        require(IERC20(token).transfer(address(receiver), amount), 'IERC3156: Transfer failed');
        console.log('Transferred money, calling Calback...');

        require(
            receiver.onFlashLoan(address(receiver), token, amount, fee, data) ==
                keccak256('ERC3156Borrower.onFlashLoan'),
            'IERC3156: Callback failed'
        );
        require(
            IERC20(token).transferFrom(address(receiver), address(this), amount + fee),
            'IERC3156: Repay failed'
        );
        console.log('All Gucci! Repaid and all. :)');
        return true;
    }

    function depositTokens(uint256 amount) public {
        _token.transferFrom(msg.sender, address(this), amount);
    }
}
