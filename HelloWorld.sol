// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

contract HelloWorld {
  string public text;

  function setText(string memory myText) public {
    text = myText;
  }
}