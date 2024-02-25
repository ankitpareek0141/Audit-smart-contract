// v2.3 source code verification script: verifies on Etherscan
//   - Arkive – Mystery Box (AletheaNFT),
//   - ArkiveMinter – Mystery Box Minter (OpenSea Factory Implementation for Arkive)
//   - ArkiveDrop (ERC721Drop)

// Run: npx hardhat run --network rinkeby ./scripts/v2_3_verify.js

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

	// config file contains known deployed addresses, deployment settings
	const Config = require('./config');

	// a collection of all known addresses (smart contracts and external)
	const conf = Config(network.name);

	// all verification tasks are submitted asynchronously, and are run in parallel
	// verification tasks array stores corresponding verification promises
	const verification_tasks = [];

	// verify ArkiveERC721 (AletheaNFT) source code
	if(conf.SophiaBeing) {
		console.log("Submitting ArkiveERC721 (AletheaNFT) source code for verification at %o", conf.ArkiveERC721);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.ArkiveERC721,
			constructorArguments: ["Arkive", "AKV"],
		}));
	}

	// verify ArkiveMinter (OpenSeaFactoryImpl) source code
	if(conf.ArkiveMinter) {
		assert(conf.ArkiveERC721, "ArkiveERC721 not defined for the network " + network.name);
		assert(conf.ARKIVE_OPTIONS, "ARKIVE_OPTIONS not defined for ArkiveMinter for the network" + network.name);
		console.log("Submitting ArkiveMinter (OpenSeaFactoryImpl) source code for verification at %o", conf.ArkiveMinter);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.ArkiveMinter,
			constructorArguments: [conf.ArkiveERC721, conf.OPENSEA_MINTER_ADDR, conf.ARKIVE_OPTIONS],
		}));
	}

	// verify ArkiveDrop (ERC721Drop) source code
	if(conf.ArkiveDrop) {
		assert(conf.ArkiveERC721, "ArkiveERC721 not defined for the network " + network.name);
		console.log("Submitting ArkiveDrop (ERC721Drop) source code for verification at %o", conf.ArkiveDrop);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.ArkiveDrop,
			constructorArguments: [conf.ArkiveERC721],
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
