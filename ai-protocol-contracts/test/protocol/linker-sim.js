// Alethea IntelliLinker: Linking/Unlinking Simulation
// Following simulation executes a significant amount of iNFT linking/unlinking
// tracking the expected iNFT state of the tokens involved

const log = require("loglevel");
log.setLevel(process.env.LOG_LEVEL? process.env.LOG_LEVEL: "info");

// Zeppelin test helpers
const {
	BN,
	constants,
	expectEvent,
	expectRevert,
} = require("@openzeppelin/test-helpers");

// Chai test helpers
const {expect} = require("chai");

// web3 utils
const toWei = web3.utils.toWei;

// deployment routines in use
const {
	ali_erc20_deploy,
	sale_deploy_initialized,
	linker_deploy,
} = require("./include/deployment_routines");

// run linking/unlinking simulation
contract("IntelliLinker: Linking/Unlinking Simulation", function(accounts) {
	// extract accounts to be used:
	// A0 – special default zero account accounts[0] used by Truffle, reserved
	// a0 – deployment account having all the permissions, reserved
	// H0 – initial token holder account
	// a1, a2,... – working accounts to perform tests on
	const [A0, a0, H0, a1, a2] = accounts;
	// participants – rest of the accounts
	const participants = accounts.slice(3);

	// deploy the ALI token instance
	let ali;
	beforeEach(async function() {
		ali = await ali_erc20_deploy(a0, H0);
	});

	// supply all the participants with some good amount of ALI to spend in linking
	const initial_ali_balance = toWei(new BN(1_000_000), "ether");
	beforeEach(async function() {
		log.info("allocating ALI tokens to %o participants", participants.length)
		for(let participant of participants) {
			await ali.transfer(participant, initial_ali_balance, {from: H0});
		}
	});

	// deploy and initialize the sale
	let nft, persona, iNft, sale, ITEM_PRICE;
	beforeEach(async function() {
		({nft, persona, iNft, sale, ITEM_PRICE} = await sale_deploy_initialized(a0, ali.address));
	});

	// deploy the iNFT Linker
	let linker, link_price;
	beforeEach(async function() {
		({linker} = await linker_deploy(a0, ali.address, persona.address, iNft.address, nft.address));
		link_price = await linker.linkPrice();
	});

	// simulation executor
	async function linker_sim_test(amt_per_acc) {
		const total_amt = amt_per_acc * participants.length;

		// unlink all the iNFTs
		log.info("unlinking all %o iNFTs...", total_amt);
		for(let i = 1; i <= total_amt; i++) {
			const participant = participants[Math.floor((i - 1) / amt_per_acc)];
			await linker.unlink(i, {from: participant});
		}

		// verify total supplies
		expect(
			await nft.totalSupply(),
			"NFT supply doesn't match iNFTs sold"
		).to.be.bignumber.that.equals(total_amt + "")
		expect(
			await persona.totalSupply(),
			"AI Personality supply doesn't match iNFTs sold"
		).to.be.bignumber.that.equals(total_amt + "")
		expect(
			await persona.balanceOf(iNft.address),
			"iNFT still owns some AI Personalities"
		).to.be.bignumber.that.equals( "0")
		expect(
			await iNft.totalSupply(),
			"some iNFT still exist"
		).to.be.bignumber.that.equals("0")

		// link all the iNFTs again
		log.info("linking all %o iNFTs again...", total_amt);
		for(let i = 1; i <= total_amt; i++) {
			const participant = participants[Math.floor((i - 1) / amt_per_acc)];
			await ali.approve(linker.address, link_price, {from: participant});
			await persona.approve(linker.address, i, {from: participant});
			await linker.link(i, nft.address, i, {from: participant});
		}

		// verify total supplies
		expect(
			await nft.totalSupply(),
			"NFT supply doesn't match iNFTs linked"
		).to.be.bignumber.that.equals(total_amt + "")
		expect(
			await persona.totalSupply(),
			"AI Personality supply doesn't match iNFTs linked"
		).to.be.bignumber.that.equals(total_amt + "")
		expect(
			await persona.balanceOf(iNft.address),
			"AI Personality iNFT balance doesn't match iNFTs linked"
		).to.be.bignumber.that.equals( total_amt + "")
		expect(
			await iNft.totalSupply(),
			"iNFT supply doesn't match iNFTs linked"
		).to.be.bignumber.that.equals(total_amt + "")

		log.info("Execution complete.")
	}

	describe("when low complexity sim setup is complete", function() {
		// supply all the participants with `initial_amt` of iNFTs via the sale
		const amt_per_acc = 5;
		beforeEach(async function() {
			// distribute the iNFTs in batches – `initial_amt` for each account
			log.info("allocating %o iNFTs...", amt_per_acc * participants.length)
			for(let participant of participants) {
				await sale.buy(amt_per_acc, {value: ITEM_PRICE.muln(amt_per_acc), from: participant});
			}
		});

		// low complexity test executes in coverage
		it("linking/unlinking simulation (low complexity)", async function() {
			await linker_sim_test(amt_per_acc);
		});
	});
	describe("when no-coverage sim setup is complete", function() {
		// supply all the participants with `initial_amt` of iNFTs via the sale
		const amt_per_acc = 50;
		beforeEach(async function() {
			// distribute the iNFTs in batches – `initial_amt` for each account
			log.info("allocating %o iNFTs...", amt_per_acc * participants.length)
			for(let participant of participants) {
				await sale.buy(amt_per_acc, {value: ITEM_PRICE.muln(amt_per_acc), from: participant});
			}
		});

		// tests marked with @skip-on-coverage will are removed from solidity-coverage,
		// see yield-solcover.js, see https://github.com/sc-forks/solidity-coverage/blob/master/docs/advanced.md
		it("linking/unlinking simulation [ @skip-on-coverage ]", async function() {
			await linker_sim_test(amt_per_acc);
		});
	});

});
