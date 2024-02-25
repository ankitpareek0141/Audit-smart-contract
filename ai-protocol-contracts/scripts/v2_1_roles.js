// v2.1 roles setup script: setups roles for
//   - PersonalityDrop,
//   - PersonalityStaking

// Run: npx hardhat run --network rinkeby ./scripts/v2_1_roles.js

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

	// setup roles required for PersonalityDrop to operate
	if(conf.PersonalityDrop) {
		{
			const PersonalityDrop = await hre.ethers.getContractFactory("ERC721Drop");
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

		{
			const PersonalityPodERC721 = await hre.ethers.getContractFactory("PersonalityPodERC721");
			console.log("Connecting to PersonalityPodERC721 at %o", conf.PersonalityPodERC721);
			instances.PersonalityPodERC721 = await PersonalityPodERC721.attach(conf.PersonalityPodERC721);
			const name = await instances.PersonalityPodERC721.name();
			const symbol = await instances.PersonalityPodERC721.symbol();
			const totalSupply = await instances.PersonalityPodERC721.totalSupply();
			const features = await instances.PersonalityPodERC721.features();
			const r0 = await instances.PersonalityPodERC721.userRoles(A0);
			const r1 = await instances.PersonalityPodERC721.userRoles(conf.PersonalityDrop);
			console.log("Connected to PersonalityPodERC721 at %o:", conf.PersonalityPodERC721);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "PersonalityDrop Role", "value": r1.toHexString()}, // 16
			]);

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_TOKEN_CREATOR" %o on PersonalityPodERC721 %o for PersonalityDrop %o',
					ROLE_TOKEN_CREATOR,
					conf.PersonalityPodERC721,
					conf.PersonalityDrop
				);
				await instances.PersonalityPodERC721.updateRole(conf.PersonalityDrop, ROLE_TOKEN_CREATOR);
			}
		}
	}
	else {
		console.log("PersonalityDrop (ERC721Drop) is not deployed, skipping");
	}

	// PersonalityStaking (NFTStaking): no roles to setup

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
