// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {Fundme} from "../src/Fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundmeTest is Test {

    Fundme fundMe;
    address USER = makeAddr("ATHARV");
    uint256 public constant SEND_VALUE = 1 ether;

    modifier funded {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, SEND_VALUE);
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

    function testFundFunctionWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFunderAddressWithinFunders() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        address funderAddress = fundMe.getFunders(0);
        assertEq(funderAddress, USER);
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();

        uint256 Amount = fundMe.getAmountToFundedAddress(USER);
        assertEq(Amount, SEND_VALUE);
    }

    function testOnlyOwnerCanWithdraw() public funded{
        vm.expectRevert();
        vm.prank(USER);
        fundMe.withdraw();
    }

    function testWithdrawWithASingleUser() public funded{
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }

    function testWithdrawWithMultipleUsers() public funded{
        uint8 numberOfFunders = 10;
        uint8 startingIndex = 1;

        for(uint160 i = startingIndex; i < numberOfFunders; i++){
            hoax(address(i),SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingFundMeBalance);
    }
}