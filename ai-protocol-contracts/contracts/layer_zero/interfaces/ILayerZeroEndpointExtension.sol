// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@layerzerolabs/lz-evm-sdk-v1-0.7/contracts/interfaces/ILayerZeroEndpoint.sol";
import "@layerzerolabs/lz-evm-sdk-v1-0.7/contracts/interfaces/ILayerZeroMessagingLibrary.sol";

/**
 * @notice Useful function not present in ILayerZeroEndpoint,
 *      but required for proper application deployment and configuration locking
 */
interface ILayerZeroEndpointExtension is ILayerZeroEndpoint {
	function latestVersion() external view returns(uint16);
	// version -> ILayerZeroEndpointLibrary
	function libraryLookup(uint16) external view returns(ILayerZeroMessagingLibrary);

	// default send/receive libraries
	function defaultSendVersion() external view returns(uint16);
	function defaultReceiveVersion() external view returns(uint16);
	function defaultSendLibrary() external view returns(ILayerZeroMessagingLibrary);
	function defaultReceiveLibraryAddress() external view returns(address);

	struct LibraryConfig {
		uint16 sendVersion;
		uint16 receiveVersion;
		address receiveLibraryAddress;
		ILayerZeroMessagingLibrary sendLibrary;
	}

	// user app config = [uaAddress]
	function uaConfigLookup(address) external view returns (LibraryConfig calldata);
}
