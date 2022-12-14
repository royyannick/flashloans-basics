// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 
Created by Yannick Roy, for a basic Flashloan example.
Code taken/inspired from the Ethereum EIP-3156
https://eips.ethereum.org/EIPS/eip-3156 
*/

import "./IERC3156Borrower.sol";

interface IERC3156Lender {
    /**
     * @dev The amount of currency available to be lent.
     * @param token The loan currency.
     * @return The amount of `token` that can be borrowed.
     */
    function maxFlashLoan(address token) external view returns (uint256);

    /**
     * @dev The fee to be charged for a given loan.
     * @param token The loan currency.
     * @param amount The amount of tokens lent.
     * @return The amount of `token` to be charged for the loan, on top of the returned principal.
     */
    function flashFee(address token, uint256 amount)
        external
        view
        returns (uint256);

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
    ) external returns (bool);
}
