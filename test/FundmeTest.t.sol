// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Fundme} from "../src/Fundme.sol";

contract FundmeTest is Test {

    Fundme fundMe;

    function setUp() external {
        fundMe = new Fundme(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function testdemo() public {
        assertEq(fundMe.MIN_USD_VALUE(), 5 * 1e18);
    }

    function testOwnerIsMSGSender() public {
        assertEq(fundMe.i_owner(), address(this));
    }

    function testPriceFeedVersionIsCurrect() public {
        uint256 version = fundMe.getVersion();
        assertEq(version,4);
    }
}