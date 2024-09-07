// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "../lib/klaytn-contracts/contracts/KIP/token/KIP17/extensions/KIP17URIStorage.sol";
import "../lib/klaytn-contracts/contracts/access/Ownable.sol";
import "../lib/klaytn-contracts/contracts/access/AccessControl.sol";
import "./TokenBoundAccountRegistry.sol";

contract BadgeMinter is KIP17URIStorage, Ownable, AccessControl {
    uint256 private _tokenIds;
    uint256 public maxSupply;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    TokenBoundAccountRegistry public registry;

    mapping(uint256 => address) public tokenBoundAccounts;

    event Minted(address indexed recipient, uint256 tokenId, string newTokenURI);

    constructor(uint256 _maxSupply, address _registry) KIP17("BadgeMinter", "Badge") {
        maxSupply = _maxSupply;
        registry = TokenBoundAccountRegistry(_registry);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        _transferOwnership(msg.sender);
    }

    function mintBadge(address recipient, string memory newTokenURI)
        public
        onlyRole(MINTER_ROLE)
        returns (uint256)
    {
        require(_tokenIds < maxSupply, "Max supply reached");
        _tokenIds++;

        uint256 newItemId = _tokenIds;
        _safeMint(recipient, newItemId);
        _setTokenURI(newItemId, newTokenURI);

        // Create a new Token Bound Account
        address tba = registry.createAccount(recipient, newItemId);
        tokenBoundAccounts[newItemId] = tba;

        emit Minted(recipient, newItemId, newTokenURI);

        return newItemId;
    }

    function mintBadgeAndTransferOwnership(address recipient, string memory newTokenURI, address newOwner)
        public
        onlyRole(MINTER_ROLE)
        returns (uint256)
    {
        uint256 newItemId = mintBadge(recipient, newTokenURI);
        _transferOwnershipOfToken(newItemId, newOwner);
        return newItemId;
    }

    function _transferOwnershipOfToken(uint256 tokenId, address newOwner) internal {
        require(_exists(tokenId), "Token does not exist");
        _transfer(ownerOf(tokenId), newOwner, tokenId);
    }

    function updateTokenURI(uint256 tokenId, string memory newTokenURI) public onlyOwner {
        _setTokenURI(tokenId, newTokenURI);
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        require(_maxSupply > _tokenIds, "New max supply must be greater than current supply");
        maxSupply = _maxSupply;
    }

    function setMinterRole(address minter) public onlyOwner {
        grantRole(MINTER_ROLE, minter);
    }

    function revokeMinterRole(address minter) public onlyOwner {
        revokeRole(MINTER_ROLE, minter);
    }

    function totalSupply() public view returns (uint256) {
        return _tokenIds;
    }

    function getAccount(uint256 tokenId) public view returns (address) {
        return tokenBoundAccounts[tokenId];
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(KIP17, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}