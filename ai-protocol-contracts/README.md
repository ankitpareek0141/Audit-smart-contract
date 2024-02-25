# Alethea iNFT Protocol #
Version 3.0.1

This repo contains Alethea ERC20 Token (ALI) v2, Personality Pod ERC721 token, Intelligent Token (iNFT) v2,
iNFT Linker, and other helper smart contracts powering the Alethea iNFT Protocol.

The project is built using
* [Hardhat](https://hardhat.org/), a popular Ethereum development environment,
* [Web3.js](https://web3js.readthedocs.io/), a collection of libraries that allows interacting with
local or remote Ethereum node using HTTP, IPC or WebSocket, and
* [Truffle](https://www.trufflesuite.com/truffle), a popular development framework for Ethereum.

Smart contracts deployment is configured to use [Infura](https://infura.io/)
and [HD Wallet](https://www.npmjs.com/package/@truffle/hdwallet-provider)

## Repository Description ##
What's inside?

* [Alethea Protocol On-chain Architecture](docs/Alethea%20Protocol%20On-chain%20Architecture.pdf), containing
   * Protocol Overview
   * Access Control Technical Design
   * Alethea ERC20 Token Technical Design
   * Tiny ERC721 Token Technical Design
   * iNFT Technical Design
   * iNFT Linker Technical Design
   * Fixed Supply Sale Technical Design
   * NFT Airdrop Helper Technical Design
   * NFT Staking Helper Technical Design
   * OpenSea Factory Technical Design

* Alethea ERC20 (ALI) Token
   * Token Audit by Miguel Palhas:  
      [https://hackmd.io/@naps62/alierc20-audit](https://hackmd.io/@naps62/alierc20-audit)
   * Smart Contract(s):
      * [AliERC20v2Base](contracts/token/AliERC20v2.sol) – base ERC20 implementation
      * [AliERC20v2](contracts/token/AliERC20v2.sol) – "L1" ALI ERC20 Token Implementation for Ethereum network
      with the initial (and fixed) supply of 10 billion tokens
      * [ChildAliERC20v2](contracts/token/AliERC20v2.sol) – "L2" ALI ERC20 Token Implementation for BNB Smart Chain
      network with no initial supply (tokens to be bridged from L1)
      * [PolygonAliERC20v2](contracts/token/PolygonAliERC20v2.sol) – "L2" ALI ERC20 Token Implementation for Polygon
      network with no initial supply (tokens to bridged from L1), contains functions to support standard Polygon bridge
      * [OpAliERC20v2](contracts/token/OpAliERC20v2.sol) – "L3" ALI ERC20 Token Implementation for OP Stack based
      rollup network (like opBNB or Base) with no initial supply (tokens to be bridged from L2)
      * [AccessControl](contracts/utils/AccessControl.sol) – replaces OpenZeppelin AccessControl
      * Auxiliary Libraries
         * [AddressUtils](contracts/lib/AddressUtils.sol)
         * [ECDSA](contracts/lib/ECDSA.sol)
      * Interfaces
         * [ERC20](contracts/interfaces/ERC20Spec.sol)
         * [ERC1363](contracts/interfaces/ERC1363Spec.sol)
         * [ERC1363Receiver](contracts/interfaces/ERC1363Spec.sol)
         * [ERC1363Spender](contracts/interfaces/ERC1363Spec.sol)
         * [ERC165](contracts/interfaces/ERC165Spec.sol)
         * [EIP2612](contracts/interfaces/EIP2612.sol)
         * [EIP3009](contracts/interfaces/EIP3009.sol)
   * Test(s):
      * Token Summary
         * [erc20_summary.js](test/ali_token/erc20_summary.js)
      * Functional Requirements Summary
         * [erc20_zeppelin.js](test/ali_token/erc20_zeppelin.js) – ERC-20 compliance tests ported from
            [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts/)
            (see [ERC20.behavior.js](test/ali_token/include/zeppelin/ERC20.behavior.js)
            and [ERC20.behavior.ext.js](test/ali_token/include/zeppelin/ERC20.behavior.ext.js))
         * [erc1363_ref.js](test/ali_token/erc1363_ref.js) – ERC-1363 compliance tests ported from
            [ERC-1363 Reference Implementation](https://github.com/vittominacori/erc1363-payable-token/)
            (see [ERC1363.behaviour.js](test/ali_token/include/erc1363/ERC1363.behaviour.js)
            and [ERC1363Payable.behaviour.js](test/ali_token/include/erc1363/ERC1363Payable.behaviour.js))
         * [eip2612_zeppelin.js](test/ali_token/eip2612_zeppelin.js) – EIP-2612 compliance tests ported from
            [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts/)
            (see [EIP2612.behavior.js](test/ali_token/include/zeppelin/EIP2612.behavior.js))
         * [eip3009_coinbase.js](test/ali_token/eip3009_coinbase.js) – EIP-3009 compliance tests ported from
            [Coinbase Stablecoin](https://github.com/CoinbaseStablecoin/eip-3009)
            (see [EIP3009.behavior.js](test/ali_token/include/coinbase/EIP3009.behavior.js))
      * Voting Delegation Requirements
         * [voting.js](test/ali_token/voting.js) – "Voting Delegation Requirements" tests
            (see [Alethea Protocol On-chain Architecture](docs/Alethea%20Protocol%20On-chain%20Architecture.pdf))
         * [voting_comp.js](test/ali_token/voting_comp.js) – ported from
            [Compound Protocol](https://github.com/compound-finance/compound-protocol)
            (see [Comp.behavior.js](test/ali_token/include/comp/Comp.behavior.js))
         * [voting_zeppelin.js](test/ali_token/voting_zeppelin.js) – ported from
            [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts/)
            (see [Voting.behavior.js](test/ali_token/include/zeppelin/Voting.behavior.js))
         * [voting-sim.js](test/ali_token/voting-sim.js) – voting simulation tests
            (executes a lot of random token transfers and voting delegations)
      * ERC20 Improvements Required
         * [erc20_improvements.js](test/ali_token/erc20_improvements.js)
      * Non-functional Requirements
         * [gas_consumption.js](test/ali_token/gas_consumption.js) – gas consumption tests
      * Miscellaneous
         * [acl.js](test/ali_token/acl.js) – access control related tests
         * [mint_burn.js](test/ali_token/mint_burn.js) – mint/burn functionality tests
         * [deployment.js](test/ali_token/deployment.js) – deployment related tests
* Tiny ERC721 Base
   * Smart Contract(s):
      * [TinyERC721](contracts/token/TinyERC721.sol) – Token implementation
      * [AccessControl](contracts/utils/AccessControl.sol) – replaces OpenZeppelin AccessControl
      * Auxiliary Libraries
         * [AddressUtils](contracts/lib/AddressUtils.sol)
         * [ArrayUtils](contracts/lib/ArrayUtils.sol)
         * [StringUtils](contracts/lib/StringUtils.sol)
         * [ECDSA](contracts/lib/ECDSA.sol)
      * Interfaces
         * [ERC721](contracts/interfaces/ERC721Spec.sol)
         * [ERC721TokenReceiver](contracts/interfaces/ERC721Spec.sol)
         * [ERC721Metadata](contracts/interfaces/ERC721Spec.sol)
         * [ERC721Enumerable](contracts/interfaces/ERC721Spec.sol)
         * [BurnableERC721](contracts/interfaces/AletheaERC721Spec.sol)
         * [MintableERC721](contracts/interfaces/AletheaERC721Spec.sol)
   * Test(s):
      * Functional Requirements
         * [erc721_zeppelin.js](test/erc721/erc721_zeppelin.js) – ERC-721 compliance tests ported from
            [OpenZeppelin Contracts](https://github.com/OpenZeppelin/openzeppelin-contracts/)
            (see [ERC721.behavior.js](test/erc721/include/zeppelin/ERC721.behavior.js)
            and [ERC721URIStorage.behaviour.js](test/erc721/include/zeppelin/ERC721URIStorage.behaviour.js))
         * [erc721_permits.js](test/erc721/erc721_permits.js) – EIP-712 based permits (`permit` and `permitForAll`)
         * [batch_minting.js](test/erc721/batch_minting.js) – batch minting support
      * Non-functional Requirements
         * [erc721_id_space.js](test/erc721/erc721_id_space.js) – 32-bits token ID space tests
         * [gas_consumption.js](test/erc721/gas_consumption.js) – gas consumption tests
         * [array_utils.js](test/erc721/array_utils.js) – tests for 32-bits assembly array push optimization
      * Miscellaneous
         * [acl.js](test/erc721/acl.js) – access control related tests
         * [locking.js](test/erc721/locking.js) – currently unused, but reserved `isTransferable` feature tests
         * [seq_rnd_gas.js](test/erc721/seq_rnd_gas.js) – gas usage tests for different ways of writing arrays
* Royal NFT ERC721 Extension extends Tiny ERC721 Base to support EIP-2981, and OpenSea integration
   * Smart Contract(s):
      * [RoyalNFT](contracts/token/RoyalNFT.sol)
   * Tests:
      * [contract_metadata.js](test/erc721/with_royalties/contract_metadata.js)
      * [eip2981_royalties.js](test/erc721/with_royalties/eip2981_royalties.js)
      * [fake_ownership.js](test/erc721/with_royalties/fake_ownership.js)
* Alethea NFT ERC721 Token inherits solidity code and tests from Royal NFT ERC721 Extension  
   Smart contract: [AletheaNFT](contracts/token/AletheaNFT.sol)
* WhitelabelNFT ERC721 smart contract inherits solidity code and tests from Royal NFT ERC721 Extension
  Smart contract: [WhitelabelNFT](contracts/token/WhitelabelNFT.sol)
* Personality Pod ERC721 Token inherits solidity code and tests from Royal NFT ERC721 Extension  
   Smart contract: [PersonalityPodERC721](contracts/token/PersonalityPodERC721.sol)
* iNFT
   * Smart Contract(s):
      * [IntelligentNFTv2](contracts/protocol/IntelligentNFTv2.sol) – iNFT implementation
      * [AccessControl](contracts/utils/AccessControl.sol) – replaces OpenZeppelin AccessControl
      * Auxiliary Libraries
         * [StringUtils](contracts/lib/StringUtils.sol)
      * Interfaces
         * [ERC20](contracts/interfaces/ERC20Spec.sol)
         * [ERC721](contracts/interfaces/ERC721Spec.sol)
   * Test(s):
      * [inft.test.js](test/inft/inft.test.js)
      * [iNft_acl.js](test/protocol/iNft_acl.js)
      * [iNft_updates.js](test/protocol/iNft_updates.js)
* iNFT Linker
   * Smart Contract(s):
      * [IntelliLinker](contracts/protocol/IntelliLinker.sol) – Linker implementation
      * [AccessControl](contracts/utils/AccessControl.sol) – replaces OpenZeppelin AccessControl
      * Interfaces
         * [ERC721](contracts/interfaces/ERC721Spec.sol)
   * Test(s):
      * [linker.js](test/protocol/linker.js) – functional requirements tests
      * [linker_acl.js](test/protocol/linker_acl.js) – access control related tests
      * [linker-sim.js](test/protocol/linker-sim.js) – linking/unlinking simulation
* iNFT Linker v2 (Upgradeable)
   * Smart Contract(s):
      * [IntelliLinkerV2](contracts/protocol/IntelliLinkerV2.sol) – Linker V2 implementation
      * [UpgradeableAccessControl](contracts/utils/UpgradeableAccessControl.sol) – replaces OpenZeppelin AccessControl
      * Interfaces
         * [ERC721](contracts/interfaces/ERC721Spec.sol)
   * Test(s):
      * [linker_v2.js](test/protocol/linker_v2.js) – functional requirements tests
      * [linker_v2_acl.js](test/protocol/linker_v2_acl.js) – access control related tests
* iNFT Linker v3 (Upgradeable)
   * Smart Contract(s):
      * [IntelliLinkerV3](contracts/protocol/IntelliLinkerV3.sol) – Linker V3 implementation
      * [UpgradeableAccessControl](contracts/utils/UpgradeableAccessControl.sol) – replaces OpenZeppelin AccessControl
      * Interfaces
         * [ERC721](contracts/interfaces/ERC721Spec.sol)
   * Test(s):
      * [linker_v3.js](test/protocol/linker_v3.js) – functional requirements tests
      * [linker_v3_acl.js](test/protocol/linker_v3_acl.js) – access control related tests
* Fixed Supply Sale
   * Smart Contract(s):
      * [FixedSupplySale](contracts/protocol/FixedSupplySale.sol) – Sale implementation
      * [AccessControl](contracts/utils/AccessControl.sol) – replaces OpenZeppelin AccessControl
   * Test(s):
      * [10k_sale.js](test/protocol/10k_sale.js) – functional requirements tests
      * [10k_sale-cascade.js](test/protocol/10k_sale-cascade.js) – reinitialization tests
      * [10k_sale-sim.js](test/protocol/10k_sale-sim.js) – 10,000 sale simulation
* OpenSea Factory (see [OpenSea docs](https://docs.opensea.io/docs/2-custom-sale-contract-viewing-your-sale-assets-on-opensea))
   * Smart Contract(s): 
      * [OpenSeaFactory](contracts/protocol/OpenSeaFactory.sol)
   * Test(s):
      * [opensea_factory.js](test/protocol/opensea_factory.js)
      * [opensea_factory_initialize.js](test/protocol/opensea_factory_initialize.js)
* Personality Pod Drop (v2.1 release)
   * Smart Contract(s):
      * [ERC721Drop](contracts/protocol/ERC721Drop.sol)
   * Test(s):
      * [persona_drop.js](test/protocol/persona_drop.js)
      * [persona_drop-sim.js](test/protocol/persona_drop-sim.js) – 1,012 pods drop simulation
* Layer Zero based ERC20 Tunnel (v2.8 release)
  * Smart Contract(s):
    * [LzERC20RootTunnelV1](contracts/layer_zero/LzERC20RootTunnelV1.sol) – root chain entrance/exit
    * [LzERC20ChildTunnelV1](contracts/layer_zero/LzERC20ChildTunnelV1.sol) – child chain entrance/exit
  * Test(s):
    * [lz_erc20_root_tunnel.js](test/layer_zero/lz_erc20_root_tunnel.js)
    * [lz_erc20_child_tunnel.js](test/layer_zero/lz_erc20_child_tunnel.js)
  * Deployment Scripts
* Deployment Script(s)
   * [config.js](scripts/config.js) – deployment configuration, review before executing the script
   * [v2_deploy.js](scripts/v2_deploy.js) – deployment script
   * [v2_features.js](scripts/v2_features.js) – an addon to enable public functions (features)
   * [v2_roles.js](scripts/v2_roles.js) – an addon to enable restricted functions access between contracts (roles)
   * [v2_verify.js](scripts/v2_verify.js) – an addon to verify smart contracts code on Etherscan
   * [v2_1_deploy.js](scripts/v2_1_deploy.js) – v2.1 deployment script: AI Pod Airdrop and Staking
   * [v2_1_features.js](scripts/v2_1_features.js) – v2.1 addon to enable public functions (features)
   * [v2_1_roles.js](scripts/v2_1_roles.js) – v2.1 addon to enable restricted functions access between contracts (roles)
   * [v2_1_verify.js](scripts/v2_1_verify.js) – v2.1 addon to verify smart contracts code on Etherscan
   * [v2_2_deploy.js](scripts/v2_2_deploy.js) – v2.2 deployment script: Sophia beingAI iNFT (AletheaNFT)
   * [v2_2_features.js](scripts/v2_2_features.js) – v2.2 addon to enable public functions (features)
   * [v2_2_verify.js](scripts/v2_2_verify.js) – v2.2 addon to verify smart contracts code on Etherscan
   * [v2_3_deploy.js](scripts/v2_3_deploy.js) – v2.3 deployment script: "Arkive" Mystery Box
   * [v2_3_features.js](scripts/v2_3_features.js) – v2.3 addon to enable public functions (features)
   * [v2_3_roles.js](scripts/v2_3_roles.js) – v2.3 addon to enable restricted functions access between contracts (roles)
   * [v2_3_verify.js](scripts/v2_3_verify.js) – v2.3 addon to verify smart contracts code on Etherscan
   * [v2_4_deploy.js](scripts/v2_4_deploy.js) – v2.4 deployment script: IntelliLinkerV2 (Upgradeable)
   * [v2_4_features.js](scripts/v2_4_features.js) – v2.4 addon to enable public functions (features)
   * [v2_4_roles.js](scripts/v2_4_roles.js) – v2.4 addon to enable restricted functions access between contracts (roles)
   * [v2_4_verify.js](scripts/v2_4_verify.js) – v2.4 addon to verify smart contracts code on Etherscan
   * [v2_4_1_deploy.js](deploy/v2_4_1_deploy.js) – v2.4.1 upgrade script: IntelliLinkerV2 -> IntelliLinkerV3 upgrade
   * [v2_4_1_setup.js](deploy/v2_4_1_setup.js) – v2.4.1 addon to enable ALLOW_ANY_NFT_CONTRACT_FOR_LINKING feature
   * [v2_5_deploy_polygon.js](deploy/v2_5_deploy_polygon.js) – deploys ALI token and Character NFT into Polygon
   * [v2_5_features_polygon.js](deploy/v2_5_features_polygon.js)
   * [v2_5_roles_polygon.js](deploy/v2_5_roles_polygon.js)
   * [v2_5_allowance_polygon.js](deploy/v2_5_allowance_polygon.js) – enables service wallets to spend ALI
   * [v2_5_1_deploy_polygon.js](deploy/v2_5_1_deploy_polygon.js) – deploys Digital Twin NFT into Polygon
   * [v2_5_1_features_polygon.js](deploy/v2_5_1_features_polygon.js)
   * [v2_6_deploy_binance.js](deploy/v2_6_deploy_binance.js) – deploys ALI token, Art NFT, and Digital Twin NFT into BSC
   * [v2_6_features_binance.js](deploy/v2_6_features_binance.js)
   * [v2_6_roles_binance.js](deploy/v2_6_roles_binance.js)
   * [v2_7_deploy_char_token.js](deploy/v2_7_deploy_char_token.js) – deploys AiAgentERC20 token
   * [v2_8/*](deploy/v2_8) – OpAliERC20v2 token release on Base network
   * [v2_9/*](deploy/v2_9) – deployment and configuration scripts for v2.9 release,
     including ChildAliERC20v2 (L2), OpAliERC20v2 (L3), LzERC20RootTunnel and LzERC20ChildTunnel
   * [v3_0/*](deploy/v3_0) – deployment and configuration scripts for v3.0 / v3.0.1 releases,
     including bonding curves a.k.a. tradeable shares, trading fees distributors, leaderboard reward system
* Audits:
   * v2.5 by Miguel Palhas:
   [part 1](docs/audits/miguel/v2.5_factory.pdf),
   [part 2](docs/audits/miguel/v2.5_polygon.pdf),
   [part 3](docs/audits/miguel/v2.5_web3auth.pdf)
   * [v2.6 by Miguel Palhas](docs/audits/miguel/v2.6_binance.pdf)
   * [v2.5 by ImmuneBytes](docs/audits/ibytes/v2.5.pdf)
   * [v2.6 by ImmuneBytes](docs/audits/ibytes/v2.6.pdf)
   * [v2.5 by Sheraz Arshad](docs/audits/sheraz/v2.5_polygon.pdf)
   * v3.0.x:
     * v3.0.x by Darren
       * [initial audit](docs/audits/v3_0/v3_0_darren.pdf)
       * [resolution](docs/audits/v3_0/v3_0_darren_resolution.md)
       * [final audit](docs/audits/v3_0/v3_0_darren_v1_1.pdf)
     * v3.0.x by ImmuneBytes
       * [initial audit](docs/audits/v3_0/v3_0_ibytes.pdf)
       * [resolution](docs/audits/v3_0/v3_0_ibytes_resolution.md)
       * [final audit](docs/audits/v3_0/v3_0_ibytes_final.pdf)
     * v3.0.x by Miguel Palhas:
       * [initial audit](docs/audits/v3_0/v3_0_miguel.pdf)
       * [resolution](docs/audits/v3_0/v3_0_miguel_resolution.md)

## Installation ##

Following steps were tested to work in macOS Catalina

1. Clone the repository  
   ```git clone git@github.com:AletheaAI/alethea-contracts.git```
2. Navigate into the cloned repository  
   ```cd alethea-contracts```
3. Install [Node Version Manager (nvm)](https://github.com/nvm-sh/nvm) – latest  
   ```brew install nvm```
4. Install [Node package manager (npm)](https://www.npmjs.com/) and [Node.js](https://nodejs.org/) – version 16  
   ```nvm install 16```
5. Activate node version installed  
   ```nvm use 16```
6. Install project dependencies  
   ```npm install```

### Troubleshooting ###
* After executing ```nvm use 16``` I get  
   ```
   nvm is not compatible with the npm config "prefix" option: currently set to "/usr/local/Cellar/nvm/0.35.3/versions/node/v16.4.0"
   Run `npm config delete prefix` or `nvm use --delete-prefix v16.4.0` to unset it.
   ```
   Fix:  
   ```
   nvm use --delete-prefix v16.4.0
   npm config delete prefix
   npm config set prefix "/usr/local/Cellar/nvm/0.37.2/versions/node/v16.4.0"
   ```
* After executing ```npm install``` I get
   ```
   npm ERR! code 127
   npm ERR! path ./alethea-contracts/node_modules/utf-8-validate
   npm ERR! command failed
   npm ERR! command sh -c node-gyp-build
   npm ERR! sh: node-gyp-build: command not found
   
   npm ERR! A complete log of this run can be found in:
   npm ERR!     ~/.npm/_logs/2021-08-30T07_10_23_362Z-debug.log
   ```
   Fix:  
   ```
   npm install -g node-gyp
   npm install -g node-gyp-build
   ```

### Notes on Ubuntu 20.04 LTS ###
- [How to install Node.js 16 on Ubuntu 20.04 LTS](https://joshtronic.com/2021/05/09/how-to-install-nodejs-16-on-ubuntu-2004-lts/)
- [How to Run Linux Commands in Background](https://linuxize.com/post/how-to-run-linux-commands-in-background/)

## Configuration ##
1. Create or import 12-word mnemonics for
   1. Mainnet
   2. Goerli
   3. Polygon
   4. Mumbai (Polygon Testnet)
   5. Binance Smart Chain (BSC) Mainnet
   6. BSC Testnet
   7. opBNB
   8. opBNB Testnet
   9. Base Mainnet
   10. Base Goerli (Testnet)

   You can use MetaMask to create mnemonics: https://metamask.io/

   Note: you can use same mnemonic for test networks (ropsten, rinkeby and kovan).
   Always use a separate one for mainnet, keep it secure.

   Note: you can add more configurations to connect to the networks not listed above.
   Check and add configurations required into the [hardhat.config.js](hardhat.config.js).

   Note: you can use private keys instead of mnemonics (see Alternative Configuration section below)

2. Create an infura access key at https://infura.io/

   Note: you can use alchemy API key instead of infura access key (see Alternative Configuration section below)

3. Create etherscan API key at https://etherscan.io/

4. Export mnemonics, infura access key, and etherscan API key as system environment variables
   (they should be available for hardhat):

   | Name           | Value                  |
   |----------------|------------------------|
   | MNEMONIC1      | Mainnet mnemonic       |
   | MNEMONIC5      | Goerli mnemonic        |
   | MNEMONIC137    | Polygon mnemonic       |
   | MNEMONIC80001  | Mumbai mnemonic        |
   | MNEMONIC56     | BSC mnemonic           |
   | MNEMONIC97     | BSC Testnet mnemonic   |
   | MNEMONNIC204   | opBNB mnemonic         |
   | MNEMONNIC5611  | opBNB Testnet mnemonic |
   | MNEMONNIC8453  | Base Mainnet mnemonic  |
   | MNEMONNIC84531 | Base Goerli mnemonic   |
   | INFURA_KEY     | Infura access key      |
   | ETHERSCAN_KEY  | Etherscan API key      |

Note:  
Read [How do I set an environment variable?](https://www.schrodinger.com/kb/1842) article for more info on how to
set up environment variables in Linux, Windows and macOS.

### Example Script: macOS Catalina ###
```
export MNEMONIC1="slush oyster cash hotel choice universe puzzle slot reflect sword intact fat"
export MNEMONIC5="result mom hard lend adapt where result mule address ivory excuse embody"
export MNEMONIC137="slush oyster cash hotel choice universe puzzle slot reflect sword intact fat"
export MNEMONIC80001="result mom hard lend adapt where result mule address ivory excuse embody"
export MNEMONIC56="slush oyster cash hotel choice universe puzzle slot reflect sword intact fat"
export MNEMONIC97="result mom hard lend adapt where result mule address ivory excuse embody"
export MNEMONIC204="slush oyster cash hotel choice universe puzzle slot reflect sword intact fat"
export MNEMONIC5611="result mom hard lend adapt where result mule address ivory excuse embody"
export MNEMONIC8453="slush oyster cash hotel choice universe puzzle slot reflect sword intact fat"
export MNEMONIC84531="result mom hard lend adapt where result mule address ivory excuse embody"
export INFURA_KEY="000ba27dfb1b3663aadfc74c3ab092ae"
export ETHERSCAN_KEY="9GEEN6VPKUR7O6ZFBJEKCWSK49YGMPUBBG"
```

## Alternative Configuration: Using Private Keys instead of Mnemonics, and Alchemy instead if Infura ##
Alternatively to using mnemonics, private keys can be used instead.
When both mnemonics and private keys are set in the environment variables, private keys are used.

Similarly, alchemy can be used instead of infura.
If both infura and alchemy keys are set, alchemy is used.

1. Create or import private keys of the accounts for
   1. Mainnet
   2. Goerli
   3. Polygon
   4. Mumbai (Polygon Testnet)
   5. Binance Smart Chain (BSC) Mainnet
   6. BSC Testnet
   7. opBNB
   8. opBNB Testnet
   9. Base Mainnet
   10. Base Goerli (Testnet)

   You can use MetaMask to export private keys: https://metamask.io/

   Note: you can use the same private key for test networks (ropsten, rinkeby and kovan).
   Always use a separate one for mainnet, keep it secure.

2. Create an alchemy API key at https://alchemy.com/

3. Create etherscan API key at https://etherscan.io/

4. Export private keys, infura access key, and etherscan API key as system environment variables
   (they should be available for hardhat):

   | Name         | Value                     |
   |--------------|---------------------------|
   | P_KEY1       | Mainnet private key       |
   | P_KEY5       | Goerli private key        |
   | P_KEY137     | Polygon private key       |
   | P_KEY80001   | Mumbai private key        |
   | P_KEY56      | BSC private key           |
   | P_KEY97      | BSC Testnet private key   |
   | P_KEY204     | opBNB private key         |
   | P_KEY5611    | opBNB Testnet private key |
   | P_KEY8453    | Base Mainnet private key  |
   | P_KEY84531   | Base Goerli private key   |
   | ALCHEMY_KEY  | Alchemy API key           |
   | ETHERSCAN_KEY| Etherscan API key         |

Note: private keys should start with ```0x```

### Example Script: macOS Catalina ###
```
export P_KEY1="0x5ed21858f273023c7fc0683a1e853ec38636553203e531a79d677cb39b3d85ad"
export P_KEY5="0xfb84b845b8ea672939f5f6c9a43b2ae53b3ee5eb8480a4bfc5ceeefa459bf20c"
export P_KEY137="0x5ed21858f273023c7fc0683a1e853ec38636553203e531a79d677cb39b3d85ad"
export P_KEY80001="0xfb84b845b8ea672939f5f6c9a43b2ae53b3ee5eb8480a4bfc5ceeefa459bf20c"
export P_KEY56="0x5ed21858f273023c7fc0683a1e853ec38636553203e531a79d677cb39b3d85ad"
export P_KEY97="0xfb84b845b8ea672939f5f6c9a43b2ae53b3ee5eb8480a4bfc5ceeefa459bf20c"
export P_KEY204="0x5ed21858f273023c7fc0683a1e853ec38636553203e531a79d677cb39b3d85ad"
export P_KEY5611="0xfb84b845b8ea672939f5f6c9a43b2ae53b3ee5eb8480a4bfc5ceeefa459bf20c"
export P_KEY8453="0x5ed21858f273023c7fc0683a1e853ec38636553203e531a79d677cb39b3d85ad"
export P_KEY84531="0xfb84b845b8ea672939f5f6c9a43b2ae53b3ee5eb8480a4bfc5ceeefa459bf20c"
export ALCHEMY_KEY="hLe1XqWAUlvmlW42Ka5fdgbpb97ENsMJ"
export ETHERSCAN_KEY="9GEEN6VPKUR7O6ZFBJEKCWSK49YGMPUBBG"
```

## Using Custom JSON-RPC Endpoint URL ##
To use custom JSON-RPC endpoint instead of infura/alchemy public endpoints, set the corresponding RPC URL as
an environment variable:

| Name            | Value                         |
|-----------------|-------------------------------|
| MAINNET_RPC_URL | Mainnet JSON-RPC endpoint URL |
| GOERLI_RPC_URL  | Goerli JSON-RPC endpoint URL  |

## Compilation ##
Execute ```npx hardhat compile``` command to compile smart contracts.

Compilation settings are defined in [hardhat.config.js](./hardhat.config.js) ```solidity``` section.

Note: Solidity files *.sol use strict compiler version, you need to change all the headers when upgrading the
compiler to another version 

## Testing ##
Smart contract tests are built with Truffle – in JavaScript (ES6) and [web3.js](https://web3js.readthedocs.io/)

The tests are located in [test](./test) folder. 
They can be run with built-in [Hardhat Network](https://hardhat.org/hardhat-network/).

Run ```npx hardhat test``` to run all the tests or ```.npx hardhat test <test_file>``` to run individual test file.
Example: ```npx hardhat test ./test/inft/inft.test.js```

### Troubleshooting ###
* After running any test (executing ```npx hardhat test ./test/inft/inft.test.js``` for example) I get
   ```
   An unexpected error occurred:
   
   Error: This method only supports Buffer but input was: 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
   ```
   Fix: downgrade @nomiclabs/hardhat-truffle5 plugin to 2.0.0 (see https://issueexplorer.com/issue/nomiclabs/hardhat/1885)
   ```
   npm install -D @nomiclabs/hardhat-truffle5@2.0.0
   ```

## Test Coverage ##
Smart contracts test coverage is powered by [solidity-coverage] plugin.

Run `npx hardhat coverage` to run test coverage and generate the report.

### Troubleshooting ###
* After running the coverage I get
   ```
   <--- Last few GCs --->

   [48106:0x7f9b09900000]  3878743 ms: Scavenge 3619.3 (4127.7) -> 3606.1 (4128.2) MB, 5.2 / 0.0 ms  (average mu = 0.262, current mu = 0.138) task
   [48106:0x7f9b09900000]  3878865 ms: Scavenge 3620.6 (4128.2) -> 3606.9 (4129.2) MB, 4.9 / 0.0 ms  (average mu = 0.262, current mu = 0.138) allocation failure
   [48106:0x7f9b09900000]  3882122 ms: Mark-sweep 3619.5 (4129.2) -> 3579.6 (4128.4) MB, 3221.6 / 0.7 ms  (average mu = 0.372, current mu = 0.447) task scavenge might not succeed


   <--- JS stacktrace --->

   FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
    1: 0x10610e065 node::Abort() (.cold.1) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    2: 0x104dabc19 node::Abort() [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    3: 0x104dabd8f node::OnFatalError(char const*, char const*) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    4: 0x104f29ef7 v8::Utils::ReportOOMFailure(v8::internal::Isolate*, char const*, bool) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    5: 0x104f29e93 v8::internal::V8::FatalProcessOutOfMemory(v8::internal::Isolate*, char const*, bool) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    6: 0x1050f8be5 v8::internal::Heap::FatalProcessOutOfMemory(char const*) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    7: 0x1050fccb6 v8::internal::Heap::RecomputeLimits(v8::internal::GarbageCollector) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    8: 0x1050f94f6 v8::internal::Heap::PerformGarbageCollection(v8::internal::GarbageCollector, v8::GCCallbackFlags) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
    9: 0x1050f6c4d v8::internal::Heap::CollectGarbage(v8::internal::AllocationSpace, v8::internal::GarbageCollectionReason, v8::GCCallbackFlags) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
   10: 0x105103dca v8::internal::Heap::AllocateRawWithLightRetrySlowPath(int, v8::internal::AllocationType, v8::internal::AllocationOrigin, v8::internal::AllocationAlignment) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
   11: 0x105103e51 v8::internal::Heap::AllocateRawWithRetryOrFailSlowPath(int, v8::internal::AllocationType, v8::internal::AllocationOrigin, v8::internal::AllocationAlignment) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
   12: 0x1050d425c v8::internal::Factory::NewFillerObject(int, bool, v8::internal::AllocationType, v8::internal::AllocationOrigin) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
   13: 0x10546fe0f v8::internal::Runtime_AllocateInYoungGeneration(int, unsigned long*, v8::internal::Isolate*) [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
   14: 0x105839d19 Builtins_CEntry_Return1_DontSaveFPRegs_ArgvOnStack_NoBuiltinExit [/usr/local/opt/nvm/versions/node/v16.4.0/bin/node]
   Abort trap: 6
   ```

   Fix: increase Node.js memory limit to 8 GB:
   ```
   export NODE_OPTIONS="--max-old-space-size=8192"
   ```

## Deployment (Prior to v2.4.1) ##
Deployments are implemented as [hardhat scripts](https://hardhat.org/guides/deploying.html), without migrations.

Deployment scripts perform smart contracts deployment itself and their setup configuration.
Executing a script may require several transactions to complete, which may fail. To help troubleshoot
partially finished deployment, the scripts are designed to be rerunnable and execute only the transactions
which were not executed in previous run(s).

Deployment scripts are located under [scripts](./scripts) folder.

To run fresh deployment:

1. Open [scripts/config.js](./scripts/config.js)

2. For the network of interest (where the deployment is going to happen to) locate the deployed instances address(es) and
erase them. For example, if we are to deploy all the contracts into the Rinkeby network:
   ```
   ...

		// Rinkeby Configuration
		case "rinkeby":
			return {
				// ALI ERC20 v2
				AliERC20v2: "",
				// where initial ALI token supply goes to
				ALI_H0: "0x5F185Da55f7BBD9217E3b3CeE06b180721FA6d34",
				// Personality Pod ERC721
				PersonalityPodERC721: "",
				// The Revenants NFT (AletheaNFT)
				TheRevenants: "",
				// iNFT v2
				IntelligentNFTv2: "",
				// iNFT Linker
				IntelliLinker: "",
				// 10k Sale (or Restricted Sale)
				FixedSupplySale: "",
				// Personality Minter (OpenSea Factory Implementation for PersonalityPodERC721)
				PersonalityMinter: "",
				// option ID ranges for the Personality Minter
				PERSONALITY_OPTIONS: [101, 201, 601, 2001, 5001, 10001],
				// Authorized OpenSea NFT Minter address which mints tokens via the Minter/Factory
				OPENSEA_MINTER_ADDR: "0xF57B2c51dED3A29e6891aba85459d600256Cf317",
				// 1,012 Personality Pod Airdrop contract
				PersonalityDrop: "",
			};

   ...
   ```

3. Run the deployment script of interest with the ```npx hardhat run``` command
   ```
   npx hardhat run --network rinkeby ./scripts/v2_deploy.js
   ```
where ```./scripts/v2_deploy.js``` specifies the deployment script,
and ```--network rinkeby``` specifies the network to run script for
(see [hardhat.config.js](./hardhat.config.js) for network definitions). 

To rerun the deployment script and continue partially completed script:

1. Open [scripts/config.js](./scripts/config.js)

2. For the network of interest locate the deployed instances address(es) and fill with the correct (previously deployed)
values. For example, if we already deployed some contracts into Rinkeby network, but are missing other contracts:
   ```
   ...

		// Rinkeby Configuration
		case "rinkeby":
			return {
				// ALI ERC20 v2
				AliERC20v2: "0x088effA8E63DF55F3736f04ED25581326f9798BA",
				// where initial ALI token supply goes to
				ALI_H0: "0x5F185Da55f7BBD9217E3b3CeE06b180721FA6d34",
				// Personality Pod ERC721
				PersonalityPodERC721: "0x88F4F4c6F5390D47b5F40c80025477CC24B86031",
				// The Revenants NFT (AletheaNFT)
				TheRevenants: "0x1B8fC14101A0fABb01b0422C7eecfDDA840246cE",
				// iNFT v2
				IntelligentNFTv2: "0x7CA09B3016327061E14e154Fb6dc1997F774C0Ff",
				// iNFT Linker
				IntelliLinker: "0x27eC121D2edc32815399Ce80822382eabf4f549C",
				// 10k Sale (or Restricted Sale)
				FixedSupplySale: "0x0A70c6b844425f844cF5b46725c7f92F26fa2F17",
				// Personality Minter (OpenSea Factory Implementation for PersonalityPodERC721)
				PersonalityMinter: "0x76145954700D7744c4FbC81Fe7312969cFAA2Df4",
				// option ID ranges for the Personality Minter
				PERSONALITY_OPTIONS: [101, 8109, 8909, 8989],
				// Authorized OpenSea NFT Minter address which mints tokens via the Minter/Factory
				OPENSEA_MINTER_ADDR: "0xF57B2c51dED3A29e6891aba85459d600256Cf317",
				// 1,012 Personality Pod Airdrop contract
				PersonalityDrop: "0x58774C8E2ba92D885398A282Ed7Cbd7a283fad8d",
			};

   ...
   ```

3. Run the deployment script with the ```npx hardhat run``` command, for example:
   ```
   npx hardhat run --network rinkeby ./scripts/v2_deploy.js
   ```

## Post-deployment Routines (Prior to v2.4.1) ##
After the deployment is complete and [configuration](./scripts/config.js) is filled with the deployed contract
addresses, run the following scripts to enable features and roles, and to submit source code to Etherscan:
* ```v2_features.js```
* ```v2_roles.js```
* ```v2_verify.js```

Example:
   ```
   npx hardhat run --network rinkeby ./scripts/v2_features.js
   npx hardhat run --network rinkeby ./scripts/v2_roles.js
   npx hardhat run --network rinkeby ./scripts/v2_verify.js
   ```

## Deployment (Post v2.4.1) ##
Deployments are implemented via [hardhat-deploy plugin](https://github.com/wighawag/hardhat-deploy) by Ronan Sandford.

Deployment scripts perform smart contracts deployment itself and their setup configuration.
Executing a script may require several transactions to complete, which may fail. To help troubleshoot
partially finished deployment, the scripts are designed to be rerunnable and execute only the transactions
which were not executed in previous run(s).

Deployment scripts are located under [deploy](./deploy) folder.
Deployment execution state is saved under [deployments](./deployments) folder.

To run fresh deployment (goerli):

1. Delete [deployments/goerli](./deployments/goerli) folder contents.

2. Run the deployment of interest with the ```npx hardhat deploy``` command
   ```
   npx hardhat deploy --network goerli --tags v2_5_deploy
   ```
   where ```v2_5_deploy``` specifies the deployment script tag to run,
   and ```--network goerli``` specifies the network to run script for
   (see [hardhat.config.js](./hardhat.config.js) for network definitions).

3. Verify source code on Etherscan with the ```npx hardhat verify``` command
   ```
   npx hardhat verify --network goerli
   ```

4. Enable the roles (see Access Control) required by the protocol
   ```
   npx hardhat deploy --network goerli --tags v2_5_roles
   ```
   Note: this step can be done via Etherscan UI manually

5. Enable the features (see Access Control) required by the protocol
   ```
   npx hardhat deploy --network goerli --tags v2_5_features
   ```
   Note: this step can be done via Etherscan UI manually

To rerun the deployment script and continue partially completed script skip the first step
(do not cleanup the [deployments](./deployments) folder).

## Deployment (v2.8) ##
2.8 deployment is special since it is executed in 3 networks: mainnet/goerli, BNB/BNB Testnet, opBNB/opBNB Testnet

During the deployment the data from one deployment needs to be supplied into another, therefore scripts are run 4
times:
1. L1: mainnet/goerli
2. L2: BNB/BNB Testnet
3. L3: opBNB/opBNB Testnet
4. L1: mainnet/goerli (set some addresses from L2)

To execute all these steps for all L1/L2/L3 testnets (goerli, BNB Testnet and opBNB Testnet) run:
```
npm run deploy-testnet
```

To execute all these steps for all L1/L2/L3 mainnets (mainnet, BNB, opBNB) run:
```
npm run deploy-mainnet
```

To verify deployed contracts source code in all L1/L2/L3 testnets (goerli, BNB Testnet and opBNB Testnet) run:
```
npm run verify-testnet
```

To verify deployed contracts source code in all L1/L2/L3 mainnets (mainnet, BNB, opBNB) run:
```
npm run verify-mainnet
```

## Connecting to the Live Infrastructure ##
The core of the iNFT protocol is permissionless, meaning it is possible for developers to create their own
interfaces to interact with the protocol.

### ALI ERC20 Token (Artificial Liquid Intelligence ERC20 Token) ###
| Network          | Address                                      |
|------------------|----------------------------------------------|
| Ethereum Mainnet | `0x6B0b3a982b4634aC68dD83a4DBF02311cE324181` |
| Polygon Mainnet  | `0xbfc70507384047aa74c29cdc8c5cb88d0f7213ac` |
| BNB Mainnet      | `0xfcCF7b2caEE328A02042Ac19f1B3970Ca683E806` |

### iNFT Protocol: Ethereum Mainnet ###
| Contract         | Ethereum Mainnet Address                     |
|------------------|----------------------------------------------|
| AI Pod ERC721    | `0xDd70AF84BA86F29bf437756B655110D134b5651C` |
| iNFT             | `0xa189121eE045AEAA8DA80b72F7a1132e3B216237` |
| iNFT Linker      | `0xB9F02FC926b2ab66CAdd6eA1Ee90FB0D8698790b` |

`iNFT` contract locks the AI Pod, "attaching" it to the target NFT. `iNFT` contract is available for reading only,
writing interaction (creation of iNFT record) is possible via `iNFT Linker` helper contract.

### Whitelisted Target NFTs: Ethereum Mainnet ###
`iNFT Linker` allows binding an AI Pod to a "target NFT", binding is possible only to the supported ERC721 contracts,
which were used to train AI models.

At the moment of writing following ERC721 contracts are supported to binding an AI Pod to them and creating an iNFT:

```
0xf3E6DbBE461C6fa492CeA7Cb1f5C5eA660EB1B47
0xF4ee95274741437636e748DdAc70818B4ED7d043
0xBd3531dA5CF5857e7CfAA92426877b022e612cf8
0xC4a0b1E7AA137ADA8b2F911A501638088DFdD508
0xB5C747561a185A146f83cFff25BdfD2455b31fF4
```

(c) 2021-2023 [Alethea AI](https://alethea.ai/)
