// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Fundme} from "../src/Fundme.sol";

contract DeployFundMe is Script{

    Fundme fundMe; 

    function run() public {
        vm.startBroadcast();
        fundMe = new Fundme(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        vm.stopBroadcast();
    }
}
