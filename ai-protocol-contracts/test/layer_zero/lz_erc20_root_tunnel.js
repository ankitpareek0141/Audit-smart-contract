// LzERC20RootTunnel tests

// Zeppelin test helpers
const {
	BN,
	constants,
	expectEvent,
	expectRevert,
} = require("@openzeppelin/test-helpers");
const {
	assert,
	expect,
} = require("chai");
const {
	ZERO_ADDRESS,
	ZERO_BYTES32,
	MAX_UINT256,
} = constants;

// BN utils
const {
	toBN,
	random_bits,
} = require("../include/bn_utils");

// ACL token features and roles
const {
	not,
	FEATURE_ENTRANCE_OPEN,
	ROLE_RESCUE_MANAGER,
	ROLE_LZ_CONFIG_MANAGER,
	ROLE_TUNNEL_MANAGER,
} = require("../include/features_roles");

// event helper functions in use
const {
	expectEventInTransaction
} = require("../include/helper");

// deployment routines in use
const {
	ali_erc20_deploy: erc20_deploy,
	lz_erc20_root_tunnel_deploy: tunnel_deploy,
	lz_erc20_root_tunnel_deploy_restricted: tunnel_deploy_restricted,
	lz_erc20_root_tunnel_deploy_pure: tunnel_deploy_pure,
	lz_endpoint_mock_deploy,
} = require("./include/deployment_routines");
const {extract_gas} = require("../include/block_utils");

