// v2.4 features setup script: setups features for
//   - IntelliLinkerV2Proxy

// Run: npx hardhat run --network rinkeby ./scripts/v2_4_features.js

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

	// setup features for iNFT Linker v2 (Upgradeable)
	if(conf.IntelliLinkerV2Proxy) {
		const IntelliLinkerV2 = await hre.ethers.getContractFactory("IntelliLinkerV2");
		console.log("Connecting to IntelliLinkerV2Proxy at %o", conf.IntelliLinkerV2Proxy);
		instances.IntelliLinkerV2Proxy = await IntelliLinkerV2.attach(conf.IntelliLinkerV2Proxy);
		const linkPrice = await instances.IntelliLinkerV2Proxy.linkPrice();
		const linkFee = await instances.IntelliLinkerV2Proxy.linkFee();
		const feeDestination = await instances.IntelliLinkerV2Proxy.feeDestination();
		const nextId = await instances.IntelliLinkerV2Proxy.nextId();
		const aliContract = await instances.IntelliLinkerV2Proxy.aliContract();
		const personalityContract = await instances.IntelliLinkerV2Proxy.personalityContract();
		const iNftContract = await instances.IntelliLinkerV2Proxy.iNftContract();
		const features = await instances.IntelliLinkerV2Proxy.features();
		const r0 = await instances.IntelliLinkerV2Proxy.userRoles(A0);
		console.log("Connected to IntelliLinkerV2Proxy at %o:", conf.IntelliLinkerV2Proxy);
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

		assert.equal(aliContract, conf.AliERC20v2, "AliERC20v2 mismatch: conf vs IntelliLinkerV2Proxy");
		assert.equal(personalityContract, conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs IntelliLinkerV2Proxy");
		assert.equal(iNftContract, conf.IntelligentNFTv2, "IntelligentNFTv2 mismatch: conf vs IntelliLinkerV2Proxy");

		if(features.isZero()) {
			console.log('Enabling "FEATURE_LINKING" %o for IntelliLinkerV2Proxy %o', FEATURE_LINKING, conf.IntelliLinkerV2Proxy);
			await instances.IntelliLinkerV2Proxy.updateFeatures(FEATURE_LINKING);
		}
	}
	else {
		console.log("IntelliLinkerV2Proxy is not deployed, skipping");
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
