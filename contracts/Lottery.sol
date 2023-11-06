pragma solidity ^0.8.0;

//@author Antoine Libouban
//@title Lottery.sol
// SPDX-License-Identifier: UNLICENSED


import "@openzeppelin/contracts/utils/Strings.sol";
import {LottoTickets} from "./LotoTickets.sol";


contract Lottery {

  using Strings for uint;
  LottoTickets[] public tickets;




//  constructor () public {


    // You could have more variables to initialize here
 // }

  // to be sure is not called by another contract
  modifier callerIsUser() {
    require(tx.origin == msg.sender, "The caller is another contract");
    _;
  }

  function tirage() internal  callerIsUser {
    // this function will create a random
    // in range of the lengt of tickets
    // and we will get the index of tickets[random] to have a winner
    // after we send to him the
  }

  function storeTicket() public callerIsUser {

  }

  function sendPrizeToWinner() public callerIsUser {

  }



}

