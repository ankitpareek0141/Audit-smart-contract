// v2.2 deployment script: deploys
//   - SophiaBeing,

// Run: npx hardhat run --network rinkeby ./scripts/v2_2_deploy.js

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
			" gets automatically created and destroyed every time. Use the Hardhat" +
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

	// link/deploy SophiaBeing
	const AletheaNFT = await hre.ethers.getContractFactory("AletheaNFT");
	if(conf.SophiaBeing) {
		console.log("Connecting to SophiaBeing (AletheaNFT) at %o", conf.SophiaBeing);
		instances.SophiaBeing = await AletheaNFT.attach(conf.SophiaBeing);
		const name = await instances.SophiaBeing.name();
		const symbol = await instances.SophiaBeing.symbol();
		const totalSupply = await instances.SophiaBeing.totalSupply();
		const features = await instances.SophiaBeing.features();
		const r0 = await instances.SophiaBeing.userRoles(A0);
		console.log("Connected to SophiaBeing at %o:", conf.SophiaBeing);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Total Supply", "value": to_number(totalSupply)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);
	}
	else {
		console.log("deploying SophiaBeing (AletheaNFT)");
		const token = await AletheaNFT.deploy("Sophia beingAI iNFT", "SOP");
		instances.SophiaBeing = await token.deployed();
		conf.SophiaBeing = instances.SophiaBeing.address;
		console.log("SophiaBeing (AletheaNFT) deployed to %o", conf.SophiaBeing);
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
