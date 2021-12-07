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

  function withdraw() onlyOwner public {
    require(balances[msg.sender] > 0, "Insufficient funds.");

    uint amount = balances[msg.sender];
    balances[msg.sender] = 0;
    payable(msg.sender).transfer(amount);
  }

  function sumStore(uint a) public view returns(uint) {
      return a.sum(number);
  }
}

contract Challange is Ownable {
  using SafeMath for uint;

  uint testNumberPrice = 25000000 gwei;

  event NewPrice(uint newPrice);

  // Tests number and charges for this operation
  function testNumber(uint number) payable public returns(string memory returnText) {
    require(number <= 10, "Number out of range.");
    // Guarantees that the value charged is equal to (0,025 ether)*testNumberPrice
    require(msg.value == testNumberPrice, "Wrong msg.value.");

    // Updates the price
    doubleTestNumberPrice();

    // Returns the test response
    if (number > 5) {
      return "It's bigger than five.";
    }
    return "It's less than or equal to five.";
  }

  function doubleTestNumberPrice() private {
    testNumberPrice = testNumberPrice.mul(2);

    emit NewPrice(testNumberPrice);
  }

  // Withdraws a chosen amount 
  function withdraw(uint amount) onlyOwner public {
    require(address(this).balance > amount, "Insufficient funds.");

    payable(owner).transfer(amount);
  }
}