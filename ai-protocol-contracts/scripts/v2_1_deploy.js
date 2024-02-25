// v2.1 deployment script: deploys
//   - PersonalityDrop,
//   - PersonalityStaking

// Run: npx hardhat run --network rinkeby ./scripts/v2_1_deploy.js

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

	assert(conf.PersonalityPodERC721, `PersonalityPodERC721 not defined for the network ${network.name}`);

	// link PersonalityPodERC721
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

	// link/deploy PersonalityDrop
	const PersonalityDrop = await hre.ethers.getContractFactory("ERC721Drop");
	if(conf.PersonalityDrop) {
		console.log("Connecting to PersonalityDrop (ERC721Drop) at %o", conf.PersonalityDrop);
		instances.PersonalityDrop = await PersonalityDrop.attach(conf.PersonalityDrop);
		const targetContract = await instances.PersonalityDrop.targetContract();
		const root = await instances.PersonalityDrop.root();
		const features = await instances.PersonalityDrop.features();
		const r0 = await instances.PersonalityDrop.userRoles(A0);
		console.log("Connected to PersonalityDrop (ERC721Drop) at %o:", conf.PersonalityDrop);
		console.table([
			{"key": "Target Contract", "value": targetContract},
			{"key": "Merkle Root", "value": root},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		assert(targetContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs ERC721Drop.targetContract");
	}
	else {
		console.log("deploying PersonalityDrop (ERC721Drop)");
		const drop = await PersonalityDrop.deploy(conf.PersonalityPodERC721);
		instances.PersonalityDrop = await drop.deployed();
		conf.PersonalityDrop = instances.PersonalityDrop.address;
		console.log("PersonalityDrop (ERC721Drop) deployed to %o", conf.PersonalityDrop);
	}

	// link/deploy PersonalityStaking (NFTStaking)
	const NFTStaking = await hre.ethers.getContractFactory("NFTStaking");
	if(conf.PersonalityStaking) {
		console.log("Connecting to PersonalityStaking (NFTStaking) at %o", conf.PersonalityStaking);
		instances.PersonalityStaking = await NFTStaking.attach(conf.PersonalityStaking);
		const targetContract = await instances.PersonalityStaking.targetContract();
		const features = await instances.PersonalityStaking.features();
		const r0 = await instances.PersonalityStaking.userRoles(A0);
		console.log("Connected to PersonalityStaking (NFTStaking) at %o:", conf.PersonalityStaking);
		console.table([
			{"key": "Target Contract", "value": targetContract},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		assert(targetContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs NFTStaking.targetContract");
	}
	else {
		console.log("deploying PersonalityStaking (NFTStaking)");
		const staking = await NFTStaking.deploy(conf.PersonalityPodERC721);
		instances.PersonalityStaking = await staking.deployed();
		conf.PersonalityStaking = instances.PersonalityStaking.address;
		console.log("PersonalityStaking (NFTStaking) deployed to %o", conf.PersonalityStaking);
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
