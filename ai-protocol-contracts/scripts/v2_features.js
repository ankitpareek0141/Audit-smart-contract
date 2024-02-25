// v2 features setup script: setups features for
//   - AliERC20v2,
//   - PersonalityPodERC721,
//   - TheRevenants (AletheaNFT),
//   - IntelliLinker,

// Run: npx hardhat run --network rinkeby ./scripts/v2_features.js

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// BigNumber utils
const {
	print_amt,
	to_number,
} = require("./include/big_number_utils");

// features in use
const {
	FEATURE_LINKING,
	FEATURE_ALL,
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

	// setup features for ALI Token
	if(conf.AliERC20v2) {
		const AliERC20v2 = await hre.ethers.getContractFactory("AliERC20v2");
		console.log("Connecting to AliERC20v2 at %o", conf.AliERC20v2);
		instances.AliERC20v2 = await AliERC20v2.attach(conf.AliERC20v2);
		const name = await instances.AliERC20v2.name();
		const symbol = await instances.AliERC20v2.symbol();
		const decimals = await instances.AliERC20v2.decimals();
		const B0 = await instances.AliERC20v2.balanceOf(conf.ALI_H0);
		const S0 = await instances.AliERC20v2.totalSupply();
		const features = await instances.AliERC20v2.features();
		const r0 = await instances.AliERC20v2.userRoles(A0);
		console.log("Connected to AliERC20v2 at %o:", conf.AliERC20v2);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Decimals", "value": to_number(decimals)},
			{"key": "Total Supply", "value": to_number(S0)},
			{"key": "Initial Holder, H0", "value": conf.ALI_H0},
			{"key": "balanceOf(H0)", "value": to_number(B0)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		if(features.isZero()) {
			console.log('Enabling "FEATURE_ALL" %o for AliERC20v2 %o', FEATURE_ALL, conf.AliERC20v2);
			await instances.AliERC20v2.updateFeatures(FEATURE_ALL);
		}
	}
	else {
		console.log("AliERC20v2 is not deployed, skipping");
	}

	// setup features for Personality Pod ERC721
	if(conf.PersonalityPodERC721) {
		const PersonalityPodERC721 = await hre.ethers.getContractFactory("PersonalityPodERC721");
		console.log("Connecting to PersonalityPodERC721 at %o", conf.PersonalityPodERC721);
		instances.PersonalityPodERC721 = await PersonalityPodERC721.attach(conf.PersonalityPodERC721);
		const name = await instances.PersonalityPodERC721.name();
		const symbol = await instances.PersonalityPodERC721.symbol();
		const totalSupply = await instances.PersonalityPodERC721.totalSupply();
		const features = await instances.PersonalityPodERC721.features();
		const r0 = await instances.PersonalityPodERC721.userRoles(A0);
		console.log("Connected to PersonalityPodERC721 at %o:", conf.PersonalityPodERC721);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Total Supply", "value": to_number(totalSupply)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		if(features.isZero()) {
			console.log('Enabling "FEATURE_ALL" %o for PersonalityPodERC721 %o', FEATURE_ALL, conf.PersonalityPodERC721);
			await instances.PersonalityPodERC721.updateFeatures(FEATURE_ALL);
		}
	}
	else {
		console.log("PersonalityPodERC721 is not deployed, skipping");
	}

	// setup features for TheRevenants
	if(conf.TheRevenants) {
		const AletheaNFT = await hre.ethers.getContractFactory("AletheaNFT");
		console.log("Connecting to TheRevenants (AletheaNFT) at %o", conf.TheRevenants);
		instances.TheRevenants = await AletheaNFT.attach(conf.TheRevenants);
		const name = await instances.TheRevenants.name();
		const symbol = await instances.TheRevenants.symbol();
		const totalSupply = await instances.TheRevenants.totalSupply();
		const features = await instances.TheRevenants.features();
		const r0 = await instances.TheRevenants.userRoles(A0);
		console.log("Connected to TheRevenants (AletheaNFT) at %o:", conf.TheRevenants);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Total Supply", "value": to_number(totalSupply)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		if(features.isZero()) {
			console.log('Enabling "FEATURE_ALL" %o for TheRevenants (AletheaNFT) %o', FEATURE_ALL, conf.TheRevenants);
			await instances.TheRevenants.updateFeatures(FEATURE_ALL);
		}
	}
	else {
		console.log("TheRevenants (AletheaNFT) is not deployed, skipping");
	}

	// iNFT version 2 doesn't introduce any features

	// setup features for iNFT Linker
	if(conf.IntelliLinker) {
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

		if(features.isZero()) {
			console.log('Enabling "FEATURE_LINKING" %o for IntelliLinker %o', FEATURE_LINKING, conf.IntelliLinker);
			await instances.IntelliLinker.updateFeatures(FEATURE_LINKING);
		}
	}
	else {
		console.log("IntelliLinker is not deployed, skipping");
	}

	// FixedSupply Sale introduces FEATURE_PUBLIC_SALE feature which we leave disabled

	// PersonalityMinter (OpenSeaFactoryImpl) doesn't introduce any features

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
