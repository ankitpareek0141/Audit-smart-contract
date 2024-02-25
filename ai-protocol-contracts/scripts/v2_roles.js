// v2 roles setup script: setups roles for
//   - AliERC20v2,
//   - PersonalityPodERC721,
//   - TheRevenants (AletheaNFT),
//   - IntelligentNFTv2,
//   - IntelliLinker,
//   - FixedSupplySale,
//   - PersonalityMinter (OpenSeaFactoryImpl)

// Run: npx hardhat run --network rinkeby ./scripts/v2_roles.js

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// we use assert to fail fast in case of any errors
const assert = require("assert");

// BigNumber utils
const {
	print_amt,
	to_number,
} = require("./include/big_number_utils");

// roles in use
const {
	ROLE_TOKEN_CREATOR,
	ROLE_MINTER,
} = require("./include/features_roles");

// we're going to use async/await programming style, therefore we put
// all the logic into async main and execute it in the end of the file
// see https://javascript.plainenglish.io/writing-asynchronous-programs-in-javascript-9a292570b2a6
async function main() {
	// Hardhat always runs the compile task when running scripts with its command
	// line interface.
	//
	// If this script is run directly using `node` you may want to call compile
	// manually to make sure everything is compiled
	// await hre.run('compile');

	// check if we're on the local hardhat test network
	if (network.name === "hardhat") {
		console.warn(
			"You are trying to deploy a contract to the Hardhat Network, which" +
			"gets automatically created and destroyed every time. Use the Hardhat" +
			" option '--network localhost'"
		);
	}

	// print some useful info on the account we're using for the deployment
	const [A0] = await web3.eth.getAccounts();
	let nonce = await web3.eth.getTransactionCount(A0);
	let balance = await web3.eth.getBalance(A0);
	// print initial debug information
	console.log("network %o", network.name);
	console.log("service account %o, nonce: %o, balance: %o ETH", A0, nonce, print_amt(balance));

	// config file contains known deployed addresses, deployment settings
	const Config = require('./config');

	// a collection of all known addresses (smart contracts and external)
	const conf = Config(network.name);

	// an object to contain all ABI linked instances to the addresses above
	const instances = {};

	// setup roles required for iNFT Linker to operate
	if(conf.IntelliLinker) {
		{
			const IntelliLinker = await hre.ethers.getContractFactory("IntelliLinker");
			console.log("Connecting to IntelliLinker at %o", conf.IntelliLinker);
			instances.IntelliLinker = await IntelliLinker.attach(conf.IntelliLinker);
			const linkPrice = await instances.IntelliLinker.linkPrice();
			const linkFee = await instances.IntelliLinker.linkFee();
			const feeDestination = await instances.IntelliLinker.feeDestination();
			const nextId = await instances.IntelliLinker.nextId();
			const aliContract = await instances.IntelliLinker.aliContract();
			const personalityContract = await instances.IntelliLinker.personalityContract();
			const iNftContract = await instances.IntelliLinker.iNftContract();
			const features = await instances.IntelliLinker.features();
			const r0 = await instances.IntelliLinker.userRoles(A0);
			console.log("Connected to IntelliLinker at %o:", conf.IntelliLinker);
			console.table([
				{"key": "Link Price", "value": to_number(linkPrice)},
				{"key": "Link Fee", "value": to_number(linkFee)},
				{"key": "Fee Destination", "value": feeDestination},
				{"key": "Next ID", "value": to_number(nextId)},
				{"key": "ALI Contract", "value": aliContract},
				{"key": "AI Personality Contract", "value": personalityContract},
				{"key": "iNFT Contract", "value": iNftContract},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
			]);

			assert(aliContract === conf.AliERC20v2, "AliERC20v2 mismatch: conf vs IntelliLinker");
			assert(personalityContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs IntelliLinker");
			assert(iNftContract === conf.IntelligentNFTv2, "IntelligentNFTv2 mismatch: conf vs IntelliLinker");
		}

		{
			const IntelligentNFTv2 = await hre.ethers.getContractFactory("IntelligentNFTv2");
			console.log("Connecting to IntelligentNFTv2 at %o", conf.IntelligentNFTv2);
			instances.IntelligentNFTv2 = await IntelligentNFTv2.attach(conf.IntelligentNFTv2);
			const name = await instances.IntelligentNFTv2.name();
			const symbol = await instances.IntelligentNFTv2.symbol();
			const totalSupply = await instances.IntelligentNFTv2.totalSupply();
			const aliContract = await instances.IntelligentNFTv2.aliContract();
			const aliBalance = await instances.IntelligentNFTv2.aliBalance();
			const features = await instances.IntelligentNFTv2.features();
			const r0 = await instances.IntelligentNFTv2.userRoles(A0);
			const r1 = await instances.IntelligentNFTv2.userRoles(conf.IntelliLinker);
			console.log("Connected to IntelligentNFTv2 at %o:", conf.IntelligentNFTv2);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "ALI Contract", "value": aliContract},
				{"key": "ALI Balance", "value": to_number(aliBalance)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "Linker Role", "value": r1.toHexString()}, // 16
			]);

			assert(aliContract === conf.AliERC20v2, "AliERC20v2 mismatch: conf vs IntelligentNFTv2");

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_MINTER" %o on IntelligentNFTv2 %o for IntelliLinker %o',
					ROLE_MINTER,
					conf.IntelligentNFTv2,
					conf.IntelliLinker
				);
				await instances.IntelligentNFTv2.updateRole(conf.IntelliLinker, ROLE_MINTER);
			}
		}
	}
	else {
		console.log("IntelliLinker is not deployed, skipping");
	}

	// setup roles required for FixedSupply Sale to operate
	if(conf.FixedSupplySale) {
		{
			const FixedSupplySale = await hre.ethers.getContractFactory("FixedSupplySale");
			console.log("Connecting to FixedSupplySale at %o", conf.FixedSupplySale);
			instances.FixedSupplySale = await FixedSupplySale.attach(conf.FixedSupplySale);
			const itemPrice = await instances.FixedSupplySale.itemPrice();
			const nextId = await instances.FixedSupplySale.nextId();
			const finalId = await instances.FixedSupplySale.finalId();
			const saleStart = await instances.FixedSupplySale.saleStart();
			const saleEnd = await instances.FixedSupplySale.saleEnd();
			const batchLimit = await instances.FixedSupplySale.batchLimit();
			const soldCounter = await instances.FixedSupplySale.soldCounter();
			const aliContract = await instances.FixedSupplySale.aliContract();
			const nftContract = await instances.FixedSupplySale.nftContract();
			const personalityContract = await instances.FixedSupplySale.personalityContract();
			const iNftContract = await instances.FixedSupplySale.iNftContract();
			const features = await instances.FixedSupplySale.features();
			const r0 = await instances.FixedSupplySale.userRoles(A0);
			console.log("Connected to FixedSupplySale at %o:", conf.FixedSupplySale);
			console.table([
				{"key": "Item Price", "value": to_number(itemPrice)},
				{"key": "Next ID", "value": to_number(nextId)},
				{"key": "Final ID", "value": to_number(finalId)},
				{"key": "Sale Start", "value": new Date(to_number(saleStart) * 1000)},
				{"key": "Sale End", "value": new Date(to_number(saleEnd) * 1000)},
				{"key": "Batch Limit", "value": to_number(batchLimit)},
				{"key": "Sold Counter", "value": to_number(soldCounter)},
				{"key": "ALI Contract", "value": aliContract},
				{"key": "NFT Contract", "value": nftContract},
				{"key": "AI Personality Contract", "value": personalityContract},
				{"key": "iNFT Contract", "value": iNftContract},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
			]);

			assert(aliContract === conf.AliERC20v2, "AliERC20v2 mismatch: conf vs FixedSupplySale");
			assert(nftContract === conf.TheRevenants, "TheRevenants mismatch: conf vs FixedSupplySale");
			assert(personalityContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs FixedSupplySale");
			assert(iNftContract === conf.IntelligentNFTv2, "IntelligentNFTv2 mismatch: conf vs FixedSupplySale");
		}

		{
			const PersonalityPodERC721 = await hre.ethers.getContractFactory("PersonalityPodERC721");
			console.log("Connecting to PersonalityPodERC721 at %o", conf.PersonalityPodERC721);
			instances.PersonalityPodERC721 = await PersonalityPodERC721.attach(conf.PersonalityPodERC721);
			const name = await instances.PersonalityPodERC721.name();
			const symbol = await instances.PersonalityPodERC721.symbol();
			const totalSupply = await instances.PersonalityPodERC721.totalSupply();
			const features = await instances.PersonalityPodERC721.features();
			const r0 = await instances.PersonalityPodERC721.userRoles(A0);
			const r1 = await instances.PersonalityPodERC721.userRoles(conf.FixedSupplySale);
			console.log("Connected to PersonalityPodERC721 at %o:", conf.PersonalityPodERC721);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "Sale Role", "value": r1.toHexString()}, // 16
			]);

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_TOKEN_CREATOR" %o on PersonalityPodERC721 %o for FixedSupplySale %o',
					ROLE_TOKEN_CREATOR,
					conf.PersonalityPodERC721,
					conf.FixedSupplySale
				);
				await instances.PersonalityPodERC721.updateRole(conf.FixedSupplySale, ROLE_TOKEN_CREATOR);
			}
		}

		{
			const AletheaNFT = await hre.ethers.getContractFactory("AletheaNFT");
			console.log("Connecting to TheRevenants (AletheaNFT) at %o", conf.TheRevenants);
			instances.TheRevenants = await AletheaNFT.attach(conf.TheRevenants);
			const name = await instances.TheRevenants.name();
			const symbol = await instances.TheRevenants.symbol();
			const totalSupply = await instances.TheRevenants.totalSupply();
			const features = await instances.TheRevenants.features();
			const r0 = await instances.TheRevenants.userRoles(A0);
			const r1 = await instances.TheRevenants.userRoles(conf.FixedSupplySale);
			console.log("Connected to TheRevenants (AletheaNFT) at %o:", conf.TheRevenants);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "Sale Role", "value": r1.toHexString()}, // 16
			]);

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_TOKEN_CREATOR" %o on TheRevenants (AletheaNFT) %o for FixedSupplySale %o',
					ROLE_TOKEN_CREATOR,
					conf.TheRevenants,
					conf.FixedSupplySale
				);
				await instances.TheRevenants.updateRole(conf.FixedSupplySale, ROLE_TOKEN_CREATOR);
			}
		}

		{
			const IntelligentNFTv2 = await hre.ethers.getContractFactory("IntelligentNFTv2");
			console.log("Connecting to IntelligentNFTv2 at %o", conf.IntelligentNFTv2);
			instances.IntelligentNFTv2 = await IntelligentNFTv2.attach(conf.IntelligentNFTv2);
			const name = await instances.IntelligentNFTv2.name();
			const symbol = await instances.IntelligentNFTv2.symbol();
			const totalSupply = await instances.IntelligentNFTv2.totalSupply();
			const aliContract = await instances.IntelligentNFTv2.aliContract();
			const aliBalance = await instances.IntelligentNFTv2.aliBalance();
			const features = await instances.IntelligentNFTv2.features();
			const r0 = await instances.IntelligentNFTv2.userRoles(A0);
			const r1 = await instances.IntelligentNFTv2.userRoles(conf.FixedSupplySale);
			console.log("Connected to IntelligentNFTv2 at %o:", conf.IntelligentNFTv2);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "ALI Contract", "value": aliContract},
				{"key": "ALI Balance", "value": to_number(aliBalance)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "Sale Role", "value": r1.toHexString()}, // 16
			]);

			assert(aliContract === conf.AliERC20v2, "AliERC20v2 mismatch: conf vs IntelligentNFTv2");

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_MINTER" %o on IntelligentNFTv2 %o for FixedSupplySale %o',
					ROLE_MINTER,
					conf.IntelligentNFTv2,
					conf.FixedSupplySale
				);
				await instances.IntelligentNFTv2.updateRole(conf.FixedSupplySale, ROLE_MINTER);
			}
		}
	}
	else {
		console.log("FixedSupplySale is not deployed, skipping");
	}

	// setup roles required for PersonalityMinter to operate
	if(conf.PersonalityMinter) {
		{
			const OpenSeaFactory = await hre.ethers.getContractFactory("OpenSeaFactoryImpl");
			console.log("Connecting to PersonalityMinter (OpenSeaFactoryImpl) at %o", conf.PersonalityMinter);
			instances.PersonalityMinter = await OpenSeaFactory.attach(conf.PersonalityMinter);
			const nftContract = await instances.PersonalityMinter.nftContract();
			const numOptions = to_number(await instances.PersonalityMinter.numOptions());
			const options = new Array(numOptions);
			for(let i = 0; i < options.length; i++) {
				const upper = to_number(await instances.PersonalityMinter.tokenIdUpperBound(i));
				const current = to_number(await instances.PersonalityMinter.currentTokenId(i));
				options[i] = upper - current;
			}
			const features = await instances.PersonalityMinter.features();
			const r0 = await instances.PersonalityMinter.userRoles(A0);
			console.log("Connected to PersonalityMinter (OpenSeaFactoryImpl) at %o:", conf.PersonalityMinter);
			console.table([
				{"key": "NFT Contract", "value": nftContract},
				{"key": "Number of Options", "value": numOptions},
				{"key": "Tokens Left", "value": options.reduce((a, v) => a + v, 0)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
			]);

			assert(nftContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs OpenSeaFactoryImpl.nftContract");
		}

		{
			const PersonalityPodERC721 = await hre.ethers.getContractFactory("PersonalityPodERC721");
			console.log("Connecting to PersonalityPodERC721 at %o", conf.PersonalityPodERC721);
			instances.PersonalityPodERC721 = await PersonalityPodERC721.attach(conf.PersonalityPodERC721);
			const name = await instances.PersonalityPodERC721.name();
			const symbol = await instances.PersonalityPodERC721.symbol();
			const totalSupply = await instances.PersonalityPodERC721.totalSupply();
			const features = await instances.PersonalityPodERC721.features();
			const r0 = await instances.PersonalityPodERC721.userRoles(A0);
			const r1 = await instances.PersonalityPodERC721.userRoles(conf.PersonalityMinter);
			console.log("Connected to PersonalityPodERC721 at %o:", conf.PersonalityPodERC721);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "Minter Role", "value": r1.toHexString()}, // 16
			]);

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_TOKEN_CREATOR" %o on PersonalityPodERC721 %o for PersonalityMinter (OpenSeaFactoryImpl) %o',
					ROLE_TOKEN_CREATOR,
					conf.PersonalityPodERC721,
					conf.PersonalityMinter
				);
				await instances.PersonalityPodERC721.updateRole(conf.PersonalityMinter, ROLE_TOKEN_CREATOR);
			}
		}
	}
	else {
		console.log("PersonalityMinter (OpenSeaFactoryImpl) is not deployed, skipping");
	}

	console.log("execution complete");
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
	.then(() => process.exit(0))
	.catch(error => {
		console.error(error);
		process.exit(1);
	});
