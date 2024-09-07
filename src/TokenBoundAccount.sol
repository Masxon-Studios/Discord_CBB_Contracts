// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../lib/klaytn-contracts/contracts/access/Ownable.sol";

contract TokenBoundAccount is Ownable {
    constructor(address _owner) {
        _transferOwnership(_owner);
    }

    function executeCall(address to, uint256 value, bytes calldata data) external onlyOwner returns (bytes memory) {
        (bool success, bytes memory result) = to.call{value: value}(data);
        require(success, "Call failed");
        return result;
    }

    receive() external payable {}
}