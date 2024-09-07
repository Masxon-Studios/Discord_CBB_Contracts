Community Badge Minting Smart Contracts
This repository contains the Solidity smart contracts used to mint community badges (NFTs) on the Klaytn blockchain. The contracts integrate with a Rust-based Discord bot and use Foundry for development and deployment. Each badge corresponds to a specific Discord user, wallet address, and role.

Features
Implements the KIP17 standard for NFT badges
Supports role-based minting (admin, volunteer, moderator)
Integrated with Foundry for streamlined development and testing
Includes a registry for managing token-bound accounts linked to badges
Configurable maximum supply for badge minting
Contracts Overview
BadgeMinter.sol
The main contract responsible for minting badges. It uses Klaytn's KIP17URIStorage and connects to a TokenBoundAccountRegistry to create token-bound accounts during minting.

TokenBoundAccount.sol
Defines the structure for token-bound accounts. Each badge is linked to a token-bound account.

TokenBoundAccountRegistry.sol
Manages token-bound accounts, allowing the creation of accounts tied to specific token IDs.

Requirements
Foundry installed for smart contract development
Access to a Klaytn node (e.g., Baobab)
.env file for configuration
Setup and Installation
Step 1: Clone the Repository
bash
Copy code
git clone https://github.com/yourusername/community-badge-contracts.git
cd community-badge-contracts
Step 2: Install Dependencies
Install Foundry:

bash
Copy code
curl -L https://foundry.paradigm.xyz | bash
foundryup
Step 3: Configure .env
Create a .env file in the root of the project with the following variables:

env
Copy code
KLAYTN_WALLET_ADDRESS=your_wallet_address
PRIVATE_KEY=your_private_key
KLAYTN_NODE_URL=https://api.baobab.klaytn.net:8651
Step 4: Compile Contracts
bash
Copy code
forge build
Step 5: Deploy Contracts
bash
Copy code
forge script scripts/Deploy.s.sol --broadcast --rpc-url $KLAYTN_NODE_URL --private-key $PRIVATE_KEY
This will deploy the contracts using Foundry.

Usage
Once the contracts are deployed, they can be interacted with through the Rust Discord bot or manually using Web3 tools like Remix or Hardhat.

Example Minting Command
solidity
Copy code
mintBadge(address recipient, string newTokenURI)
This command mints a new badge to the specified recipient with a given token URI.

Testing
You can write and run tests using Foundry. To run the test suite:

bash
Copy code
forge test
License
This project is licensed under the MIT License - see the LICENSE file for details.

