// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "../layer_zero/LzERC20RootTunnelV1.sol";
import "../layer_zero/LzERC20ChildTunnelV1.sol";

contract LzERC20RootTunnelV1Mock is LzERC20RootTunnelV1 {
	function setLzEndpoint(address _lzEndpoint) public {
		lzEndpoint = ILayerZeroEndpointUpgradeable(_lzEndpoint);
	}
	function setTrustedRemote(uint16 _srcChainId, bytes calldata _path) public {
		_setTrustedRemote(_srcChainId, _path);
	}
	function setTrustedRemoteAddress(uint16 _remoteChainId, bytes calldata _remoteAddress) public {
		_setTrustedRemoteAddress(_remoteChainId, _remoteAddress);
	}
}

contract LzERC20ChildTunnelV1Mock is LzERC20ChildTunnelV1 {
	function setLzEndpoint(address _lzEndpoint) public {
		lzEndpoint = ILayerZeroEndpointUpgradeable(_lzEndpoint);
	}
	function setTrustedRemote(uint16 _srcChainId, bytes calldata _path) public {
		_setTrustedRemote(_srcChainId, _path);
	}
	function setTrustedRemoteAddress(uint16 _remoteChainId, bytes calldata _remoteAddress) public {
		_setTrustedRemoteAddress(_remoteChainId, _remoteAddress);
	}
}
