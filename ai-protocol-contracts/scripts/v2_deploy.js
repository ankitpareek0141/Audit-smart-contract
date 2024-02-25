// v2 deployment script: deploys
//   - AliERC20v2,
//   - PersonalityPodERC721,
//   - TheRevenants (AletheaNFT),
//   - IntelligentNFTv2,
//   - IntelliLinker,
//   - FixedSupplySale,
//   - PersonalityMinter (OpenSeaFactoryImpl)

// Run: npx hardhat run --network rinkeby ./scripts/v2_deploy.js

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

	assert(conf.ALI_H0, `H0 not defined for the network ${network.name}`);
	if(!conf.OPENSEA_MINTER_ADDR) {
		console.warn("Wyvern OPENSEA_MINTER_ADDR not defined for the network %o", network.name);
	}
	if(!conf.PERSONALITY_OPTIONS) {
		console.warn("PERSONALITY_OPTIONS not defined for PersonalityMinter for the network %o", network.name);
	}

	// link/deploy ALI Token
	const AliERC20v2 = await hre.ethers.getContractFactory("AliERC20v2");
	if(conf.AliERC20v2) {
		console.log("Connecting to AliERC20v2 at %o", conf.AliERC20v2);
		instances.AliERC20v2 = await AliERC20v2.attach(conf.AliERC20v2);
		const name = await instances.AliERC20v2.name();
		const symbol = await instances.AliERC20v2.symbol();
		const decimals = await instances.AliERC20v2.decimals();
		const B0 = await instances.AliERC20v2.balanceOf(conf.ALI_H0);
		const S0 = await instances.AliERC20v2.totalSupply();
		const features = await instances.AliERC20v2.features();
		const r0 = await instances.AliERC20v2.userRoles(A0);
		console.log("Connected to AliERC20v2 at %o:", conf.AliERC20v2);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Decimals", "value": to_number(decimals)},
			{"key": "Total Supply", "value": to_number(S0)},
			{"key": "Initial Holder, H0", "value": conf.ALI_H0},
			{"key": "balanceOf(H0)", "value": to_number(B0)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);
	}
	else {
		console.log("deploying AliERC20v2, H0 = %o", conf.ALI_H0);
		const token = await AliERC20v2.deploy(conf.ALI_H0);
		instances.AliERC20v2 = await token.deployed();
		conf.AliERC20v2 = instances.AliERC20v2.address;
		console.log("AliERC20v2 deployed to %o", conf.AliERC20v2);
	}

	// link/deploy PersonalityPodERC721
	const PersonalityPodERC721 = await hre.ethers.getContractFactory("PersonalityPodERC721");
	if(conf.PersonalityPodERC721) {
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
	}
	else {
		console.log("deploying PersonalityPodERC721");
		const token = await PersonalityPodERC721.deploy("iNFT Personality Pod", "POD");
		instances.PersonalityPodERC721 = await token.deployed();
		conf.PersonalityPodERC721 = instances.PersonalityPodERC721.address;
		console.log("PersonalityPodERC721 deployed to %o", conf.PersonalityPodERC721);
	}

	// link/deploy TheRevenants
	const AletheaNFT = await hre.ethers.getContractFactory("AletheaNFT");
	if(conf.TheRevenants) {
		console.log("Connecting to TheRevenants (AletheaNFT) at %o", conf.TheRevenants);
		instances.TheRevenants = await AletheaNFT.attach(conf.TheRevenants);
		const name = await instances.TheRevenants.name();
		const symbol = await instances.TheRevenants.symbol();
		const totalSupply = await instances.TheRevenants.totalSupply();
		const features = await instances.TheRevenants.features();
		const r0 = await instances.TheRevenants.userRoles(A0);
		console.log("Connected to TheRevenants at %o:", conf.TheRevenants);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Total Supply", "value": to_number(totalSupply)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);
	}
	else {
		console.log("deploying TheRevenants (AletheaNFT)");
		const token = await AletheaNFT.deploy("Revenants by Alethea AI", "REV");
		instances.TheRevenants = await token.deployed();
		conf.TheRevenants = instances.TheRevenants.address;
		console.log("TheRevenants (AletheaNFT) deployed to %o", conf.TheRevenants);
	}

	// link/deploy iNFT version 2
	const IntelligentNFTv2 = await hre.ethers.getContractFactory("IntelligentNFTv2");
	if(conf.IntelligentNFTv2) {
		console.log("Connecting to IntelligentNFTv2 at %o", conf.IntelligentNFTv2);
		instances.IntelligentNFTv2 = await IntelligentNFTv2.attach(conf.IntelligentNFTv2);
		const name = await instances.IntelligentNFTv2.name();
		const symbol = await instances.IntelligentNFTv2.symbol();
		const totalSupply = await instances.IntelligentNFTv2.totalSupply();
		const aliContract = await instances.IntelligentNFTv2.aliContract();
		const aliBalance = await instances.IntelligentNFTv2.aliBalance();
		const features = await instances.IntelligentNFTv2.features();
		const r0 = await instances.IntelligentNFTv2.userRoles(A0);
		console.log("Connected to IntelligentNFTv2 at %o:", conf.IntelligentNFTv2);
		console.table([
			{"key": "Name", "value": name},
			{"key": "Symbol", "value": symbol},
			{"key": "Total Supply", "value": to_number(totalSupply)},
			{"key": "ALI Contract", "value": aliContract},
			{"key": "ALI Balance", "value": to_number(aliBalance)},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		assert(aliContract === conf.AliERC20v2, "AliERC20v2 mismatch: conf vs IntelligentNFTv2");
	}
	else {
		console.log("deploying IntelligentNFTv2");
		const iNft = await IntelligentNFTv2.deploy(conf.AliERC20v2);
		instances.IntelligentNFTv2 = await iNft.deployed();
		conf.IntelligentNFTv2 = instances.IntelligentNFTv2.address;
		console.log("IntelligentNFTv2 deployed to %o", conf.IntelligentNFTv2);
	}

	// link/deploy iNFT Linker
	const IntelliLinker = await hre.ethers.getContractFactory("IntelliLinker");
	if(conf.IntelliLinker) {
		console.log("Connecting to IntelliLinker at %o", conf.IntelliLinker);
		instances.IntelliLinker = await IntelliLinker.attach(conf.IntelliLinker);
		const linkPrice = await instances.IntelliLinker.linkPrice();
		const linkFee = await instances.IntelliLinker.linkFee();
		const feeDestination = await instances.IntelliLinker.feeDestination();
		const nextId = await instances.IntelliLinker.nextId();
		const aliContract = await instances.IntelliLinker.aliContract();
		const personalityContract = await instances.IntelliLinker.personalityContract();
		const iNftContract = await instances.IntelliLinker.iNftContract();
		const features = await instances.IntelliLinker.features();
		const r0 = await instances.IntelliLinker.userRoles(A0);
		console.log("Connected to IntelliLinker at %o:", conf.IntelliLinker);
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

		assert(aliContract === conf.AliERC20v2, "AliERC20v2 mismatch: conf vs IntelliLinker");
		assert(personalityContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs IntelliLinker");
		assert(iNftContract === conf.IntelligentNFTv2, "IntelligentNFTv2 mismatch: conf vs IntelliLinker");
	}
	else {
		console.log("deploying IntelliLinker");
		const linker = await IntelliLinker.deploy(conf.AliERC20v2, conf.PersonalityPodERC721, conf.IntelligentNFTv2);
		instances.IntelliLinker = await linker.deployed();
		conf.IntelliLinker = instances.IntelliLinker.address;
		console.log("IntelliLinker deployed to %o", conf.IntelliLinker);
	}

	// link/deploy FixedSupply Sale
	const FixedSupplySale = await hre.ethers.getContractFactory("FixedSupplySale");
	if(conf.FixedSupplySale) {
		console.log("Connecting to FixedSupplySale at %o", conf.FixedSupplySale);
		instances.FixedSupplySale = await FixedSupplySale.attach(conf.FixedSupplySale);
		const itemPrice = await instances.FixedSupplySale.itemPrice();
		const nextId = await instances.FixedSupplySale.nextId();
		const finalId = await instances.FixedSupplySale.finalId();
		const saleStart = await instances.FixedSupplySale.saleStart();
		const saleEnd = await instances.FixedSupplySale.saleEnd();
		const batchLimit = await instances.FixedSupplySale.batchLimit();
		const soldCounter = await instances.FixedSupplySale.soldCounter();
		const aliContract = await instances.FixedSupplySale.aliContract();
		const nftContract = await instances.FixedSupplySale.nftContract();
		const personalityContract = await instances.FixedSupplySale.personalityContract();
		const iNftContract = await instances.FixedSupplySale.iNftContract();
		const features = await instances.FixedSupplySale.features();
		const r0 = await instances.FixedSupplySale.userRoles(A0);
		console.log("Connected to FixedSupplySale at %o:", conf.FixedSupplySale);
		console.table([
			{"key": "Item Price", "value": to_number(itemPrice)},
			{"key": "Next ID", "value": to_number(nextId)},
			{"key": "Final ID", "value": to_number(finalId)},
			{"key": "Sale Start", "value": new Date(to_number(saleStart) * 1000)},
			{"key": "Sale End", "value": new Date(to_number(saleEnd) * 1000)},
			{"key": "Batch Limit", "value": to_number(batchLimit)},
			{"key": "Sold Counter", "value": to_number(soldCounter)},
			{"key": "ALI Contract", "value": aliContract},
			{"key": "NFT Contract", "value": nftContract},
			{"key": "AI Personality Contract", "value": personalityContract},
			{"key": "iNFT Contract", "value": iNftContract},
			{"key": "Features", "value": features.toHexString()}, // 2
			{"key": "Deployer Role", "value": r0.toHexString()}, // 16
		]);

		assert(aliContract === conf.AliERC20v2, "AliERC20v2 mismatch: conf vs FixedSupplySale");
		assert(nftContract === conf.TheRevenants, "TheRevenants mismatch: conf vs FixedSupplySale");
		assert(personalityContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs FixedSupplySale");
		assert(iNftContract === conf.IntelligentNFTv2, "IntelligentNFTv2 mismatch: conf vs FixedSupplySale");
	}
	else {
		console.log("deploying FixedSupplySale");
		const linker = await FixedSupplySale.deploy(conf.AliERC20v2, conf.TheRevenants, conf.PersonalityPodERC721, conf.IntelligentNFTv2);
		instances.FixedSupplySale = await linker.deployed();
		conf.FixedSupplySale = instances.FixedSupplySale.address;
		console.log("FixedSupplySale deployed to %o", conf.FixedSupplySale);
	}

	// only if OPENSEA_MINTER_ADDR and PERSONALITY_OPTIONS are set - link/deploy PersonalityMinter
	if(conf.OPENSEA_MINTER_ADDR && conf.PERSONALITY_OPTIONS) {
		// link/deploy PersonalityMinter (OpenSea Factory Implementation for PersonalityPodERC721)
		const OpenSeaFactory = await hre.ethers.getContractFactory("OpenSeaFactoryImpl");
		if(conf.PersonalityMinter) {
			console.log("Connecting to PersonalityMinter (OpenSeaFactoryImpl) at %o", conf.PersonalityMinter);
			instances.PersonalityMinter = await OpenSeaFactory.attach(conf.PersonalityMinter);
			const nftContract = await instances.PersonalityMinter.nftContract();
			const numOptions = to_number(await instances.PersonalityMinter.numOptions());
			assert(numOptions === conf.PERSONALITY_OPTIONS.length - 1, "PERSONALITY_OPTIONS mismatch: conf vs PersonalityMinter.numOptions");
			const options = new Array(numOptions);
			for(let i = 0; i < options.length; i++) {
				const current = to_number(await instances.PersonalityMinter.currentTokenId(i));
				const upper = to_number(await instances.PersonalityMinter.tokenIdUpperBound(i));
				options[i] = upper - current;
				if(i !== options.length - 1) {
					assert(
						upper === conf.PERSONALITY_OPTIONS[i + 1],
						`PERSONALITY_OPTIONS[${i + 1}] mismatch: conf vs PersonalityMinter.tokenIdUpperBound(${i})`
					);
				}
			}
			const optionsTable = options.map((o, i) => Object.assign(
				{"key": `Option ${i}`, "value": o})
			);
			const features = await instances.PersonalityMinter.features();
			const r0 = await instances.PersonalityMinter.userRoles(A0);
			console.log("Connected to PersonalityMinter (OpenSeaFactoryImpl) at %o:", conf.PersonalityMinter);
			console.table([
				{"key": "NFT Contract", "value": nftContract},
				{"key": "Number of Options", "value": numOptions},
				...optionsTable,
				{"key": "Tokens Left", "value": options.reduce((a, v) => a + v, 0)},
				{"key": "Features", "value": features.toHexString()}, // 2
				{"key": "Deployer Role", "value": r0.toHexString()}, // 16
			]);

			assert(nftContract === conf.PersonalityPodERC721, "PersonalityPodERC721 mismatch: conf vs OpenSeaFactoryImpl.nftContract");
		}
		else {
			console.log("deploying PersonalityMinter (OpenSeaFactoryImpl)");
			const minter = await OpenSeaFactory.deploy(conf.PersonalityPodERC721, conf.OPENSEA_MINTER_ADDR, conf.PERSONALITY_OPTIONS);
			instances.PersonalityMinter = await minter.deployed();
			conf.PersonalityMinter = instances.PersonalityMinter.address;
			console.log("PersonalityMinter (OpenSeaFactoryImpl) deployed to %o", conf.PersonalityMinter);
		}
	}
	else {
		console.log("PersonalityMinter (OpenSeaFactoryImpl) linking/deployment skipped");
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
