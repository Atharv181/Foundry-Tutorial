// SPDX-License-Identifier: MIT


// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

pragma solidity ^0.8.18;

contract Fundme{
    
    address public immutable i_owner;
    uint256 public constant MIN_USD_VALUE = 5 ether; 

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value >= MIN_USD_VALUE, "Insufficient funds. Try to fund more than 5 ETH");
    }

    function getPriceFeed() public {
        
    }
}