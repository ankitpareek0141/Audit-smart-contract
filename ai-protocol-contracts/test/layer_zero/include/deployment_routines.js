// deployment routines to reuse
const {
	ali_erc20_deploy,
	child_ali_erc20_deploy,
} = require("../../ali_token/include/deployment_routines");

// ACL token features and roles
const {
	FEATURE_ALL,
	ROLE_TOKEN_CREATOR,
	ROLE_TOKEN_DESTROYER,
} = require("../../include/features_roles");

/**
 * Deploys LzERC20RootTunnel with all the features enabled, binding it to
 * LayerZeroEndpoint, and ERC20 instances specified.
 * If no instances specified – deploys new ones.
 *
 * @param a0 smart contract owner, super admin
 * @param lz_endpoint_address LayerZeroEndpoint address, required
 * @param root_token_address, ERC20 root token address, optional
 * @param use_mock should we use LzERC20RootTunnelV1Mock allowing to modify the lzEndpoint?
 * @returns LzERC20RootTunnel, LayerZeroEndpoint, and ERC20 root token instances
 */
async function lz_erc20_root_tunnel_deploy(
	a0,
	lz_endpoint_address,
	root_token_address,
	use_mock = false,
) {
	// deploy the contract
	const {root_tunnel, root_token} = await lz_erc20_root_tunnel_deploy_restricted(
		a0,
		lz_endpoint_address,
		root_token_address,
		use_mock,
	);
	// enable all permissions on the contract
	await root_tunnel.updateFeatures(FEATURE_ALL, {from: a0});

	// return the reference
	return {root_tunnel, root_token};
}

/**
 * Deploys LzERC20RootTunnel with no features enabled, binding it to
 * LayerZeroEndpoint, and ERC20 instances specified.
 * If no instances specified – deploys new ones.
 *
 * @param a0 smart contract owner, super admin
 * @param lz_endpoint_address LayerZeroEndpoint address, required
 * @param root_token_address, ERC20 root token address, optional
 * @param use_mock should we use LzERC20RootTunnelV1Mock allowing to modify the lzEndpoint?
 * @returns LzERC20RootTunnel, LayerZeroEndpoint, and ERC20 root token instances
 */
async function lz_erc20_root_tunnel_deploy_restricted(
	a0,
	lz_endpoint_address,
	root_token_address,
	use_mock = false,
) {
	// smart contracts required
	const AliERC20 = artifacts.require("./AliERC20v2");

	// link to/deploy ERC20 root token
	const root_token = root_token_address? await AliERC20.at(root_token_address): await ali_erc20_deploy(a0);

	// deploy the instance
	const root_tunnel = await lz_erc20_root_tunnel_deploy_pure(
		a0,
		lz_endpoint_address,
		root_token.address,
		use_mock,
	);

	// return all the instances
	return {root_tunnel, root_token};
}

/**
 * Deploys LzERC20RootTunnel with no features enabled, binding it to
 * LayerZeroEndpoint, root ERC20 token instances specified.
 *
 * @param a0 smart contract owner, super admin
 * @param lz_endpoint_address LayerZeroEndpoint address
 * @param root_token_address, ERC20 root token address
 * @param use_mock should we use LzERC20RootTunnelV1Mock allowing to modify the lzEndpoint?
 * @returns LzERC20RootTunnel instance
 */
async function lz_erc20_root_tunnel_deploy_pure(
	a0,
	lz_endpoint_address,
	root_token_address,
	use_mock = false,
) {
	// deploy implementation
	const LzERC20RootTunnel = artifacts.require(use_mock? "./LzERC20RootTunnelV1Mock": "./LzERC20RootTunnelV1");
	const impl = await LzERC20RootTunnel.new({from: a0});
	// prepare the initialization call bytes
	const init_data = impl.contract.methods.postConstruct(lz_endpoint_address, root_token_address).encodeABI();

	// deploy the proxy
	const Proxy = artifacts.require("./ERC1967Proxy");
	const proxy = await Proxy.new(impl.address, init_data, {from: a0});
	// wrap the proxy into the impl ABI and return the proxy
	return await LzERC20RootTunnel.at(proxy.address);
}

/**
 * Deploys LzERC20ChildTunnel, binding it to
 * LayerZeroEndpoint, child ERC20 token instances specified.
 * If no instance address specified – deploys a new one.
 *
 * @param a0 smart contract owner, super admin
 * @param lz_endpoint_address LayerZeroEndpoint address, required
 * @param child_token_address, ERC20 child token address, optional
 * @param use_mock should we use LzERC20ChildTunnelV1Mock allowing to modify the lzEndpoint?
 * @returns LzERC20RootTunnel instance, fxChild address, child ERC20 token instance
 */
async function lz_erc20_child_tunnel_deploy(
	a0,
	lz_endpoint_address,
	child_token_address,
	use_mock = false,
) {
	// smart contracts required
	const ChildAliERC20 = artifacts.require("./ChildAliERC20v2");

	// link to/deploy ERC20 root token
	const child_token = child_token_address? await ChildAliERC20.at(child_token_address): await child_ali_erc20_deploy(a0);

	// deploy the instance
	const child_tunnel = await lz_erc20_child_tunnel_deploy_pure(
		a0,
		lz_endpoint_address,
		child_token.address,
		use_mock,
	);

	// enable child token minting/burning permissions
	await child_token.updateRole(child_tunnel.address, ROLE_TOKEN_CREATOR | ROLE_TOKEN_DESTROYER, {from: a0});

	// return all the instances
	return {child_tunnel, child_token};
}

/**
 * Deploys LzERC20ChildTunnel, binding it to
 * LayerZeroEndpoint, child ERC20 token instances specified.
 *
 * @param a0 smart contract owner, super admin
 * @param lz_endpoint_address LayerZeroEndpoint address, required
 * @param child_token_address, ERC20 child token address
 * @param use_mock should we use LzERC20ChildTunnelV1Mock allowing to modify the lzEndpoint?
 * @returns MaticERC20ChildTunnel instance
 */
async function lz_erc20_child_tunnel_deploy_pure(
	a0,
	lz_endpoint_address,
	child_token_address,
	use_mock = false,
) {
	// deploy implementation
	const LzERC20ChildTunnel = artifacts.require(use_mock? "./LzERC20ChildTunnelV1Mock": "./LzERC20ChildTunnelV1");
	const impl = await LzERC20ChildTunnel.new({from: a0});
	// prepare the initialization call bytes
	const init_data = impl.contract.methods.postConstruct(lz_endpoint_address, child_token_address).encodeABI();

	// deploy the proxy
	const Proxy = artifacts.require("./ERC1967Proxy");
	const proxy = await Proxy.new(impl.address, init_data, {from: a0});
	// wrap the proxy into the impl ABI and return the proxy
	return await LzERC20ChildTunnel.at(proxy.address);
}

/**
 * Deploys LzEndpointMock
 *
 * @param a0 deployer account
 * @returns LzEndpointMock
 */
async function lz_endpoint_mock_deploy(a0) {
	// smart contracts in use
	const LzEndpointMock = artifacts.require("./LzEndpointMock");

	// deploy and return the instance
	return await LzEndpointMock.new({from: a0});
}

// export public deployment API
module.exports = {
	ali_erc20_deploy,
	child_ali_erc20_deploy,
	lz_erc20_root_tunnel_deploy,
	lz_erc20_root_tunnel_deploy_restricted,
	lz_erc20_root_tunnel_deploy_pure,
	lz_erc20_child_tunnel_deploy,
	lz_erc20_child_tunnel_deploy_pure,
	lz_endpoint_mock_deploy,
};
