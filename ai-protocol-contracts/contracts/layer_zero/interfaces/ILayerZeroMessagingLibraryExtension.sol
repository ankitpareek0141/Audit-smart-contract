// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@layerzerolabs/lz-evm-sdk-v1-0.7/contracts/interfaces/ILayerZeroMessagingLibrary.sol";

/**
 * @notice Useful function not present in ILayerZeroMessagingLibrary,
 *      but required for proper application deployment and configuration locking
 */
interface ILayerZeroMessagingLibraryExtension is ILayerZeroMessagingLibrary {
	// Application config
	struct ApplicationConfiguration {
		uint16 inboundProofLibraryVersion;
		uint64 inboundBlockConfirmations;
		address relayer;
		uint16 outboundProofType;
		uint64 outboundBlockConfirmations;
		address oracle;
	}

	// User Application
	// app address => chainId => config
	function appConfig(address, uint16) external view returns(ApplicationConfiguration calldata);
	// default UA settings if no version specified
	function defaultAppConfig(uint16) external view returns(ApplicationConfiguration calldata);
	function defaultAdapterParams(uint16, uint16) external view returns (bytes calldata);
}
