// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Fundme} from "../src/Fundme.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script{
    function run() public returns (Fundme,HelperConfig){
        HelperConfig config = new HelperConfig();
        (address priceFeed)= config.activeNetworkConfig();

        vm.startBroadcast();
        Fundme fundMe = new Fundme(priceFeed);
        vm.stopBroadcast();
        return (fundMe, config);
    }
}
