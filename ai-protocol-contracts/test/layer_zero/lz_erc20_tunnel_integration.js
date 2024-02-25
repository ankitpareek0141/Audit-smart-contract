// LzERC20RootTunnel/LzERC20ChildTunnel integration tests

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
const {random_bn, random_bits} = require("../include/bn_utils");

// ACL token features and roles
const {
	not,
	FEATURE_ENTRANCE_OPEN,
	ROLE_RESCUE_MANAGER,
	ROLE_LZ_CONFIG_MANAGER,
} = require("../include/features_roles");

// event helper functions in use
const {
	expectEventInTransaction
} = require("../include/helper");

// ALI Token (root token) constants
const {
	TOTAL_SUPPLY: S0,
} = require("../ali_token/include/ali_erc20_constants");

// deployment routines in use
const {
	lz_erc20_root_tunnel_deploy: root_tunnel_deploy,
	lz_erc20_child_tunnel_deploy: child_tunnel_deploy,
	lz_endpoint_mock_deploy, tunnel_deploy,
} = require("./include/deployment_routines");

// run integration tests
contract("LzERC20RootTunnel/LzERC20ChildTunnel integration", function(accounts) {
	// extract accounts to be used:
	// A0 – special default zero account accounts[0] used by Truffle, reserved
	// a0 – deployment account having all the permissions, reserved
	// H0 – initial token holder account
	// a1, a2,... – working accounts to perform tests on
	const [A0, a0, H0, a1, a2, a3, a4, a5] = accounts;

	describe("after LzERC20RootTunnel - Root LzEndpoint - Child LzEndpoint - LzERC20ChildTunnel infra is deployed", function() {
		const deposit_from = a1;
		const deposit_to = a2;
		const withdraw_from = a3;
		const withdraw_to = a4;
		const deposit_value = BN.min(S0, random_bn(1, S0));
		const withdraw_value = BN.min(deposit_value, random_bn(1, deposit_value));

		// values from LzEndpointMock
		const chain_id = new BN(101);
		const nonce = new BN(0);
		const gas_limit = new BN(200_000);

		let root_tunnel, child_tunnel, root_lz_endpoint, child_lz_endpoint, root_token, child_token;
		beforeEach(async function() {
			root_lz_endpoint = await lz_endpoint_mock_deploy(a0);
			child_lz_endpoint = await lz_endpoint_mock_deploy(a0);

			({root_tunnel, root_token} = await root_tunnel_deploy(a0, root_lz_endpoint.address));
			({child_tunnel, child_token} = await child_tunnel_deploy(a0, child_lz_endpoint.address));

			await root_tunnel.setChildTunnel(chain_id, child_tunnel.address, {from: a0});
			await child_tunnel.setRootTunnel(chain_id, root_tunnel.address, {from: a0});
			await root_lz_endpoint.setDestinationEndpoint(child_lz_endpoint.address, {from: a0});
			await child_lz_endpoint.setDestinationEndpoint(root_lz_endpoint.address, {from: a0});
			await root_lz_endpoint.setLzReceiver(root_tunnel.address, {from: a0});
			await child_lz_endpoint.setLzReceiver(child_tunnel.address, {from: a0});

			await root_token.transfer(deposit_from, S0, {from: a0});
		});

		describe("deposits: entering the tunnel", function() {
			function execute_deposit_test(deposit_fn, from, to, value) {
				const payload = web3.eth.abi.encodeParameters(
					["address", "address", "uint256"],
					[from, to, value],
				);

				let receipt;
				beforeEach(async function() {
					const fee = await root_tunnel.estimateDepositFee(from, to, value);
					receipt = await deposit_fn(fee);
				});
				it('"DepositInitiated" event is emitted by the root tunnel', async function() {
					await expectEvent.inTransaction(receipt.tx, root_tunnel, "DepositInitiated", {from, to, value});
				});
				it('"MessageSent" event is emitted by the Root LZ endpoint (LzEndpointMock)', async function() {
					await expectEvent.inTransaction(receipt.tx, root_lz_endpoint, "MessageSent", {
						_dstChainId: chain_id,
						_destination: web3.utils.encodePacked(
							{value: child_tunnel.address, type: "address"},
							{value: root_tunnel.address, type: "address"},
						),
						_payload: payload,
						_refundAddress: from,
						_zroPaymentAddress: ZERO_ADDRESS,
						_adapterParams: null, // ZERO_BYTES32,
					});
				});
				it('"PayloadReceived" event is emitted by the Child LZ endpoint (LzEndpointMock)', async function() {
					await expectEvent.inTransaction(receipt.tx, child_lz_endpoint, "PayloadReceived", {
						_srcChainId: chain_id,
						_srcAddress: web3.utils.encodePacked(
							{value: root_tunnel.address, type: "address"},
							{value: child_tunnel.address, type: "address"},
						),
						_dstAddress: child_tunnel.address,
						_nonce: nonce,
						_gasLimit: gas_limit,
						_payload: payload,
					});
				});
				it('"DepositComplete" event is emitted by the child tunnel', async function() {
					await expectEvent.inTransaction(
						receipt.tx,
						child_tunnel,
						"DepositComplete",
						{stateId: nonce, from, to, value});
				});
				it("lockedInTunnel counter increases as expected", async function() {
					expect(await root_tunnel.lockedInTunnel()).to.be.bignumber.that.equals(value);
				});
				it("sender balance decreases as expected", async function() {
					expect(await root_token.balanceOf(from)).to.be.bignumber.that.equals(S0.sub(value) + "");
				});
				it("root tunnel balance increases as expected", async function() {
					expect(await root_token.balanceOf(root_tunnel.address)).to.be.bignumber.that.equals(value);
				});
				it("receiver balance increases as expected", async function() {
					expect(await child_token.balanceOf(to)).to.be.bignumber.that.equals(value);
				});
			}

			describe("deposit: depositing to self", function() {
				execute_deposit_test(async function(fee) {
					await root_token.approve(root_tunnel.address, deposit_value, {from: deposit_from});
					return await root_tunnel.deposit(deposit_value, {from: deposit_from, value: fee});
				}, deposit_from, deposit_from, deposit_value);
			});

			describe("depositTo: depositing to someone else", function() {
				execute_deposit_test(async function(fee) {
					await root_token.approve(root_tunnel.address, deposit_value, {from: deposit_from});
					return await root_tunnel.depositTo(deposit_to, deposit_value, {from: deposit_from, value: fee});
				}, deposit_from, deposit_to, deposit_value);
			});
		});

		describe("withdrawals: exiting the tunnel", function() {
			beforeEach(async function() {
				const fee = await root_tunnel.estimateDepositFee(deposit_from, withdraw_from, deposit_value);
				await root_token.approve(root_tunnel.address, deposit_value, {from: deposit_from});
				await root_tunnel.depositTo(withdraw_from, deposit_value, {from: deposit_from, value: fee});
			});

			function execute_withdrawal_test(withdrawal_fn, from, to, value) {
				const payload = web3.eth.abi.encodeParameters(
					["address", "address", "uint256"],
					[from, to, value],
				);

				let receipt;
				beforeEach(async function() {
					const fee = await child_tunnel.estimateWithdrawalFee(from, to, value);
					receipt = await withdrawal_fn(fee);
				});
				it('"WithdrawalInitiated" event is emitted by the child tunnel', async function() {
					await expectEvent.inTransaction(receipt.tx, child_tunnel, "WithdrawalInitiated", {from, to, value});
				});
				it('"MessageSent" event is emitted by the Child LZ endpoint (LzEndpointMock)', async function() {
					await expectEvent.inTransaction(receipt.tx, child_lz_endpoint, "MessageSent", {
						_dstChainId: chain_id,
						_destination: web3.utils.encodePacked(
							{value: root_tunnel.address, type: "address"},
							{value: child_tunnel.address, type: "address"},
						),
						_payload: payload,
						_refundAddress: from,
						_zroPaymentAddress: ZERO_ADDRESS,
						_adapterParams: null, // ZERO_BYTES32,
					});
				});
				it('"PayloadReceived" event is emitted by the Root LZ endpoint (LzEndpointMock)', async function() {
					await expectEvent.inTransaction(receipt.tx, root_lz_endpoint, "PayloadReceived", {
						_srcChainId: chain_id,
						_srcAddress: web3.utils.encodePacked(
							{value: child_tunnel.address, type: "address"},
							{value: root_tunnel.address, type: "address"},
						),
						_dstAddress: root_tunnel.address,
						_nonce: nonce,
						_gasLimit: gas_limit,
						_payload: payload,
					});
				});
				it('"WithdrawalComplete" event is emitted by the root tunnel', async function() {
					await expectEvent.inTransaction(
						receipt.tx,
						root_tunnel,
						"WithdrawalComplete",
						{stateId: nonce, from, to, value}
					);
				});
				it("sender balance decreases as expected", async function() {
					expect(await child_token.balanceOf(from)).to.be.bignumber.that.equals(deposit_value.sub(value) + "");
				});
				it("child tunnel balance doesn't increase (tokens are burnt)", async function() {
					expect(await child_token.balanceOf(child_tunnel.address)).to.be.bignumber.that.equals("0");
				});
				it("receiver balance increases as expected", async function() {
					expect(await root_token.balanceOf(to)).to.be.bignumber.that.equals(value);
				});
				it("root tunnel balance decreases as expected", async function() {
					expect(await root_token.balanceOf(root_tunnel.address)).to.be.bignumber.that.equals(deposit_value.sub(value));
				});
			}

			describe("withdraw: when initiating a withdrawal to self", function() {
				execute_withdrawal_test(async function(fee) {
					await child_token.approve(child_tunnel.address, deposit_value, {from: withdraw_from});
					return await child_tunnel.withdraw(deposit_value, {from: withdraw_from, value: fee});
				}, withdraw_from, withdraw_from, deposit_value);
			});

			describe("withdrawTo: when initiating a withdrawal to someone else", function() {
				execute_withdrawal_test(async function(fee) {
					await child_token.approve(child_tunnel.address, deposit_value, {from: withdraw_from});
					return await child_tunnel.withdrawTo(withdraw_to, deposit_value, {from: withdraw_from, value: fee});
				}, withdraw_from, withdraw_to, deposit_value);
			});
		});
	});
});
