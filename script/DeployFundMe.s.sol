// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Fundme} from "../src/Fundme.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{

    Fundme fundMe; 

    function run() public returns (Fundme){

        HelperConfig config = new HelperConfig();
        (address priceFeed)= config.activeNetworkConfig();

        vm.startBroadcast();
        fundMe = new Fundme(priceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
