// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

library SafeMath {
  function sum(uint a, uint b) internal pure returns(uint) {
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

contract HelloWorld is Ownable {
  using SafeMath for uint;

  string public text;
  uint public number;
  address payable public userAddress;
  bool public answer;
  mapping (address => uint) public interactCount;
  mapping (address => uint) public balances;

  function setText(string memory myText) onlyOwner public {
    text = myText;
    countInteraction();
  }

  function setNumber(uint myNumber) public payable {
    require(msg.value >= 1 ether, "Insufficient ETH sent.");

    balances[msg.sender] = balances[msg.sender].sum(msg.value);
    number = myNumber;
    countInteraction();
  }

  function setUserAddress() public {
    userAddress = payable (msg.sender);
    countInteraction();
  }
  
  function setAnswer(bool trueOrFalse) public {
    answer = trueOrFalse;
    countInteraction();
  }

  function countInteraction() private {
    interactCount[msg.sender] = interactCount[msg.sender].sum(1);
  }

  function sendETH(address payable targetAddress) public payable {
    targetAddress.transfer(msg.value);
  }

  function withdraw() public {
    require(balances[msg.sender] > 0, "Insufficient funds.");

    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    payable(msg.sender).transfer(amount);
  }

  function sumStore(uint a) public view returns(uint) {
      return a.sum(number);
  }
}