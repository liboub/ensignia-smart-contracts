pragma solidity ^0.8.0;
// SPDX-License-Identifier: UNLICENSED


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Owner Burnable Token
 * @dev Token that allows the owner to irreversibly burned (destroyed) any token.
 */
contract OwnerBurnableToken is ERC20, Ownable {
  constructor(string memory name, string memory symbol) ERC20(name, symbol) {}

  function mint(address to, uint256 amount) external onlyOwner {
    _mint(to, amount);
  }

  function burn(address who, uint256 value) external onlyOwner {
    _burn(who, value);
  }

  // Function to receive Ether. msg.data must be empty
  receive() external payable virtual {}

  // Fallback function is called when msg.data is not empty
  fallback() external virtual {}
}