// run tunnel tests
contract("LzERC20RootTunnel", function(accounts) {
	// extract accounts to be used:
	// A0 – special default zero account accounts[0] used by Truffle, reserved
	// a0 – deployment account having all the permissions, reserved
	// H0 – initial token holder account
	// a1, a2,... – working accounts to perform tests on
	const [A0, a0, H0, a1, a2, a3, a4, a5] = accounts;

	describe("tunnel deployment", function() {
		it("reverts if LZ endpoint lzEndpoint is not set", async function() {
			await expectRevert(tunnel_deploy_pure(a0, ZERO_ADDRESS, a2), "LZ endpoint not set");
		});
		it("reverts if root token rootToken is not set", async function() {
			await expectRevert(tunnel_deploy_pure(a0, a1, ZERO_ADDRESS), "root token not set");
		});
		describe("succeeds otherwise", function() {
			let tunnel;
			beforeEach(async function() {
				tunnel = await tunnel_deploy_pure(a0, a1, a2);
			});
			it("LZ endpoint lzEndpoint gets set correctly", async function() {
				expect(await tunnel.lzEndpoint()).to.equal(a1);
			});
			it("root token rootToken gets set correctly", async function() {
				expect(await tunnel.rootToken()).to.equal(a2);
			});
		});
	});
	describe("AccessControl (ACL) tests", function() {
		const by = a1;
		const someone = a2;

		let tunnel, lz_endpoint, token;
		beforeEach(async function() {
			lz_endpoint = await lz_endpoint_mock_deploy(a0);
			({root_tunnel: tunnel, root_token: token} = await tunnel_deploy_restricted(a0, lz_endpoint.address));
		});

		// ACL deposits
		describe("[ACL:deposits] when sender is ready to deposit", function() {
			const value = 1;
			const fee = 1_000_000_000;
			beforeEach(async function() {
				await token.mint(by, value, {from: a0});
				await tunnel.setChildTunnel(1, a1, {from: a0});
			});
			async function deposit() {
				await token.approve(tunnel.address, value, {from: by});
				return await tunnel.deposit(value, {from: by, value: fee});
			}
			async function depositTo() {
				await token.approve(tunnel.address, value, {from: by});
				return await tunnel.depositTo(someone, value, {from: by, value: fee});
			}
			describe("when FEATURE_ENTRANCE_OPEN is enabled", function() {
				beforeEach(async function() {
					await tunnel.updateFeatures(FEATURE_ENTRANCE_OPEN, {from: a0});
				});
				it("deposit succeeds", async function() {
					await deposit();
				});
				it("depositTo succeeds", async function() {
					await depositTo();
				});
			});
			describe("when FEATURE_ENTRANCE_OPEN is disabled", function() {
				beforeEach(async function() {
					await tunnel.updateFeatures(not(FEATURE_ENTRANCE_OPEN), {from: a0});
				});
				it("deposit reverts", async function() {
					await expectRevert(deposit(), "entrance closed");
				});
				it("depositTo reverts", async function() {
					await expectRevert(depositTo(), "entrance closed");
				});
			});
		});

		// ACL rescueToken
		describe("[ACL:rescueToken] when someone accidentally sent a token (in unsafe way)", function() {
			const value = new BN(1);
			beforeEach(async function() {
				await token.mint(someone, value, {from: a0});
				await token.transfer(tunnel.address, value, {from: someone});
			});

			async function rescueErc20() {
				return await tunnel.rescueToken(token.address, someone, value, {from: by});
			}
			describe("when sender doesn't have ROLE_RESCUE_MANAGER permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, not(ROLE_RESCUE_MANAGER), {from: a0});
				});
				it("sender can't rescue ERC20 tokens", async function() {
					await expectRevert(rescueErc20(), "access denied");
				});
			});
			describe("when sender has ROLE_RESCUE_MANAGER permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, ROLE_RESCUE_MANAGER, {from: a0});
				});
				it("sender can rescue ERC20 tokens", async function() {
					await rescueErc20();
				});
			});
		});

		// ACL setChildTunnel
		describe("[ACL:setChildTunnel] when the child tunnel is not yet set", function() {
			async function setChildTunnel() {
				return await tunnel.setChildTunnel(1, someone, {from: by});
			}
			describe("when sender doesn't have full admin permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, not(MAX_UINT256), {from: a0});
				});
				it("sender can't set the fx child tunnel", async function() {
					await expectRevert(setChildTunnel(), "access denied");
				});
			});
			describe("when sender has full admin permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, MAX_UINT256, {from: a0});
				});
				it("sender can set the fx child tunnel", async function() {
					await setChildTunnel();
				});
			});
		});

		// ACL LZ Endpoint Config
		describe("[ACL:ILayerZeroUserApplicationConfig] accessing LZ Endpoint Config", function() {
			async function setZroPaymentAddress() {
				return await tunnel.setZroPaymentAddress(a1, {from: by});
			}
			async function setAdapterParams() {
				return await tunnel.setAdapterParams(web3.utils.encodePacked(
					{value: 1, type: "uint16"},
					{value: 220_000, type: "uint256"},
				), {from: by});
			}
			async function setConfig() {
				return await tunnel.setConfig(1, 1, 1, web3.utils.stringToHex("_config"), {from: by});
			}
			async function setSendVersion() {
				return await tunnel.setSendVersion(1, {from: by});
			}
			async function setReceiveVersion() {
				return await tunnel.setReceiveVersion(1, {from: by});
			}
			async function forceResumeReceive() {
				return await tunnel.forceResumeReceive(1, web3.utils.stringToHex("_srcAddress"), {from: by});
			}

			describe("when sender doesn't have ROLE_LZ_CONFIG_MANAGER permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, not(ROLE_LZ_CONFIG_MANAGER), {from: a0});
				});
				it("setZroPaymentAddress reverts", async function() {
					await expectRevert(setZroPaymentAddress(), "access denied");
				});
				it("setAdapterParams reverts", async function() {
					await expectRevert(setAdapterParams(), "access denied");
				});
				it("setConfig reverts", async function() {
					await expectRevert(setConfig(), "access denied");
				});
				it("setSendVersion reverts", async function() {
					await expectRevert(setSendVersion(), "access denied");
				});
				it("setReceiveVersion reverts", async function() {
					await expectRevert(setReceiveVersion(), "access denied");
				});
				it("forceResumeReceive reverts", async function() {
					await expectRevert(forceResumeReceive(), "access denied");
				});
			});
			describe("when sender has ROLE_LZ_CONFIG_MANAGER permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, ROLE_LZ_CONFIG_MANAGER, {from: a0});
				});
				it("setZroPaymentAddress succeeds", async function() {
					await setZroPaymentAddress();
				});
				it("setAdapterParams succeeds", async function() {
					await setAdapterParams();
				});
				it("setConfig succeeds", async function() {
					await setConfig();
				});
				it("setSendVersion succeeds", async function() {
					await setSendVersion();
				});
				it("setReceiveVersion succeeds", async function() {
					await setReceiveVersion();
				});
				it("setReceiveVersion succeeds", async function() {
					await setReceiveVersion();
				});
			});
		});

		// ACL Tunnel Setup functions
		describe("[ACL:Setup] accessing Tunnel Setup functions", function() {
			async function setPrecrime() {
				return await tunnel.setPrecrime(ZERO_ADDRESS, {from: by});
			}
/*
			async function setMinDstGas() {
				return await tunnel.setMinDstGas(1, 1, 1, {from: by});
			}
*/
			async function setPayloadSizeLimit() {
				return await tunnel.setPayloadSizeLimit(1, 1, {from: by});
			}

			describe("when sender doesn't have ROLE_TUNNEL_MANAGER permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, not(ROLE_TUNNEL_MANAGER), {from: a0});
				});
				it("setPrecrime reverts", async function() {
					await expectRevert(setPrecrime(), "access denied");
				});
/*
				it("setMinDstGas reverts", async function() {
					await expectRevert(setMinDstGas(), "access denied");
				});
*/
				it("setPayloadSizeLimit reverts", async function() {
					await expectRevert(setPayloadSizeLimit(), "access denied");
				});
			});
			describe("when sender has ROLE_TUNNEL_MANAGER permission", function() {
				beforeEach(async function() {
					await tunnel.updateRole(by, ROLE_TUNNEL_MANAGER, {from: a0});
				});
				it("setPrecrime succeeds", async function() {
					await setPrecrime();
				});
/*
				it("setMinDstGas succeeds", async function() {
					await setMinDstGas();
				});
*/
				it("setPayloadSizeLimit succeeds", async function() {
					await setPayloadSizeLimit();
				});
			});
		});
	});

	describe("when tunnel is already deployed (EOA LZ endpoint)", function() {
		const lz_endpoint_address = a1;
		let tunnel, lz_endpoint, token;
		beforeEach(async function() {
			lz_endpoint = await lz_endpoint_mock_deploy(a0);
			({root_tunnel: tunnel, root_token: token} = await tunnel_deploy(a0, lz_endpoint.address, undefined, true));
		});

		describe("lzReceive: exiting the tunnel (withdrawal finalization)", function() {
			const stateId = new BN(1);
			const child_chain_id = new BN(1);
			const another_chain_id = new BN(2);
			const child_tunnel_address = a2;
			const from = a3;
			const to = a4;
			const someone = a5;
			const value = new BN(1);
			const nonce = new BN(1);
			const payload = web3.eth.abi.encodeParameters(
				["address", "address", "uint256"],
				[from, to, value]
			);

			beforeEach(async function() {
				await tunnel.setChildTunnel(child_chain_id, child_tunnel_address, {from: a0});
				await token.mint(from, value.muln(2), {from: a0});
				await token.approve(tunnel.address, value.muln(2), {from});
				await tunnel.deposit(value.muln(2), {from, value: 1_000_000_000});
				await tunnel.setLzEndpoint(lz_endpoint_address, {from: a0});
			});

			async function lzReceive(
				lz_endpoint = lz_endpoint_address,
				child_chain = child_chain_id,
				child_tunnel = child_tunnel_address,
				root_tunnel = tunnel.address,
				src_address = web3.utils.encodePacked(
					{value: child_tunnel, type: "address"},
					{value: root_tunnel, type: "address"},
				),
			) {
				return await tunnel.lzReceive(child_chain, src_address, nonce, payload, {from: lz_endpoint});
			}

			it("reverts if executed not by LZ Endpoint lzEndpoint", async function() {
				await expectRevert(lzReceive(someone), "LzApp: invalid endpoint caller");
			});
			it("reverts if executed externally via `nonblockingLzReceive`", async function() {
				const src_address = web3.utils.encodePacked(
					{value: child_tunnel_address, type: "address"},
					{value: tunnel.address, type: "address"},
				);
				await expectRevert(
					tunnel.nonblockingLzReceive(child_chain_id, src_address, nonce, payload, {from: lz_endpoint_address}),
					"NonblockingLzApp: caller must be LzApp"
				);
			});
			it("reverts if executed externally via `nonblockingLzReceive` (zero inputs)", async function() {
				await expectRevert(
					tunnel.nonblockingLzReceive(0, ZERO_BYTES32, 0, ZERO_BYTES32, {from: lz_endpoint_address}),
					"NonblockingLzApp: caller must be LzApp"
				);
			});

			async function fails(
				promise,
				error,
				chainId = child_chain_id,
				child_tunnel = child_tunnel_address,
				root_tunnel = tunnel.address,
				srcAddress = web3.utils.encodePacked(
					{value: child_tunnel, type: "address"},
					{value: root_tunnel, type: "address"},
				),
			) {
				const reason = "0x08c379a0" +
					web3.utils.padLeft("20", 64) +
					web3.utils.padLeft(toBN(error.length).toString(16), 64) +
					web3.utils.padRight(web3.utils.asciiToHex(error).substring(2), 64);

				const receipt = await promise;
				expectEvent(receipt, "MessageFailed", {
					_srcChainId: chainId,
					_srcAddress: srcAddress,
					_nonce: nonce,
					_payload: payload,
					_reason: reason,
				});
			}

			it("fails if token transfers are disabled", async function() {
				await token.updateFeatures(0, {from: a0});
				await fails(lzReceive(), "transfers are disabled");
			});
			describe("succeeds otherwise", function() {
				let receipt;
				beforeEach(async function() {
					receipt = await lzReceive();
				});
				function consumes_no_more_than(gas) {
					// tests marked with @skip-on-coverage are removed from solidity-coverage,
					// see yield-solcover.js, see https://github.com/sc-forks/solidity-coverage/blob/master/docs/advanced.md
					it(`consumes no more than ${gas} gas  [ @skip-on-coverage ]`, async function() {
						const gasUsed = extract_gas(receipt);
						expect(gasUsed).to.be.lte(gas);
						if(gas - gasUsed > gas / 20) {
							console.log("only %o gas was used while expected up to %o", gasUsed, gas);
						}
					});
				}
				it('"WithdrawalComplete" event is emitted', async function() {
					expectEvent(receipt, "WithdrawalComplete", {stateId, from, to, value});
				});
				it('ERC20 "Transfer" event is emitted (root token gets unlocked)', async function() {
					await expectEventInTransaction(receipt.tx, "Transfer", [{
						type: "address",
						name: "from",
						indexed: true,
						value: tunnel.address,
					}, {
						type: "address",
						name: "to",
						indexed: true,
						value: to,
					}, {
						type: "uint256",
						name: "value",
						value: value,
					}]);
				});
				it("expected amount of the root token gets unlocked", async function() {
					expect(await token.balanceOf(to)).to.be.bignumber.that.equals(value);
				});
				consumes_no_more_than(95440);
			});
		});
	});

	describe("when tunnel is already deployed (SC LZ endpoint)", function() {
		let tunnel, lz_endpoint, token;
		beforeEach(async function() {
			lz_endpoint = await lz_endpoint_mock_deploy(a0);
			({root_tunnel: tunnel, root_token: token} = await tunnel_deploy(a0, lz_endpoint.address));
		});

		describe("setChildTunnel: setting the child tunnel", function() {
			const child_chain_id = new BN(1);
			const child_tunnel_address = a2;
			it("reverts if child tunnel chain ID is zero", async function() {
				await expectRevert(tunnel.setChildTunnel(0, child_tunnel_address, {from: a0}), "zero chain ID");
			});
			it("reverts if child tunnel address is zero", async function() {
				await expectRevert(tunnel.setChildTunnel(child_chain_id, ZERO_ADDRESS, {from: a0}), "zero address");
			});
			describe("succeeds otherwise", function() {
				beforeEach(async function() {
					await tunnel.setChildTunnel(child_chain_id, child_tunnel_address, {from: a0});
				});
				it("tunnel chain ID gets set correctly", async function() {
					expect(await tunnel.childTunnelChainId()).to.be.bignumber.that.equals(child_chain_id);
				});
				it("tunnel address gets set correctly", async function() {
					expect(await tunnel.childTunnelAddress()).to.be.equal(child_tunnel_address);
				});
				it("tunnel cannot be updated again after it was set", async function() {
					await expectRevert(tunnel.setChildTunnel(child_chain_id, a3, {from: a0}), "child tunnel already set");
				});
			});
		});
		describe("setZroPaymentAddress: setting the ZRO payment address", function() {
			const zroPaymentAddress = a1;
			describe("succeeds", function() {
				let receipt;
				beforeEach(async function() {
					receipt = await tunnel.setZroPaymentAddress(zroPaymentAddress, {from: a0});
				});
				it('"ZroPaymentAddressUpdated" event is emitted', async function() {
					expectEvent(receipt, "ZroPaymentAddressUpdated", {zroPaymentAddress});
				});
			});
		});
		describe("setAdapterParams: setting custom relayer adapter params", function() {
			async function setAdapterParams(version = 1, gas_amt, native_value, native_addr) {
				const params = [
					{value: version, type: "uint16"},
				];
				if(gas_amt !== undefined) {
					params.push({value: gas_amt, type: "uint256"});
				}
				if(native_value !== undefined) {
					params.push({value: native_value, type: "uint256"});
				}
				if(native_addr !== undefined) {
					params.push({value: native_addr, type: "address"});
				}
				const adapter_params = web3.utils.encodePacked(...params.slice(0, version > 2? params.length: version > 1? 4: 2));
				return await tunnel.setAdapterParams(adapter_params, {from: a0});
			}
			it("fails if version is zero", async function() {
				await expectRevert(setAdapterParams(0, 200_000), "unknown version");
			});
			it("fails if version is 3", async function() {
				await expectRevert(setAdapterParams(3, 200_000), "unknown version");
			});
			it("fails if gas amount not set", async function() {
				await expectRevert(setAdapterParams(1, 0), "gas amount not set");
			});
			it("fails if airdrop value not set", async function() {
				await expectRevert(setAdapterParams(2, 200_000, 0, a1), "airdrop value not set");
			});
			it("fails if airdrop address not set", async function() {
				await expectRevert(setAdapterParams(2, 200_000, 300_000, ZERO_ADDRESS), "airdrop address not set");
			});
			it("fails if params message is malformed", async function() {
				await expectRevert(setAdapterParams(1), "malformed");
			});
			describe("succeeds otherwise", function() {
				const version = "2";
				const gasAmount = "200000";
				const nativeForDst = "300000";
				const addressOnDst = a1;

				let receipt;
				beforeEach(async function() {
					receipt = await setAdapterParams(2, 200_000, 300_000, a1);
				});
				it('"AdapterParamsUpdated" event is emitted', async function() {
					expectEvent(receipt, "AdapterParamsUpdated", {version, gasAmount, nativeForDst, addressOnDst});
				});
			});
		});

		describe("accessing the EZ Endpoint configuration", function() {
			const _version = new BN(1);
			const _chainId = new BN(2);
			const _configType = new BN(3);
			const _config = web3.utils.stringToHex("_config");
			const _srcChainId = _chainId;
			const _srcAddress = web3.utils.encodePacked({value: a1, type: "address"}, {value: a2, type: "address"});

			describe("setConfig", function() {
				let receipt;
				beforeEach(async function() {
					receipt = await tunnel.setConfig(_version, _chainId, _configType, _config, {from: a0});
				});
				it('emits "ConfigSet" on the LzEndpointMock', async function() {
					await expectEvent.inTransaction(receipt.tx, lz_endpoint, "ConfigSet", {_version, _chainId, _configType, _config});
				});
			});
			describe("setSendVersion", function() {
				let receipt;
				beforeEach(async function() {
					receipt = await tunnel.setSendVersion(_version, {from: a0});
				});
				it('emits "SendVersionSet" on the LzEndpointMock', async function() {
					await expectEvent.inTransaction(receipt.tx, lz_endpoint, "SendVersionSet", {_version});
				});
			});
			describe("setReceiveVersion", function() {
				let receipt;
				beforeEach(async function() {
					receipt = await tunnel.setReceiveVersion(_version, {from: a0});
				});
				it('emits "ReceiveVersionSet" on the LzEndpointMock', async function() {
					await expectEvent.inTransaction(receipt.tx, lz_endpoint, "ReceiveVersionSet", {_version});
				});
			});
			describe("forceResumeReceive", function() {
				let receipt;
				beforeEach(async function() {
					receipt = await tunnel.forceResumeReceive(_srcChainId, _srcAddress, {from: a0});
				});
				it('emits "ForceResumeReceived" on the LzEndpointMock', async function() {
					await expectEvent.inTransaction(receipt.tx, lz_endpoint, "ForceResumeReceived", {_srcChainId, _srcAddress});
				});
			});
		});

		describe("deposits: entering the tunnel", function() {
			const child_chain_id = new BN(1);
			const child_tunnel_address = a2;
			const from = a3;
			const to = a4;
			const balance = random_bits(192);
			const value = BN.min(balance, random_bits(192));

			beforeEach(async function() {
				await tunnel.setChildTunnel(child_chain_id, child_tunnel_address, {from: a0});
				await token.mint(from, balance, {from: a0});
			});

			function execute_deposit_test(deposit_fn, from, to, value) {
				let receipt;
				beforeEach(async function() {
					const fee = await tunnel.estimateDepositFee(from, to, value);
					receipt = await deposit_fn(fee);
				});
				it('"DepositInitiated" event is emitted', async function() {
					await expectEvent.inTransaction(receipt.tx, tunnel, "DepositInitiated", {from, to, value});
				});
				it('"MessageSent" event is emitted by LZ endpoint (LzEndpoint)', async function() {
					await expectEvent.inTransaction(receipt.tx, lz_endpoint, "MessageSent", {
						_dstChainId: child_chain_id,
						_destination: web3.utils.encodePacked(
							{value: child_tunnel_address, type: "address"},
							{value: tunnel.address, type: "address"},
						),
						_payload: web3.eth.abi.encodeParameters(
							["address", "address", "uint256"],
							[from, to, value],
						),
						_refundAddress: from,
						_zroPaymentAddress: ZERO_ADDRESS,
						_adapterParams: null, // ZERO_BYTES32,
					});
				});
				it("lockedInTunnel counter increases as expected", async function() {
					expect(await tunnel.lockedInTunnel()).to.be.bignumber.that.equals(value);
				});
				it("sender balance decreases as expected", async function() {
					expect(await token.balanceOf(from)).to.be.bignumber.that.equals(balance.sub(value) + "");
				});
				it("tunnel balance increases as expected", async function() {
					expect(await token.balanceOf(tunnel.address)).to.be.bignumber.that.equals(value);
				});
			}

			describe("deposit: when initiating a deposit to self", function() {
				execute_deposit_test(async function(fee) {
					await token.approve(tunnel.address, value, {from});
					return await tunnel.deposit(value, {from, value: fee});
				}, from, from, value);
			});

			describe("depositTo: when initiating a deposit to someone else", function() {
				execute_deposit_test(async function(fee) {
					await token.approve(tunnel.address, value, {from});
					return await tunnel.depositTo(to, value, {from, value: fee});
				}, from, to, value);
			});
		});

		{
			const loser = a1;
			const value_lost = new BN(1);
			const fee = 1_000_000_000;

			function execute_rescue_test(deployment_fn, deposit_value, err_msg) {
				let token;
				beforeEach(async function() {
					token = await deployment_fn();
					await token.mint(loser, value_lost.add(deposit_value), {from: a0});
					if(!deposit_value.isZero()) {
						await token.approve(tunnel.address, deposit_value, {from: loser});
						await tunnel.setChildTunnel(1, a1, {from: a0});
						await tunnel.deposit(deposit_value, {from: loser, value: fee});
					}
					await token.transfer(tunnel.address, value_lost, {from: loser});
				});
				describe("it is possible to recover what was lost", function() {
					let receipt;
					beforeEach(async function() {
						receipt = await tunnel.rescueToken(token.address, loser, value_lost, {from: a0});
					});
					it('ERC20 "Transfer" event is emitted', async function() {
						await expectEventInTransaction(receipt.tx, "Transfer", [{
							type: "address",
							name: "from",
							indexed: true,
							value: tunnel.address,
						}, {
							type: "address",
							name: "to",
							indexed: true,
							value: loser,
						}, {
							type: "uint256",
							name: "value",
							value: value_lost,
						}]);
					});
					it("tunnel balance decreases as expected", async function() {
						expect(await token.balanceOf(tunnel.address)).to.be.bignumber.that.equals(deposit_value);
					});
					it("loser balance increases as expected", async function() {
						expect(await token.balanceOf(loser)).to.be.bignumber.that.equals(value_lost);
					});
					it("it impossible to recover more", async function() {
						await expectRevert(tunnel.rescueToken(token.address, loser, 1, {from: a0}), err_msg);
					});
				});
				it("it is impossible to recover more than it was lost", async function() {
					await expectRevert(tunnel.rescueToken(token.address, loser, value_lost.addn(1), {from: a0}), err_msg);
				});
			}

			describe("rescueToken: rescuing rootToken", function() {
				const deployment_fn = async() => token;
				const deposit_value = new BN(2);
				const err_msg = "locked in tunnel";
				execute_rescue_test(deployment_fn, deposit_value, err_msg);
			});

			describe("rescueToken: rescuing other tokens", function() {
				const deployment_fn = async() => await erc20_deploy(a0);
				const deposit_value = new BN(0);
				const err_msg = "transfer amount exceeds balance";
				execute_rescue_test(deployment_fn, deposit_value, err_msg);
			});
		}
	});
});
