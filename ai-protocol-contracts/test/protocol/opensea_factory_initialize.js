// Alethea OpenSea Factory Initialization: Tests

// Zeppelin test helpers
const {
	BN,
	balance,
	constants,
	expectEvent,
	expectRevert,
} = require("@openzeppelin/test-helpers");
const {
	ZERO_ADDRESS,
	ZERO_BYTES32,
	MAX_UINT256,
} = constants;

// Chai test helpers
const {assert, expect} = require("chai");

// number utils
const {random_int} = require("../include/number_utils");

// helper functions in use
const {
	expectEventInTransaction
} = require("../include/helper");

// deployment routines in use
const {
	persona_deploy,
	ali_erc20_deploy,
	os_factory_deploy_pure,
} = require("./include/deployment_routines");

// run OpenSea Factory Initialization tests
contract("OpenSea Factory Initialization: tests", function(accounts) {
	// extract accounts to be used:
	// A0 – special default zero account accounts[0] used by Web3, reserved
	// a0 – deployment account having all the permissions, reserved
	// H0 – initial token holder account
	// a1, a2,... – working accounts to perform tests on
	const [A0, a0, H0, a1, a2, a3] = accounts;

	let persona, persona_addr;
	const proxy_registry_addr = "0x0000000000000000000000000000000000000001";
	beforeEach(async function() {
		persona = await persona_deploy(a0);
		persona_addr = persona.address;
	});
	
	describe("OpenSea Factory deployment", function() {
		let ali, ali_addr;
		const range_bounds = new Array(random_int(2, 15))
			.fill(0)
			.map(e => random_int(101, 20_000))
			.sort((a, b) => a - b);
		beforeEach(async function() {
			ali = await ali_erc20_deploy(a0, H0);
			ali_addr = ali.address;
		});
		it("fails if AI Personality address is not set", async function() {
			const persona_addr = ZERO_ADDRESS; // unset the address
			await expectRevert(
				os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr),
				"NFT contract is not set"
			);
		});
		it("fails if AI Personality is not valid ERC721", async function() {
			const persona_addr = ali_addr; // mess up the address
			await expectRevert(
				os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr),
				"unexpected NFT type"
			);
		});
		it("fails if proxy registry is not provided", async function() {
			const proxy_registry_addr = ZERO_ADDRESS; // unset the registry
			await expectRevert(
				os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr),
				"OpenSea proxy registry is not set"
			);
		});
		it("fails if range bounds elements are not provided", async function() {
			const range_bounds = []; // unset the range bounds
			await expectRevert(
				os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr),
				"invalid number of options"
			);
		});
		it("fails if range bounds elements not able to generate options", async function() {
			const range_bounds = [101]; // mess up the range bounds
			await expectRevert(
				os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr),
				"invalid number of options"
			);
		});
		it("fails if range bounds elements are not monotonically increasing", async function() {
			const range_bounds = [101, 101]; // mess up the range bounds
			await expectRevert(
				os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr),
				"invalid range bounds"
			);
		});
		it("fails if range bounds initial element hasn't value more than 100", async function() {
			const range_bounds = [100, 101]; // mess up the range bound
			await expectRevert(
				os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr),
				"invalid range bound initial element"
			);
		});
		describe("succeeds with valid AI Personality and range bounds", function() {
			let factory;
			beforeEach(async function() {
				factory = await os_factory_deploy_pure(a0, range_bounds, persona_addr, proxy_registry_addr);
			});
			it("AI Personality address is set as expected", async function() {
				expect(await factory.nftContract()).to.be.equal(persona_addr);
			});
			it("proxy registry address is set as expected", async function() {
				expect(await factory.proxyRegistry()).to.be.equal(proxy_registry_addr);
			});
			it('"owner" address is set as expected', async function() {
				expect(await factory.owner()).to.be.equal(a0);
			});
			it("number of options is set as expected", async function() {
				expect(await factory.numOptions()).to.be.bignumber.that.equals(range_bounds.length - 1 + "");
			});
			it("ranges are set as expected", async function() {
				const lower_bounds = range_bounds.slice(0, -1);
				const upper_bounds = range_bounds.slice(1);
				for(let i = 0; i < range_bounds.length - 1; i++) {
					expect(
						await factory.currentTokenId(i),
						"invalid lower bound " + i
					).to.be.bignumber.that.equals(lower_bounds[i] + "");
					expect(
						await factory.tokenIdUpperBound(i),
						"invalid upper bound " + i
					).to.be.bignumber.that.equals(upper_bounds[i] + "");
				}
			});
			it('fires "Transfer" event for each optionId', async function() {
				for(let i = 0; i < range_bounds.length - 1; i++) {
					await expectEventInTransaction(
						factory.transactionHash, "Transfer", [{
							type: "address",
							name: "from",
							indexed: true,
							value: ZERO_ADDRESS,
						}, {
							type: "address",
							name: "to",
							indexed: true,
							value: a0,
						}, {
							type: "uint256",
							name: "tokenId",
							indexed: true,
							value: i,
						}]
					);
				}
			});
		});
	});
});
