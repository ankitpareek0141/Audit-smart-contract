// v2.4 source code verification script: verifies on Etherscan
//   - IntelliLinkerV2Impl
//   - IntelliLinkerV2Proxy

// Run: npx hardhat run --network rinkeby ./scripts/v2_4_verify.js

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

	// verify iNFT Linker v2 (Upgradeable) source code – Implementation
	if(conf.IntelliLinkerV2Impl) {
		console.log("Submitting IntelliLinkerV2Impl source code for verification at %o", conf.IntelliLinkerV2Impl);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.IntelliLinkerV2Impl,
			constructorArguments: [],
		}));
	}

	// verify iNFT Linker v2 (Upgradeable) source code – Proxy (ERC1967)
	if(conf.IntelliLinkerV2Proxy) {
		assert(conf.IntelliLinkerV2Impl, "IntelliLinkerV2Impl not defined for the network " + network.name);
		assert(conf.AliERC20v2, "AliERC20v2 not defined for the network " + network.name);
		assert(conf.PersonalityPodERC721, "PersonalityPodERC721 not defined for the network " + network.name);
		assert(conf.IntelligentNFTv2, "IntelligentNFTv2 not defined for the network " + network.name);

		const IntelliLinkerV2 = await hre.ethers.getContractFactory("IntelliLinkerV2");
		const impl = await IntelliLinkerV2.attach(conf.IntelliLinkerV2Impl);

		// prepare the initialization call bytes to initialize the proxy (upgradeable compatibility)
		const init_data = impl.interface.encodeFunctionData(
			"postConstruct",
			[
				conf.AliERC20v2,
				conf.PersonalityPodERC721,
				conf.IntelligentNFTv2,
			]
		);

		console.log("Submitting IntelliLinkerV2Proxy source code for verification at %o", conf.IntelliLinkerV2Proxy);
		verification_tasks.push(hre.run("verify:verify", {
			address: conf.IntelliLinkerV2Proxy,
			constructorArguments: [conf.IntelliLinkerV2Impl, init_data],
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
