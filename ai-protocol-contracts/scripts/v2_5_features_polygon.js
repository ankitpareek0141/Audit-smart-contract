// v2.5 features setup script: setups features in Polygon (Mumbai) for
//   - PolygonAliERC20v2
//   - PolygonCharacter (WhitelabelNFT)

// Run: npx hardhat run --network mumbai ./scripts/v2_5_features_polygon.js

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
	if(conf.PolygonAliERC20v2) {
		const PolygonAliERC20v2 = await hre.ethers.getContractFactory("PolygonAliERC20v2");
		console.log("Connecting to PolygonAliERC20v2 at %o", conf.PolygonAliERC20v2);
		instances.PolygonAliERC20v2 = await PolygonAliERC20v2.attach(conf.PolygonAliERC20v2);
		const name = await instances.PolygonAliERC20v2.name();
		const symbol = await instances.PolygonAliERC20v2.symbol();
		const decimals = await instances.PolygonAliERC20v2.decimals();
		const B0 = await instances.PolygonAliERC20v2.balanceOf(A0);
		const S0 = await instances.PolygonAliERC20v2.totalSupply();
		const features = await instances.PolygonAliERC20v2.features();
		const r0 = await instances.PolygonAliERC20v2.userRoles(A0);
		console.log("Connected to PolygonAliERC20v2 at %o:", conf.PolygonAliERC20v2);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Decimals", "value": to_number(decimals)},
			{"key": "Total Supply", "value": to_number(S0)},
			{"key": "Initial Holder, H0", "value": A0},
			{"key": "balanceOf(H0)", "value": to_number(B0)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		if(features.isZero()) {
			console.log('Enabling "FEATURE_ALL" %o for PolygonAliERC20v2 %o', FEATURE_ALL, conf.PolygonAliERC20v2);
			await instances.PolygonAliERC20v2.updateFeatures(FEATURE_ALL);
		}
	}
	else {
		console.log("PolygonAliERC20v2 is not deployed, skipping");
	}

	// setup features for PolygonCharacter (WhitelabelNFT)
	if(conf.PolygonCharacter) {
		const WhitelabelNFT = await hre.ethers.getContractFactory("WhitelabelNFT");
		console.log("Connecting to PolygonCharacter (WhitelabelNFT) at %o", conf.PolygonCharacter);
		instances.PolygonCharacter = await WhitelabelNFT.attach(conf.PolygonCharacter);
		const name = await instances.PolygonCharacter.name();
		const symbol = await instances.PolygonCharacter.symbol();
		const totalSupply = await instances.PolygonCharacter.totalSupply();
		const features = await instances.PolygonCharacter.features();
		const r0 = await instances.PolygonCharacter.userRoles(A0);
		console.log("Connected to PolygonCharacter at %o:", conf.PolygonCharacter);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Total Supply", "value": to_number(totalSupply)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		if(features.isZero()) {
			console.log('Enabling "FEATURE_ALL" %o for PolygonCharacter (WhitelabelNFT) %o', FEATURE_ALL, conf.PolygonCharacter);
			await instances.PolygonCharacter.updateFeatures(FEATURE_ALL);
		}
	}
	else {
		console.log("PolygonCharacter (WhitelabelNFT) is not deployed, skipping");
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
