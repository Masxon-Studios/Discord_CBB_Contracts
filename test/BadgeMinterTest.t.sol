// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/TokenBoundAccount.sol";
import "../src/TokenBoundAccountRegistry.sol";
import "../src/BadgeMinter.sol";

contract BadgeMinterTest is Test {
    TokenBoundAccount private _tokenBoundAccount;
    TokenBoundAccountRegistry private _registry;
    BadgeMinter private _badgeMinter;

    address private _owner = address(this); // Use the test contract as the owner
    address private _addr1 = address(0x2);
    address private _addr2 = address(0x3);

    function setUp() public {
        vm.startPrank(_owner);
        _tokenBoundAccount = new TokenBoundAccount(_owner);
        _registry = new TokenBoundAccountRegistry(address(_tokenBoundAccount));
        _badgeMinter = new BadgeMinter(10000, address(_registry)); // Set max supply to 10000

        // Ensure _owner is the owner of _badgeMinter
        assertEq(_badgeMinter.owner(), _owner);

        // Grant MINTER_ROLE to _owner
        _badgeMinter.grantRole(_badgeMinter.MINTER_ROLE(), _owner);
        vm.stopPrank();
    }

    function testMintBadge() public {
        vm.startPrank(_owner); // Ensure the caller is the owner
        uint256 newItemId = _badgeMinter.mintBadge(_addr1, "https://example.com/nft");
        vm.stopPrank();

        assertEq(_badgeMinter.ownerOf(newItemId), _addr1);
        assertEq(_badgeMinter.totalSupply(), 1);

        address accountAddress = _badgeMinter.getAccount(newItemId);
        assertTrue(accountAddress != address(0));
    }

    function testMintBadgeAndTransferOwnership() public {
        vm.startPrank(_owner); // Ensure the caller is the owner
        uint256 newItemId = _badgeMinter.mintBadgeAndTransferOwnership(_addr1, "https://example.com/nft", _addr2);
        vm.stopPrank();

        assertEq(_badgeMinter.ownerOf(newItemId), _addr2);
        assertEq(_badgeMinter.totalSupply(), 1);

        address accountAddress = _badgeMinter.getAccount(newItemId);
        assertTrue(accountAddress != address(0));
    }

    function testUpdateTokenURI() public {
        vm.startPrank(_owner); // Ensure the caller is the owner
        uint256 newItemId = _badgeMinter.mintBadge(_addr1, "https://example.com/nft");
        _badgeMinter.updateTokenURI(newItemId, "https://example.com/new-nft");
        vm.stopPrank();

        assertEq(_badgeMinter.tokenURI(newItemId), "https://example.com/new-nft");
    }

    function testSetMaxSupply() public {
        vm.startPrank(_owner); // Ensure the caller is the owner
        _badgeMinter.setMaxSupply(20000);
        vm.stopPrank();

        assertEq(_badgeMinter.maxSupply(), 20000);
    }

    function testGrantAndRevokeMinterRole() public {
        vm.startPrank(_owner); // Ensure the caller is the owner
        _badgeMinter.setMinterRole(_addr1);
        assertTrue(_badgeMinter.hasRole(_badgeMinter.MINTER_ROLE(), _addr1));

        _badgeMinter.revokeMinterRole(_addr1);
        assertFalse(_badgeMinter.hasRole(_badgeMinter.MINTER_ROLE(), _addr1));
        vm.stopPrank();
    }

    function testMintingExceedsMaxSupply() public {
        vm.startPrank(_owner); // Ensure the caller is the owner
        for (uint256 i = 0; i < 10000; i++) {
            _badgeMinter.mintBadge(_addr1, "https://example.com/nft");
        }

        vm.expectRevert("Max supply reached");
        _badgeMinter.mintBadge(_addr1, "https://example.com/nft");
        vm.stopPrank();
    }

    function testMintingWithUnauthorizedAddress() public {
        vm.startPrank(_addr1); // Start prank as an unauthorized address
        vm.expectRevert("AccessControl: account 0x0000000000000000000000000000000000000002 is missing role 0x9f2df0fed2c77648de5860a4cc508cd0818c85b8b8a1ab4ceeef8d981c8956a6");
        _badgeMinter.mintBadge(_addr1, "https://example.com/nft");
        vm.stopPrank();
    }
}
