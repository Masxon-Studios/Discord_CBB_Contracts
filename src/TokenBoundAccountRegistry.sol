// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../lib/openzeppelin-contracts/contracts/proxy/Clones.sol";
import "../lib/klaytn-contracts/contracts/access/Ownable.sol";
import "./TokenBoundAccount.sol";

contract TokenBoundAccountRegistry is Ownable {
    address public implementation;

    event AccountCreated(address indexed account, address indexed owner, uint256 indexed tokenId);

    constructor(address _implementation) {
        implementation = _implementation;
    }

    function createAccount(address owner, uint256 tokenId) external returns (address) {
        address clone = Clones.clone(implementation);
        TokenBoundAccount(payable(clone)).transferOwnership(owner);
        emit AccountCreated(clone, owner, tokenId);
        return clone;
    }
}