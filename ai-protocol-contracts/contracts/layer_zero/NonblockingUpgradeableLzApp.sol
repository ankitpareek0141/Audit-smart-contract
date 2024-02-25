// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@layerzerolabs/solidity-examples/contracts/contracts-upgradable/lzApp/NonblockingLzAppUpgradeable.sol";
import "../utils/UpgradeableAccessControl.sol";

/**
 * @title Nonblocking Upgradeable LayerZero App with Access Control
 */
abstract contract NonblockingUpgradeableLzApp is NonblockingLzAppUpgradeable, UpgradeableAccessControl {
	/**
	 * @dev The address of the ZRO token holder who would pay for the transaction
	 *      Zero address value means the native token is used instead of ZRO (default)
	 */
	address internal zroPaymentAddress;

	/**
	 * @dev Parameters for custom functionality encoded as bytes (empty value means no custom params);
	 *      e.g. gas limit override, receive airdropped native gas from the relayer on destination, etc.
	 *      see https://layerzero.gitbook.io/docs/evm-guides/advanced/relayer-adapter-parameters
	 */
	bytes internal adapterParams;

	/**
	 * @dev An empty reserved space in storage that is put in place in Upgrade Safe contracts
	 *      see https://docs.openzeppelin.com/contracts/3.x/upgradeable#storage_gaps
	 */
	uint256[48] private __gap;

	/**
	 * @notice LZ Config Manager is responsible for tunnel configuration, manager is
	 *      allowed to access LZ Endpoint configuration functions via the tunnel
	 *
	 * @dev Role ROLE_LZ_CONFIG_MANAGER allows accessing LZ Endpoint configuration related
	 *      functions: `setConfig`, `setSendVersion`, `setReceiveVersion`, and `forceResumeReceive`
	 */
	uint32 public constant ROLE_LZ_CONFIG_MANAGER = 0x0010_0000;

	/**
	 * @notice Tunnel Manager is responsible for tunnel setup, manager is
	 *      allowed to access tunnel setup related functions
	 *
	 * @dev Role ROLE_TUNNEL_MANAGER allows accessing Tunnel setup related
	 *      functions: `setPrecrime`, `setMinDstGas`, and `setPayloadSizeLimit`
	 */
	uint32 public constant ROLE_TUNNEL_MANAGER = 0x0020_0000;

	/**
	 * @dev Fired in setZroPaymentAddress()
	 *
	 * @param zroPaymentAddress ZRO payment address set, or zero address;
	 *      zero address means native token is used for payments instead of ZRO token
	 */
	event ZroPaymentAddressUpdated(address zroPaymentAddress);

	/**
	 * @dev Fired in setAdapterParams()
	 *
	 * @param adapterParams LZ relayer adapter parameters encoded as bytes
	 *      see https://layerzero.gitbook.io/docs/evm-guides/advanced/relayer-adapter-parameters
	 *
	 * The rest of the params represent the decoded adapterParams bytes
	 */
	event AdapterParamsUpdated(
		bytes adapterParams,
		uint16 version,
		uint256 gasAmount,
		uint256 nativeForDst,
		address addressOnDst
	);

	/**
	 * @dev Ensures function is executed only by ROLE_LZ_CONFIG_MANAGER
	 */
	modifier onlyLzConfigManager {
		// verify the access permission
		require(isSenderInRole(ROLE_LZ_CONFIG_MANAGER), "access denied");

		_;
	}

	/**
	 * @dev Ensures function is executed only by ROLE_TUNNEL_MANAGER
	 */
	modifier onlyTunnelManager {
		// verify the access permission
		require(isSenderInRole(ROLE_TUNNEL_MANAGER), "access denied");

		_;
	}

	/**
	 * @dev OZ proxy init, initialization routines usually present inside the constructor
	 */
	function __NonblockingUpgradeableLzApp_init(address _endpoint) internal onlyInitializing {
		__Context_init_unchained();
		__LzAppUpgradeable_init_unchained(_endpoint);
		__NonblockingLzAppUpgradeable_init_unchained(_endpoint);
	}

	/**
	 * @dev OZ proxy init, initialization routines usually present outside the constructor
	 */
	function __NonblockingUpgradeableLzApp_init_unchained() internal onlyInitializing {}

	/**
	 * @dev Set/update/unset ZRO payment address, which is
	 *      the address of the ZRO token holder who would pay for the transaction
	 *      Zero address value means the native token is used instead of ZRO (default)
	 *
	 * @param _zroPaymentAddress ZRO payment address
	 */
	function setZroPaymentAddress(address _zroPaymentAddress) external virtual onlyLzConfigManager {
		// update the address (note: zero value is OK)
		zroPaymentAddress = _zroPaymentAddress;

		// emit an event
		emit ZroPaymentAddressUpdated(_zroPaymentAddress);
	}

	/**
	 * @dev Set/update/unset LZ relayer adapter parameters for custom functionality
	 *      encoded as bytes (empty value means no custom params)
	 *
	 * @param _adapterParams LZ relayer adapter custom params
	 */
	function setAdapterParams(bytes memory _adapterParams) external virtual onlyLzConfigManager {
		// what can be packed inside the adapter params (if it is not empty)
		uint16 version; // 1 or 2
		uint256 gasAmount; // present in both 1 and 2
		uint256 nativeForDst; // present only in 2
		address addressOnDst; // present only in 2

		// if custom relayer adapter parameters are set, we validate them:
		if(_adapterParams.length > 0) {
			// decode the parameters as if they are version 1 (version 2 compatible)
			// since the parameters are tightly packed
			// this cannot be unpacked with abi.decode, but only with assembly
			assembly {
				// see https://ethereum.stackexchange.com/questions/143522/how-to-decode-encodepacked-data
				version := mload(add(_adapterParams, 2))
				gasAmount := mload(add(_adapterParams, 34))
			}

			// supported versions are 1 and 2
			require(version > 0 && version <= 2, "unknown version");

			// check that adapter params length is correct
			require(version == 1 && _adapterParams.length == 34 || version == 2 && _adapterParams.length == 86, "malformed");

			// verify gas amount value is set
			require(gasAmount > 0, "gas amount not set");

			// for the version 2
			if(version > 1) {
				// decode the rest of the parameters
				assembly {
					// see https://ethereum.stackexchange.com/questions/143522/how-to-decode-encodepacked-data
					nativeForDst := mload(add(_adapterParams, 66))
					addressOnDst := mload(add(_adapterParams, 86))
				}

				// verify the values are set
				require(nativeForDst > 0, "airdrop value not set");
				require(addressOnDst != address(0), "airdrop address not set");
			}
		}

		// update the address (note: empty value is OK)
		adapterParams = _adapterParams;

		// emit an event
		emit AdapterParamsUpdated(_adapterParams, version, gasAmount, nativeForDst, addressOnDst);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 *
	 * @notice Restricted access function to execute `setConfig` function on the LZ Endpoint
	 *      set the configuration of the LayerZero messaging library of the specified version
	 *
	 * @dev Requires sender to have ROLE_LZ_CONFIG_MANAGER permission
	 *
	 * @param _version - messaging library version
	 * @param _chainId - the chainId for the pending config change
	 * @param _configType - type of configuration. every messaging library has its own convention.
	 * @param _config - configuration in the bytes. can encode arbitrary content.
	 */
	function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) external virtual override onlyLzConfigManager {
		_setConfig(_version, _chainId, _configType, _config);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 *
	 * @notice Restricted access function to execute `setSendVersion` function on the LZ Endpoint
	 *      set the send() LayerZero messaging library version to _version
	 *
	 * @dev Requires sender to have ROLE_LZ_CONFIG_MANAGER permission
	 *
	 * @param _version - new messaging library version
	 */
	function setSendVersion(uint16 _version) external virtual override onlyLzConfigManager {
		_setSendVersion(_version);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 *
	 * @notice Restricted access function to execute `setReceiveVersion` function on the LZ Endpoint
	 *      set the lzReceive() LayerZero messaging library version to _version
	 *
	 * @dev Requires sender to have ROLE_LZ_CONFIG_MANAGER permission
	 *
	 * @param _version - new messaging library version
	 */
	function setReceiveVersion(uint16 _version) external virtual override onlyLzConfigManager {
		_setReceiveVersion(_version);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 *
	 * @notice Restricted access function to execute `forceResumeReceive` function on the LZ Endpoint
	 *      Only when the UA needs to resume the message flow in blocking mode and clear the stored payload
	 *
	 * @dev Requires sender to have ROLE_LZ_CONFIG_MANAGER permission
	 *
	 * @param _srcChainId - the chainId of the source chain
	 * @param _srcAddress - the contract address of the source contract at the source chain
	 */
	function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) external override virtual onlyLzConfigManager {
		_forceResumeReceive(_srcChainId, _srcAddress);
	}

	/**
	 * @dev see LzAppUpgradeable
	 */
	function setPrecrime(address _precrime) external virtual onlyTunnelManager {
		_setPrecrime(_precrime);
	}

	/**
	 * @dev see LzAppUpgradeable
	 */
/*
	function setMinDstGas(uint16 _dstChainId, uint16 _packetType, uint _minGas) external virtual onlyTunnelManager {
		_setMinDstGas(_dstChainId, _packetType, _minGas);
	}
*/

	/**
	 * @dev see LzAppUpgradeable
	 */
	function setPayloadSizeLimit(uint16 _dstChainId, uint _size) external virtual onlyTunnelManager {
		_setPayloadSizeLimit(_dstChainId, _size);
	}

	/**
	 * @dev Estimates the message transfer fee to the destination chain `chainId`
	 *
	 * @param chainId destination chain
	 * @param message the message to send
	 * @return message transfer fee in wei
	 */
	function __estimateMessageFee(uint16 chainId, bytes memory message) internal view returns (uint256) {
		// estimate fee based on the message input
		(uint256 fee,) = lzEndpoint.estimateFees(
			chainId,
			address(this),
			message,
			address(0) == zroPaymentAddress, // _payInZRO
			adapterParams
		);
		// return the result
		return fee;
	}

	/**
	 * @dev Auxiliary function to send the token transfer message to the
	 *      destination chain `chainId`
	 *
	 * @dev Evaluates the message transfer fee and tries to supply this fee
	 *      Throws if sender didn't supply enough value to cover the fee
	 *      Returns any excess of the funds sent back to sender
	 *      (all of the above happens in LZ code, see UltraLightNode)
	 *
	 * @param chainId destination chain
	 * @param message the message to send
	 */
	function __sendMessageTo(uint16 chainId, bytes memory message) internal {
		// send the message
		_lzSend(
			chainId,
			message,
			payable(msg.sender),
			zroPaymentAddress,
			adapterParams,
			msg.value
		);
	}
}
