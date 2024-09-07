// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../lib/forge-std/src/Script.sol";
import "../src/TokenBoundAccount.sol";
import "../src/TokenBoundAccountRegistry.sol";
import "../src/BadgeMinter.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        // Pass the deployer address to the TokenBoundAccount constructor
        TokenBoundAccount tokenBoundAccount = new TokenBoundAccount(deployer);
        TokenBoundAccountRegistry registry = new TokenBoundAccountRegistry(address(tokenBoundAccount));
        BadgeMinter badgeMinter = new BadgeMinter(10000, address(registry)); // Set max supply to 10000

        // Use the badgeMinter variable to avoid the unused variable warning
        console.log("BadgeMinter deployed to:", address(badgeMinter));

        vm.stopBroadcast();
    }
}
