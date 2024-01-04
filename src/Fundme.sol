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

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error Fundme__NotOwner();

contract Fundme{
    using PriceConverter for uint256;
    
    address public immutable i_owner;
    uint256 public constant MIN_USD_VALUE = 5 ether; 

    mapping(address => uint256) public valueAddressFund;
    address[] public funders;

    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner {
        if (msg.sender != i_owner) revert Fundme__NotOwner();
        _;
    }

    constructor(address priceFeed){
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MIN_USD_VALUE, "Insufficient funds. Try to fund more than 5 USD");
        valueAddressFund[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256){
        return s_priceFeed.version();
    }

    function withdraw() public onlyOwner{
        for(uint8 i= 0; i<funders.length;i++){
            valueAddressFund[funders[i]] = 0;
        }
        funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }
}