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

    //////////////
    /// Errors /// 
    //////////////

error Fundme__NotOwner();

contract Fundme{

    /////////////////
    /// Variables /// 
    /////////////////

    using PriceConverter for uint256;
    
    address public immutable i_owner;
    uint256 public constant MIN_USD_VALUE = 5 ether; 

    mapping(address => uint256) private s_valueAddressFund;
    address[] private s_funders;

    AggregatorV3Interface private s_priceFeed;

    /////////////////
    /// Modifiers /// 
    /////////////////

    modifier onlyOwner {
        if (msg.sender != i_owner) revert Fundme__NotOwner();
        _;
    }

    ///////////////////
    /// constructor /// 
    ///////////////////

    constructor(address priceFeed){
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    /////////////////
    /// Functions /// 
    /////////////////

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MIN_USD_VALUE, "Try to fund more than 5 USD");
        s_valueAddressFund[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    function withdraw() public onlyOwner{
        for(uint8 i= 0; i< s_funders.length;i++){
            s_valueAddressFund[s_funders[i]] = 0;
        }
        s_funders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            s_valueAddressFund[funder] = 0;
        }
        s_funders = new address[](0);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    ////////////////////////
    /// Getter Functions /// 
    ////////////////////////

    function getAmountToFundedAddress(address _funder) public view returns (uint256){
        return s_valueAddressFund[_funder];
    }

    function getVersion() public view returns (uint256){
        return s_priceFeed.version();
    }

    function getFunders(uint8 _index) public view returns (address){
        return s_funders[_index];
    }

    function getOwner() public view returns (address){
        return i_owner;
    }
}