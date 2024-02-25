// v2.5 roles setup script: setups roles in Polygon (Mumbai) for
//   - CharacterFactory (NFTFactory)

// Run: npx hardhat run --network mumbai ./scripts/v2_5_roles_polygon.js

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

	// setup roles required for CharacterFactory to operate
	if(conf.CharacterFactory) {
		{
			const CharacterFactory = await hre.ethers.getContractFactory("NFTFactory");
			console.log("Connecting to CharacterFactory (NFTFactory) at %o", conf.CharacterFactory);
			instances.CharacterFactory = await CharacterFactory.attach(conf.CharacterFactory);
			const features = await instances.CharacterFactory.features();
			const r0 = await instances.CharacterFactory.userRoles(A0);
			console.log("Connected to CharacterFactory (NFTFactory) at %o:", conf.CharacterFactory);
			console.table([
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
			]);
		}

		{
			const WhitelabelNFT = await hre.ethers.getContractFactory("WhitelabelNFT");
			console.log("Connecting to PolygonCharacter (WhitelabelNFT) at %o", conf.PolygonCharacter);
			instances.PolygonCharacter = await WhitelabelNFT.attach(conf.PolygonCharacter);
			const name = await instances.PolygonCharacter.name();
			const symbol = await instances.PolygonCharacter.symbol();
			const totalSupply = await instances.PolygonCharacter.totalSupply();
			const features = await instances.PolygonCharacter.features();
			const r0 = await instances.PolygonCharacter.userRoles(A0);
			const r1 = await instances.PolygonCharacter.userRoles(conf.CharacterFactory);
			console.log("Connected to PolygonCharacter at %o:", conf.PolygonCharacter);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "CharacterFactory Role", "value": r1.toHexString()}, // 16
			]);

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_TOKEN_CREATOR" %o on PolygonCharacter (WhitelabelNFT) %o for CharacterFactory (NFTFactory) %o',
					ROLE_TOKEN_CREATOR,
					conf.PolygonCharacter,
					conf.CharacterFactory
				);
				await instances.PolygonCharacter.updateRole(conf.CharacterFactory, ROLE_TOKEN_CREATOR);
			}
		}
	}
	else {
		console.log("CharacterFactory (NFTFactory) is not deployed, skipping");
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
