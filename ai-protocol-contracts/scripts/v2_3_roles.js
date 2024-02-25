// v2.3 roles setup script: setups roles for
//   - Arkive – Mystery Box (AletheaNFT),
//   - ArkiveMinter – Mystery Box Minter (OpenSea Factory Implementation for Arkive)

// Run: npx hardhat run --network rinkeby ./scripts/v2_3_roles.js

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
	ROLE_MINTER,
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

	// setup roles required for ArkiveMinter to operate
	if(conf.ArkiveMinter) {
		{
			const OpenSeaFactory = await hre.ethers.getContractFactory("OpenSeaFactoryImpl");
			console.log("Connecting to ArkiveMinter (OpenSeaFactoryImpl) at %o", conf.ArkiveMinter);
			instances.ArkiveMinter = await OpenSeaFactory.attach(conf.ArkiveMinter);
			const nftContract = await instances.ArkiveMinter.nftContract();
			const numOptions = to_number(await instances.ArkiveMinter.numOptions());
			const options = new Array(numOptions);
			for(let i = 0; i < options.length; i++) {
				const upper = to_number(await instances.ArkiveMinter.tokenIdUpperBound(i));
				const current = to_number(await instances.ArkiveMinter.currentTokenId(i));
				options[i] = upper - current;
			}
			const features = await instances.ArkiveMinter.features();
			const r0 = await instances.ArkiveMinter.userRoles(A0);
			console.log("Connected to ArkiveMinter (OpenSeaFactoryImpl) at %o:", conf.ArkiveMinter);
			console.table([
				{"key": "NFT Contract", "value": nftContract},
				{"key": "Number of Options", "value": numOptions},
				{"key": "Tokens Left", "value": options.reduce((a, v) => a + v, 0)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
			]);

			assert(nftContract === conf.ArkiveERC721, "ArkiveERC721 mismatch: conf vs OpenSeaFactoryImpl.nftContract");
		}

		{
			const AletheaNFT = await hre.ethers.getContractFactory("AletheaNFT");
			console.log("Connecting to ArkiveERC721 at %o", conf.ArkiveERC721);
			instances.ArkiveERC721 = await AletheaNFT.attach(conf.ArkiveERC721);
			const name = await instances.ArkiveERC721.name();
			const symbol = await instances.ArkiveERC721.symbol();
			const totalSupply = await instances.ArkiveERC721.totalSupply();
			const features = await instances.ArkiveERC721.features();
			const r0 = await instances.ArkiveERC721.userRoles(A0);
			const r1 = await instances.ArkiveERC721.userRoles(conf.PersonalityMinter);
			console.log("Connected to ArkiveERC721 at %o:", conf.ArkiveERC721);
			console.table([
				{"key": "Name", "value": name},
				{"key": "Symbol", "value": symbol},
				{"key": "Total Supply", "value": to_number(totalSupply)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
				{"key": "Minter Role", "value": r1.toHexString()}, // 16
			]);

			if(r1.isZero()) {
				console.log(
					'Enabling "ROLE_TOKEN_CREATOR" %o on ArkiveERC721 %o for ArkiveMinter (OpenSeaFactoryImpl) %o',
					ROLE_TOKEN_CREATOR,
					conf.ArkiveERC721,
					conf.ArkiveMinter
				);
				await instances.ArkiveERC721.updateRole(conf.ArkiveMinter, ROLE_TOKEN_CREATOR);
			}
		}
	}
	else {
		console.log("ArkiveMinter (OpenSeaFactoryImpl) is not deployed, skipping");
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
