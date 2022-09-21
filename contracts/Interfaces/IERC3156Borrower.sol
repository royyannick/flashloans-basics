// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 
Created by Yannick Roy, for a basic Flashloan example.
Code taken/inspired from the Ethereum EIP-3156
https://eips.ethereum.org/EIPS/eip-3156 
*/

interface IERC3156Borrower {
    /**
     * @dev Receive a flash loan.
     * @param initiator The initiator of the loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @param fee The additional amount of tokens to repay.
     * @param data Arbitrary data structure, intended to contain user-defined parameters.
     * @return The keccak256 hash of "ERC3156FlashBorrower.onFlashLoan"
     */
    function onFlashLoan(
        address initiator,
        address token,
        uint256 amount,
        uint256 fee,
        bytes calldata data
    ) external returns (bytes32);
}
