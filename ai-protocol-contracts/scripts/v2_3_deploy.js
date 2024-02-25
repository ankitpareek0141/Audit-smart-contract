// v2.3 deployment script: deploys
//   - Arkive – Mystery Box (AletheaNFT),
//   - ArkiveMinter – Mystery Box Minter (OpenSea Factory Implementation for Arkive)
//   - ArkiveDrop (ERC721Drop)

// Run: npx hardhat run --network rinkeby ./scripts/v2_3_deploy.js

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

	// link/deploy "Arkive" Mystery Box (AletheaNFT)
	const AletheaNFT = await hre.ethers.getContractFactory("AletheaNFT");
	if(conf.ArkiveERC721) {
		console.log("Connecting to \"Arkive\" Mystery Box (AletheaNFT) at %o", conf.ArkiveERC721);
		instances.ArkiveERC721 = await AletheaNFT.attach(conf.ArkiveERC721);
		const name = await instances.ArkiveERC721.name();
		const symbol = await instances.ArkiveERC721.symbol();
		const totalSupply = await instances.ArkiveERC721.totalSupply();
		const features = await instances.ArkiveERC721.features();
		const r0 = await instances.ArkiveERC721.userRoles(A0);
		console.log("Connected to ArkiveERC721 at %o:", conf.ArkiveERC721);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Total Supply", "value": to_number(totalSupply)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);
	}
	else {
		console.log("deploying \"Arkive\" Mystery Box (AletheaNFT)");
		const token = await AletheaNFT.deploy("Arkive", "AKV");
		instances.ArkiveERC721 = await token.deployed();
		conf.ArkiveERC721 = instances.ArkiveERC721.address;
		console.log("ArkiveERC721 deployed to %o", conf.ArkiveERC721);
	}

	// only if OPENSEA_MINTER_ADDR and ARKIVE_OPTIONS are set - link/deploy ArkiveMinter
	if(conf.OPENSEA_MINTER_ADDR && conf.ARKIVE_OPTIONS) {
		// link/deploy ArkiveMinter (OpenSea Factory Implementation for "Arkive" Mystery Box)
		const OpenSeaFactory = await hre.ethers.getContractFactory("OpenSeaFactoryImpl");
		if(conf.ArkiveMinter) {
			console.log("Connecting to ArkiveMinter (OpenSeaFactoryImpl) at %o", conf.ArkiveMinter);
			instances.ArkiveMinter = await OpenSeaFactory.attach(conf.ArkiveMinter);
			const nftContract = await instances.ArkiveMinter.nftContract();
			const numOptions = to_number(await instances.ArkiveMinter.numOptions());
			assert(numOptions === conf.ARKIVE_OPTIONS.length - 1, "ARKIVE_OPTIONS mismatch: conf vs ArkiveMinter.numOptions");
			const options = new Array(numOptions);
			for(let i = 0; i < options.length; i++) {
				const current = to_number(await instances.ArkiveMinter.currentTokenId(i));
				const upper = to_number(await instances.ArkiveMinter.tokenIdUpperBound(i));
				options[i] = upper - current;
				if(i !== options.length - 1) {
					assert(
						upper === conf.ARKIVE_OPTIONS[i + 1],
						`ARKIVE_OPTIONS[${i + 1}] mismatch: conf vs ArkiveMinter.tokenIdUpperBound(${i})`
					);
				}
			}
			const optionsTable = options.map((o, i) => Object.assign(
				{"key": `Option ${i}`, "value": o})
			);
			const features = await instances.ArkiveMinter.features();
			const r0 = await instances.ArkiveMinter.userRoles(A0);
			console.log("Connected to ArkiveMinter (OpenSeaFactoryImpl) at %o:", conf.ArkiveMinter);
			console.table([
				{"key": "NFT Contract", "value": nftContract},
				{"key": "Number of Options", "value": numOptions},
				...optionsTable,
				{"key": "Tokens Left", "value": options.reduce((a, v) => a + v, 0)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
			]);

			assert(nftContract === conf.ArkiveERC721, "ArkiveERC721 mismatch: conf vs OpenSeaFactoryImpl.nftContract");
		}
		else {
			console.log("deploying ArkiveMinter (OpenSeaFactoryImpl)");
			const minter = await OpenSeaFactory.deploy(conf.ArkiveERC721, conf.OPENSEA_MINTER_ADDR, conf.ARKIVE_OPTIONS);
			instances.ArkiveMinter = await minter.deployed();
			conf.ArkiveMinter = instances.ArkiveMinter.address;
			console.log("ArkiveMinter (OpenSeaFactoryImpl) deployed to %o", conf.ArkiveMinter);
		}
	}
	else {
		console.log("ArkiveMinter (OpenSeaFactoryImpl) linking/deployment skipped");
	}

	// link/deploy ArkiveDrop
	const ERC721Drop = await hre.ethers.getContractFactory("ERC721Drop");
	if(conf.ArkiveDrop) {
		console.log("Connecting to ArkiveDrop (ERC721Drop) at %o", conf.ArkiveDrop);
		instances.ArkiveDrop = await ERC721Drop.attach(conf.ArkiveDrop);
		const targetContract = await instances.ArkiveDrop.targetContract();
		const root = await instances.ArkiveDrop.root();
		const features = await instances.ArkiveDrop.features();
		const r0 = await instances.ArkiveDrop.userRoles(A0);
		console.log("Connected to ArkiveDrop at %o:", conf.ArkiveDrop);
		console.table([
			{"key": "Target Contract", "value": targetContract},
			{"key": "Merkle Root", "value": root},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		assert(targetContract === conf.ArkiveERC721, "ArkiveERC721 mismatch: conf vs ERC721Drop.targetContract");
	}
	else {
		console.log("deploying ArkiveDrop (ERC721Drop)");
		const drop = await ERC721Drop.deploy(conf.ArkiveERC721);
		instances.ArkiveDrop = await drop.deployed();
		conf.ArkiveDrop = instances.ArkiveDrop.address;
		console.log("ArkiveDrop deployed to %o", conf.ArkiveDrop);
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
