// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./OwnerBurnableToken.sol";

contract DocToken is ERC20, OwnerBurnableToken {

  /**
@dev Constructor
    */
  constructor() OwnerBurnableToken("Dollar on Chain", "DOC") {}


  /**
@dev Fallback function
    */
  fallback() external override {
    // Fallback logic
  }

  /**
@dev Function to receive Ether
    */
  receive() external payable override {
    // Logic to execute on Ether reception
  }
}
