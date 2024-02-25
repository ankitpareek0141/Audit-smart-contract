// v2.5 source code verification script: verifies on Polyscan
//   - PolygonAliERC20v2
//   - PolygonCharacter (WhitelabelNFT)
//   - CharacterFactory (NFTFactory)

// Run: npx hardhat run --network mumbai ./scripts/v2_5_verify_polygon.js

// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// we use assert to fail fast in case of any errors
const assert = require("assert");

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
	if(network.name === "hardhat") {
		console.warn(
			"You are trying to deploy a contract to the Hardhat Network, which" +
			"gets automatically created and destroyed every time. Use the Hardhat" +
			" option '--network localhost'"
		);
	}

	// get the default account
	const [A0] = await web3.eth.getAccounts();

	// config file contains known deployed addresses, deployment settings
	const Config = require('./config');

	// a collection of all known addresses (smart contracts and external)
	const conf = Config(network.name);

	// all verification tasks are submitted asynchronously, and are run in parallel
	// verification tasks array stores corresponding verification promises
	const verification_tasks = [];

	// verify ALI Token source code
	if(conf.PolygonAliERC20v2) {
		console.log("Submitting PolygonAliERC20v2 source code for verification at %o", conf.PolygonAliERC20v2);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.PolygonAliERC20v2,
			constructorArguments: [A0],
		}));
	}

	// verify Polygon Character NFT (WhitelabelNFT) source code
	if(conf.PolygonCharacter) {
		console.log("Submitting PolygonCharacter (WhitelabelNFT) source code for verification at %o", conf.PolygonCharacter);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.PolygonCharacter,
			constructorArguments: ["mycharacter.ai", "MYAI"],
		}));
	}

	// verify CharacterFactory (NFTFactory) source code
	if(conf.CharacterFactory) {
		console.log("Submitting CharacterFactory (NFTFactory) source code for verification at %o", conf.CharacterFactory);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.CharacterFactory,
		}));
	}

	// wait for verification tasks to complete, some or all may fail if code is already verified
	await Promise.allSettled(verification_tasks);

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
