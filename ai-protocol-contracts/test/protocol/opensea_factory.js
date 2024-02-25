// Zeppelin test helpers
const {
	BN,
	balance,
	constants,
	expectEvent,
	expectRevert,
} = require("@openzeppelin/test-helpers");

// ACL token features and roles
const {
	ROLE_MINTER,
	ROLE_OS_MANAGER,
	ROLE_URI_MANAGER
} = require("../include/features_roles");

const {
	ZERO_ADDRESS,
	ZERO_BYTES32,
	MAX_UINT256,
} = constants;

// Chai test helpers
const {assert, expect} = require("chai");

// deployment routines in use
const {
	persona_deploy,
	os_factory_deploy_restricted,
} = require("./include/deployment_routines");

async function contractsSameAttributeValue(c1, c2, attr) {
	return await c1[attr]() === await c2[attr]();
}

// run OpenSea Factory tests
contract("OpenSea Factory: tests", function(accounts) {
	// extract accounts to be used:
	// A0 – special default zero account accounts[0] used by Web3, reserved
	// a0 – deployment account having all the permissions, reserved
	// H0 – initial token holder account
	// a1, a2,... – working accounts to perform tests on
	const [A0, a0, H0, a1, a2, a3] = accounts;

	// define the constant range bounds
	let range_bounds = [101, 2500, 5000, 7500, 9999, 10000];

	let persona, proxy_registry, factory;
	beforeEach(async function() {
		// deploy factory
		({persona, proxy_registry, factory} = await os_factory_deploy_restricted(a0, range_bounds));

		// allow factory to mint pods
		await persona.updateRole(factory.address, ROLE_MINTER, {from: a0});
	});

	describe("base URI", async() => {
		it("should not be able to set without appropriate role", async() => {
			await expectRevert(factory.setBaseURI("abc", {from: a1}), "access denied");
		});

		it("should be able to set with correct role", async() => {
			await factory.updateRole(a1, ROLE_URI_MANAGER, {from: a0});

			const _newVal = "abc";

			expectEvent(await factory.setBaseURI(_newVal, {from: a1}), "BaseURIUpdated", {_newVal});
		});

		it("should calculate the correct token URI", async() => {
			const baseURI = "abc";
			const tokenId = "1";

			await factory.setBaseURI(baseURI, {from: a0});

			expect(await factory.tokenURI(tokenId)).to.equal(baseURI + tokenId);
		});
	});

	it("should have the same name as the nft sold", async() => {
		expect(await contractsSameAttributeValue(factory, persona, "name")).to.be.true;
	});

	it("should have the same symbol as the nft sold", async() => {
		expect(await contractsSameAttributeValue(factory, persona, "symbol")).to.be.true;
	});

	it("should have the correct number of options", async() => {
		expect(await factory.numOptions().then(bn => parseInt(bn.toString()))).to.equal(range_bounds.length - 1);
	});

	it("should signify it implements OpenSea Factory interface", async() => {
		expect(await factory.supportsFactoryInterface()).to.be.true;
	});

	describe("fire transfer events", async() => {
		it("should not be able to fire events without appropriate role", async() => {
			await expectRevert(factory.fireTransferEvents(ZERO_ADDRESS, ZERO_ADDRESS, {from: a1}), "access denied");
		});

		it("should be able to set with correct role", async() => {
			await factory.updateRole(a1, ROLE_OS_MANAGER, {from: a0});

			expectEvent(await factory.fireTransferEvents(ZERO_ADDRESS, ZERO_ADDRESS, {from: a1}), "Transfer");
		});
	});

	describe("mint", async() => {
		it("should not be able to mint without appropriate role", async() => {
			await expectRevert(factory.mint(0, a1, {from: a1}), "access denied");
		});

		it("should be able to mint with correct role", async() => {
			await proxy_registry.setOwner(a1, {from: a0});

			expectEvent(await factory.mint(0, a1, {from: a1}), "Minted");
		});

		it("should not be able to mint out of range optionId", async() => {
			await expectRevert(factory.mint(range_bounds.length, a1, {from: a0}), "cannot mint");
		});

		it("should not be able to over-mint optionId", async() => {
			// optionId 4 might be minted only once
			await factory.mint(4, a1, {from: a0});

			await expectRevert(factory.mint(4, a1, {from: a0}), "cannot mint");
		});
	});

	it("transferFrom should behave like mint", async() => {
		expectEvent(await factory.transferFrom(ZERO_ADDRESS, a1, 0, {from: a0}), "Minted");
	});
});
