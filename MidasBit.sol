// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

library SafeMath {
  function add(uint a, uint b) internal pure returns(uint) {
    uint c = a + b;
    require(c >= a, "Sum Overflow!");
    return c;
  }

  function sub(uint a, uint b) internal pure returns(uint) {
    require(b <= a, "Sub Underflow!");
    return a - b;
  }

  function mul(uint a, uint b) internal pure returns(uint) {
    if(a == 0) {
      return 0;
    }
    uint c = a * b;
    require(c / a == b, "Mul Overflow!");
    return c;
  }

  function div(uint a, uint b) internal pure returns(uint) {
    return a / b;
  }

  function pow(uint a, uint b) internal pure returns(uint) {
    return a ** b;
  }
}

contract Ownable {
  address payable public owner;
  event OwnershipTransferred(address newOwner);
  
  constructor() {
    owner = payable (msg.sender);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "You are not the owner!");
    _;
  }

  function transferOwnership(address payable newOwner) onlyOwner public {
    owner = newOwner;

    emit OwnershipTransferred(owner);
  }
}

interface ERC20 {

    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}


contract BasicToken is Ownable, ERC20 {
  using SafeMath for uint;

  uint internal _totalSupply;
  mapping(address => uint) internal _balances;
  mapping(address => mapping(address => uint)) internal _allowed;

  // Returns the total supply of tokens
  function totalSupply() public view returns(uint) {
    return _totalSupply;
  }

  // Returns the balance of an address
  function balanceOf(address account) public view returns (uint) {
    return _balances[account];
  }

  // Transfer a amount to recipient's address
  function transfer(address recipient, uint amount) public returns (bool success) {
    require(_balances[msg.sender] >= amount, "Insufficient funds.");
    require(recipient != address(0));

    _balances[msg.sender] = _balances[msg.sender].sub(amount);
    _balances[recipient] = _balances[recipient].add(amount);

    emit Transfer(msg.sender, recipient, amount);

    return true;
  }

  // Approves the amount another address can spend for you
  function approve(address spender, uint amount) public returns (bool) {
    _allowed[msg.sender][spender] = amount;

    emit Approval(msg.sender, spender, amount);

    return true;
  }

  // Returns how much an address is allowed to spend in the name of an owner address
  function allowance(address owner, address spender) public view returns (uint) {
    return _allowed[owner][spender];
  }

  // Transfer a amount from sender's address to a recipient's address
  function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
    require(_allowed[sender][msg.sender] >= amount, "Insufficient allowed funds.");
    require(_balances[sender] >= amount, "Insufficient funds.");
    require(recipient != address(0));

    _balances[sender] = _balances[sender].sub(amount);
    _balances[recipient] = _balances[recipient].add(amount);
    _allowed[sender][msg.sender] = _allowed[sender][msg.sender].sub(amount);

    emit Transfer(sender, recipient, amount);

    return true;
  }
}

contract MintableToken is BasicToken {
  using SafeMath for uint;

  event Mint(address indexed to, uint amount);

  function mint(address recipient, uint amount) onlyOwner public {
    _balances[recipient] = _balances[recipient].add(amount);
    _totalSupply = _totalSupply.add(amount);

    emit Mint(recipient, amount);
  }
}

contract TestCoin is MintableToken {
  string public constant name = "Test Token";
  string public constant symbol = "TST";
  uint8 public constant decimalds = 18;
}

contract MidasBit is MintableToken {
  string public constant name = "Midas Bit";
  string public constant symbol = "MIDAS";
  uint8 public constant decimalds = 18;
}
