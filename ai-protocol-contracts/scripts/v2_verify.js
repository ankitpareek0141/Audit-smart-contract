// v2 source code verification script: verifies on Etherscan
//   - AliERC20v2,
//   - PersonalityPodERC721,
//   - TheRevenants (AletheaNFT),
//   - IntelligentNFTv2,
//   - IntelliLinker,
//   - FixedSupplySale
//   - PersonalityMinter (OpenSeaFactoryImpl)

// Run: npx hardhat run --network rinkeby ./scripts/v2_verify.js

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

	assert(conf.ALI_H0, "H0 not defined for the network " + network.name);

	// all verification tasks are submitted asynchronously, and are run in parallel
	// verification tasks array stores corresponding verification promises
	const verification_tasks = [];

	// verify ALI Token source code
	if(conf.AliERC20v2) {
		console.log("Submitting AliERC20v2 source code for verification at %o", conf.AliERC20v2);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.AliERC20v2,
			constructorArguments: [conf.ALI_H0],
		}));
	}

	// verify PersonalityPodERC721 source code
	if(conf.PersonalityPodERC721) {
		console.log("Submitting PersonalityPodERC721 source code for verification at %o", conf.PersonalityPodERC721);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.PersonalityPodERC721,
			constructorArguments: ["iNFT Personality Pod", "POD"],
		}));
	}

	// verify The Revenants (AletheaNFT) source code
	if(conf.TheRevenants) {
		console.log("Submitting The Revenants (AletheaNFT) source code for verification at %o", conf.TheRevenants);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.TheRevenants,
			constructorArguments: ["Revenants by Alethea AI", "REV"],
		}));
	}

	// verify iNFT version 2 source code
	if(conf.IntelligentNFTv2) {
		assert(conf.AliERC20v2, "AliERC20v2 not defined for the network " + network.name);
		console.log("Submitting IntelligentNFTv2 source code for verification at %o", conf.IntelligentNFTv2);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.IntelligentNFTv2,
			constructorArguments: [conf.AliERC20v2],
		}));
	}

	// verify iNFT Linker source code
	if(conf.IntelliLinker) {
		assert(conf.AliERC20v2, "AliERC20v2 not defined for the network " + network.name);
		assert(conf.PersonalityPodERC721, "PersonalityPodERC721 not defined for the network " + network.name);
		assert(conf.IntelligentNFTv2, "IntelligentNFTv2 not defined for the network " + network.name);
		console.log("Submitting IntelliLinker source code for verification at %o", conf.IntelliLinker);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.IntelliLinker,
			constructorArguments: [conf.AliERC20v2, conf.PersonalityPodERC721, conf.IntelligentNFTv2],
		}));
	}

	// verify FixedSupply Sale source code
	if(conf.FixedSupplySale) {
		assert(conf.AliERC20v2, "AliERC20v2 not defined for the network " + network.name);
		assert(conf.TheRevenants, "TheRevenants not defined for the network " + network.name);
		assert(conf.PersonalityPodERC721, "PersonalityPodERC721 not defined for the network " + network.name);
		assert(conf.IntelligentNFTv2, "IntelligentNFTv2 not defined for the network " + network.name);
		console.log("Submitting FixedSupplySale source code for verification at %o", conf.FixedSupplySale);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.FixedSupplySale,
			constructorArguments: [conf.AliERC20v2, conf.TheRevenants, conf.PersonalityPodERC721, conf.IntelligentNFTv2],
		}));
	}

	// verify PersonalityMinter (OpenSeaFactoryImpl) source code
	if(conf.PersonalityMinter) {
		assert(conf.PersonalityPodERC721, "PersonalityPodERC721 not defined for the network " + network.name);
		assert(conf.PERSONALITY_OPTIONS, "PERSONALITY_OPTIONS not defined for PersonalityMinter for the network" + network.name);
		console.log("Submitting PersonalityMinter (OpenSeaFactoryImpl) source code for verification at %o", conf.PersonalityMinter);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.PersonalityMinter,
			constructorArguments: [conf.PersonalityPodERC721, conf.OPENSEA_MINTER_ADDR, conf.PERSONALITY_OPTIONS],
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
