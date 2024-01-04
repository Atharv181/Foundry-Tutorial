// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Fundme} from "../src/Fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundmeTest is Test {

    Fundme fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testdemo() public {
        assertEq(fundMe.MIN_USD_VALUE(), 5 * 1e18);
    }

    function testOwnerIsMSGSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testPriceFeedVersionIsCurrect() public {
        uint256 version = fundMe.getVersion();
        assertEq(version,4);
    }
}