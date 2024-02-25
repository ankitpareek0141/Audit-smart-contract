// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@layerzerolabs/solidity-examples/contracts/contracts-upgradable/interfaces/ILayerZeroEndpointUpgradeable.sol";
import "@layerzerolabs/solidity-examples/contracts/contracts-upgradable/interfaces/ILayerZeroReceiverUpgradeable.sol";

contract LzEndpointMock is ILayerZeroEndpointUpgradeable {
	ILayerZeroEndpointUpgradeable public destinationEndpoint;
	ILayerZeroReceiverUpgradeable public lzReceiver;
	uint64 public nonce;

	// ILayerZeroUserApplicationConfig events
	event ConfigSet(uint16 _version, uint16 _chainId, uint _configType, bytes _config);
	event SendVersionSet(uint16 _version);
	event ReceiveVersionSet(uint16 _version);
	event ForceResumeReceived(uint16 _srcChainId, bytes _srcAddress);

	// ILayerZeroEndpoint events
	event MessageSent(uint16 _dstChainId, bytes _destination, bytes _payload, address payable _refundAddress, address _zroPaymentAddress, bytes _adapterParams);
	event PayloadReceived(uint16 _srcChainId, bytes _srcAddress, address _dstAddress, uint64 _nonce, uint _gasLimit, bytes _payload);
	event PayloadRetried(uint16 _srcChainId, bytes _srcAddress, bytes _payload);

	function setDestinationEndpoint(address _destinationEndpoint) public {
		destinationEndpoint = ILayerZeroEndpointUpgradeable(_destinationEndpoint);
	}

	function setLzReceiver(address _lzReceiver) public {
		lzReceiver = ILayerZeroReceiverUpgradeable(_lzReceiver);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 */
	function setConfig(uint16 _version, uint16 _chainId, uint _configType, bytes calldata _config) public override {
		emit ConfigSet(_version, _chainId, _configType, _config);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 */
	function setSendVersion(uint16 _version) public override {
		emit SendVersionSet(_version);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 */
	function setReceiveVersion(uint16 _version) public override {
		emit ReceiveVersionSet(_version);
	}

	/**
	 * @inheritdoc ILayerZeroUserApplicationConfigUpgradeable
	 */
	function forceResumeReceive(uint16 _srcChainId, bytes calldata _srcAddress) public override {
		emit ForceResumeReceived(_srcChainId, _srcAddress);
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function send(
		uint16 _dstChainId,
		bytes memory _destination,
		bytes calldata _payload,
		address payable _refundAddress,
		address _zroPaymentAddress,
		bytes calldata _adapterParams
	) public payable override {
		if(address(destinationEndpoint) != address(0)) {
			address a1;
			address a2;
			assembly {
				a1 := mload(add(_destination, 20))
				a2 := mload(add(_destination, 40))
			}
			destinationEndpoint.receivePayload(101, abi.encodePacked(a2, a1), a1, nonce++, 200_000, _payload);
		}

		emit MessageSent(_dstChainId, _destination, _payload, _refundAddress, _zroPaymentAddress, _adapterParams);
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function receivePayload(
		uint16 _srcChainId,
		bytes calldata _srcAddress,
		address _dstAddress,
		uint64 _nonce,
		uint _gasLimit,
		bytes calldata _payload
	) public override {
		if(address(lzReceiver) != address(0)) {
			lzReceiver.lzReceive(_srcChainId, _srcAddress, _nonce, _payload);
		}

		emit PayloadReceived(_srcChainId, _srcAddress, _dstAddress, _nonce, _gasLimit, _payload);
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getInboundNonce(uint16 _srcChainId, bytes calldata _srcAddress) public view override returns(uint64) {
		return 1;
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getOutboundNonce(uint16 _dstChainId, address _srcAddress) public view override returns(uint64) {
		return 1;
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function estimateFees(
		uint16 _dstChainId,
		address _userApplication,
		bytes calldata _payload,
		bool _payInZRO,
		bytes calldata _adapterParam
	) public view override returns(uint nativeFee, uint zroFee) {
		return (1 gwei, 2 gwei);
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getChainId() public view override returns(uint16) {
		return 101;
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function retryPayload(uint16 _srcChainId, bytes calldata _srcAddress, bytes calldata _payload) public override {
		emit PayloadRetried(_srcChainId, _srcAddress, _payload);
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function hasStoredPayload(uint16 _srcChainId, bytes calldata _srcAddress) public view override returns(bool) {
		return true;
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getSendLibraryAddress(address _userApplication) public view override returns(address) {
		return address(1);
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getReceiveLibraryAddress(address _userApplication) public view override returns(address) {
		return address(2);
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function isSendingPayload() public view override returns(bool) {
		return true;
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function isReceivingPayload() public view override returns(bool) {
		return true;
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getConfig(
		uint16 _version,
		uint16 _chainId,
		address _userApplication,
		uint _configType
	) public view override returns(bytes memory) {
		return bytes("");
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getSendVersion(address _userApplication) public view override returns(uint16) {
		return 1;
	}

	/**
	 * @inheritdoc ILayerZeroEndpointUpgradeable
	 */
	function getReceiveVersion(address _userApplication) public view override returns(uint16) {
		return 1;
	}
}
