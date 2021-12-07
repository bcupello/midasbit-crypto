// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract HelloWorld {
  string public text;
  uint public number;
  address public userAddress;
  bool public answer;
  mapping (address => uint) public interactCount;
  mapping (address => uint) public balances;

  function setText(string memory myText) public {
    text = myText;
    countInteraction();
  }

  function setNumber(uint myNumber) public payable {
    require(msg.value >= 1 ether, "Insufficient ETH sent.");

    balances[msg.sender] += msg.value;
    number = myNumber;
    countInteraction();
  }

  function setUserAddress() public {
    userAddress = msg.sender;
    countInteraction();
  }
  
  function setAnswer(bool trueOrFalse) public {
    answer = trueOrFalse;
    countInteraction();
  }

  function countInteraction() private {
    interactCount[msg.sender] += 1;
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

  function sum(uint num1, uint num2) public pure returns(uint) {
    return num1 + num2;
  }

  function sub(uint num1, uint num2) public pure returns(uint) {
    return num1 - num2;
  }

  function mult(uint num1, uint num2) public pure returns(uint) {
    return num1 * num2;
  }

  function div(uint num1, uint num2) public pure returns(uint) {
    return num1 / num2;
  }

  function pow(uint num1, uint num2) public pure returns(uint) {
    return num1 ** num2;
  }

  function sumStore(uint num1) public view returns(uint) {
      return num1 + number;
  }
}