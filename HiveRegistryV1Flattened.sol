// Sources flattened with hardhat v2.19.4 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts-upgradeable/proxy/beacon/IBeaconUpgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (proxy/beacon/IBeacon.sol)

pragma solidity ^0.8.0;

/**
 * @dev This is the interface that {BeaconProxy} expects of its beacon.
 */
interface IBeaconUpgradeable {
    /**
     * @dev Must return an address that can be used as a delegate call target.
     *
     * {BeaconProxy} will check that this address is a contract.
     */
    function implementation() external view returns (address);
}


// File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Address.sol)

pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library AddressUpgradeable {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}


// File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (proxy/utils/Initializable.sol)

pragma solidity ^0.8.0;

/**
 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
 * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
 *
 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
 *
 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
 *
 * [CAUTION]
 * ====
 * Avoid leaving a contract uninitialized.
 *
 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
 * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
 * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
 *
 * [.hljs-theme-light.nopadding]
 * ```
 * /// @custom:oz-upgrades-unsafe-allow constructor
 * constructor() initializer {}
 * ```
 * ====
 */
abstract contract Initializable {
    /**
     * @dev Indicates that the contract has been initialized.
     */
    bool private _initialized;

    /**
     * @dev Indicates that the contract is in the process of being initialized.
     */
    bool private _initializing;

    /**
     * @dev Modifier to protect an initializer function from being invoked twice.
     */
    modifier initializer() {
        // If the contract is initializing we ignore whether _initialized is set in order to support multiple
        // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
        // contract may have been reentered.
        require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");

        bool isTopLevelCall = !_initializing;
        if (isTopLevelCall) {
            _initializing = true;
            _initialized = true;
        }

        _;

        if (isTopLevelCall) {
            _initializing = false;
        }
    }

    /**
     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
     * {initializer} modifier, directly or indirectly.
     */
    modifier onlyInitializing() {
        require(_initializing, "Initializable: contract is not initializing");
        _;
    }

    function _isConstructor() private view returns (bool) {
        return !AddressUpgradeable.isContract(address(this));
    }
}


// File @openzeppelin/contracts-upgradeable/utils/StorageSlotUpgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/StorageSlot.sol)

pragma solidity ^0.8.0;

/**
 * @dev Library for reading and writing primitive types to specific storage slots.
 *
 * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
 * This library helps with reading and writing to such slots without the need for inline assembly.
 *
 * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
 *
 * Example usage to set ERC1967 implementation slot:
 * ```
 * contract ERC1967 {
 *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
 *
 *     function _getImplementation() internal view returns (address) {
 *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
 *     }
 *
 *     function _setImplementation(address newImplementation) internal {
 *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
 *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
 *     }
 * }
 * ```
 *
 * _Available since v4.1 for `address`, `bool`, `bytes32`, and `uint256`._
 */
library StorageSlotUpgradeable {
    struct AddressSlot {
        address value;
    }

    struct BooleanSlot {
        bool value;
    }

    struct Bytes32Slot {
        bytes32 value;
    }

    struct Uint256Slot {
        uint256 value;
    }

    /**
     * @dev Returns an `AddressSlot` with member `value` located at `slot`.
     */
    function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
     */
    function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
     */
    function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
        assembly {
            r.slot := slot
        }
    }

    /**
     * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
     */
    function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
        assembly {
            r.slot := slot
        }
    }
}


// File @openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (proxy/ERC1967/ERC1967Upgrade.sol)

pragma solidity ^0.8.2;




/**
 * @dev This abstract contract provides getters and event emitting update functions for
 * https://eips.ethereum.org/EIPS/eip-1967[EIP1967] slots.
 *
 * _Available since v4.1._
 *
 * @custom:oz-upgrades-unsafe-allow delegatecall
 */
abstract contract ERC1967UpgradeUpgradeable is Initializable {
    function __ERC1967Upgrade_init() internal onlyInitializing {
        __ERC1967Upgrade_init_unchained();
    }

    function __ERC1967Upgrade_init_unchained() internal onlyInitializing {
    }
    // This is the keccak-256 hash of "eip1967.proxy.rollback" subtracted by 1
    bytes32 private constant _ROLLBACK_SLOT = 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143;

    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Emitted when the implementation is upgraded.
     */
    event Upgraded(address indexed implementation);

    /**
     * @dev Returns the current implementation address.
     */
    function _getImplementation() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address newImplementation) private {
        require(AddressUpgradeable.isContract(newImplementation), "ERC1967: new implementation is not a contract");
        StorageSlotUpgradeable.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
    }

    /**
     * @dev Perform implementation upgrade
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeTo(address newImplementation) internal {
        _setImplementation(newImplementation);
        emit Upgraded(newImplementation);
    }

    /**
     * @dev Perform implementation upgrade with additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCall(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        _upgradeTo(newImplementation);
        if (data.length > 0 || forceCall) {
            _functionDelegateCall(newImplementation, data);
        }
    }

    /**
     * @dev Perform implementation upgrade with security checks for UUPS proxies, and additional setup call.
     *
     * Emits an {Upgraded} event.
     */
    function _upgradeToAndCallSecure(
        address newImplementation,
        bytes memory data,
        bool forceCall
    ) internal {
        address oldImplementation = _getImplementation();

        // Initial upgrade and setup call
        _setImplementation(newImplementation);
        if (data.length > 0 || forceCall) {
            _functionDelegateCall(newImplementation, data);
        }

        // Perform rollback test if not already in progress
        StorageSlotUpgradeable.BooleanSlot storage rollbackTesting = StorageSlotUpgradeable.getBooleanSlot(_ROLLBACK_SLOT);
        if (!rollbackTesting.value) {
            // Trigger rollback using upgradeTo from the new implementation
            rollbackTesting.value = true;
            _functionDelegateCall(
                newImplementation,
                abi.encodeWithSignature("upgradeTo(address)", oldImplementation)
            );
            rollbackTesting.value = false;
            // Check rollback was effective
            require(oldImplementation == _getImplementation(), "ERC1967Upgrade: upgrade breaks further upgrades");
            // Finally reset to the new implementation and log the upgrade
            _upgradeTo(newImplementation);
        }
    }

    /**
     * @dev Storage slot with the admin of the contract.
     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    /**
     * @dev Emitted when the admin account has changed.
     */
    event AdminChanged(address previousAdmin, address newAdmin);

    /**
     * @dev Returns the current admin.
     */
    function _getAdmin() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value;
    }

    /**
     * @dev Stores a new address in the EIP1967 admin slot.
     */
    function _setAdmin(address newAdmin) private {
        require(newAdmin != address(0), "ERC1967: new admin is the zero address");
        StorageSlotUpgradeable.getAddressSlot(_ADMIN_SLOT).value = newAdmin;
    }

    /**
     * @dev Changes the admin of the proxy.
     *
     * Emits an {AdminChanged} event.
     */
    function _changeAdmin(address newAdmin) internal {
        emit AdminChanged(_getAdmin(), newAdmin);
        _setAdmin(newAdmin);
    }

    /**
     * @dev The storage slot of the UpgradeableBeacon contract which defines the implementation for this proxy.
     * This is bytes32(uint256(keccak256('eip1967.proxy.beacon')) - 1)) and is validated in the constructor.
     */
    bytes32 internal constant _BEACON_SLOT = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;

    /**
     * @dev Emitted when the beacon is upgraded.
     */
    event BeaconUpgraded(address indexed beacon);

    /**
     * @dev Returns the current beacon.
     */
    function _getBeacon() internal view returns (address) {
        return StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value;
    }

    /**
     * @dev Stores a new beacon in the EIP1967 beacon slot.
     */
    function _setBeacon(address newBeacon) private {
        require(AddressUpgradeable.isContract(newBeacon), "ERC1967: new beacon is not a contract");
        require(
            AddressUpgradeable.isContract(IBeaconUpgradeable(newBeacon).implementation()),
            "ERC1967: beacon implementation is not a contract"
        );
        StorageSlotUpgradeable.getAddressSlot(_BEACON_SLOT).value = newBeacon;
    }

    /**
     * @dev Perform beacon upgrade with additional setup call. Note: This upgrades the address of the beacon, it does
     * not upgrade the implementation contained in the beacon (see {UpgradeableBeacon-_setImplementation} for that).
     *
     * Emits a {BeaconUpgraded} event.
     */
    function _upgradeBeaconToAndCall(
        address newBeacon,
        bytes memory data,
        bool forceCall
    ) internal {
        _setBeacon(newBeacon);
        emit BeaconUpgraded(newBeacon);
        if (data.length > 0 || forceCall) {
            _functionDelegateCall(IBeaconUpgradeable(newBeacon).implementation(), data);
        }
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function _functionDelegateCall(address target, bytes memory data) private returns (bytes memory) {
        require(AddressUpgradeable.isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return AddressUpgradeable.verifyCallResult(success, returndata, "Address: low-level delegate call failed");
    }
    uint256[50] private __gap;
}


// File @openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (proxy/utils/UUPSUpgradeable.sol)

pragma solidity ^0.8.0;


/**
 * @dev An upgradeability mechanism designed for UUPS proxies. The functions included here can perform an upgrade of an
 * {ERC1967Proxy}, when this contract is set as the implementation behind such a proxy.
 *
 * A security mechanism ensures that an upgrade does not turn off upgradeability accidentally, although this risk is
 * reinstated if the upgrade retains upgradeability but removes the security mechanism, e.g. by replacing
 * `UUPSUpgradeable` with a custom implementation of upgrades.
 *
 * The {_authorizeUpgrade} function must be overridden to include access restriction to the upgrade mechanism.
 *
 * _Available since v4.1._
 */
abstract contract UUPSUpgradeable is Initializable, ERC1967UpgradeUpgradeable {
    function __UUPSUpgradeable_init() internal onlyInitializing {
        __ERC1967Upgrade_init_unchained();
        __UUPSUpgradeable_init_unchained();
    }

    function __UUPSUpgradeable_init_unchained() internal onlyInitializing {
    }
    /// @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
    address private immutable __self = address(this);

    /**
     * @dev Check that the execution is being performed through a delegatecall call and that the execution context is
     * a proxy contract with an implementation (as defined in ERC1967) pointing to self. This should only be the case
     * for UUPS and transparent proxies that are using the current contract as their implementation. Execution of a
     * function through ERC1167 minimal proxies (clones) would not normally pass this test, but is not guaranteed to
     * fail.
     */
    modifier onlyProxy() {
        require(address(this) != __self, "Function must be called through delegatecall");
        require(_getImplementation() == __self, "Function must be called through active proxy");
        _;
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     */
    function upgradeTo(address newImplementation) external virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallSecure(newImplementation, new bytes(0), false);
    }

    /**
     * @dev Upgrade the implementation of the proxy to `newImplementation`, and subsequently execute the function call
     * encoded in `data`.
     *
     * Calls {_authorizeUpgrade}.
     *
     * Emits an {Upgraded} event.
     */
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable virtual onlyProxy {
        _authorizeUpgrade(newImplementation);
        _upgradeToAndCallSecure(newImplementation, data, true);
    }

    /**
     * @dev Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
     * {upgradeTo} and {upgradeToAndCall}.
     *
     * Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.
     *
     * ```solidity
     * function _authorizeUpgrade(address) internal override onlyOwner {}
     * ```
     */
    function _authorizeUpgrade(address newImplementation) internal virtual;
    uint256[50] private __gap;
}


// File @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library StringsUpgradeable {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}


// File @openzeppelin/contracts-upgradeable/utils/cryptography/ECDSAUpgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)

pragma solidity ^0.8.0;

/**
 * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
 *
 * These functions can be used to verify that a message was signed by the holder
 * of the private keys of a given address.
 */
library ECDSAUpgradeable {
    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV
    }

    function _throwError(RecoverError error) private pure {
        if (error == RecoverError.NoError) {
            return; // no error: do nothing
        } else if (error == RecoverError.InvalidSignature) {
            revert("ECDSA: invalid signature");
        } else if (error == RecoverError.InvalidSignatureLength) {
            revert("ECDSA: invalid signature length");
        } else if (error == RecoverError.InvalidSignatureS) {
            revert("ECDSA: invalid signature 's' value");
        } else if (error == RecoverError.InvalidSignatureV) {
            revert("ECDSA: invalid signature 'v' value");
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature` or error string. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     *
     * Documentation for signature generation:
     * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
     * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
     *
     * _Available since v4.3._
     */
    function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
        // Check the signature length
        // - case 65: r,s,v signature (standard)
        // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
        if (signature.length == 65) {
            bytes32 r;
            bytes32 s;
            uint8 v;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
            return tryRecover(hash, v, r, s);
        } else if (signature.length == 64) {
            bytes32 r;
            bytes32 vs;
            // ecrecover takes the signature parameters, and the only way to get them
            // currently is to use assembly.
            assembly {
                r := mload(add(signature, 0x20))
                vs := mload(add(signature, 0x40))
            }
            return tryRecover(hash, r, vs);
        } else {
            return (address(0), RecoverError.InvalidSignatureLength);
        }
    }

    /**
     * @dev Returns the address that signed a hashed message (`hash`) with
     * `signature`. This address can then be used for verification purposes.
     *
     * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
     * this function rejects them by requiring the `s` value to be in the lower
     * half order, and the `v` value to be either 27 or 28.
     *
     * IMPORTANT: `hash` _must_ be the result of a hash operation for the
     * verification to be secure: it is possible to craft signatures that
     * recover to arbitrary addresses for non-hashed data. A safe way to ensure
     * this is by receiving a hash of the original message (which may otherwise
     * be too long), and then calling {toEthSignedMessageHash} on it.
     */
    function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, signature);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
     *
     * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address, RecoverError) {
        bytes32 s;
        uint8 v;
        assembly {
            s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
            v := add(shr(255, vs), 27)
        }
        return tryRecover(hash, v, r, s);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
     *
     * _Available since v4.2._
     */
    function recover(
        bytes32 hash,
        bytes32 r,
        bytes32 vs
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, r, vs);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
     * `r` and `s` signature fields separately.
     *
     * _Available since v4.3._
     */
    function tryRecover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address, RecoverError) {
        // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
        // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
        // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
        // signatures from current libraries generate a unique signature with an s-value in the lower half order.
        //
        // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
        // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
        // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
        // these malleable signatures as well.
        if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
            return (address(0), RecoverError.InvalidSignatureS);
        }
        if (v != 27 && v != 28) {
            return (address(0), RecoverError.InvalidSignatureV);
        }

        // If the signature is valid (and not malleable), return the signer address
        address signer = ecrecover(hash, v, r, s);
        if (signer == address(0)) {
            return (address(0), RecoverError.InvalidSignature);
        }

        return (signer, RecoverError.NoError);
    }

    /**
     * @dev Overload of {ECDSA-recover} that receives the `v`,
     * `r` and `s` signature fields separately.
     */
    function recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
        _throwError(error);
        return recovered;
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from a `hash`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
        // 32 is the length in bytes of hash,
        // enforced by the type signature above
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
    }

    /**
     * @dev Returns an Ethereum Signed Message, created from `s`. This
     * produces hash corresponding to the one signed with the
     * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
     * JSON-RPC method as part of EIP-191.
     *
     * See {recover}.
     */
    function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", StringsUpgradeable.toString(s.length), s));
    }

    /**
     * @dev Returns an Ethereum Signed Typed Data, created from a
     * `domainSeparator` and a `structHash`. This produces hash corresponding
     * to the one signed with the
     * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
     * JSON-RPC method as part of EIP-712.
     *
     * See {recover}.
     */
    function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }
}


// File @openzeppelin/contracts-upgradeable/utils/cryptography/draft-EIP712Upgradeable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)

pragma solidity ^0.8.0;


/**
 * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
 *
 * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
 * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
 * they need in their contracts using a combination of `abi.encode` and `keccak256`.
 *
 * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
 * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
 * ({_hashTypedDataV4}).
 *
 * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
 * the chain id to protect against replay attacks on an eventual fork of the chain.
 *
 * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
 * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
 *
 * _Available since v3.4._
 */
abstract contract EIP712Upgradeable is Initializable {
    /* solhint-disable var-name-mixedcase */
    bytes32 private _HASHED_NAME;
    bytes32 private _HASHED_VERSION;
    bytes32 private constant _TYPE_HASH = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");

    /* solhint-enable var-name-mixedcase */

    /**
     * @dev Initializes the domain separator and parameter caches.
     *
     * The meaning of `name` and `version` is specified in
     * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
     *
     * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
     * - `version`: the current major version of the signing domain.
     *
     * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
     * contract upgrade].
     */
    function __EIP712_init(string memory name, string memory version) internal onlyInitializing {
        __EIP712_init_unchained(name, version);
    }

    function __EIP712_init_unchained(string memory name, string memory version) internal onlyInitializing {
        bytes32 hashedName = keccak256(bytes(name));
        bytes32 hashedVersion = keccak256(bytes(version));
        _HASHED_NAME = hashedName;
        _HASHED_VERSION = hashedVersion;
    }

    /**
     * @dev Returns the domain separator for the current chain.
     */
    function _domainSeparatorV4() internal view returns (bytes32) {
        return _buildDomainSeparator(_TYPE_HASH, _EIP712NameHash(), _EIP712VersionHash());
    }

    function _buildDomainSeparator(
        bytes32 typeHash,
        bytes32 nameHash,
        bytes32 versionHash
    ) private view returns (bytes32) {
        return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
    }

    /**
     * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
     * function returns the hash of the fully encoded EIP712 message for this domain.
     *
     * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
     *
     * ```solidity
     * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
     *     keccak256("Mail(address to,string contents)"),
     *     mailTo,
     *     keccak256(bytes(mailContents))
     * )));
     * address signer = ECDSA.recover(digest, signature);
     * ```
     */
    function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
        return ECDSAUpgradeable.toTypedDataHash(_domainSeparatorV4(), structHash);
    }

    /**
     * @dev The hash of the name parameter for the EIP712 domain.
     *
     * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712NameHash() internal virtual view returns (bytes32) {
        return _HASHED_NAME;
    }

    /**
     * @dev The hash of the version parameter for the EIP712 domain.
     *
     * NOTE: This function reads from storage by default, but can be redefined to return a constant value if gas costs
     * are a concern.
     */
    function _EIP712VersionHash() internal virtual view returns (bytes32) {
        return _HASHED_VERSION;
    }
    uint256[50] private __gap;
}


// File @openzeppelin/contracts/utils/Context.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v4.4.1

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File contracts/bonding_curves/BondingCurve.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Bonding Curve
 *
 * @notice A friend.tech-like bonding curve definition
 *
 * @notice Bonding curve defines the price of the smallest unit of the asset as a function
 *      of the asset supply
 */
interface BondingCurve {
	/**
	 * @notice Bonding curve function definition. The function calculating the price
	 *      of the `amount` of shares given the current total supply `supply`
	 *
	 * @param supply total shares supply
	 * @param amount number of shares to buy/sell
	 * @return the price of the shares (all `amount` amount)
	 */
	function getPrice(uint256 supply, uint256 amount) external pure returns(uint256);
}


// File contracts/interfaces/ERC165Spec.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title ERC-165 Standard Interface Detection
 *
 * @dev Interface of the ERC165 standard, as defined in the
 *       https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * @dev Implementers can declare support of contract interfaces,
 *      which can then be queried by others.
 *
 * @author Christian Reitwießner, Nick Johnson, Fabian Vogelsteller, Jordi Baylina, Konrad Feldmeier, William Entriken
 */
interface ERC165 {
	/**
	 * @notice Query if a contract implements an interface
	 *
	 * @dev Interface identification is specified in ERC-165.
	 *      This function uses less than 30,000 gas.
	 *
	 * @param interfaceID The interface identifier, as specified in ERC-165
	 * @return `true` if the contract implements `interfaceID` and
	 *      `interfaceID` is not 0xffffffff, `false` otherwise
	 */
	function supportsInterface(bytes4 interfaceID) external view returns (bool);
}


// File contracts/interfaces/ERC20Spec.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title EIP-20: ERC-20 Token Standard
 *
 * @notice The ERC-20 (Ethereum Request for Comments 20), proposed by Fabian Vogelsteller in November 2015,
 *      is a Token Standard that implements an API for tokens within Smart Contracts.
 *
 * @notice It provides functionalities like to transfer tokens from one account to another,
 *      to get the current token balance of an account and also the total supply of the token available on the network.
 *      Besides these it also has some other functionalities like to approve that an amount of
 *      token from an account can be spent by a third party account.
 *
 * @notice If a Smart Contract implements the following methods and events it can be called an ERC-20 Token
 *      Contract and, once deployed, it will be responsible to keep track of the created tokens on Ethereum.
 *
 * @notice See https://ethereum.org/en/developers/docs/standards/tokens/erc-20/
 * @notice See https://eips.ethereum.org/EIPS/eip-20
 */
interface ERC20 {
	/**
	 * @dev Fired in transfer(), transferFrom() to indicate that token transfer happened
	 *
	 * @param from an address tokens were consumed from
	 * @param to an address tokens were sent to
	 * @param value number of tokens transferred
	 */
	event Transfer(address indexed from, address indexed to, uint256 value);

	/**
	 * @dev Fired in approve() to indicate an approval event happened
	 *
	 * @param owner an address which granted a permission to transfer
	 *      tokens on its behalf
	 * @param spender an address which received a permission to transfer
	 *      tokens on behalf of the owner `_owner`
	 * @param value amount of tokens granted to transfer on behalf
	 */
	event Approval(address indexed owner, address indexed spender, uint256 value);

	/**
	 * @return name of the token (ex.: USD Coin)
	 */
	// OPTIONAL - This method can be used to improve usability,
	// but interfaces and other contracts MUST NOT expect these values to be present.
	// function name() external view returns (string memory);

	/**
	 * @return symbol of the token (ex.: USDC)
	 */
	// OPTIONAL - This method can be used to improve usability,
	// but interfaces and other contracts MUST NOT expect these values to be present.
	// function symbol() external view returns (string memory);

	/**
	 * @dev Returns the number of decimals used to get its user representation.
	 *      For example, if `decimals` equals `2`, a balance of `505` tokens should
	 *      be displayed to a user as `5,05` (`505 / 10 ** 2`).
	 *
	 * @dev Tokens usually opt for a value of 18, imitating the relationship between
	 *      Ether and Wei. This is the value {ERC20} uses, unless this function is
	 *      overridden;
	 *
	 * @dev NOTE: This information is only used for _display_ purposes: it in
	 *      no way affects any of the arithmetic of the contract, including
	 *      {IERC20-balanceOf} and {IERC20-transfer}.
	 *
	 * @return token decimals
	 */
	// OPTIONAL - This method can be used to improve usability,
	// but interfaces and other contracts MUST NOT expect these values to be present.
	// function decimals() external view returns (uint8);

	/**
	 * @return the amount of tokens in existence
	 */
	function totalSupply() external view returns (uint256);

	/**
	 * @notice Gets the balance of a particular address
	 *
	 * @param _owner the address to query the the balance for
	 * @return balance an amount of tokens owned by the address specified
	 */
	function balanceOf(address _owner) external view returns (uint256 balance);

	/**
	 * @notice Transfers some tokens to an external address or a smart contract
	 *
	 * @dev Called by token owner (an address which has a
	 *      positive token balance tracked by this smart contract)
	 * @dev Throws on any error like
	 *      * insufficient token balance or
	 *      * incorrect `_to` address:
	 *          * zero address or
	 *          * self address or
	 *          * smart contract which doesn't support ERC20
	 *
	 * @param _to an address to transfer tokens to,
	 *      must be either an external address or a smart contract,
	 *      compliant with the ERC20 standard
	 * @param _value amount of tokens to be transferred,, zero
	 *      value is allowed
	 * @return success true on success, throws otherwise
	 */
	function transfer(address _to, uint256 _value) external returns (bool success);

	/**
	 * @notice Transfers some tokens on behalf of address `_from' (token owner)
	 *      to some other address `_to`
	 *
	 * @dev Called by token owner on his own or approved address,
	 *      an address approved earlier by token owner to
	 *      transfer some amount of tokens on its behalf
	 * @dev Throws on any error like
	 *      * insufficient token balance or
	 *      * incorrect `_to` address:
	 *          * zero address or
	 *          * same as `_from` address (self transfer)
	 *          * smart contract which doesn't support ERC20
	 *
	 * @param _from token owner which approved caller (transaction sender)
	 *      to transfer `_value` of tokens on its behalf
	 * @param _to an address to transfer tokens to,
	 *      must be either an external address or a smart contract,
	 *      compliant with the ERC20 standard
	 * @param _value amount of tokens to be transferred,, zero
	 *      value is allowed
	 * @return success true on success, throws otherwise
	 */
	function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

	/**
	 * @notice Approves address called `_spender` to transfer some amount
	 *      of tokens on behalf of the owner (transaction sender)
	 *
	 * @dev Transaction sender must not necessarily own any tokens to grant the permission
	 *
	 * @param _spender an address approved by the caller (token owner)
	 *      to spend some tokens on its behalf
	 * @param _value an amount of tokens spender `_spender` is allowed to
	 *      transfer on behalf of the token owner
	 * @return success true on success, throws otherwise
	 */
	function approve(address _spender, uint256 _value) external returns (bool success);

	/**
	 * @notice Returns the amount which _spender is still allowed to withdraw from _owner.
	 *
	 * @dev A function to check an amount of tokens owner approved
	 *      to transfer on its behalf by some other address called "spender"
	 *
	 * @param _owner an address which approves transferring some tokens on its behalf
	 * @param _spender an address approved to transfer some tokens on behalf
	 * @return remaining an amount of tokens approved address `_spender` can transfer on behalf
	 *      of token owner `_owner`
	 */
	function allowance(address _owner, address _spender) external view returns (uint256 remaining);
}

/**
 * @title Mintable/burnable ERC20 Extension
 *
 * @notice Adds mint/burn functions to ERC20 interface, these functions
 *      are usually present in ERC20 implementations, but these become
 *      a must for the bridged tokens in L2 since the bridge on L2
 *      needs to have a way to mint tokens deposited from L1 to L2
 *      and to burn tokens to be withdrawn from L2 to L1
 */
interface MintableBurnableERC20 is ERC20 {
	/**
	 * @dev Mints (creates) some tokens to address specified
	 * @dev The value specified is treated as is without taking
	 *      into account what `decimals` value is
	 *
	 * @param _to an address to mint tokens to
	 * @param _value an amount of tokens to mint (create)
	 */
	function mint(address _to, uint256 _value) external;

	/**
	 * @dev Burns (destroys) some tokens from the address specified
	 *
	 * @dev The value specified is treated as is without taking
	 *      into account what `decimals` value is
	 *
	 * @param _from an address to burn some tokens from
	 * @param _value an amount of tokens to burn (destroy)
	 */
	function burn(address _from, uint256 _value) external;
}


// File contracts/interfaces/ERC1363Spec.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;


/**
 * @title ERC1363 Interface
 *
 * @dev Interface defining a ERC1363 Payable Token contract.
 *      Implementing contracts MUST implement the ERC1363 interface as well as the ERC20 and ERC165 interfaces.
 */
interface ERC1363 is ERC20, ERC165  {
	/*
	 * Note: the ERC-165 identifier for this interface is 0xb0202a11.
	 * 0xb0202a11 ===
	 *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
	 *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
	 *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
	 *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)')) ^
	 *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
	 *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
	 */

	/**
	 * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
	 * @param to address The address which you want to transfer to
	 * @param value uint256 The amount of tokens to be transferred
	 * @return true unless throwing
	 */
	function transferAndCall(address to, uint256 value) external returns (bool);

	/**
	 * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
	 * @param to address The address which you want to transfer to
	 * @param value uint256 The amount of tokens to be transferred
	 * @param data bytes Additional data with no specified format, sent in call to `to`
	 * @return true unless throwing
	 */
	function transferAndCall(address to, uint256 value, bytes memory data) external returns (bool);

	/**
	 * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
	 * @param from address The address which you want to send tokens from
	 * @param to address The address which you want to transfer to
	 * @param value uint256 The amount of tokens to be transferred
	 * @return true unless throwing
	 */
	function transferFromAndCall(address from, address to, uint256 value) external returns (bool);


	/**
	 * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
	 * @param from address The address which you want to send tokens from
	 * @param to address The address which you want to transfer to
	 * @param value uint256 The amount of tokens to be transferred
	 * @param data bytes Additional data with no specified format, sent in call to `to`
	 * @return true unless throwing
	 */
	function transferFromAndCall(address from, address to, uint256 value, bytes memory data) external returns (bool);

	/**
	 * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
	 * and then call `onApprovalReceived` on spender.
	 * @param spender address The address which will spend the funds
	 * @param value uint256 The amount of tokens to be spent
	 */
	function approveAndCall(address spender, uint256 value) external returns (bool);

	/**
	 * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
	 * and then call `onApprovalReceived` on spender.
	 * @param spender address The address which will spend the funds
	 * @param value uint256 The amount of tokens to be spent
	 * @param data bytes Additional data with no specified format, sent in call to `spender`
	 */
	function approveAndCall(address spender, uint256 value, bytes memory data) external returns (bool);
}

/**
 * @title ERC1363Receiver Interface
 *
 * @dev Interface for any contract that wants to support `transferAndCall` or `transferFromAndCall`
 *      from ERC1363 token contracts.
 */
interface ERC1363Receiver {
	/*
	 * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
	 * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
	 */

	/**
	 * @notice Handle the receipt of ERC1363 tokens
	 *
	 * @dev Any ERC1363 smart contract calls this function on the recipient
	 *      after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
	 *      transfer. Return of other than the magic value MUST result in the
	 *      transaction being reverted.
	 *      Note: the token contract address is always the message sender.
	 *
	 * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
	 * @param from address The address which are token transferred from
	 * @param value uint256 The amount of tokens transferred
	 * @param data bytes Additional data with no specified format
	 * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
	 *      unless throwing
	 */
	function onTransferReceived(address operator, address from, uint256 value, bytes memory data) external returns (bytes4);
}

/**
 * @title ERC1363Spender Interface
 *
 * @dev Interface for any contract that wants to support `approveAndCall`
 *      from ERC1363 token contracts.
 */
interface ERC1363Spender {
	/*
	 * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
	 * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
	 */

	/**
	 * @notice Handle the approval of ERC1363 tokens
	 *
	 * @dev Any ERC1363 smart contract calls this function on the recipient
	 *      after an `approve`. This function MAY throw to revert and reject the
	 *      approval. Return of other than the magic value MUST result in the
	 *      transaction being reverted.
	 *      Note: the token contract address is always the message sender.
	 *
	 * @param owner address The address which called `approveAndCall` function
	 * @param value uint256 The amount of tokens to be spent
	 * @param data bytes Additional data with no specified format
	 * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
	 *      unless throwing
	 */
	function onApprovalReceived(address owner, uint256 value, bytes memory data) external returns (bytes4);
}


// File contracts/bonding_curves/HoldersRewardsDistributor.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Bonding Curve Holder Reward Distributor
 *
 * @notice Holder reward distributor keeps track of every trade event happening in the curve,
 *      and based on the amount of shares the holder has, alters the holders' reward weight,
 *      which directly affects the amount of the distributed rewards between the holders
 *
 * @notice Holder reward distributor accepts the fees from the curve and distributes these fees
 *      across shares holders proportionally to their weights
 *
 * @dev Apart from the `accept(uint256,address)` function designed to accept the fees from the
 *      curve contract, the implementation must implement receive(), fallback(), and onTransferReceived()
 *      functions to accept direct payments in both ETH and/or ERC20 payment token
 *
 * @dev receive() and onTransferReceived() with an empty data field must accept the fee in the same way
 *      as an accept() function would do, but in a passive way (without ERC20 transfer)
 *
 * @dev The fallback() and onTransferReceived() with non-empty data field must accept the fee and the trading event;
 *      trading event encoded in the bytes data field contains the information
 *      on the trade which resulted in the fee being sent:
 *
 *      - address trader - shares holder/trader
 *      - bool isBuy - true if shares were bought, false if shares were sold
 *      - uint256 sharesAmount - amount of shares bought or sold
 *
 *      the values above are packed as data = abi.encode(trader, isBuy, sharesAmount)
 *      and can be unpacked as (trader, isBuy, sharesAmount) = abi.decode(data, (address, bool, uint256))
 *
 *      if specified, the data field must be parsed by the implementation and its containing data applied;
 *      standard logic applies, if the data is malformed implementation should throw
 *
 */
interface HoldersRewardsDistributor is ERC1363Receiver {
	/**
	 * @dev Fired in `sharesBought` and `sharesSold`
	 *
	 * @param trader is a buyer or a seller, depending on the operation type
	 * @param isBuy true if the event comes from the `sharesBought` and represents the buy operation,
	 *      false if the event comes from the `sharesSold` and represents the sell operation
	 * @param sharesAmount amount of the shares bought or sold (see `isBuy`)
	 */
	event SharesTraded(address indexed trader, bool indexed isBuy, uint256 sharesAmount);

	/**
	 * @dev Fired when the fee for the distribution is received
	 *
	 * @param feeAmount amount of the fee to distribute between the holders
	 */
	event FeeReceived(uint256 feeAmount);

	/**
	 * @dev Fired in `claimReward`
	 *
	 * @param holder address of the trader (and shares holder) who received the reward
	 * @param rewardAmount amount of the reward sent
	 */
	event RewardClaimed(address indexed holder, uint256 rewardAmount);

	/**
	 * @notice ERC20 payment token distributor is bound to
	 *
	 * @return paymentToken ERC20 payment token address the contract is bound to,
	 *      or zero zero address if it operates with the plain ETH
	 */
	function getPaymentToken() external view returns(address paymentToken);

/*
	*/
/**
	 * @notice Notifies the distributor about the trade event
	 *
	 * @dev Trade amount specified affects holder's (buyer's) weight when calculating the reward
	 *
	 * @param buyer shares buyer (becomes shares holder if not yet), a.k.a trader
	 * @param amountBought amount of the shares bought
	 *//*

	function sharesBought(address buyer, uint256 amountBought) external;

	*/
/**
	 * @notice Notifies the distributor about the trade event
	 *
	 * @dev Trade amount specified affects holder's (seller's) weight when calculating the reward
	 *
	 * @param seller shares seller (shares holder), a.k.a trader
	 * @param amountSold amount of the shares sold
	 *//*

	function sharesSold(address seller, uint256 amountSold) external;

	*/
/**
	 * @notice Executed by the fee sender to send the fee; in case of the ERC20 payment,
	 *      this is the ask to take the specified amount of the ERC20 token of the specified type;
	 *      in case of the ETH payment, the amount must be supplied with the transaction itself
	 *
	 * @dev When paying with an ERC20 payment token, sender must approve the contract for
	 *      at least the amount specified before executing this function
	 *
	 * @dev Updates the accumulated reward per share
	 *
	 * @param feeAmount amount of the fee sent,
	 *      in the case of ETH payment must be equal to msg.value
	 *//*

	function accept(uint256 feeAmount) external payable;
*/

	/**
	 * @notice Executed by the holder to claim entire pending reward
	 *
	 * @dev Holder can verify pending reward amount with the `pendingReward` function
	 */
	function claimTheReward() external;

	/**
	 * @notice Pending (claimable) reward. This is the amount which can be claimed using `claimTheReward`
	 *
	 * @param holder the holder address to query the reward for
	 * @return rewardAmount pending reward amount\
	 */
	function pendingReward(address holder) external view returns(uint256 rewardAmount);
}


// File contracts/bonding_curves/TradeableShares.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;


/**
 * @title Tradeable Shares
 *
 * @notice Tradeable shares is a non-transferable, but buyable/sellable fungible token-like asset,
 *      which is sold/bought solely by the shares contract at the predefined by
 *      the bonding curve function price
 *
 * @notice The shares is bound to its "subject" – an NFT; the NFT owner gets the subject fee
 *      emerging in every buy/sell operation
 *
 * @dev Based on the friend.tech FriendtechSharesV1.sol
 */
interface TradeableShares is BondingCurve {
	/**
	 * @notice Shares subject is an NFT defined by its ERC721 contract address and NFT ID
	 *       Note: this is different from the original FriendTech implementation where
	 *       shares subject is always equal to the issuer address
	 */
	struct SharesSubject {
		/// @dev ERC721 contract address
		address tokenAddress;

		/// @dev NFT ID
		uint256 tokenId;
	}

	/**
	 * @dev Fired in `buyShares` and `sellShares` functions, this event logs
	 *      the entire trading activity happening on the curve
	 *
	 * @dev Trader, that is the buyer or seller, depending on the operation type is the transaction sender
	 *
	 * @param beneficiary the address which receives shares or funds, usually this is the trader itself
	 * @param issuer subject issuer, usually an owner of the NFT defined by the subject
	 * @param isBuy true if the event comes from the `buyShares` and represents the buy operation,
	 *      false if the event comes from the `sellShares` and represents the sell operation
	 * @param sharesAmount amount of the shares bought or sold (see `isBuy`)
	 * @param paidAmount amount of ETH spent or gained by the buyer or seller;
	 *      this is implementation dependent and can represent an amount of ERC20 payment token
	 * @param protocolFeeAmount amount of fees paid to the protocol
	 * @param holdersFeeAmount amount of fees paid to the shares holders
	 * @param subjectFeeAmount amount of fees paid to the subject (issuer)
	 * @param supply total shares supply after the operation
	 */
	event Trade(
		address indexed beneficiary,
		address indexed issuer,
		bool indexed isBuy,
		uint256 sharesAmount,
		uint256 paidAmount,
		uint256 protocolFeeAmount,
		uint256 holdersFeeAmount,
		uint256 subjectFeeAmount,
		uint256 supply
	);

	/**
	 * @notice Shares subject, usually defined as NFT (ERC721 contract address + NFT ID)
	 *
	 * @dev Immutable, client applications may cache this value
	 *
	 * @return Shares subject as a SharesSubject struct, this is an NFT if all currently known implementations
	 */
	function getSharesSubject() external view returns(SharesSubject calldata);

	/**
	 * @notice Protocol fee destination, the address protocol fee is sent to
	 *
	 * @dev Mutable, can be changed by the protocol fee manager
	 *
	 * @return the address where the protocol fee is sent to
	 */
	function getProtocolFeeDestination() external view returns(address);

	/**
	 * @notice Protocol fee percent, applied to all the buy and sell operations;
	 *      the fee percent is defined with the 18 decimals, 10^18 corresponds to 100%
	 *
	 * @notice Protocol fee is sent to the protocol fee destination (see `getProtocolFeeDestination`)
	 *
	 * @dev Immutable, client applications may cache this value
	 *
	 * @return protocol fee percent with the 18 decimals (10^18 is 100%)
	 */
	function getProtocolFeePercent() external view returns(uint256);

	/**
	 * @notice Protocol fee destination and protocol fee percent as a tuple;
	 *      the fee percent is defined with the 18 decimals, 10^18 corresponds to 100%
	 *
	 * @dev Implementation must always return zero fee percent if fee destination is zero address
	 *
	 * @return feeDestination protocol fee destination
	 * @return feePercent protocol fee percent, zero if protocol fee destination is zero
	 */
	function getProtocolFeeInfo() external view returns(address feeDestination, uint256 feePercent);

	/**
	 * @notice Shares holders reward distributor contract attached to the shares contract
	 *      in order to receive its portion of the fees to be distributed among the shares holders
	 *
	 * @dev Immutable, client applications may cache this value; holders fee destination is not
	 *      an arbitrary address capable of receiving ETH or ERC20, but a HoldersRewardsDistributor
	 *      smart contract, which not only receives the fees but also receives updated on the
	 *      trading activity in the shares contract
	 *
	 * @return the contract where the holders fee is sent to
	 */
	function getHoldersFeeDestination() external view returns(HoldersRewardsDistributor);

	/**
	 * @notice Shares holders fee percent, applied to all the buy and sell operations;
	 *      the fee percent is defined with the 18 decimals, 10^18 corresponds to 100%
	 *
	 * @notice Shares holders fee is sent to the holders fee destination (see `getHoldersFeeDestination`)
	 *
	 * @dev Immutable, client applications may cache this value
	 *
	 * @return shares holders fee percent with the 18 decimals (10^18 is 100%)
	 */
	function getHoldersFeePercent() external view returns(uint256);

	/**
	 * @notice Shares holders fee destination and shares holders fee percent as a tuple;
	 *      the fee percent is defined with the 18 decimals, 10^18 corresponds to 100%
	 *
	 * @dev Implementation must always return zero fee percent if fee destination is zero
	 *
	 * @return feeDestination shares holders fee destination
	 * @return feePercent shares holders fee percent, zero if holders fee destination is zero
	 */
	function getHoldersFeeInfo() external view returns(HoldersRewardsDistributor feeDestination, uint256 feePercent);

	/**
	 * @notice Subject fee destination and subject fee percent as a tuple;
	 *      subject fee destination is shares issuer address;
	 *      the fee percent is defined with the 18 decimals, 10^18 corresponds to 100%;
	 *
	 * @dev Implementation must always return zero fee percent if fee destination is zero address
	 *
	 * @return feeDestination protocol fee destination
	 * @return feePercent protocol fee percent, zero if subject fee destination is zero
	 */
	function getSubjectFeeInfo() external view returns(address feeDestination, uint256 feePercent);

	/**
	 * @notice Subject fee percent, applied to all the buy and sell operations,
	 *      the fee percent is defined with the 18 decimals, 10^18 corresponds to 100%
	 *
	 * @notice Subject fee is sent to the subject fee issuer (see `getSharesIssuer`)
	 *
	 * @dev Immutable, client applications may cache this value
	 *
	 * @return subject fee percent with the 18 decimals (10^18 is 100%)
	 */
	function getSubjectFeePercent() external view returns(uint256);

	/**
	 * @notice Shares issuer, the receiver of the shares fees
	 *
	 * @dev Mutable, changes (potentially frequently and unpredictably) when the NFT owner changes;
	 *      subject to the front-run attacks, off-chain client applications must not rely on this address
	 *      in anyway
	 *
	 * @return nftOwner subject issuer, the owner of the NFT
	 */
	function getSharesIssuer() external view returns(address nftOwner);

	/**
	 * @notice Shares balance of the given holder; this function is similar to ERC20.balanceOf()
	 *
	 * @param holder the address to check the balance for
	 *
	 * @return balance number of shares the holder has
	 */
	function getSharesBalance(address holder) external view returns(uint256 balance);

	/**
	 * @notice Total amount of the shares in existence, the sum of all individual shares balances;
	 *      this function is similar to ERC20.totalSupply()
	 *
	 * @return supply total shares supply
	 */
	function getSharesSupply() external view returns(uint256 supply);

	/**
	 * @notice The price of the `amount` of shares to buy calculated based on
	 *      the specified total shares supply
	 *
	 * @param supply total shares supply
	 * @param amount number of shares to buy
	 * @return the price of the shares to buy
	 */
	function getBuyPrice(uint256 supply, uint256 amount) external pure returns(uint256);

	/**
	 * @notice The price of the `amount` of shares to sell calculated based on
	 *      the specified total shares supply
	 *
	 * @param supply total shares supply
	 * @param amount number of shares to sell
	 * @return the price of the shares to sell
	 */
	function getSellPrice(uint256 supply, uint256 amount) external pure returns(uint256);

	/**
	 * @notice The price of the `amount` of shares to buy, including all fees;
	 *      calculated based on the specified total shares supply and fees percentages
	 *
	 * @param supply total shares supply
	 * @param amount number of shares to buy
	 * @param protocolFeePercent protocol fee percent
	 * @param holdersFeePercent shares holders fee percent
	 * @param subjectFeePercent protocol fee percent
	 * @return the price of the shares to buy
	 */
	function getBuyPriceAfterFee(
		uint256 supply,
		uint256 amount,
		uint256 protocolFeePercent,
		uint256 holdersFeePercent,
		uint256 subjectFeePercent
	) external pure returns(uint256);

	/**
	 * @notice The price of the `amount` of shares to sell, including all fees;
	 *      calculated based on the specified total shares supply and fees percentages
	 *
	 * @param supply total shares supply
	 * @param amount number of shares to sell
	 * @param protocolFeePercent protocol fee percent
	 * @param holdersFeePercent shares holders fee percent
	 * @param subjectFeePercent protocol fee percent
	 * @return the price of the shares to sell
	 */
	function getSellPriceAfterFee(
		uint256 supply,
		uint256 amount,
		uint256 protocolFeePercent,
		uint256 holdersFeePercent,
		uint256 subjectFeePercent
	) external pure returns(uint256);

	/**
	 * @notice Current price of the `amount` of shares to buy; calculated based on
	 *      the current total shares supply
	 *
	 * @param amount number of shares to buy
	 * @return the price of the shares to buy
	 */
	function getBuyPrice(uint256 amount) external view returns(uint256);

	/**
	 * @notice Current price of the `amount` of shares to sell; calculated based on
	 *      the current total shares supply
	 *
	 * @param amount number of shares to sell
	 * @return the price of the shares to sell
	 */
	function getSellPrice(uint256 amount) external view returns(uint256);

	/**
	 * @notice Current price of the `amount` of shares to buy, including all fees;
	 *      calculated based on the current total shares supply and fees percentages
	 *
	 * @param amount number of shares to buy
	 * @return the price of the shares to buy
	 */
	function getBuyPriceAfterFee(uint256 amount) external view returns(uint256);

	/**
	 * @notice Current price of the `amount` of shares to sell, including all fees;
	 *      calculated based on the current total shares supply and fees percentages
	 *
	 * @param amount number of shares to sell
	 * @return the price of the shares to sell
	 */
	function getSellPriceAfterFee(uint256 amount) external view returns(uint256);

	/**
	 * @notice Buy `amount` of shares. Sender has to supply `getBuyPriceAfterFee(amount)` ETH.
	 *      First share can be bought only by current subject issuer.
	 *
	 * @dev Depending on the implementation, ERC20 token payment may be required instead of ETH.
	 *      In such a case, implementation must through if ETH is sent, effectively overriding
	 *      the function definition as non-payable
	 *
	 * @param amount amount of the shares to buy
	 */
	function buyShares(uint256 amount) external payable;

	/**
	 * @notice Buy `amount` of shares in the favor of the address specified (beneficiary).
	 *      Sender has to supply `getBuyPriceAfterFee(amount)` ETH.
	 *      First share can be bought only by current subject issuer.
	 *
	 * @dev Depending on the implementation, ERC20 token payment may be required instead of ETH.
	 *      In such a case, implementation must through if ETH is sent, effectively overriding
	 *      the function definition as non-payable
	 *
	 * @param amount amount of the shares to buy
	 * @param beneficiary an address receiving the shares
	 */
	function buySharesTo(uint256 amount, address beneficiary) external payable;

	/**
	 * @notice Sell `amount` of shares. Sender gets `getSellPriceAfterFee(amount)` of ETH.
	 *      Last share cannot be sold.
	 *
	 * @dev Depending on the implementation, ERC20 token may be payed instead of ETH.
	 *
	 * @param amount amount of the shares to sell
	 */
	function sellShares(uint256 amount) external;

	/**
	 * @notice Sell `amount` of shares in the favor of the address specified (beneficiary).
	 *      The beneficiary gets `getSellPriceAfterFee(amount)` of ETH.
	 *      Last share cannot be sold.
	 *
	 * @dev Depending on the implementation, ERC20 token may be payed instead of ETH.
	 *
	 * @param amount amount of the shares to sell
	 * @param beneficiary an address receiving the funds from the sale
	 */
	function sellSharesTo(uint256 amount, address payable beneficiary) external;

	/**
	 * @notice Cumulative value of all trades; allows to derive cumulative fees paid
	 *
	 * @dev This value cannot decrease over time; it can increase or remain constant
	 *      if no trades are happening
	 *
	 * @return Sum of the modulo of all trading operations
	 */
	function getTradeVolume() external view returns(uint256);
}


// File contracts/bonding_curves/HiveRegistry.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Hive Registry (Interface)
 *
 * @notice Hive Registry keeps track of and manages the Hives
 *
 * @notice The Hive is a record in the `HiveRegistry` smart contract; the Hive:
 *      1) is bound to one (and only one) AI Pod,
 *      2) has one (and only one) ERC20 token enabling the Hive economy,
 *      3) has one and only one hiveURI pointing to some off-chain resource with the information about the Hive
 *         (possibly a website),
 *      4) has any number of NFTs (assets) bound to it (pre-sorted by category), and each NFT asset
 *         * has one (and only one) category within the Hive;
 *           * category examples: GPU Provider, Dataset Provider, AI Model Provider, etc.
 *         * cannot join other hives (can only join 1 Hive at a time)
 *         * NFT which created a Hive cannot join the same Hive, or any other Hive
 *
 * @dev Hive Registry provides functions to register Hive, register DPTs within the Hive, etc.
 */
interface HiveRegistry {
	/**
	 * @dev RegisterAsDPTRequest represents a EIP712 signed request to to register an NFT as DPT within a Hive
	 * @dev See `registerAsDPT()`
	 */
	struct RegisterAsDPTRequest {
		/// @dev NFT/DPT details (ERC721 address, ERC721 ID)
		TradeableShares.SharesSubject asset;
		// @dev NFT/DPT owner address
		address dptOwner;
		/// @dev unix timestamp when the request becomes valid
		uint256 validFromTimestamp;
		/// @dev unix timestamp when the request expires (becomes invalid)
		uint256 expiresAtTimestamp;
		/// @dev nonce of the request (sequential number, increased by one)
		uint256 nonce;
	}

	/**
	 * @dev Where an asset is linked:
	 *      - which hive (ID)
	 *      - under what category (ID)
	 *      - for enumeration support - asset index in the collections
	 */
	struct AssetLinkDetails {
		/// @dev Hive Id to which asset is linked
		uint16 hiveId;
		/// @dev category under which asset is linked
		uint16 categoryId;
		/// @dev Index of an asset within the linked asset array
		uint224 assetIndex;
	}

	/**
	 * @dev Category Info:
	 *      - category type in string value
	 *      - nft collection address which are allowed to link under
	 *        particular category, if set as ZERO address then any nft
	 *        collection can link.
	 */
	struct CategoryInfo {
		/// @dev categoryType in string format
		string category;
		/// @dev nft collection allowed to link under particular category
		address allowedCollection;
	}

	/**
	 * @dev Fired in register()
	 *
	 * @param by an address requested for DPT registration
	 * @param dptAddress DPT token address
	 * @param dptId DPT token ID
	 * @param timestamp time at which DTP is registered
	 */
	event DPTRegistered(address indexed by, address indexed dptAddress, uint256 indexed dptId, uint256 timestamp);

	/**
	 * @dev Fired in `register()` and in `fastForward()`
	 */
	event NonceUsed(address indexed issuer, uint256 nonce);

	/**
	 * @dev Fired in whitelistPods()
	 *
	 * @param by an address who execute transaction
	 * @param podId POD token ID
	 */
	event PodWhitelisted(address indexed by, uint256 podId);

	/**
	 * @dev Fired in delistPods()
	 *
	 * @param by an address who execute transaction
	 * @param podId POD token ID
	 */
	event PodDelisted(address indexed by, uint256 podId);

	/**
	 * @dev Fired in createHive()
	 *
	 * @param by an address who execute transaction
	 * @param hiveId an new created hive ID
	 * @param tokenAddress pod token address
	 * @param tokenId pod token ID
	 * @param timestamp time at which hive is created
	 */
	event HiveCreated(address indexed by, uint256 indexed hiveId, address tokenAddress, uint256 indexed tokenId, uint256 timestamp);

	/**
	 * @dev Fired in setHiveTokenAddress()
	 *
	 * @param by an address who execute transaction
	 * @param hiveId an hive ID
	 * @param tokenAddress ERC20 token against hive
	 */
	event HiveTokenUpdated(address indexed by, uint256 indexed hiveId, address indexed tokenAddress);

	/**
	 * @dev Fired in updateHiveURI()
	 *
	 * @param by an address who execute transaction
	 * @param hiveId an hive ID
	 * @param hiveURI hive metadata URI
	 */
	event HiveUriUpdated(address indexed by, uint256 indexed hiveId, string hiveURI);

	/**
	 * @dev Fired in addCategory()
	 *
	 * @param by an address who execute transaction
	 * @param categoryIndex an global category index
	 * @param category category in string
	 * @param allowedCollection nft collection address
	 */
	event CategoryAdded(address indexed by, uint256 indexed categoryIndex, string category, address allowedCollection);

	/**
	 * @dev Fired in linkAsset()
	 *
	 * @param by an address who execute transaction
	 * @param tokenAddress asset token address
	 * @param tokenId asset token ID
	 * @param hiveId hive ID
	 * @param category category index
	 * @param timestamp time at which asset is linked
	 */
	event AssetLinked(address by, address indexed tokenAddress, uint256 indexed tokenId, uint16 indexed hiveId, uint16 category, uint256 timestamp);

	/**
	 * @dev Fired in unlinkAsset()
	 *
	 * @param by an address who execute transaction
	 * @param tokenAddress asset token address
	 * @param tokenId asset token ID
	 * @param hiveId hive ID
	 * @param category category index
	 * @param timestamp time at which asset is unlinked
	 */
	event AssetUnlinked(address by, address indexed tokenAddress, uint256 indexed tokenId, uint16 indexed hiveId, uint16 category, uint256 timestamp);

	/**
	 * @notice Registers an NFT as DPT by the request with a valid signature.
	 *
	 * @param req The RegisterAssetRequest struct containing request details.
	 * @param signature The signature of the request.
	 */
	function eip712RegisterAsDPT(RegisterAsDPTRequest calldata req, bytes calldata signature) external;

	/**
	 * @notice Registers an NFT as DPT directly by the authorizer.
	 *
	 * @param _dpt The TradeableShares.SharesSubject struct representing the DPT.
	 */
	function registerAsDPT(TradeableShares.SharesSubject calldata _dpt) external;

	/**
	 * @notice Fast forward the nonce for the issuer specified, used to
	 *      discard one or more signed requests to `registerDPTRequest`
	 *
	 * @dev Implementation must not allow to decrease the nonce, only increasing (rewinding)
	 *      must be possible
	 *
	 * @param _issuer the issuer address to rewind the nonce for
	 * @param _nonce the nonce value to rewind to
	 */
	function fastForwardTheNonce(address _issuer, uint256 _nonce) external;

	/**
	 * @notice Creates a Hive. Available only for level 5 AI Pods
	 *
	 * @param podId Level 5 AI PodId
	 * @param hiveURI hive URI pointing to some off-chain resource
	 */
	function createHive(uint256 podId, string calldata hiveURI) external;

	/**
	 * @notice Links an asset (NFT) to the Hive under certain category
	 *
	 * @param asset an NFT (ERC721 address, ERC721 ID)
	 * @param hiveId ID of the hive to join
	 * @param categoryName asset category name within the Hive
	 */
	function linkAsset(TradeableShares.SharesSubject calldata asset, uint16 hiveId, string calldata categoryName) external;

	/**
	 * @notice Links an asset (NFT) to the Hive under certain category
	 *
	 * @param asset an NFT (ERC721 address, ERC721 ID)
	 * @param hiveId ID of the hive to join
	 * @param categoryId asset category ID within the Hive
	 */
	function linkAsset(TradeableShares.SharesSubject calldata asset, uint16 hiveId, uint16 categoryId) external;

	/**
	 * @notice Unlinks an asset (NFT) from the Hive
	 *
	 * @param asset an NFT (ERC721 address, ERC721 ID)
	 */
	function unlinkAsset(TradeableShares.SharesSubject calldata asset) external;

	/**
	 * @notice Sets ERC20 Hive economy token address; can be done only once
	 *
	 * @param hiveId Hive ID
	 * @param tokenAddress ERC20 token address to set
	 */
	function setHiveTokenAddress(uint256 hiveId, address tokenAddress) external;

	/**
	 * @notice Updates Hive URI
	 *
	 * @param hiveId Hive ID
	 * @param hiveURI Hive URI
	 */
	function updateHiveURI(uint256 hiveId, string calldata hiveURI) external;

	/**
	 * @notice Add global category and assign it an index
	 *
	 * @param categoryName category name
	 * @param allowedCollection nft collection linking permitted within specific category.
	 *      If allowedCollection is ZERO_ADDRESS, any NFT collection may
	 *      link within that category.
	 */
	function addCategory(string calldata categoryName, address allowedCollection) external;

	/**
	 * @notice Whitelists the AI Pods, that is marks podIds as level 5 pods,
	 *      meaning these pods become capable of launching Hives
	 *
	 * @param podIds array of level 5 AI Pod IDs
	 */
	function whitelistPods(uint256[] calldata podIds) external;

	/**
	 * @notice Blacklists the AI Pods
	 *
	 * @param podIds array of AI Pod IDs do delist
	 */
	function delistPods(uint256[] calldata podIds) external;

	/**
	 * @notice Checks whether the give AI Pod is whitelisted, that is a Level 5
	 *      pod capable of creating a Hive (or already having a Hive)
	 *
	 * @param podId AI Pod ID to query
	 */
	function isPodWhitelisted(uint256 podId) external view returns (bool);

	/**
	 * @notice Gets the info of the linked asset, the hiveID and categoryId where it is linked to
	 *
	 * @dev Zero return values indicate the asset is not linked
	 *
	 * @param asset an NFT (ERC721 address, ERC721 ID)
	 * @return hiveId Hive ID where asset is linked to, zero if it is not linked
	 * @return categoryId category ID where the asset is registered within a Hive, or zero if not linked
	 * @return categoryName category where the asset is registered within a Hive in string value
	 */
	function getLinkedAssetDetails(TradeableShares.SharesSubject calldata asset) external view returns (
		uint256 hiveId,
		uint256 categoryId,
		string memory categoryName
	);

	/**
	 * @notice Checks whether asset is linked to any Hive
	 *
	 * @param asset an NFT (ERC721 address, ERC721 ID)
	 * @return true if asset is linked, false otherwise
	 */
	function isAssetLinked(TradeableShares.SharesSubject calldata asset) external view returns (bool);

	/**
	 * @notice How many assets are linked with the given Hive
	 *
	 * @param hiveId Hive ID to query
	 * @return number of assets linked with the Hive
	 */
	function getNumOfAssetsLinkedWithHive(uint16 hiveId) external view returns (uint256);

	/**
	 * @notice How many assets are linked with the given Hive in the give category
	 *
	 * @param hiveId Hive ID to query
	 * @param categoryId category ID (index)
	 * @return number of assets linked with the Hive
	 */
	function getNumOfAssetsLinkedWithHive(uint16 hiveId, uint16 categoryId) external view returns (uint256);

	/**
	 * @notice Resolve category ID (index) by its name
	 *
	 * @param categoryName category name
	 * @return category ID (index)
	 */
	function getCategoryIndex(string calldata categoryName) external view returns (uint16);

	/**
	 * @notice Resolve Hive ID where the given asset is linked; an asset can also be an AI Pod
	 *      which created the Hive
	 *
	 * @param podId AI Pod ID
	 * @return Hive ID
	 */
	function getHiveId(uint256 podId) external view returns (uint256);

	/**
	 * @notice Finds which AI Pod created the Hive
	 *
	 * @param hiveId ID of the Hive to query for
	 * @return AI-pod (ERC721 address, ERC721 ID)
	 */
	function getHiveCreatorPod(uint256 hiveId) external view returns (TradeableShares.SharesSubject memory);

	/**
	 * @notice Finds the URI of the given Hive
	 *
	 * @param hiveId ID of the Hive to query for
	 * @return Hive URL
	 */
	function getHiveURI(uint16 hiveId) external view returns (string memory);

	/**
	 * @notice Finds the economy ERC20 token address assigned to the Hive
	 *
	 * @param hiveId ID of the Hive to query for
	 * @return address of the ERC20 token representing the economy of the Hive
	 */
	function getHiveToken(uint256 hiveId) external view returns (address);

	/**
	 * @notice Finds the all details associated with Hive
	 *
	 * @param hiveId ID of the Hive to query for
	 * @return pod AI-Pod details asossiated with hive
	 * @return hiveOwner owner of AI-Pod cum hive
	 * @return hiveToken address of the ERC20 token representing the economy of the Hive
	 * @return hiveUri Hive metadata URL
	 */
	function getHiveDetails(uint16 hiveId) external view returns (TradeableShares.SharesSubject memory pod, address hiveOwner, address hiveToken, string memory hiveUri);

	/**
	 * @notice Total number of Hives registered within the registry
	 *
	 * @return Total number of Hives
	 */
	function getNumOfHives() external view returns (uint256);

	/**
	 * @notice Total number of asset categories known to the Hives
	 *
	 * @return Total number of categories
	 */
	function getNumOfGlobalCategories() external view returns (uint256);

	/**
	 * @notice Gets current (unused) nonce for the given client address;
	 *      unused nonce is required to build the RegisterDPTRequest and sign it
	 *      nonces increment by one after each use
	 *
	 * @param client the client address to get the nonce for
	 * @return current (unused) nonce; incremented by one after
	 *      each successful execution of the `registerDPTRequest` function
	 */
	function getNonce(address client) external view returns(uint256);

	/**
	 * @notice Checks whether a DPT is already registered.
	 *
	 * @param _dpt The TradeableShares.SharesSubject struct representing the DPT.
	 * @return True if the DPT is registered, false otherwise.
	 */
	function isDPTRegistered(TradeableShares.SharesSubject calldata _dpt) external view returns(bool);
}


// File contracts/interfaces/ERC721Spec.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title ERC-721 Non-Fungible Token Standard
 *
 * @notice See https://eips.ethereum.org/EIPS/eip-721
 *
 * @dev Solidity issue #3412: The ERC721 interfaces include explicit mutability guarantees for each function.
 *      Mutability guarantees are, in order weak to strong: payable, implicit nonpayable, view, and pure.
 *      Implementation MUST meet the mutability guarantee in this interface and MAY meet a stronger guarantee.
 *      For example, a payable function in this interface may be implemented as nonpayable
 *      (no state mutability specified) in implementing contract.
 *      It is expected a later Solidity release will allow stricter contract to inherit from this interface,
 *      but current workaround is that we edit this interface to add stricter mutability before inheriting:
 *      we have removed all "payable" modifiers.
 *
 * @dev The ERC-165 identifier for this interface is 0x80ac58cd.
 *
 * @author William Entriken, Dieter Shirley, Jacob Evans, Nastassia Sachs
 */
interface ERC721 is ERC165 {
	/// @dev This emits when ownership of any NFT changes by any mechanism.
	///  This event emits when NFTs are created (`from` == 0) and destroyed
	///  (`to` == 0). Exception: during contract creation, any number of NFTs
	///  may be created and assigned without emitting Transfer. At the time of
	///  any transfer, the approved address for that NFT (if any) is reset to none.
	event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

	/// @dev This emits when the approved address for an NFT is changed or
	///  reaffirmed. The zero address indicates there is no approved address.
	///  When a Transfer event emits, this also indicates that the approved
	///  address for that NFT (if any) is reset to none.
	event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

	/// @dev This emits when an operator is enabled or disabled for an owner.
	///  The operator can manage all NFTs of the owner.
	event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

	/// @notice Count all NFTs assigned to an owner
	/// @dev NFTs assigned to the zero address are considered invalid, and this
	///  function throws for queries about the zero address.
	/// @param _owner An address for whom to query the balance
	/// @return The number of NFTs owned by `_owner`, possibly zero
	function balanceOf(address _owner) external view returns (uint256);

	/// @notice Find the owner of an NFT
	/// @dev NFTs assigned to zero address are considered invalid, and queries
	///  about them do throw.
	/// @param _tokenId The identifier for an NFT
	/// @return The address of the owner of the NFT
	function ownerOf(uint256 _tokenId) external view returns (address);

	/// @notice Transfers the ownership of an NFT from one address to another address
	/// @dev Throws unless `msg.sender` is the current owner, an authorized
	///  operator, or the approved address for this NFT. Throws if `_from` is
	///  not the current owner. Throws if `_to` is the zero address. Throws if
	///  `_tokenId` is not a valid NFT. When transfer is complete, this function
	///  checks if `_to` is a smart contract (code size > 0). If so, it calls
	///  `onERC721Received` on `_to` and throws if the return value is not
	///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
	/// @param _from The current owner of the NFT
	/// @param _to The new owner
	/// @param _tokenId The NFT to transfer
	/// @param _data Additional data with no specified format, sent in call to `_to`
	function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata _data) external /*payable*/;

	/// @notice Transfers the ownership of an NFT from one address to another address
	/// @dev This works identically to the other function with an extra data parameter,
	///  except this function just sets data to "".
	/// @param _from The current owner of the NFT
	/// @param _to The new owner
	/// @param _tokenId The NFT to transfer
	function safeTransferFrom(address _from, address _to, uint256 _tokenId) external /*payable*/;

	/// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
	///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
	///  THEY MAY BE PERMANENTLY LOST
	/// @dev Throws unless `msg.sender` is the current owner, an authorized
	///  operator, or the approved address for this NFT. Throws if `_from` is
	///  not the current owner. Throws if `_to` is the zero address. Throws if
	///  `_tokenId` is not a valid NFT.
	/// @param _from The current owner of the NFT
	/// @param _to The new owner
	/// @param _tokenId The NFT to transfer
	function transferFrom(address _from, address _to, uint256 _tokenId) external /*payable*/;

	/// @notice Change or reaffirm the approved address for an NFT
	/// @dev The zero address indicates there is no approved address.
	///  Throws unless `msg.sender` is the current NFT owner, or an authorized
	///  operator of the current owner.
	/// @param _approved The new approved NFT controller
	/// @param _tokenId The NFT to approve
	function approve(address _approved, uint256 _tokenId) external /*payable*/;

	/// @notice Enable or disable approval for a third party ("operator") to manage
	///  all of `msg.sender`'s assets
	/// @dev Emits the ApprovalForAll event. The contract MUST allow
	///  multiple operators per owner.
	/// @param _operator Address to add to the set of authorized operators
	/// @param _approved True if the operator is approved, false to revoke approval
	function setApprovalForAll(address _operator, bool _approved) external;

	/// @notice Get the approved address for a single NFT
	/// @dev Throws if `_tokenId` is not a valid NFT.
	/// @param _tokenId The NFT to find the approved address for
	/// @return The approved address for this NFT, or the zero address if there is none
	function getApproved(uint256 _tokenId) external view returns (address);

	/// @notice Query if an address is an authorized operator for another address
	/// @param _owner The address that owns the NFTs
	/// @param _operator The address that acts on behalf of the owner
	/// @return True if `_operator` is an approved operator for `_owner`, false otherwise
	function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

/// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
interface ERC721TokenReceiver {
	/// @notice Handle the receipt of an NFT
	/// @dev The ERC721 smart contract calls this function on the recipient
	///  after a `transfer`. This function MAY throw to revert and reject the
	///  transfer. Return of other than the magic value MUST result in the
	///  transaction being reverted.
	///  Note: the contract address is always the message sender.
	/// @param _operator The address which called `safeTransferFrom` function
	/// @param _from The address which previously owned the token
	/// @param _tokenId The NFT identifier which is being transferred
	/// @param _data Additional data with no specified format
	/// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
	///  unless throwing
	function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes calldata _data) external returns(bytes4);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 *
 * @notice See https://eips.ethereum.org/EIPS/eip-721
 *
 * @dev The ERC-165 identifier for this interface is 0x5b5e139f.
 *
 * @author William Entriken, Dieter Shirley, Jacob Evans, Nastassia Sachs
 */
interface ERC721Metadata is ERC721 {
	/// @notice A descriptive name for a collection of NFTs in this contract
	function name() external view returns (string memory _name);

	/// @notice An abbreviated name for NFTs in this contract
	function symbol() external view returns (string memory _symbol);

	/// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
	/// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
	///  3986. The URI may point to a JSON file that conforms to the "ERC721
	///  Metadata JSON Schema".
	function tokenURI(uint256 _tokenId) external view returns (string memory);
}

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 *
 * @notice See https://eips.ethereum.org/EIPS/eip-721
 *
 * @dev The ERC-165 identifier for this interface is 0x780e9d63.
 *
 * @author William Entriken, Dieter Shirley, Jacob Evans, Nastassia Sachs
 */
interface ERC721Enumerable is ERC721 {
	/// @notice Count NFTs tracked by this contract
	/// @return A count of valid NFTs tracked by this contract, where each one of
	///  them has an assigned and queryable owner not equal to the zero address
	function totalSupply() external view returns (uint256);

	/// @notice Enumerate valid NFTs
	/// @dev Throws if `_index` >= `totalSupply()`.
	/// @param _index A counter less than `totalSupply()`
	/// @return The token identifier for the `_index`th NFT,
	///  (sort order not specified)
	function tokenByIndex(uint256 _index) external view returns (uint256);

	/// @notice Enumerate NFTs assigned to an owner
	/// @dev Throws if `_index` >= `balanceOf(_owner)` or if
	///  `_owner` is the zero address, representing invalid NFTs.
	/// @param _owner An address where we are interested in NFTs owned by them
	/// @param _index A counter less than `balanceOf(_owner)`
	/// @return The token identifier for the `_index`th NFT assigned to `_owner`,
	///   (sort order not specified)
	function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}


// File contracts/interfaces/ERC721SpecExt.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Mintable ERC721
 *
 * @notice Defines mint capabilities for Alethea ERC721 tokens.
 *      This interface should be treated as a definition of what mintable means for ERC721
 *
 * @author Basil Gorin
 */
interface MintableERC721 {
	/**
	 * @notice Checks if specified token exists
	 *
	 * @dev Returns whether the specified token ID has an ownership
	 *      information associated with it
	 *
	 * @param _tokenId ID of the token to query existence for
	 * @return whether the token exists (true - exists, false - doesn't exist)
	 */
	function exists(uint256 _tokenId) external view returns(bool);

	/**
	 * @dev Creates new token with token ID specified
	 *      and assigns an ownership `_to` for this token
	 *
	 * @dev Unsafe: doesn't execute `onERC721Received` on the receiver.
	 *      Prefer the use of `safeMint` instead of `mint`.
	 *
	 * @dev Should have a restricted access handled by the implementation
	 *
	 * @param _to an address to mint token to
	 * @param _tokenId ID of the token to mint
	 */
	function mint(address _to, uint256 _tokenId) external;

	/**
	 * @dev Creates new tokens starting with token ID specified
	 *      and assigns an ownership `_to` for these tokens
	 *
	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
	 *
	 * @dev n must be greater or equal 2: `n > 1`
	 *
	 * @dev Unsafe: doesn't execute `onERC721Received` on the receiver.
	 *      Prefer the use of `safeMintBatch` instead of `mintBatch`.
	 *
	 * @dev Should have a restricted access handled by the implementation
	 *
	 * @param _to an address to mint tokens to
	 * @param _tokenId ID of the first token to mint
	 * @param n how many tokens to mint, sequentially increasing the _tokenId
	 */
	function mintBatch(address _to, uint256 _tokenId, uint256 n) external;

	/**
	 * @dev Creates new token with token ID specified
	 *      and assigns an ownership `_to` for this token
	 *
	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
	 *      `onERC721Received` on `_to` and throws if the return value is not
	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
	 *
	 * @dev Should have a restricted access handled by the implementation
	 *
	 * @param _to an address to mint token to
	 * @param _tokenId ID of the token to mint
	 */
	function safeMint(address _to, uint256 _tokenId) external;

	/**
	 * @dev Creates new token with token ID specified
	 *      and assigns an ownership `_to` for this token
	 *
	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
	 *      `onERC721Received` on `_to` and throws if the return value is not
	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
	 *
	 * @dev Should have a restricted access handled by the implementation
	 *
	 * @param _to an address to mint token to
	 * @param _tokenId ID of the token to mint
	 * @param _data additional data with no specified format, sent in call to `_to`
	 */
	function safeMint(address _to, uint256 _tokenId, bytes memory _data) external;

	/**
	 * @dev Creates new tokens starting with token ID specified
	 *      and assigns an ownership `_to` for these tokens
	 *
	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
	 *
	 * @dev n must be greater or equal 2: `n > 1`
	 *
	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
	 *      `onERC721Received` on `_to` and throws if the return value is not
	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
	 *
	 * @dev Should have a restricted access handled by the implementation
	 *
	 * @param _to an address to mint token to
	 * @param _tokenId ID of the token to mint
	 * @param n how many tokens to mint, sequentially increasing the _tokenId
	 */
	function safeMintBatch(address _to, uint256 _tokenId, uint256 n) external;

	/**
	 * @dev Creates new tokens starting with token ID specified
	 *      and assigns an ownership `_to` for these tokens
	 *
	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
	 *
	 * @dev n must be greater or equal 2: `n > 1`
	 *
	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
	 *      `onERC721Received` on `_to` and throws if the return value is not
	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
	 *
	 * @dev Should have a restricted access handled by the implementation
	 *
	 * @param _to an address to mint token to
	 * @param _tokenId ID of the token to mint
	 * @param n how many tokens to mint, sequentially increasing the _tokenId
	 * @param _data additional data with no specified format, sent in call to `_to`
	 */
	function safeMintBatch(address _to, uint256 _tokenId, uint256 n, bytes memory _data) external;
}

/**
 * @title Alethea Burnable ERC721
 *
 * @notice Defines burn capabilities for Alethea ERC721 tokens.
 *      This interface should be treated as a definition of what burnable means for ERC721
 *
 * @author Basil Gorin
 */
interface BurnableERC721 {
	/**
	 * @notice Destroys the token with token ID specified
	 *
	 * @dev Should be accessible publicly by token owners.
	 *      May have a restricted access handled by the implementation
	 *
	 * @param _tokenId ID of the token to burn
	 */
	function burn(uint256 _tokenId) external;
}

/**
 * @title With Base URI
 *
 * @notice A marker interface for the contracts having the baseURI() function
 *      or public string variable named baseURI
 *      NFT implementations like TinyERC721, or ShortERC721 are example of such smart contracts
 *
 * @author Basil Gorin
 */
interface WithBaseURI {
	/**
	 * @dev Usually used in NFT implementations to construct ERC721Metadata.tokenURI as
	 *      `base URI + token ID` if token URI is not set (not present in `_tokenURIs` mapping)
	 *
	 * @dev For example, if base URI is https://api.com/token/, then token #1
	 *      will have an URI https://api.com/token/1
	 */
	function baseURI() external view returns(string memory);
}


// File contracts/bonding_curves/SharesSubjectLib.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;



/**
 * @title Shares Subject Library
 *
 * @notice Auxiliary functions to work with SharesSubject struct
 */
library SharesSubjectLib {
	/**
	 * @notice Determines current owner of the shares subject, which is a corresponding NFT owner
	 *
	 * @dev This function returns zero address if NFT doesn't exist, or even if NFT contract doesn't exist
	 *
	 * @param sharesSubject shares subject, owner of the curve
	 * @return address of the issuer, underlying NFT owner; or zero address
	 */
	function getSharesIssuer(TradeableShares.SharesSubject memory sharesSubject) internal view returns(address) {
		// we have to check if the address is callable, otherwise staticall would throw
		if(isCallable(sharesSubject.tokenAddress)) {
			// try to avoid an exception / failed call in the ownerOf function by checking NFT existence first
			// this is required *only* to avoid "partially failed" transaction display on etherscan
			{
				// we use staticcall instead of ABI function call to guaranty immutable call
				(bool success, bytes memory data) = sharesSubject.tokenAddress.staticcall{gas: 4900}(
					// MintableERC721 interface: function exists(uint256) external view returns(bool)
					abi.encodeWithSelector(MintableERC721.exists.selector, sharesSubject.tokenId)
				);
				// only if the call was successful
				if(success) {
					// try to decode the result as a bool,
					// and if we know for sure token doesn't exist,
					if(!abi.decode(data, (bool))) {
						// just return zero address as a default result in case of any error
						return address(0);
					}
				}
			}

			// try to get the ERC721 owner of the underlying NFT
			{
				// we use staticcall instead of ABI function call to guaranty immutable call
				(bool success, bytes memory data) = sharesSubject.tokenAddress.staticcall{gas: 4900}(
					// ERC721 interface: function ownerOf(uint256) external view returns(address)
					abi.encodeWithSelector(ERC721.ownerOf.selector, sharesSubject.tokenId)
				);
				// only if the call was successful
				if(success) {
					// try to decode the result as an address and return
					return abi.decode(data, (address));
				}
			}
		}

		// return the default zero address value in case of any errors
		return address(0);
	}

	/**
	 * @notice Determines the owner of the shares subject's underlying NFT collection
	 *
	 * @dev This function returns zero address if the underlying ERC721 contract is not OZ ownable
	 *      (doesn't have `owner()` function), doesn't exist, or if any other error occurs
	 *
	 * @param sharesSubject shares subject, owner of the curve
	 * @return address of the NFT collection owner (OZ ownable); or zero address
	 */
	function getCollectionOwner(TradeableShares.SharesSubject memory sharesSubject) internal view returns(address) {
		// we have to check if the address is callable, otherwise staticall would throw
		if(isCallable(sharesSubject.tokenAddress)) {
			// try to derive the owner via the OZ Ownable interface owner()
			// we use staticcall instead of ABI function call to guaranty immutable call
			(bool success, bytes memory data) = sharesSubject.tokenAddress.staticcall{gas: 4900}(
				// OZ Ownable interface: function owner() external view returns(address)
				abi.encodeWithSelector(Ownable.owner.selector)
			);

			// only if the call was successful
			if(success) {
				// try to decode the result as an address and return
				return abi.decode(data, (address));
			}
		}

		// return the default zero address value in case of any errors
		return address(0);
	}

	/**
	 * @notice Calculates the keccak256 bytes32 key for the shares subject to be used in the mappings
	 *
	 * @param sharesSubject shares subject, owner of the curve
	 * @return keccak256 of the shares subject
	 */
	function getSharesKey(TradeableShares.SharesSubject memory sharesSubject) internal pure returns(bytes32) {
		// delegate to `getSharesKey`
		return getSharesKey(sharesSubject.tokenAddress, sharesSubject.tokenId);
	}

	/**
	 * @notice Calculates the keccak256 bytes32 key for the shares subject to be used in the mappings
	 *
	 * @param tokenAddress shares subject token address (NFT address)
	 * @param tokenId shares subject token ID (NFT ID)
	 * @return keccak256 of the shares subject
	 */
	function getSharesKey(address tokenAddress, uint256 tokenId) internal pure returns(bytes32) {
		// calculate the keccak256 from the concatenated internals of the SharesSubject struct
		return keccak256(abi.encode(tokenAddress, tokenId));
	}

	/**
	 * @notice Checks if two subjects - subject 1 and subject 2 - are equal
	 *      Returns false if any of the subjects is not initialized (have zero ERC721 address)
	 *
	 * @param sharesSubject1 subject 1
	 * @param sharesSubject2 subject 2
	 * @return true if subject 1 and subject 2 are equal
	 */
	function equals(
		TradeableShares.SharesSubject memory sharesSubject1,
		TradeableShares.SharesSubject memory sharesSubject2
	) internal pure returns(bool) {
		return sharesSubject1.tokenAddress != address(0)
			&& sharesSubject1.tokenAddress == sharesSubject2.tokenAddress
			&& sharesSubject1.tokenId == sharesSubject2.tokenId;
	}

	/**
	 * @notice Verifies if the shares subject contains a value; this function is useful
	 *      to check if the value in storage (mapping) was initialized
	 *
	 * @param sharesSubject the shares subject to check
	 * @return true if the subject has a value, false otherwise (zero value)
	 */
	function isZero(TradeableShares.SharesSubject memory sharesSubject) internal pure returns(bool) {
		return sharesSubject.tokenAddress == address(0) && sharesSubject.tokenId == 0;
	}

	/**
	 * @notice Checks if account can be called (is callable, already deployed contract)
	 *
	 * @dev Verifies if the bytecode on the specified address is present
	 *
	 * @param account an address to check
	 * @return true if address denotes already deployed callable contract
	 */
	function isCallable(address account) internal view returns(bool) {
		// This method relies on extcodesize, which returns 0 for contracts in
		// construction, since the code is only stored at the end of the
		// constructor execution.

		uint256 size;
		assembly {
			size := extcodesize(account)
		}
		return size > 0;
	}
}


// File contracts/bonding_curves/SharesFactory.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title Shares Factory
 *
 * @notice Creates/deploys TradeableShares contracts
 *
 * @notice The factory manages protocol fees of the deployed TradeableShares contract:
 *      deployed contracts usually follow the protocol fees set on the factory
 *
 * @dev Based on the friend.tech FriendtechSharesV1.sol
 */
interface SharesFactory {
	/**
	 * @dev Enum of all possible TradeableShares implementations the factory can deploy
	 */
	enum ImplementationType {
		/// @dev ETHShares implementation
		ETH,
		/// @dev ERC20Shares implementation bound to the ERC20 payment token
		ERC20
	}

	/**
	 * @dev Shares deployment request is used to enable the TradeableShares
	 *      deployment with meta-transactions
	 * @dev See `executeDeploymentRequest()`
	 */
	struct SharesDeploymentRequest {
		/// @dev TradeableShares implementation type
		ImplementationType implementationType;
		/// @dev shares subject, owner of the curve
		TradeableShares.SharesSubject sharesSubject;
		/// @dev an address to mint the NFT defined by the subject if it doesn't exist
		address issuer;
		/// @dev how many shares to buy immediately after the deployment
		uint256 amount;
		/// @dev unix timestamp when the request becomes valid
		uint256 validFromTimestamp;
		/// @dev unix timestamp when the request expires (becomes invalid)
		uint256 expiresAtTimestamp;
		/// @dev nonce of the request (sequential number, increased by one)
		uint256 nonce;
	}

	/**
	 * @dev Fired in
	 *      `setProtocolFeeDestination`
	 *      `setProtocolFeePercent`
	 *      `setHoldersFeePercent`
	 *      `setSubjectFeePercent`
	 *      `setProtocolFee`
	 *
	 * @param protocolFeeDestination address where the protocol fee is sent
	 * @param protocolFeePercent protocol fee percent, value 10^18 corresponds to 100%
	 * @param holdersFeePercent shares holders fee percent, value 10^18 corresponds to 100%
	 * @param subjectFeePercent subject fee percent, value 10^18 corresponds to 100%
	 */
	event ProtocolFeeUpdated(
		address protocolFeeDestination,
		uint64 protocolFeePercent,
		uint64 holdersFeePercent,
		uint64 subjectFeePercent
	);

	/**
	 * @dev Fired in `deploySharesContract` and `registerSharesContract`
	 *
	 * @param creator shares creator, a.k.a. shares issuer, or current owner
	 * @param implementationContract newly deployed or registered TradeableShares contract
	 * @param holdersRewardsDistributor the shares holders fee destination, HoldersRewardsDistributor contract,
	 *      this can be zero if shares contract is deployed without the shares holders fee distribution
	 * @param implementationType type of the TradeableShares, see ImplementationType
	 * @param sharesSubject current shares subject
	 * @param newDeployment true if the factory deployed this TradeableShares contract,
	 *      false if TradeableShares contract was already deployed and factory just registered it
	 */
	event SharesContractRegistered(
		address indexed creator,
		TradeableShares indexed implementationContract,
		HoldersRewardsDistributor indexed holdersRewardsDistributor,
		ImplementationType implementationType,
		TradeableShares.SharesSubject sharesSubject,
		bool newDeployment
	);

	/**
	 * @dev Fired in `executeDeploymentRequest` and in `rewind`
	 */
	event NonceUsed(address indexed issuer, uint256 nonce);

	/**
	 * @notice Address of the already deployed TradeableShares implementation
	 *      to be used by the factory to deploy the TradeableShares contracts EIP-1167 clones
	 *
	 * @param _implementationType TradeableShares implementation type
	 * @return the address of the already deployed TradeableShares implementation corresponding
	 *      to the given implementation type
	 */
	function getSharesImplAddress(ImplementationType _implementationType) external view returns(address);

	/**
	 * @notice Address of the already deployed HoldersRewardsDistributor implementation
	 *      to be used by the factory to deploy the HoldersRewardsDistributor contracts EIP-1167 clones
	 *
	 * @dev If the HoldersRewardsDistributor implementation is missing, the TradeableShares contract
	 *      can still be deployed, not being attached to the HoldersRewardsDistributor
	 *
	 * @param _implementationType TradeableShares implementation type
	 * @return the address of the already deployed HoldersRewardsDistributor implementation corresponding
	 *      to the given implementation type
	 */
	function getDistributorImplAddress(ImplementationType _implementationType) external view returns(address);

	/**
	 * @notice Protocol fee destination is the address receiving the protocol fee
	 *
	 * @return feeDestination protocol fee destination, address
	 */
	function getProtocolFeeDestination() external view returns(address feeDestination);

	/**
	 * @notice Protocol fee percent is the percentage of the buy/sell transaction volume
	 *      sent to the protocol fee destination
	 *
	 * @dev The value has 18 decimals, 100% is represented as 10^18
	 *
	 * @return feePercent protocol fee percent
	 */
	function getProtocolFeePercent() external view returns(uint256 feePercent);

	/**
	 * @notice Shares holders fee percent is the percentage of the buy/sell transaction volume
	 *      sent to the shares holders rewards distributor contract
	 *
	 * @dev The value has 18 decimals, 100% is represented as 10^18
	 *
	 * @return feePercent shares holders fee percent
	 */
	function getHoldersFeePercent() external view returns(uint256 feePercent);

	/**
	 * @notice Subject fee percent is the percentage of the buy/sell transaction volume
	 *      sent to the subject issuer
	 *
	 * @dev The value has 18 decimals, 100% is represented as 10^18
	 *
	 * @dev Implementation may return different values for different callers,
	 *      for example it can read SharesSubject from the caller TradeableShares contract
	 *      and dynamically determine the subject fee
	 *
	 * @return feePercent subject fee percent
	 */
	function getSubjectFeePercent() external view returns(uint256 feePercent);

	/**
	 * @notice Sets the protocol fee destination
	 *
	 * @dev Implementation must check the consistency of the protocol fee destination and percent
	 *      set by this and `setProtocolFeePercent` functions
	 *
	 * @param feeDestination protocol fee destination to set
	 */
	function setProtocolFeeDestination(address feeDestination) external;

	/**
	 * @notice Sets the protocol fee percent
	 *
	 * @dev Implementation must check the consistency of the protocol fee destination and percent
	 *      set by this and `setProtocolFeeDestination` functions
	 *
	 * @param feePercent protocol fee percent to set, examples: 10^18 is 100%, 10^17 is 10%
	 */
	function setProtocolFeePercent(uint64 feePercent) external;

	/**
	 * @notice Sets the shares holders fee percent
	 *
	 * @param feePercent shares holders fee percent to set, examples: 10^18 is 100%, 10^17 is 10%
	 */
	function setHoldersFeePercent(uint64 feePercent) external;

	/**
	 * @notice Sets the subject fee percent
	 *
	 * @param feePercent subject fee percent to set, examples: 10^18 is 100%, 10^17 is 10%
	 */
	function setSubjectFeePercent(uint64 feePercent) external;

	/**
	 * @notice Sets all the fees at once:
	 *      protocolFeeDestination
	 *      protocolFeePercent
	 *      holdersFeePercent
	 *      subjectFeePercent
	 *
	 * @param protocolFeeDestination protocol fee destination to set
	 * @param protocolFeePercent protocol fee percent to set, examples: 10^18 is 100%, 10^17 is 10%
	 * @param holdersFeePercent shares holders fee percent to set, examples: 10^18 is 100%, 10^17 is 10%
	 * @param subjectFeePercent subject fee percent to set, examples: 10^18 is 100%, 10^17 is 10%
	 */
	function setProtocolFee(
		address protocolFeeDestination,
		uint64 protocolFeePercent,
		uint64 holdersFeePercent,
		uint64 subjectFeePercent
	) external;

	/**
	 * @notice Deploys the TradeableShares implementation for the specified subject;
	 *      the curve remains paused, no shares are being bought immediately
	 *
	 * @notice Tries minting the NFT defined by the subject if it doesn't exist
	 *
	 * @dev Implementation must guarantee only one TradeableShares contract per subject
	 *
	 * @param implementationType TradeableShares implementation type
	 * @param sharesSubject shares subject, owner of the curve
	 * @return deployed TradeableShares contract
	 */
	function deploySharesContractPaused(
		ImplementationType implementationType,
		TradeableShares.SharesSubject calldata sharesSubject
	) external returns(TradeableShares);

	/**
	 * @notice Deploys the TradeableShares implementation for the specified subject;
	 *      the curve launches immediately, the first share is issued to the subject issuer (NFT owner)
	 *
	 * @notice Tries minting the NFT defined by the subject if it doesn't exist
	 *
	 * @dev Implementation must guarantee only one TradeableShares contract per subject
	 *
	 * @param implementationType TradeableShares implementation type
	 * @param sharesSubject shares subject, owner of the curve
	 * @return deployed TradeableShares contract
	 */
	function deploySharesContract(
		ImplementationType implementationType,
		TradeableShares.SharesSubject calldata sharesSubject
	) external returns(TradeableShares);

	/**
	 * @notice Deploys the TradeableShares implementation for the specified subject;
	 *      allows to immediately buy any amount of shares (including zero)
	 *
	 * @notice Tries minting the NFT defined by the subject if it doesn't exist
	 *
	 * @dev Implementation must guarantee only one TradeableShares contract per subject
	 *
	 * @param implementationType TradeableShares implementation type
	 * @param sharesSubject shares subject, owner of the curve
	 * @param amount how many shares to buy immediately after the deployment
	 * @return deployed TradeableShares contract
	 */
	function deploySharesContractAndBuy(
		ImplementationType implementationType,
		TradeableShares.SharesSubject calldata sharesSubject,
		uint256 amount
	) external payable returns(TradeableShares);

	/**
	 * @notice Deploys the TradeableShares implementation for the specified subject;
	 *      allows to immediately buy any amount of shares (including zero)
	 *
	 * @notice Tries minting the NFT defined by the subject if it doesn't exist
	 *
	 * @dev Implementation must guarantee only one TradeableShares contract per subject
	 *
	 * @param implementationType TradeableShares implementation type
	 * @param sharesSubject shares subject, owner of the curve
	 * @param issuer an address to mint the NFT defined by the subject if it doesn't exist
	 * @param amount how many shares to buy immediately after the deployment
	 * @return deployed TradeableShares contract
	 */
	function mintSubjectAndDeployShares(
		ImplementationType implementationType,
		TradeableShares.SharesSubject calldata sharesSubject,
		address issuer,
		uint256 amount
	) external payable returns(TradeableShares);

	/**
	 * @notice Executes signed SharesDeploymentRequest; this is identical to executing `mintSubjectAndDeployShares`
	 *      on behalf of the signer and allows the transaction to be relayed so that the gas is payed by the
	 *      relayer
	 *
	 * @param req the deployment request to fulfill, containing same data as in `mintSubjectAndDeployShares`
	 * @param signature the deployment request EIP712 signature issued by the address allowed to execute
	 *      the request
	 * @return deployed TradeableShares contract
	 */
	function executeDeploymentRequest(
		SharesDeploymentRequest calldata req,
		bytes calldata signature
	) external payable returns(TradeableShares);

	/**
	 * @notice Gets current (unused) nonce for the given issuer address;
	 *      unused nonce is required to build the SharesDeploymentRequest and sign it
	 *      nonces increment by one after each use
	 *
	 * @param issuer the issuer address to get the nonce for
	 * @return current (unused) nonce; incremented by one after
	 *      each successful execution of the `executeDeploymentRequest` function
	 */
	function getNonce(address issuer) external view returns(uint256);

	/**
	 * @notice Rewinds forward the nonce for the issuer specified, used to
	 *      discard one or more signed requests to `executeDeploymentRequest`
	 *
	 * @dev Implementation must not allow to decrease the nonce, only increasing (rewinding)
	 *      must be possible
	 *
	 * @param issuer the issuer address to rewind the nonce for
	 * @param nonce the nonce value to rewind to
	 */
	function rewindNonce(address issuer, uint256 nonce) external;

	/**
	 * @notice Gets the already deployed TradeableShares contract
	 *
	 * @param sharesSubject shares subject, owner of the curve
	 * @return deployed TradeableShares contract
	 */
	function lookupSharesContract(
		TradeableShares.SharesSubject calldata sharesSubject
	) external view returns(TradeableShares);

	/**
	 * @notice Registers or re-registers the already deployed TradeableShares contract
	 *
	 * @dev Initial registration is usually done manually by authorized address,
	 *      Re-registration is usually done by the shares contract itself
	 *      and implementations must keep the access to this function open for
	 *      the already registered contracts
	 *
	 * @param shares already deployed TradeableShares contract
	 */
	function registerSharesContract(TradeableShares shares) external;

	/**
	 * @notice Executed only by the previously registered TradeableShares contracts
	 *      to notify the factory about the subject change.
	 *
	 * @dev The factory may throw if the subject is already taken by another contract
	 */
	function notifySubjectUpdated() external;
}


// File contracts/bonding_curves/TypedStructLib.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title EIP712 Typed Struct Library
 *
 * @notice Calculates EIP712 typed structured data typeHash and hashStruct
 */
library TypedStructLib {
	/**
	 * @notice SharesDeploymentRequest typeHash
	 */
	function hashType(SharesFactory.SharesDeploymentRequest calldata) internal pure returns(bytes32) {
		// hashType(SharesDeploymentRequest) = keccak256("SharesDeploymentRequest(ImplementationType implementationType,TradeableShares.SharesSubject sharesSubject,address issuer,uint256 amount,uint256 validFromTimestamp,uint256 expiresAtTimestamp,uint256 nonce)")
		return 0x7acc9d8c19a06f50ae6d92c5e1206302e8aeac9f7f8bf014389ca2a4354650fd;
	}

	/**
	 * @notice SharesSubject typeHash
	 */
	function hashType(TradeableShares.SharesSubject calldata) internal pure returns(bytes32) {
		// hashType(SharesSubject) = keccak256("SharesSubject(address tokenAddress,uint256 tokenId)")
		return 0x685dd8e2693cf377e50b3e95f06b61dff4c1705fa19df1071074d64f4e1469eb;
	}

	/**
	 * @notice SharesDeploymentRequest hashStruct
	 */
	function hashStruct(SharesFactory.SharesDeploymentRequest calldata request) internal pure returns(bytes32) {
		return keccak256(abi.encode(
			hashType(request),
			request.implementationType,
			hashStruct(request.sharesSubject),
			request.issuer,
			request.amount,
			request.validFromTimestamp,
			request.expiresAtTimestamp,
			request.nonce
		));
	}

	/**
	 * @notice SharesSubject hashStruct
	 */
	function hashStruct(TradeableShares.SharesSubject calldata sharesSubject) internal pure returns(bytes32) {
		return keccak256(abi.encode(
			hashType(sharesSubject),
			sharesSubject.tokenAddress,
			sharesSubject.tokenId
		));
	}

}


// File contracts/lib/StringUtils.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title String Utils Library
 *
 * @dev Library for working with strings, primarily converting
 *      between strings and integer types
 *
 * @author Basil Gorin
 */
library StringUtils {
	/**
	 * @dev Converts a string to unsigned integer using the specified `base`
	 * @dev Throws on invalid input
	 *      (wrong characters for a given `base`)
	 * @dev Throws if given `base` is not supported
	 * @param a string to convert
	 * @param base number base, one of 2, 8, 10, 16
	 * @return i a number representing given string
	 */
	function atoi(string memory a, uint8 base) internal pure returns (uint256 i) {
		// check if the base is valid
		require(base == 2 || base == 8 || base == 10 || base == 16);

		// convert string into bytes for convenient iteration
		bytes memory buf = bytes(a);

		// iterate over the string (bytes buffer)
		for(uint256 p = 0; p < buf.length; p++) {
			// extract the digit
			uint8 digit = uint8(buf[p]) - 0x30;

			// if digit is greater then 10 - mind the gap
			// see `itoa` function for more details
			if(digit > 10) {
				// remove the gap
				digit -= 7;
			}

			// check if digit meets the base
			require(digit < base);

			// move to the next digit slot
			i *= base;

			// add digit to the result
			i += digit;
		}

		// return the result
		return i;
	}

	/**
	 * @dev Converts a integer to a string using the specified `base`
	 * @dev Throws if given `base` is not supported
	 * @param i integer to convert
	 * @param base number base, one of 2, 8, 10, 16
	 * @return a a string representing given integer
	 */
	function itoa(uint256 i, uint8 base) internal pure returns (string memory a) {
		// check if the base is valid
		require(base == 2 || base == 8 || base == 10 || base == 16);

		// for zero input the result is "0" string for any base
		if(i == 0) {
			return "0";
		}

		// bytes buffer to put ASCII characters into
		bytes memory buf = new bytes(256);

		// position within a buffer to be used in cycle
		uint256 p = 0;

		// extract digits one by one in a cycle
		while(i > 0) {
			// extract current digit
			uint8 digit = uint8(i % base);

			// convert it to an ASCII code
			// 0x20 is " "
			// 0x30-0x39 is "0"-"9"
			// 0x41-0x5A is "A"-"Z"
			// 0x61-0x7A is "a"-"z" ("A"-"Z" XOR " ")
			uint8 ascii = digit + 0x30;

			// if digit is greater then 10,
			// fix the 0x3A-0x40 gap of punctuation marks
			// (7 characters in ASCII table)
			if(digit >= 10) {
				// jump through the gap
				ascii += 7;
			}

			// write character into the buffer
			buf[p++] = bytes1(ascii);

			// move to the next digit
			i /= base;
		}

		// `p` contains real length of the buffer now,
		// allocate the resulting buffer of that size
		bytes memory result = new bytes(p);

		// copy the buffer in the reversed order
		for(p = 0; p < result.length; p++) {
			// copy from the beginning of the original buffer
			// to the end of resulting smaller buffer
			result[result.length - p - 1] = buf[p];
		}

		// construct string and return
		return string(result);
	}

	/**
	 * @dev Concatenates two strings `s1` and `s2`, for example, if
	 *      `s1` == `foo` and `s2` == `bar`, the result `s` == `foobar`
	 * @param s1 first string
	 * @param s2 second string
	 * @return s concatenation result s1 + s2
	 */
	function concat(string memory s1, string memory s2) internal pure returns (string memory s) {
		// an old way of string concatenation (Solidity 0.4) is commented out
/*
		// convert s1 into buffer 1
		bytes memory buf1 = bytes(s1);
		// convert s2 into buffer 2
		bytes memory buf2 = bytes(s2);
		// create a buffer for concatenation result
		bytes memory buf = new bytes(buf1.length + buf2.length);

		// copy buffer 1 into buffer
		for(uint256 i = 0; i < buf1.length; i++) {
			buf[i] = buf1[i];
		}

		// copy buffer 2 into buffer
		for(uint256 j = buf1.length; j < buf2.length; j++) {
			buf[j] = buf2[j - buf1.length];
		}

		// construct string and return
		return string(buf);
*/

		// simply use built in function
		return string(abi.encodePacked(s1, s2));
	}
}


// File contracts/utils/AccessControl.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity >=0.4.22; // require with message (0.4.22), pure/view modifiers (0.4.16), hardhat (0.4.11)

/**
 * @title Role-based Access Control (RBAC)
 *
 * @notice Access control smart contract provides an API to check
 *      if a specific operation is permitted globally and/or
 *      if a particular user has a permission to execute it.
 *
 * @notice This contract is inherited by other contracts requiring the role-based access control (RBAC)
 *      protection for the restricted access functions
 *
 * @notice It deals with two main entities: features and roles.
 *
 * @notice Features are designed to be used to enable/disable public functions
 *      of the smart contract (used by a wide audience).
 * @notice User roles are designed to control the access to restricted functions
 *      of the smart contract (used by a limited set of maintainers).
 *
 * @notice Terms "role", "permissions" and "set of permissions" have equal meaning
 *      in the documentation text and may be used interchangeably.
 * @notice Terms "permission", "single permission" implies only one permission bit set.
 *
 * @notice Access manager is a special role which allows to grant/revoke other roles.
 *      Access managers can only grant/revoke permissions which they have themselves.
 *      As an example, access manager with no other roles set can only grant/revoke its own
 *      access manager permission and nothing else.
 *
 * @notice Access manager permission should be treated carefully, as a super admin permission:
 *      Access manager with even no other permission can interfere with another account by
 *      granting own access manager permission to it and effectively creating more powerful
 *      permission set than its own.
 *
 * @dev Both current and OpenZeppelin AccessControl implementations feature a similar API
 *      to check/know "who is allowed to do this thing".
 * @dev Zeppelin implementation is more flexible:
 *      - it allows setting unlimited number of roles, while current is limited to 256 different roles
 *      - it allows setting an admin for each role, while current allows having only one global admin
 * @dev Current implementation is more lightweight:
 *      - it uses only 1 bit per role, while Zeppelin uses 256 bits
 *      - it allows setting up to 256 roles at once, in a single transaction, while Zeppelin allows
 *        setting only one role in a single transaction
 *
 * @dev This smart contract is designed to be inherited by other
 *      smart contracts which require access control management capabilities.
 *
 * @dev Access manager permission has a bit 255 set.
 *      This bit must not be used by inheriting contracts for any other permissions/features.
 *
 * @author Basil Gorin
 */
abstract contract AccessControl {
	/**
	 * @dev Privileged addresses with defined roles/permissions
	 * @dev In the context of ERC20/ERC721 tokens these can be permissions to
	 *      allow minting or burning tokens, transferring on behalf and so on
	 *
	 * @dev Maps user address to the permissions bitmask (role), where each bit
	 *      represents a permission
	 * @dev Bitmask 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	 *      represents all possible permissions
	 * @dev 'This' address mapping represents global features of the smart contract
	 *
	 * @dev We keep the mapping private to prevent direct writes to it from the inheriting
	 *      contracts, `getRole()` and `updateRole()` functions should be used instead
	 */
	mapping(address => uint256) internal userRoles; // TODO: restrict to "private"

	/**
	 * @notice Access manager is responsible for assigning the roles to users,
	 *      enabling/disabling global features of the smart contract
	 * @notice Access manager can add, remove and update user roles,
	 *      remove and update global features
	 *
	 * @dev Role ROLE_ACCESS_MANAGER allows modifying user roles and global features
	 * @dev Role ROLE_ACCESS_MANAGER has single bit at position 255 enabled
	 */
	uint256 public constant ROLE_ACCESS_MANAGER = 0x8000000000000000000000000000000000000000000000000000000000000000;

	/**
	 * @dev Bitmask representing all the possible permissions (super admin role)
	 * @dev Has all the bits are enabled (2^256 - 1 value)
	 */
	uint256 internal constant FULL_PRIVILEGES_MASK = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;

	/**
	 * @dev Fired in updateRole() and updateFeatures()
	 *
	 * @param operator address which was granted/revoked permissions
	 * @param requested permissions requested
	 * @param assigned permissions effectively set
	 */
	event RoleUpdated(address indexed operator, uint256 requested, uint256 assigned);

	/**
	 * @notice Function modifier making a function defined as public behave as restricted
	 *      (so that only a pre-configured set of accounts can execute it)
	 *
	 * @param role the role transaction executor is required to have;
	 *      the function throws an "access denied" exception if this condition is not met
	 */
	modifier restrictedTo(uint256 role) {
		// verify the access permission
		require(isSenderInRole(role), "access denied");

		// execute the rest of the function
		_;
	}

	/**
	 * @notice Creates an access control instance, setting the contract owner to have full privileges
	 *
	 * @param _owner smart contract owner having full privileges
	 */
	constructor(address _owner) internal { // visibility modifier is required to be compilable with 0.6.x
		// grant owner full privileges
		__setRole(_owner, FULL_PRIVILEGES_MASK, FULL_PRIVILEGES_MASK);
	}

	/**
	 * @notice Retrieves globally set of features enabled
	 *
	 * @dev Effectively reads userRoles role for the contract itself
	 *
	 * @return 256-bit bitmask of the features enabled
	 */
	function features() public view returns (uint256) {
		// features are stored in 'this' address mapping of `userRoles`
		return getRole(address(this));
	}

	/**
	 * @notice Updates set of the globally enabled features (`features`),
	 *      taking into account sender's permissions
	 *
	 * @dev Requires transaction sender to have `ROLE_ACCESS_MANAGER` permission
	 * @dev Function is left for backward compatibility with older versions
	 *
	 * @param _mask bitmask representing a set of features to enable/disable
	 */
	function updateFeatures(uint256 _mask) public {
		// delegate call to `updateRole`
		updateRole(address(this), _mask);
	}

	/**
	 * @notice Reads the permissions (role) for a given user from the `userRoles` mapping
	 *      (privileged addresses with defined roles/permissions)
	 * @notice In the context of ERC20/ERC721 tokens these can be permissions to
	 *      allow minting or burning tokens, transferring on behalf and so on
	 *
	 * @dev Having a simple getter instead of making the mapping public
	 *      allows enforcing the encapsulation of the mapping and protects from
	 *      writing to it directly in the inheriting smart contracts
	 *
	 * @param operator address of a user to read permissions for,
	 *      or self address to read global features of the smart contract
	 */
	function getRole(address operator) public view returns(uint256) {
		// read the value from `userRoles` and return
		return userRoles[operator];
	}

	/**
	 * @notice Updates set of permissions (role) for a given user,
	 *      taking into account sender's permissions.
	 *
	 * @dev Setting role to zero is equivalent to removing an all permissions
	 * @dev Setting role to `FULL_PRIVILEGES_MASK` is equivalent to
	 *      copying senders' permissions (role) to the user
	 * @dev Requires transaction sender to have `ROLE_ACCESS_MANAGER` permission
	 *
	 * @param operator address of a user to alter permissions for,
	 *       or self address to alter global features of the smart contract
	 * @param role bitmask representing a set of permissions to
	 *      enable/disable for a user specified
	 */
	function updateRole(address operator, uint256 role) public {
		// caller must have a permission to update user roles
		require(isSenderInRole(ROLE_ACCESS_MANAGER), "access denied");

		// evaluate the role and reassign it
		__setRole(operator, role, _evaluateBy(msg.sender, getRole(operator), role));
	}

	/**
	 * @notice Determines the permission bitmask an operator can set on the
	 *      target permission set
	 * @notice Used to calculate the permission bitmask to be set when requested
	 *     in `updateRole` and `updateFeatures` functions
	 *
	 * @dev Calculated based on:
	 *      1) operator's own permission set read from userRoles[operator]
	 *      2) target permission set - what is already set on the target
	 *      3) desired permission set - what do we want set target to
	 *
	 * @dev Corner cases:
	 *      1) Operator is super admin and its permission set is `FULL_PRIVILEGES_MASK`:
	 *        `desired` bitset is returned regardless of the `target` permission set value
	 *        (what operator sets is what they get)
	 *      2) Operator with no permissions (zero bitset):
	 *        `target` bitset is returned regardless of the `desired` value
	 *        (operator has no authority and cannot modify anything)
	 *
	 * @dev Example:
	 *      Consider an operator with the permissions bitmask     00001111
	 *      is about to modify the target permission set          01010101
	 *      Operator wants to set that permission set to          00110011
	 *      Based on their role, an operator has the permissions
	 *      to update only lowest 4 bits on the target, meaning that
	 *      high 4 bits of the target set in this example is left
	 *      unchanged and low 4 bits get changed as desired:      01010011
	 *
	 * @param operator address of the contract operator which is about to set the permissions
	 * @param target input set of permissions to operator is going to modify
	 * @param desired desired set of permissions operator would like to set
	 * @return resulting set of permissions given operator will set
	 */
	function _evaluateBy(address operator, uint256 target, uint256 desired) internal view returns (uint256) {
		// read operator's permissions
		uint256 p = getRole(operator);

		// taking into account operator's permissions,
		// 1) enable the permissions desired on the `target`
		target |= p & desired;
		// 2) disable the permissions desired on the `target`
		target &= FULL_PRIVILEGES_MASK ^ (p & (FULL_PRIVILEGES_MASK ^ desired));

		// return calculated result
		return target;
	}

	/**
	 * @notice Checks if requested set of features is enabled globally on the contract
	 *
	 * @param required set of features to check against
	 * @return true if all the features requested are enabled, false otherwise
	 */
	function isFeatureEnabled(uint256 required) public view returns (bool) {
		// delegate call to `__hasRole`, passing `features` property
		return __hasRole(features(), required);
	}

	/**
	 * @notice Checks if transaction sender `msg.sender` has all the permissions required
	 *
	 * @dev Used in smart contracts only. Off-chain clients should use `isOperatorInRole`.
	 *
	 * @param required set of permissions (role) to check against
	 * @return true if all the permissions requested are enabled, false otherwise
	 */
	function isSenderInRole(uint256 required) public view returns (bool) {
		// delegate call to `isOperatorInRole`, passing transaction sender
		return isOperatorInRole(msg.sender, required);
	}

	/**
	 * @notice Checks if operator has all the permissions (role) required
	 *
	 * @param operator address of the user to check role for
	 * @param required set of permissions (role) to check
	 * @return true if all the permissions requested are enabled, false otherwise
	 */
	function isOperatorInRole(address operator, uint256 required) public view returns (bool) {
		// delegate call to `__hasRole`, passing operator's permissions (role)
		return __hasRole(getRole(operator), required);
	}

	/**
	 * @dev Sets the `assignedRole` role to the operator, logs both `requestedRole` and `actualRole`
	 *
	 * @dev Unsafe:
	 *      provides direct write access to `userRoles` mapping without any security checks,
	 *      doesn't verify the executor (msg.sender) permissions,
	 *      must be kept private at all times
	 *
	 * @param operator address of a user to alter permissions for,
	 *       or self address to alter global features of the smart contract
	 * @param requestedRole bitmask representing a set of permissions requested
	 *      to be enabled/disabled for a user specified, used only to be logged into event
	 * @param assignedRole bitmask representing a set of permissions to
	 *      enable/disable for a user specified, used to update the mapping and to be logged into event
	 */
	function __setRole(address operator, uint256 requestedRole, uint256 assignedRole) private {
		// assign the role to the operator
		userRoles[operator] = assignedRole;

		// fire an event
		emit RoleUpdated(operator, requestedRole, assignedRole);
	}

	/**
	 * @dev Checks if role `actual` contains all the permissions required `required`
	 *
	 * @param actual existent role
	 * @param required required role
	 * @return true if actual has required role (all permissions), false otherwise
	 */
	function __hasRole(uint256 actual, uint256 required) private pure returns (bool) {
		// check the bitmask for the role required and return the result
		return actual & required == required;
	}
}


// File contracts/protocol/IntelligentNFTv2.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;




/**
 * @title Intelligent NFT Interface
 *        Version 2
 *
 * @notice External interface of IntelligentNFTv2 declared to support ERC165 detection.
 *      Despite some similarity with ERC721 interfaces, iNFT is not ERC721, any similarity
 *      should be treated as coincidental. Client applications may benefit from this similarity
 *      to reuse some of the ERC721 client code for display/reading.
 *
 * @dev See Intelligent NFT documentation below.
 *
 * @author Basil Gorin
 */
interface IntelligentNFTv2Spec {
	/**
	 * @dev ERC20/ERC721 like name - Intelligent NFT
	 *
	 * @return "Intelligent NFT"
	 */
	function name() external view returns (string memory);

	/**
	 * @dev ERC20/ERC721 like symbol - iNFT
	 *
	 * @return "iNFT"
	 */
	function symbol() external view returns (string memory);

	/**
	 * @dev ERC721 like link to the iNFT metadata
	 *
	 * @param recordId iNFT ID to get metadata URI for
	 */
	function tokenURI(uint256 recordId) external view returns (string memory);

	/**
	 * @dev ERC20/ERC721 like counter of the iNFTs in existence (upper bound),
	 *      some (or all) of which may not exist due to target NFT destruction
	 *
	 * @return amount of iNFT tracked by this smart contract
	 */
	function totalSupply() external view returns (uint256);

	/**
	 * @dev Check if iNFT binding with the given ID exists
	 *
	 * @return true if iNFT binding exist, false otherwise
	 */
	function exists(uint256 recordId) external view returns (bool);

	/**
	 * @dev ERC721 like function to get owner of the iNFT, which is by definition
	 *      an owner of the underlying NFT
	 */
	function ownerOf(uint256 recordId) external view returns (address);
}

/**
 * @title Intelligent NFT (iNFT)
 *        Version 2
 *
 * @notice Intelligent NFT (iNFT) represents an enhancement to an existing NFT
 *      (we call it a "target" or "target NFT"), it binds a GPT-3 prompt (a "personality prompt",
 *      delivered as a Personality Pod ERC721 token bound to iNFT)
 *      to the target to embed intelligence, is controlled and belongs to the owner of the target.
 *
 * @notice iNFT stores AI Personality and some amount of ALI tokens locked, available for
 *      unlocking when iNFT is destroyed
 *
 * @notice iNFT is not an ERC721 token, but it has some very limited similarity to an ERC721:
 *      every record is identified by ID and this ID has an owner, which is effectively the target NFT owner;
 *      still, it doesn't store ownership information itself and fully relies on the target ownership instead
 *
 * @dev Internally iNFTs consist of:
 *      - target NFT - smart contract address and ID of the NFT the iNFT is bound to
 *      - AI Personality - smart contract address and ID of the AI Personality used to produce given iNFT,
 *        representing a "personality prompt", and locked within an iNFT
 *      - ALI tokens amount - amount of the ALI tokens used to produce given iNFT, also locked
 *
 * @dev iNFTs can be
 *      - created, this process requires an AI Personality and ALI tokens to be locked
 *      - destroyed, this process releases an AI Personality and ALI tokens previously locked
 *
 * @author Basil Gorin
 */
contract IntelligentNFTv2 is IntelligentNFTv2Spec, AccessControl, ERC165 {
	/**
	 * @inheritdoc IntelligentNFTv2Spec
	 */
	string public override name = "Intelligent NFT";

	/**
	 * @inheritdoc IntelligentNFTv2Spec
	 */
	string public override symbol = "iNFT";

	/**
	 * @dev Each intelligent token, represented by its unique ID, is bound to the target NFT,
	 *      defined by the pair of the target NFT smart contract address and unique token ID
	 *      within the target NFT smart contract
	 *
	 * @dev Effectively iNFT is owned by the target NFT owner
	 *
	 * @dev Additionally, each token holds an AI Personality and some amount of ALI tokens bound to it
	 *
	 * @dev `IntelliBinding` keeps all the binding information, including target NFT coordinates,
	 *      bound AI Personality ID, and amount of ALI ERC20 tokens bound to the iNFT
	 */
	struct IntelliBinding {
		// Note: structure members are reordered to fit into less memory slots, see EVM memory layout
		// ----- SLOT.1 (256/256)
		/**
		 * @dev Specific AI Personality is defined by the pair of AI Personality smart contract address
		 *       and AI Personality ID
		 *
		 * @dev Address of the AI Personality smart contract
		 */
		address personalityContract;

		/**
		 * @dev AI Personality ID within the AI Personality smart contract
		 */
		uint96 personalityId;

		// ----- SLOT.2 (256/256)
		/**
		 * @dev Amount of an ALI ERC20 tokens bound to (owned by) the iNFTs
		 *
		 * @dev ALI ERC20 smart contract address is defined globally as `aliContract` constant
		 */
		uint96 aliValue;

		/**
		 * @dev Address of the target NFT deployed smart contract,
		 *      this is a contract a particular iNFT is bound to
		 */
		address targetContract;

		// ----- SLOT.3 (256/256)
		/**
		 * @dev Target NFT ID within the target NFT smart contract,
		 *      effectively target NFT ID and contract address define the owner of an iNFT
		 */
		uint256 targetId;
	}

	/**
	 * @notice iNFT binding storage, stores binding information for each existing iNFT
	 * @dev Maps iNFT ID to its binding data, which includes underlying NFT data
	 */
	mapping(uint256 => IntelliBinding) public bindings;

	/**
	 * @notice Reverse iNFT binding allows to find iNFT bound to a particular NFT
	 * @dev Maps target NFT (smart contract address and unique token ID) to the iNFT ID:
	 *      NFT Contract => NFT ID => iNFT ID
	 */
	mapping(address => mapping(uint256 => uint256)) public reverseBindings;

	/**
	 * @notice Ai Personality to iNFT binding allows to find iNFT bound to a particular Ai Personality
	 * @dev Maps Ai Personality NFT (unique token ID) to the linked iNFT:
	 *      AI Personality Contract => AI Personality ID => iNFT ID
	 */
	mapping(address => mapping(uint256 => uint256)) public personalityBindings;

	/**
	 * @notice Total amount (maximum value estimate) of iNFT in existence.
	 *       This value can be higher than number of effectively accessible iNFTs
	 *       since when underlying NFT gets burned this value doesn't get updated.
	 */
	uint256 public override totalSupply;

	/**
	 * @notice Each iNFT holds some ALI tokens, which are tracked by the ALI token ERC20 smart contract defined here
	 */
	address public immutable aliContract;

	/**
	 * @notice ALI token balance the contract is aware of, cumulative ALI obligation,
	 *      i.e. sum of all iNFT locked ALI balances
	 *
	 * @dev Sum of all `IntelliBinding.aliValue` for each iNFT in existence
	 */
	uint256 public aliBalance;

	/**
	 * @dev Base URI is used to construct ERC721Metadata.tokenURI as
	 *      `base URI + token ID` if token URI is not set (not present in `_tokenURIs` mapping)
	 *
	 * @dev For example, if base URI is https://api.com/token/, then token #1
	 *      will have an URI https://api.com/token/1
	 *
	 * @dev If token URI is set with `setTokenURI()` it will be returned as is via `tokenURI()`
	 */
	string public baseURI = "";

	/**
	 * @dev Optional mapping for token URIs to be returned as is when `tokenURI()`
	 *      is called; if mapping doesn't exist for token, the URI is constructed
	 *      as `base URI + token ID`, where plus (+) denotes string concatenation
	 */
	mapping(uint256 => string) internal _tokenURIs;

	/**
	 * @notice Minter is responsible for creating (minting) iNFTs
	 *
	 * @dev Role ROLE_MINTER allows minting iNFTs (calling `mint` function)
	 */
	uint32 public constant ROLE_MINTER = 0x0001_0000;

	/**
	 * @notice Burner is responsible for destroying (burning) iNFTs
	 *
	 * @dev Role ROLE_BURNER allows burning iNFTs (calling `burn` function)
	 */
	uint32 public constant ROLE_BURNER = 0x0002_0000;

	/**
	 * @notice Editor is responsible for editing (updating) iNFT records in general,
	 *      adding/removing locked ALI tokens to/from iNFT in particular
	 *
	 * @dev Role ROLE_EDITOR allows editing iNFTs (calling `increaseAli`, `decreaseAli` functions)
	 */
	uint32 public constant ROLE_EDITOR = 0x0004_0000;

	/**
	 * @notice URI manager is responsible for managing base URI
	 *      part of the token URI ERC721Metadata interface
	 *
	 * @dev Role ROLE_URI_MANAGER allows updating the base URI
	 *      (executing `setBaseURI` function)
	 */
	uint32 public constant ROLE_URI_MANAGER = 0x0010_0000;

	/**
	 * @dev Fired in setBaseURI()
	 *
	 * @param _by an address which executed update
	 * @param _oldVal old _baseURI value
	 * @param _newVal new _baseURI value
	 */
	event BaseURIUpdated(address indexed _by, string _oldVal, string _newVal);

	/**
	 * @dev Fired in setTokenURI()
	 *
	 * @param _by an address which executed update
	 * @param _tokenId token ID which URI was updated
	 * @param _oldVal old _baseURI value
	 * @param _newVal new _baseURI value
	 */
	event TokenURIUpdated(address indexed _by, uint256 indexed _tokenId, string _oldVal, string _newVal);

	/**
	 * @dev Fired in mint() when new iNFT is created
	 *
	 * @param _by an address which executed the mint function
	 * @param _owner current owner of the NFT
	 * @param _recordId ID of the iNFT minted (created, bound)
	 * @param _aliValue amount of ALI tokens locked within newly created iNFT
	 * @param _personalityContract AI Personality smart contract address
	 * @param _personalityId ID of the AI Personality locked within newly created iNFT
	 * @param _targetContract target NFT smart contract address
	 * @param _targetId target NFT ID (where this iNFT binds to and belongs to)
	 */
	event Minted(
		address indexed _by,
		address indexed _owner,
		uint256 indexed _recordId,
		uint96 _aliValue,
		address _personalityContract,
		uint96 _personalityId,
		address _targetContract,
		uint256 _targetId
	);

	/**
	 * @dev Fired in increaseAli() and decreaseAli() when iNFT record is updated
	 *
	 * @param _by an address which executed the update
	 * @param _owner iNFT (target NFT) owner
	 * @param _recordId ID of the updated iNFT
	 * @param _oldAliValue amount of ALI tokens locked within iNFT before update
	 * @param _newAliValue amount of ALI tokens locked within iNFT after update
	 */
	event Updated(
		address indexed _by,
		address indexed _owner,
		uint256 indexed _recordId,
		uint96 _oldAliValue,
		uint96 _newAliValue
	);

	/**
	 * @dev Fired in burn() when an existing iNFT gets destroyed
	 *
	 * @param _by an address which executed the burn function
	 * @param _recordId ID of the iNFT burnt (destroyed, unbound)
	 * @param _recipient and address which received unlocked AI Personality and ALI tokens
	 * @param _aliValue amount of ALI tokens transferred from the destroyed iNFT
	 * @param _personalityContract AI Personality smart contract address
	 * @param _personalityId ID of the AI Personality transferred from the destroyed iNFT
	 * @param _targetContract target NFT smart contract
	 * @param _targetId target NFT ID (where this iNFT was bound to and belonged to)
	 */
	event Burnt(
		address indexed _by,
		uint256 indexed _recordId,
		address indexed _recipient,
		uint96 _aliValue,
		address _personalityContract,
		uint96 _personalityId,
		address _targetContract,
		uint256 _targetId
	);

	/**
	 * @dev Creates/deploys an iNFT instance bound to already deployed ALI token instance
	 *
	 * @param _ali address of the deployed ALI ERC20 Token instance the iNFT is bound to
	 */
	constructor(address _ali) AccessControl(msg.sender) {
		// verify the inputs are set
		require(_ali != address(0), "ALI Token addr is not set");

		// verify _ali is a valid ERC20
		require(ERC165(_ali).supportsInterface(type(ERC20).interfaceId), "unexpected ALI Token type");

		// setup smart contract internal state
		aliContract = _ali;
	}

	/**
	 * @inheritdoc ERC165
	 */
	function supportsInterface(bytes4 interfaceId) public pure override returns (bool) {
		// reconstruct from current interface and super interface
		return interfaceId == type(IntelligentNFTv2Spec).interfaceId;
	}

	/**
	 * @dev Restricted access function which updates base URI used to construct
	 *      ERC721Metadata.tokenURI
	 *
	 * @param _baseURI new base URI to set
	 */
	function setBaseURI(string memory _baseURI) public virtual {
		// verify the access permission
		require(isSenderInRole(ROLE_URI_MANAGER), "access denied");

		// emit an event first - to log both old and new values
		emit BaseURIUpdated(msg.sender, baseURI, _baseURI);

		// and update base URI
		baseURI = _baseURI;
	}

	/**
	 * @dev Returns token URI if it was previously set with `setTokenURI`,
	 *      otherwise constructs it as base URI + token ID
	 *
	 * @param _recordId iNFT ID to query metadata link URI for
	 * @return URI link to fetch iNFT metadata from
	 */
	function tokenURI(uint256 _recordId) public view override returns (string memory) {
		// verify token exists
		require(exists(_recordId), "iNFT doesn't exist");

		// read the token URI for the token specified
		string memory _tokenURI = _tokenURIs[_recordId];

		// if token URI is set
		if(bytes(_tokenURI).length > 0) {
			// just return it
			return _tokenURI;
		}

		// if base URI is not set
		if(bytes(baseURI).length == 0) {
			// return an empty string
			return "";
		}

		// otherwise concatenate base URI + token ID
		return StringUtils.concat(baseURI, StringUtils.itoa(_recordId, 10));
	}

	/**
	 * @dev Sets the token URI for the token defined by its ID
	 *
	 * @param _tokenId an ID of the token to set URI for
	 * @param _tokenURI token URI to set
	 */
	function setTokenURI(uint256 _tokenId, string memory _tokenURI) public virtual {
		// verify the access permission
		require(isSenderInRole(ROLE_URI_MANAGER), "access denied");

		// we do not verify token existence: we want to be able to
		// preallocate token URIs before tokens are actually minted

		// emit an event first - to log both old and new values
		emit TokenURIUpdated(msg.sender, _tokenId, _tokenURIs[_tokenId], _tokenURI);

		// and update token URI
		_tokenURIs[_tokenId] = _tokenURI;
	}

	/**
	 * @notice Verifies if given iNFT exists
	 *
	 * @param recordId iNFT ID to verify existence of
	 * @return true if iNFT exists, false otherwise
	 */
	function exists(uint256 recordId) public view override returns (bool) {
		// verify if biding exists for that tokenId and return the result
		return bindings[recordId].targetContract != address(0);
	}

	/**
	 * @notice Returns an owner of the given iNFT.
	 *      By definition iNFT owner is an owner of the target NFT
	 *
	 * @param recordId iNFT ID to query ownership information for
	 * @return address of the given iNFT owner
	 */
	function ownerOf(uint256 recordId) public view override returns (address) {
		// get the link to the token binding (we need to access only one field)
		IntelliBinding storage binding = bindings[recordId];

		// verify the binding exists and throw standard Zeppelin message if not
		require(binding.targetContract != address(0), "iNFT doesn't exist");

		// delegate `ownerOf` call to the target NFT smart contract
		return ERC721(binding.targetContract).ownerOf(binding.targetId);
	}

	/**
	 * @dev Restricted access function which creates an iNFT, binding it to the specified
	 *      NFT, locking the AI Personality specified, and funded with the amount of ALI specified
	 *
	 * @dev Locks AI Personality defined by its ID within iNFT smart contract;
	 *      AI Personality must be transferred to the iNFT smart contract
	 *      prior to calling the `mint`, but in the same transaction with `mint`
	 *
	 * @dev Locks specified amount of ALI token within iNFT smart contract;
	 *      ALI token amount must be transferred to the iNFT smart contract
	 *      prior to calling the `mint`, but in the same transaction with `mint`
	 *
	 * @dev To summarize, minting transaction (a transaction which executes `mint`) must
	 *      1) transfer AI Personality
	 *      2) transfer ALI tokens if they are to be locked
	 *      3) mint iNFT
	 *      NOTE: breaking the items above into multiple transactions is not acceptable!
	 *            (results in a security risk)
	 *
	 * @dev The NFT to be linked to is not required to owned by the funder, but it must exist;
	 *      throws if target NFT doesn't exist
	 *
	 * @dev This is a restricted function which is accessed by iNFT Linker
	 *
	 * @param recordId ID of the iNFT to mint (create, bind)
	 * @param aliValue amount of ALI tokens to bind to newly created iNFT
	 * @param personalityContract AI Personality contract address
	 * @param personalityId ID of the AI Personality to bind to newly created iNFT
	 * @param targetContract target NFT smart contract
	 * @param targetId target NFT ID (where this iNFT binds to and belongs to)
	 */
	function mint(
		uint256 recordId,
		uint96 aliValue,
		address personalityContract,
		uint96 personalityId,
		address targetContract,
		uint256 targetId
	) public {
		// verify the access permission
		require(isSenderInRole(ROLE_MINTER), "access denied");

		// verify personalityContract is a valid ERC721
		require(ERC165(personalityContract).supportsInterface(type(ERC721).interfaceId), "personality is not ERC721");

		// verify targetContract is a valid ERC721
		require(ERC165(targetContract).supportsInterface(type(ERC721).interfaceId), "target NFT is not ERC721");

		// verify this iNFT is not yet minted
		require(!exists(recordId), "iNFT already exists");

		// verify target NFT is not yet bound to
		require(reverseBindings[targetContract][targetId] == 0, "NFT is already bound");

		// verify AI Personality is not yet locked
		require(personalityBindings[personalityContract][personalityId] == 0, "personality already linked");

		// verify if AI Personality is already transferred to iNFT
		require(ERC721(personalityContract).ownerOf(personalityId) == address(this), "personality is not yet transferred");

		// retrieve NFT owner and verify if target NFT exists
		address owner = ERC721(targetContract).ownerOf(targetId);
		// Note: we do not require funder to be NFT owner,
		// if required this constraint should be added by the caller (iNFT Linker)
		require(owner != address(0), "target NFT doesn't exist");

		// in case when ALI tokens are expected to be locked within iNFT
		if(aliValue > 0) {
			// verify ALI tokens are already transferred to iNFT
			require(aliBalance + aliValue <= ERC20(aliContract).balanceOf(address(this)), "ALI tokens not yet transferred");

			// update ALI balance on the contract
			aliBalance += aliValue;
		}

		// bind AI Personality transferred and ALI ERC20 value transferred to an NFT specified
		bindings[recordId] = IntelliBinding({
			personalityContract : personalityContract,
			personalityId : personalityId,
			aliValue : aliValue,
			targetContract : targetContract,
			targetId : targetId
		});

		// fill in the reverse binding
		reverseBindings[targetContract][targetId] = recordId;

		// fill in the AI Personality to iNFT binding
		personalityBindings[personalityContract][personalityId] = recordId;

		// increase total supply counter
		totalSupply++;

		// emit an event
		emit Minted(
			msg.sender,
			owner,
			recordId,
			aliValue,
			personalityContract,
			personalityId,
			targetContract,
			targetId
		);
	}

	/**
	 * @dev Restricted access function which creates several iNFTs, binding them to the specified
	 *      NFTs, locking the AI Personalities specified, each funded with the amount of ALI specified
	 *
	 * @dev Locks AI Personalities defined by their IDs within iNFT smart contract;
	 *      AI Personalities must be transferred to the iNFT smart contract
	 *      prior to calling the `mintBatch`, but in the same transaction with `mintBatch`
	 *
	 * @dev Locks specified amount of ALI token within iNFT smart contract for each iNFT minted;
	 *      ALI token amount must be transferred to the iNFT smart contract
	 *      prior to calling the `mintBatch`, but in the same transaction with `mintBatch`
	 *
	 * @dev To summarize, minting transaction (a transaction which executes `mintBatch`) must
	 *      1) transfer AI Personality
	 *      2) transfer ALI tokens if they are to be locked
	 *      3) mint iNFT
	 *      NOTE: breaking the items above into multiple transactions is not acceptable!
	 *            (results in a security risk)
	 *
	 * @dev The NFTs to be linked to are not required to owned by the funder, but they must exist;
	 *      throws if target NFTs don't exist
	 *
	 * @dev iNFT IDs to be minted: [recordId, recordId + n)
	 * @dev AI Personality IDs to be locked: [personalityId, personalityId + n)
	 * @dev NFT IDs to be bound to: [targetId, targetId + n)
	 *
	 * @dev n must be greater or equal 2: `n > 1`
	 *
	 * @dev This is a restricted function which is accessed by iNFT Linker
	 *
	 * @param recordId ID of the first iNFT to mint (create, bind)
	 * @param aliValue amount of ALI tokens to bind to each newly created iNFT
	 * @param personalityContract AI Personality contract address
	 * @param personalityId ID of the first AI Personality to bind to newly created iNFT
	 * @param targetContract target NFT smart contract
	 * @param targetId first target NFT ID (where this iNFT binds to and belongs to)
	 * @param n how many iNFTs to mint, sequentially increasing the recordId, personalityId, and targetId
	 */
	function mintBatch(
		uint256 recordId,
		uint96 aliValue,
		address personalityContract,
		uint96 personalityId,
		address targetContract,
		uint256 targetId,
		uint96 n
	) public {
		// verify the access permission
		require(isSenderInRole(ROLE_MINTER), "access denied");

		// verify n is set properly
		require(n > 1, "n is too small");

		// verify personalityContract is a valid ERC721
		require(ERC165(personalityContract).supportsInterface(type(ERC721).interfaceId), "personality is not ERC721");

		// verify targetContract is a valid ERC721
		require(ERC165(targetContract).supportsInterface(type(ERC721).interfaceId), "target NFT is not ERC721");

		// verifications: for each iNFT in a batch
		for(uint96 i = 0; i < n; i++) {
			// verify this token ID is not yet bound
			require(!exists(recordId + i), "iNFT already exists");

			// verify the AI Personality is not yet bound
			require(personalityBindings[personalityContract][personalityId + i] == 0, "personality already linked");

			// verify if AI Personality is already transferred to iNFT
			require(ERC721(personalityContract).ownerOf(personalityId + i) == address(this), "personality is not yet transferred");

			// retrieve NFT owner and verify if target NFT exists
			address owner = ERC721(targetContract).ownerOf(targetId + i);
			// Note: we do not require funder to be NFT owner,
			// if required this constraint should be added by the caller (iNFT Linker)
			require(owner != address(0), "target NFT doesn't exist");

			// emit an event - we log owner for each iNFT
			// and its convenient to do it here when we have the owner inline
			emit Minted(
				msg.sender,
				owner,
				recordId + i,
				aliValue,
				personalityContract,
				personalityId + i,
				targetContract,
				targetId + i
			);
		}

		// cumulative ALI value may overflow uint96, store it into uint256 on stack
		uint256 _aliValue = uint256(aliValue) * n;

		// in case when ALI tokens are expected to be locked within iNFT
		if(_aliValue > 0) {
			// verify ALI tokens are already transferred to iNFT
			require(aliBalance + _aliValue <= ERC20(aliContract).balanceOf(address(this)), "ALI tokens not yet transferred");
			// update ALI balance on the contract
			aliBalance += _aliValue;
		}

		// minting: for each iNFT in a batch
		for(uint96 i = 0; i < n; i++) {
			// bind AI Personality transferred and ALI ERC20 value transferred to an NFT specified
			bindings[recordId + i] = IntelliBinding({
				personalityContract : personalityContract,
				personalityId : personalityId + i,
				aliValue : aliValue,
				targetContract : targetContract,
				targetId : targetId + i
			});

			// fill in the AI Personality to iNFT binding
			personalityBindings[personalityContract][personalityId + i] = recordId + i;

			// fill in the reverse binding
			reverseBindings[targetContract][targetId + i] = recordId + i;
		}

		// increase total supply counter
		totalSupply += n;
	}

	/**
	 * @dev Restricted access function which destroys an iNFT, unbinding it from the
	 *      linked NFT, releasing an AI Personality, and ALI tokens locked in the iNFT
	 *
	 * @dev Transfers an AI Personality locked in iNFT to its owner via ERC721.safeTransferFrom;
	 *      owner must be an EOA or implement ERC721Receiver.onERC721Received properly
	 * @dev Transfers ALI tokens locked in iNFT to its owner
	 * @dev Since iNFT owner is determined as underlying NFT owner, this underlying NFT must
	 *      exist and its ownerOf function must not throw and must return non-zero owner address
	 *      for the underlying NFT ID
	 *
	 * @dev Doesn't verify if it's safe to send ALI tokens to the NFT owner, this check
	 *      must be handled by the transaction executor
	 *
	 * @dev This is a restricted function which is accessed by iNFT Linker
	 *
	 * @param recordId ID of the iNFT to burn (destroy, unbind)
	 */
	function burn(uint256 recordId) public {
		// verify the access permission
		require(isSenderInRole(ROLE_BURNER), "access denied");

		// decrease total supply counter
		totalSupply--;

		// read the token binding (we'll need to access all the fields)
		IntelliBinding memory binding = bindings[recordId];

		// verify binding exists
		require(binding.targetContract != address(0), "not bound");

		// destroy binding first to protect from any reentrancy possibility
		delete bindings[recordId];

		// free the reverse binding
		delete reverseBindings[binding.targetContract][binding.targetId];

		// free the AI Personality binding
		delete personalityBindings[binding.personalityContract][binding.personalityId];

		// determine an owner of the underlying NFT
		address owner = ERC721(binding.targetContract).ownerOf(binding.targetId);

		// verify that owner address is set (not a zero address)
		require(owner != address(0), "no such NFT");

		// transfer the AI Personality to the NFT owner
		// using safe transfer since we don't know if owner address can accept the AI Personality right now
		ERC721(binding.personalityContract).safeTransferFrom(address(this), owner, binding.personalityId);

		// in case when ALI tokens were locked within iNFT
		if(binding.aliValue > 0) {
			// update ALI balance on the contract prior to token transfer (reentrancy style)
			aliBalance -= binding.aliValue;

			// transfer the ALI tokens to the NFT owner
			ERC20(aliContract).transfer(owner, binding.aliValue);
		}

		// emit an event
		emit Burnt(
			msg.sender,
			recordId,
			owner,
			binding.aliValue,
			binding.personalityContract,
			binding.personalityId,
			binding.targetContract,
			binding.targetId
		);
	}

	/**
	 * @dev Restricted access function which updates iNFT record by increasing locked ALI tokens value,
	 *      effectively locking additional ALI tokens to the iNFT
	 *
	 * @dev Locks specified amount of ALI token within iNFT smart contract;
	 *      ALI token amount must be transferred to the iNFT smart contract
	 *      prior to calling the `increaseAli`, but in the same transaction with `increaseAli`
	 *
	 * @dev To summarize, update transaction (a transaction which executes `increaseAli`) must
	 *      1) transfer ALI tokens
	 *      2) update the iNFT
	 *      NOTE: breaking the items above into multiple transactions is not acceptable!
	 *            (results in a security risk)
	 *
	 * @dev This is a restricted function which is accessed by iNFT Linker
	 *
	 * @param recordId ID of the iNFT to update
	 * @param aliDelta amount of ALI tokens to lock
	 */
	function increaseAli(uint256 recordId, uint96 aliDelta) public {
		// verify the access permission
		require(isSenderInRole(ROLE_EDITOR), "access denied");

		// verify the inputs are set
		require(aliDelta != 0, "zero value");

		// get iNFT owner for logging (check iNFT record exists under the hood)
		address owner = ownerOf(recordId);

		// cache the ALI value of the record
		uint96 aliValue = bindings[recordId].aliValue;

		// verify ALI tokens are already transferred to iNFT
		require(aliBalance + aliDelta <= ERC20(aliContract).balanceOf(address(this)), "ALI tokens not yet transferred");

		// update ALI balance on the contract
		aliBalance += aliDelta;

		// update ALI balance on the binding
		bindings[recordId].aliValue = aliValue + aliDelta;

		// emit an event
		emit Updated(msg.sender, owner, recordId, aliValue, aliValue + aliDelta);
	}

	/**
	 * @dev Restricted access function which updates iNFT record by decreasing locked ALI tokens value,
	 *      effectively unlocking some or all ALI tokens from the iNFT
	 *
	 * @dev Unlocked tokens are sent to the recipient address specified
	 *
	 * @dev This is a restricted function which is accessed by iNFT Linker
	 *
	 * @param recordId ID of the iNFT to update
	 * @param aliDelta amount of ALI tokens to unlock
	 * @param recipient an address to send unlocked tokens to
	 */
	function decreaseAli(uint256 recordId, uint96 aliDelta, address recipient) public {
		// verify the access permission
		require(isSenderInRole(ROLE_EDITOR), "access denied");

		// verify the inputs are set
		require(aliDelta != 0, "zero value");
		require(recipient != address(0), "zero address");

		// get iNFT owner for logging (check iNFT record exists under the hood)
		address owner = ownerOf(recordId);

		// cache the ALI value of the record
		uint96 aliValue = bindings[recordId].aliValue;

		// positive or zero resulting balance check
		require(aliValue >= aliDelta, "not enough ALI");

		// update ALI balance on the contract
		aliBalance -= aliDelta;

		// update ALI balance on the binding
		bindings[recordId].aliValue = aliValue - aliDelta;

		// transfer the ALI tokens to the recipient
		ERC20(aliContract).transfer(recipient, aliDelta);

		// emit an event
		emit Updated(msg.sender, owner, recordId, aliValue, aliValue - aliDelta);
	}

	/**
	 * @notice Determines how many tokens are locked in a particular iNFT
	 *
	 * @dev A shortcut for bindings(recordId).aliValue
	 * @dev Throws if iNFT specified doesn't exist
	 *
	 * @param recordId iNFT ID to query locked tokens balance for
	 * @return locked tokens balance, bindings[recordId].aliValue
	 */
	function lockedValue(uint256 recordId) public view returns(uint96) {
		// ensure iNFT exists
		require(exists(recordId), "iNFT doesn't exist");

		// read and return ALI value locked in the binding
		return bindings[recordId].aliValue;
	}
}


// File contracts/protocol/NFTStaking.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;



/**
 * @title NFT Staking
 *
 * @notice Enables NFT staking for a given NFT smart contract defined on deployment
 *
 * @notice Doesn't introduce any rewards, just tracks the stake/unstake dates for each
 *      token/owner, this data will be used later on to process the rewards
 */
contract NFTStaking is AccessControl {
	/**
	 * @dev Main staking data structure keeping track of a stake,
	 *      used in `tokenStakes` array mapping
	 */
	struct StakeData {
		/**
		 * @dev Who owned and staked the token, who will be the token
		 *      returned to once unstaked
		 */
		address owner;

		/**
		 * @dev When the token was staked and transferred from the owner,
		 *      unix timestamp
		 */
		uint32 stakedOn;

		/**
		 * @dev When token was unstaked and returned back to the owner,
		 *      unix timestamp
		 * @dev Zero value means the token is still staked
		 */
		uint32 unstakedOn;
	}

	/**
	 * @dev Auxiliary data structure to help iterate over NFT owner stakes,
	 *      used in `userStakes` array mapping
	 */
	struct StakeIndex {
		/**
		 * @dev Staked token ID
		 */
		uint32 tokenId;

		/**
		 * @dev Where to look for main staking data `StakeData`
		 *      in `tokenStakes` array mapping
		 */
		uint32 index;
	}

	/**
	 * @dev NFT smart contract to stake/unstake tokens of
	 */
	address public immutable targetContract;

	/**
	 * @notice For each token ID stores the history of its stakes,
	 *      last element of the history may be "open" (unstakedOn = 0),
	 *      meaning the token is still staked and is ot be returned to the `owner`
	 *
	 * @dev Maps token ID => StakeData[]
	 */
	mapping(uint32 => StakeData[]) public tokenStakes;

	/**
	 * @notice For each owner address stores the links to its stakes,
	 *      the link is represented as StakeIndex data struct
	 *
	 * @dev Maps owner address => StakeIndex[]
	 */
	mapping(address => StakeIndex[]) public userStakes;

	/**
	 * @dev Enables staking, stake(), stakeBatch()
	 */
	uint32 public constant FEATURE_STAKING = 0x0000_0001;

	/**
	 * @dev Enables unstaking, unstake(), unstakeBatch()
	 */
	uint32 public constant FEATURE_UNSTAKING = 0x0000_0002;

	/**
	 * @notice People do mistake and may send tokens by mistake; since
	 *      staking contract is not designed to accept the tokens directly,
	 *      it allows the rescue manager to "rescue" such lost tokens
	 *
	 * @notice Rescue manager is responsible for "rescuing" ERC20/ERC721 tokens
	 *      accidentally sent to the smart contract
	 *
	 * @dev Role ROLE_RESCUE_MANAGER allows withdrawing non-staked ERC20/ERC721
	 *      tokens stored on the smart contract balance
	 */
	uint32 public constant ROLE_RESCUE_MANAGER = 0x0001_0000;

	/**
	 * @dev Fired in stake(), stakeBatch()
	 *
	 * @param _by token owner, tx executor
	 * @param _tokenId token ID staked and transferred into the smart contract
	 * @param _when unix timestamp of when staking happened
	 */
	event Staked(address indexed _by, uint32 indexed _tokenId, uint32 _when);

	/**
	 * @dev Fired in unstake(), unstakeBatch()
	 *
	 * @param _by token owner, tx executor
	 * @param _tokenId token ID unstaked and transferred back to owner
	 * @param _when unix timestamp of when unstaking happened
	 */
	event Unstaked(address indexed _by, uint32 indexed _tokenId, uint32 _when);

	/**
	 * @dev Creates/deploys NFT staking contract bound to the already deployed
	 *      target NFT ERC721 smart contract to be staked
	 *
	 * @param _nft address of the deployed NFT smart contract instance
	 */
	constructor(address _nft) AccessControl(msg.sender) {
		// verify input is set
		require(_nft != address(0), "target contract is not set");

		// verify input is valid smart contract of the expected interface
		require(ERC165(_nft).supportsInterface(type(ERC721).interfaceId), "unexpected target type");

		// setup smart contract internal state
		targetContract = _nft;
	}

	/**
	 * @notice How many times a particular token was staked
	 *
	 * @dev Used to iterate `tokenStakes(tokenId, i)`, `i < numStakes(tokenId)`
	 *
	 * @param tokenId token ID to query number of times staked for
	 * @return number of times token was staked
	 */
	function numStakes(uint32 tokenId) public view returns(uint256) {
		// just read the array length and return it
		return tokenStakes[tokenId].length;
	}

	/**
	 * @notice How many stakes a particular address has done
	 *
	 * @dev Used to iterate `userStakes(owner, i)`, `i < numStakes(owner)`
	 *
	 * @param owner an address to query number of times it staked
	 * @return number of times a particular address has staked
	 */
	function numStakes(address owner) public view returns(uint256) {
		// just read the array length and return it
		return userStakes[owner].length;
	}

	/**
	 * @notice Determines if the token is currently staked or not
	 *
	 * @param tokenId token ID to check state for
	 * @return true if token is staked, false otherwise
	 */
	function isStaked(uint32 tokenId) public view returns(bool) {
		// get an idea of current stakes for the token
		uint256 n = tokenStakes[tokenId].length;

		// evaluate based on the last stake element in the array
		return n > 0 && tokenStakes[tokenId][n - 1].unstakedOn == 0;
	}

	/**
	 * @notice Stakes the NFT; the token is transferred from its owner to the staking contract;
	 *      token must be owned by the tx executor and be transferable by staking contract
	 *
	 * @param tokenId token ID to stake
	 */
	function stake(uint32 tokenId) public {
		// verify staking is enabled
		require(isFeatureEnabled(FEATURE_STAKING), "staking is disabled");

		// get an idea of current stakes for the token
		uint256 n = tokenStakes[tokenId].length;

		// verify the token is not currently staked
		require(n == 0 || tokenStakes[tokenId][n - 1].unstakedOn != 0, "already staked");

		// verify token belongs to the address which executes staking
		require(ERC721(targetContract).ownerOf(tokenId) == msg.sender, "access denied");

		// transfer the token from owner into the staking contract
		ERC721(targetContract).transferFrom(msg.sender, address(this), tokenId);

		// current timestamp to be set as `stakedOn`
		uint32 stakedOn = now32();

		// save token stake data
		tokenStakes[tokenId].push(StakeData({
			owner: msg.sender,
			stakedOn: stakedOn,
			unstakedOn: 0
		}));

		// save token stake index
		userStakes[msg.sender].push(StakeIndex({
			tokenId: tokenId,
			index: uint32(n)
		}));

		// emit an event
		emit Staked(msg.sender, tokenId, stakedOn);
	}

	/**
	 * @notice Stakes several NFTs; tokens are transferred from their owner to the staking contract;
	 *      tokens must be owned by the tx executor and be transferable by staking contract
	 *
	 * @param tokenIds token IDs to stake
	 */
	function stakeBatch(uint32[] memory tokenIds) public {
		// iterate the collection passed
		for(uint256 i = 0; i < tokenIds.length; i++) {
			// and stake each token one by one
			stake(tokenIds[i]);
		}
	}

	/**
	 * @notice Unstakes the NFT; the token is transferred from staking contract back
	 *      its previous owner
	 *
	 * @param tokenId token ID to unstake
	 */
	function unstake(uint32 tokenId) public {
		// verify staking is enabled
		require(isFeatureEnabled(FEATURE_UNSTAKING), "unstaking is disabled");

		// get an idea of current stakes for the token
		uint256 n = tokenStakes[tokenId].length;

		// verify the token is currently staked
		require(n != 0, "not staked");
		require(tokenStakes[tokenId][n - 1].unstakedOn == 0, "already unstaked");

		// verify token belongs to the address which executes unstaking
		require(tokenStakes[tokenId][n - 1].owner == msg.sender, "access denied");

		// current timestamp to be set as `unstakedOn`
		uint32 unstakedOn = now32();

		// update token stake data
		tokenStakes[tokenId][n - 1].unstakedOn = unstakedOn;

		// transfer the token back to owner
		ERC721(targetContract).transferFrom(address(this), msg.sender, tokenId);

		// emit an event
		emit Unstaked(msg.sender, tokenId, unstakedOn);
	}

	/**
	 * @notice Unstakes several NFTs; tokens are transferred from staking contract back
	 *      their previous owner
	 *
	 * @param tokenIds token IDs to unstake
	 */
	function unstakeBatch(uint32[] memory tokenIds) public {
		// iterate the collection passed
		for(uint256 i = 0; i < tokenIds.length; i++) {
			// and unstake each token one by one
			unstake(tokenIds[i]);
		}
	}

	/**
	 * @dev Restricted access function to rescue accidentally sent ERC20 tokens,
	 *      the tokens are rescued via `transfer` function call on the
	 *      contract address specified and with the parameters specified:
	 *      `_contract.transfer(_to, _value)`
	 *
	 * @dev Requires executor to have `ROLE_RESCUE_MANAGER` permission
	 *
	 * @param _contract smart contract address to execute `transfer` function on
	 * @param _to to address in `transfer(_to, _value)`
	 * @param _value value to transfer in `transfer(_to, _value)`
	 */
	function rescueErc20(address _contract, address _to, uint256 _value) public {
		// verify the access permission
		require(isSenderInRole(ROLE_RESCUE_MANAGER), "access denied");

		// perform the transfer as requested, without any checks
		ERC20(_contract).transfer(_to, _value);
	}

	/**
	 * @dev Restricted access function to rescue accidentally sent ERC721 tokens,
	 *      the tokens are rescued via `transferFrom` function call on the
	 *      contract address specified and with the parameters specified:
	 *      `_contract.transferFrom(this, _to, _tokenId)`
	 *
	 * @dev Requires executor to have `ROLE_RESCUE_MANAGER` permission
	 *
	 * @param _contract smart contract address to execute `transferFrom` function on
	 * @param _to to address in `transferFrom(this, _to, _tokenId)`
	 * @param _tokenId token ID to transfer in `transferFrom(this, _to, _tokenId)`
	 */
	function rescueErc721(address _contract, address _to, uint256 _tokenId) public {
		// verify the access permission
		require(isSenderInRole(ROLE_RESCUE_MANAGER), "access denied");

		// verify the NFT is not staked
		require(_contract != targetContract || !isStaked(uint32(_tokenId)), "token is staked");

		// perform the transfer as requested, without any checks
		ERC721(_contract).transferFrom(address(this), _to, _tokenId);
	}

	/**
	 * @dev Testing time-dependent functionality may be difficult;
	 *      we override time in the helper test smart contract (mock)
	 *
	 * @return `block.timestamp` in mainnet, custom values in testnets (if overridden)
	 */
	function now32() public view virtual returns (uint32) {
		// return current block timestamp
		return uint32(block.timestamp);
	}
}


// File contracts/utils/InitializableAccessControl.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.2;

/**
 * @title Initializable Role-based Access Control (RBAC) // ERC1967Proxy
 *
 * @notice Access control smart contract provides an API to check
 *      if a specific operation is permitted globally and/or
 *      if a particular user has a permission to execute it.
 *
 * @notice This contract is inherited by other contracts requiring the role-based access control (RBAC)
 *      protection for the restricted access functions
 *
 * @notice It deals with two main entities: features and roles.
 *
 * @notice Features are designed to be used to enable/disable public functions
 *      of the smart contract (used by a wide audience).
 * @notice User roles are designed to control the access to restricted functions
 *      of the smart contract (used by a limited set of maintainers).
 *
 * @notice Terms "role", "permissions" and "set of permissions" have equal meaning
 *      in the documentation text and may be used interchangeably.
 * @notice Terms "permission", "single permission" implies only one permission bit set.
 *
 * @notice Access manager is a special role which allows to grant/revoke other roles.
 *      Access managers can only grant/revoke permissions which they have themselves.
 *      As an example, access manager with no other roles set can only grant/revoke its own
 *      access manager permission and nothing else.
 *
 * @notice Access manager permission should be treated carefully, as a super admin permission:
 *      Access manager with even no other permission can interfere with another account by
 *      granting own access manager permission to it and effectively creating more powerful
 *      permission set than its own.
 *
 * @dev Both current and OpenZeppelin AccessControl implementations feature a similar API
 *      to check/know "who is allowed to do this thing".
 * @dev Zeppelin implementation is more flexible:
 *      - it allows setting unlimited number of roles, while current is limited to 256 different roles
 *      - it allows setting an admin for each role, while current allows having only one global admin
 * @dev Current implementation is more lightweight:
 *      - it uses only 1 bit per role, while Zeppelin uses 256 bits
 *      - it allows setting up to 256 roles at once, in a single transaction, while Zeppelin allows
 *        setting only one role in a single transaction
 *
 * @dev This smart contract is designed to be inherited by other
 *      smart contracts which require access control management capabilities.
 *
 * @dev Access manager permission has a bit 255 set.
 *      This bit must not be used by inheriting contracts for any other permissions/features.
 *
 * @dev This is an initializable version of the RBAC, based on Zeppelin implementation,
 *      it can be used for ERC1967 proxies, as well as for EIP-1167 minimal proxies
 *      see https://docs.openzeppelin.com/contracts/4.x/upgradeable
 *      see https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable
 *      see https://forum.openzeppelin.com/t/uups-proxies-tutorial-solidity-javascript/7786
 *      see https://eips.ethereum.org/EIPS/eip-1167
 *      see https://docs.openzeppelin.com/contracts/4.x/api/proxy#Clones
 *
 * @author Basil Gorin
 */
abstract contract InitializableAccessControl is Initializable {
	/**
	 * @dev Privileged addresses with defined roles/permissions
	 * @dev In the context of ERC20/ERC721 tokens these can be permissions to
	 *      allow minting or burning tokens, transferring on behalf and so on
	 *
	 * @dev Maps user address to the permissions bitmask (role), where each bit
	 *      represents a permission
	 * @dev Bitmask 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
	 *      represents all possible permissions
	 * @dev 'This' address mapping represents global features of the smart contract
	 *
	 * @dev We keep the mapping private to prevent direct writes to it from the inheriting
	 *      contracts, `getRole()` and `updateRole()` functions should be used instead
	 */
	mapping(address => uint256) private userRoles;

	/**
	 * @dev Empty reserved space in storage. The size of the __gap array is calculated so that
	 *      the amount of storage used by a contract always adds up to the 50.
	 *      See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
	 */
	uint256[49] private __gap;

	/**
	 * @notice Access manager is responsible for assigning the roles to users,
	 *      enabling/disabling global features of the smart contract
	 * @notice Access manager can add, remove and update user roles,
	 *      remove and update global features
	 *
	 * @dev Role ROLE_ACCESS_MANAGER allows modifying user roles and global features
	 * @dev Role ROLE_ACCESS_MANAGER has single bit at position 255 enabled
	 */
	uint256 public constant ROLE_ACCESS_MANAGER = 0x8000000000000000000000000000000000000000000000000000000000000000;

	/**
	 * @notice Upgrade manager is responsible for smart contract upgrades,
	 *      see https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable
	 *      see https://docs.openzeppelin.com/contracts/4.x/upgradeable
	 *
	 * @dev Role ROLE_UPGRADE_MANAGER allows passing the _authorizeUpgrade() check
	 * @dev Role ROLE_UPGRADE_MANAGER has single bit at position 254 enabled
	 */
	uint256 public constant ROLE_UPGRADE_MANAGER = 0x4000000000000000000000000000000000000000000000000000000000000000;

	/**
	 * @dev Bitmask representing all the possible permissions (super admin role)
	 * @dev Has all the bits are enabled (2^256 - 1 value)
	 */
	uint256 private constant FULL_PRIVILEGES_MASK = type(uint256).max; // before 0.8.0: uint256(-1) overflows to 0xFFFF...

	/**
	 * @dev Fired in updateRole() and updateFeatures()
	 *
	 * @param operator address which was granted/revoked permissions
	 * @param requested permissions requested
	 * @param assigned permissions effectively set
	 */
	event RoleUpdated(address indexed operator, uint256 requested, uint256 assigned);

	/**
	 * @notice Function modifier making a function defined as public behave as restricted
	 *      (so that only a pre-configured set of accounts can execute it)
	 *
	 * @param role the role transaction executor is required to have;
	 *      the function throws an "access denied" exception if this condition is not met
	 */
	modifier restrictedTo(uint256 role) {
		// verify the access permission
		require(isSenderInRole(role), "access denied");

		// execute the rest of the function
		_;
	}

	/**
	 * @dev Creates/deploys the ACL implementation to be used in a proxy
	 *
	 * @dev Note:
	 *      the implementation is already initialized and
	 *      `_postConstruct` is not executable on the implementation
	 *      `_postConstruct` is still available in the context of a proxy
	 *      and should be executed on the proxy deployment (in the same tx)
	 */
	 // constructor() initializer {}

	/**
	 * @dev Contract initializer, sets the contract owner to have full privileges
	 *
	 * @dev Can be executed only once, reverts when executed second time
	 *
	 * @dev IMPORTANT:
	 *      this function SHOULD be executed during proxy deployment (in the same transaction)
	 *
	 * @param _owner smart contract owner having full privileges
	 */
	function _postConstruct(address _owner) internal virtual onlyInitializing {
		// grant owner full privileges
		__setRole(_owner, FULL_PRIVILEGES_MASK, FULL_PRIVILEGES_MASK);
	}

	/**
	 * @dev Highest version that has been initialized.
	 *      Non-zero value means contract was already initialized.
	 * @dev see {Initializable}, {reinitializer}.
	 *
	 * @return highest version that has been initialized
	 */
/*
	function getInitializedVersion() public view returns(uint64) {
		// delegate to `_getInitializedVersion`
		return _getInitializedVersion();
	}
*/

	/**
	 * @notice Retrieves globally set of features enabled
	 *
	 * @dev Effectively reads userRoles role for the contract itself
	 *
	 * @return 256-bit bitmask of the features enabled
	 */
	function features() public view returns (uint256) {
		// features are stored in 'this' address mapping of `userRoles`
		return getRole(address(this));
	}

	/**
	 * @notice Updates set of the globally enabled features (`features`),
	 *      taking into account sender's permissions
	 *
	 * @dev Requires transaction sender to have `ROLE_ACCESS_MANAGER` permission
	 * @dev Function is left for backward compatibility with older versions
	 *
	 * @param _mask bitmask representing a set of features to enable/disable
	 */
	function updateFeatures(uint256 _mask) public {
		// delegate call to `updateRole`
		updateRole(address(this), _mask);
	}

	/**
	 * @notice Reads the permissions (role) for a given user from the `userRoles` mapping
	 *      (privileged addresses with defined roles/permissions)
	 * @notice In the context of ERC20/ERC721 tokens these can be permissions to
	 *      allow minting or burning tokens, transferring on behalf and so on
	 *
	 * @dev Having a simple getter instead of making the mapping public
	 *      allows enforcing the encapsulation of the mapping and protects from
	 *      writing to it directly in the inheriting smart contracts
	 *
	 * @param operator address of a user to read permissions for,
	 *      or self address to read global features of the smart contract
	 */
	function getRole(address operator) public view returns(uint256) {
		// read the value from `userRoles` and return
		return userRoles[operator];
	}

	/**
	 * @notice Updates set of permissions (role) for a given user,
	 *      taking into account sender's permissions.
	 *
	 * @dev Setting role to zero is equivalent to removing an all permissions
	 * @dev Setting role to `FULL_PRIVILEGES_MASK` is equivalent to
	 *      copying senders' permissions (role) to the user
	 * @dev Requires transaction sender to have `ROLE_ACCESS_MANAGER` permission
	 *
	 * @param operator address of a user to alter permissions for,
	 *       or self address to alter global features of the smart contract
	 * @param role bitmask representing a set of permissions to
	 *      enable/disable for a user specified
	 */
	function updateRole(address operator, uint256 role) public {
		// caller must have a permission to update user roles
		require(isSenderInRole(ROLE_ACCESS_MANAGER), "access denied");

		// evaluate the role and reassign it
		__setRole(operator, role, _evaluateBy(msg.sender, getRole(operator), role));
	}

	/**
	 * @notice Determines the permission bitmask an operator can set on the
	 *      target permission set
	 * @notice Used to calculate the permission bitmask to be set when requested
	 *     in `updateRole` and `updateFeatures` functions
	 *
	 * @dev Calculated based on:
	 *      1) operator's own permission set read from userRoles[operator]
	 *      2) target permission set - what is already set on the target
	 *      3) desired permission set - what do we want set target to
	 *
	 * @dev Corner cases:
	 *      1) Operator is super admin and its permission set is `FULL_PRIVILEGES_MASK`:
	 *        `desired` bitset is returned regardless of the `target` permission set value
	 *        (what operator sets is what they get)
	 *      2) Operator with no permissions (zero bitset):
	 *        `target` bitset is returned regardless of the `desired` value
	 *        (operator has no authority and cannot modify anything)
	 *
	 * @dev Example:
	 *      Consider an operator with the permissions bitmask     00001111
	 *      is about to modify the target permission set          01010101
	 *      Operator wants to set that permission set to          00110011
	 *      Based on their role, an operator has the permissions
	 *      to update only lowest 4 bits on the target, meaning that
	 *      high 4 bits of the target set in this example is left
	 *      unchanged and low 4 bits get changed as desired:      01010011
	 *
	 * @param operator address of the contract operator which is about to set the permissions
	 * @param target input set of permissions to operator is going to modify
	 * @param desired desired set of permissions operator would like to set
	 * @return resulting set of permissions given operator will set
	 */
	function _evaluateBy(address operator, uint256 target, uint256 desired) internal view returns (uint256) {
		// read operator's permissions
		uint256 p = getRole(operator);

		// taking into account operator's permissions,
		// 1) enable the permissions desired on the `target`
		target |= p & desired;
		// 2) disable the permissions desired on the `target`
		target &= FULL_PRIVILEGES_MASK ^ (p & (FULL_PRIVILEGES_MASK ^ desired));

		// return calculated result
		return target;
	}

	/**
	 * @notice Checks if requested set of features is enabled globally on the contract
	 *
	 * @param required set of features to check against
	 * @return true if all the features requested are enabled, false otherwise
	 */
	function isFeatureEnabled(uint256 required) public view returns (bool) {
		// delegate call to `__hasRole`, passing `features` property
		return __hasRole(features(), required);
	}

	/**
	 * @notice Checks if transaction sender `msg.sender` has all the permissions required
	 *
	 * @dev Used in smart contracts only. Off-chain clients should use `isOperatorInRole`.
	 *
	 * @param required set of permissions (role) to check against
	 * @return true if all the permissions requested are enabled, false otherwise
	 */
	function isSenderInRole(uint256 required) public view returns (bool) {
		// delegate call to `isOperatorInRole`, passing transaction sender
		return isOperatorInRole(msg.sender, required);
	}

	/**
	 * @notice Checks if operator has all the permissions (role) required
	 *
	 * @param operator address of the user to check role for
	 * @param required set of permissions (role) to check
	 * @return true if all the permissions requested are enabled, false otherwise
	 */
	function isOperatorInRole(address operator, uint256 required) public view returns (bool) {
		// delegate call to `__hasRole`, passing operator's permissions (role)
		return __hasRole(getRole(operator), required);
	}

	/**
	 * @dev Sets the `assignedRole` role to the operator, logs both `requestedRole` and `actualRole`
	 *
	 * @dev Unsafe:
	 *      provides direct write access to `userRoles` mapping without any security checks,
	 *      doesn't verify the executor (msg.sender) permissions,
	 *      must be kept private at all times
	 *
	 * @param operator address of a user to alter permissions for,
	 *       or self address to alter global features of the smart contract
	 * @param requestedRole bitmask representing a set of permissions requested
	 *      to be enabled/disabled for a user specified, used only to be logged into event
	 * @param assignedRole bitmask representing a set of permissions to
	 *      enable/disable for a user specified, used to update the mapping and to be logged into event
	 */
	function __setRole(address operator, uint256 requestedRole, uint256 assignedRole) private {
		// assign the role to the operator
		userRoles[operator] = assignedRole;

		// fire an event
		emit RoleUpdated(operator, requestedRole, assignedRole);
	}

	/**
	 * @dev Checks if role `actual` contains all the permissions required `required`
	 *
	 * @param actual existent role
	 * @param required required role
	 * @return true if actual has required role (all permissions), false otherwise
	 */
	function __hasRole(uint256 actual, uint256 required) private pure returns (bool) {
		// check the bitmask for the role required and return the result
		return actual & required == required;
	}
}


// File contracts/utils/UpgradeableAccessControl.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.2;


/**
 * @title Upgradeable Role-based Access Control (RBAC) // ERC1967Proxy
 *
 * @notice Access control smart contract provides an API to check
 *      if a specific operation is permitted globally and/or
 *      if a particular user has a permission to execute it.
 *
 * @notice This contract is inherited by other contracts requiring the role-based access control (RBAC)
 *      protection for the restricted access functions
 *
 * @notice It deals with two main entities: features and roles.
 *
 * @notice Features are designed to be used to enable/disable public functions
 *      of the smart contract (used by a wide audience).
 * @notice User roles are designed to control the access to restricted functions
 *      of the smart contract (used by a limited set of maintainers).
 *
 * @notice Terms "role", "permissions" and "set of permissions" have equal meaning
 *      in the documentation text and may be used interchangeably.
 * @notice Terms "permission", "single permission" implies only one permission bit set.
 *
 * @notice Access manager is a special role which allows to grant/revoke other roles.
 *      Access managers can only grant/revoke permissions which they have themselves.
 *      As an example, access manager with no other roles set can only grant/revoke its own
 *      access manager permission and nothing else.
 *
 * @notice Access manager permission should be treated carefully, as a super admin permission:
 *      Access manager with even no other permission can interfere with another account by
 *      granting own access manager permission to it and effectively creating more powerful
 *      permission set than its own.
 *
 * @dev Both current and OpenZeppelin AccessControl implementations feature a similar API
 *      to check/know "who is allowed to do this thing".
 * @dev Zeppelin implementation is more flexible:
 *      - it allows setting unlimited number of roles, while current is limited to 256 different roles
 *      - it allows setting an admin for each role, while current allows having only one global admin
 * @dev Current implementation is more lightweight:
 *      - it uses only 1 bit per role, while Zeppelin uses 256 bits
 *      - it allows setting up to 256 roles at once, in a single transaction, while Zeppelin allows
 *        setting only one role in a single transaction
 *
 * @dev This smart contract is designed to be inherited by other
 *      smart contracts which require access control management capabilities.
 *
 * @dev Access manager permission has a bit 255 set.
 *      This bit must not be used by inheriting contracts for any other permissions/features.
 *
 * @dev This is an upgradeable version of the ACL, based on Zeppelin implementation for ERC1967,
 *      see https://docs.openzeppelin.com/contracts/4.x/upgradeable
 *      see https://docs.openzeppelin.com/contracts/4.x/api/proxy#UUPSUpgradeable
 *      see https://forum.openzeppelin.com/t/uups-proxies-tutorial-solidity-javascript/7786
 *
 * @author Basil Gorin
 */
abstract contract UpgradeableAccessControl is InitializableAccessControl, UUPSUpgradeable {
	/**
	 * @dev Creates/deploys the ACL implementation to be used in a proxy
	 *
	 * @dev Note:
	 *      the implementation is already initialized and
	 *      `_postConstruct` is not executable on the implementation
	 *      `_postConstruct` is still available in the context of a proxy
	 *      and should be executed on the proxy deployment (in the same tx)
	 */
	constructor() initializer {}

	/**
	 * @notice Returns an address of the implementation smart contract,
	 *      see ERC1967Upgrade._getImplementation()
	 *
	 * @return the current implementation address
	 */
	function getImplementation() public view virtual returns (address) {
		// delegate to `ERC1967Upgrade._getImplementation()`
		return _getImplementation();
	}

	/**
	 * @inheritdoc UUPSUpgradeable
	 */
	function _authorizeUpgrade(address) internal virtual override {
		// caller must have a permission to upgrade the contract
		require(isSenderInRole(ROLE_UPGRADE_MANAGER), "access denied");
	}
}


// File contracts/bonding_curves/HiveRegistryV1.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.4;	







/**
 * @title Hive Registry (Implementation, V1)
 *
 * @notice see HiveRegistry
 */
contract HiveRegistryV1 is HiveRegistry, UpgradeableAccessControl, EIP712Upgradeable {
	// libraries in use
	using ECDSAUpgradeable for bytes32;
	using SharesSubjectLib for TradeableShares.SharesSubject;

	/**
	 * @dev AI Personality contract defined by `personalityContract` (effectively immutable)
	 */
	address public personalityContract;

	/**
	 * @dev iNFT Linker contract defined by `iNftContract` (effectively immutable)
	 */
	address public iNftContract;

	/**
	 * @dev AI Personality staking contract defined by `podStakingContract` (effectively immutable)
	 */
	address public podStakingContract;

	/**
	 * @notice DPT registry storage, stores binding information for each existing registered DPTs
	 *
	 * @dev Mapping to store the linking status of DPTs identified by their bytes32 representation.
	 */
	mapping(bytes32 => bool) private dptLinkStatus;

	/**
	 * @dev Keeps track of the used nonces for every possible issuer
	 *      Maps address => number of used nonces
	 */
	mapping(address => uint256) private nonces;

	/**
	 * @dev Keeps track of Level 5 AI Pods
	 *      maps AI Pod ID => is Level 5?
	 */
	mapping(uint256 => bool) private whitelistedPods;

	/**
	 * @dev Enumerable of all the Hives. Hive index in the array is a Hive ID.
	 */
	TradeableShares.SharesSubject[] private hives;

	/**
	 * @dev Keeps track of the Hives' ERC20 economy tokens
	 *      Maps Hive ID => Hive economy ERC20 token address
	 */
	mapping(uint256 => address) private hiveToken;

	/**
	 * @dev Keeps track of which AI Pods created which Hives
	 *      Maps keccak256(AI Pod address, ID) => Hive ID
	 */
	mapping(bytes32 => uint256) private hiveIndex;

	/**
	 * @dev Keeps track of the Hive URIs
	 *      Maps Hive ID => Hive URI
	 */
	mapping(uint256 => string) private hiveURI;

	/**
	 * @dev Enumerable of all categories. Category index in the array is a Category ID
	 */
	CategoryInfo[] public globalCategories;

	/**
	 * @dev Keeps track of the linked assets categories
	 *      Maps Category Name => category ID / Index
	 */
	mapping(string => uint16) private categoryIndex;

	/**
	 * @dev Keeps track of the bound assets to the Hive as a categories catalog
	 *      Maps Hive ID => Category ID => Enumerable of the linked assets
	 */
	mapping(uint256 => mapping(uint16 => TradeableShares.SharesSubject[])) public assetCatalogue;

	/**
	 * @dev Keeps track of the assets linked to the Hive
	 *      Maps an asset keccak256(ERC721 address, ID) => (Hive ID, Category ID, asset Index in `assetBindings`)
	 */
	mapping(bytes32 => AssetLinkDetails) private linkedAssets;

	/**
	 * @notice Total number of assets linked (counter)
	 */
	uint256 public totalNumOfAssetsLinked;

	/**
	 * @notice Enables hive creation
	 *
	 * @dev Feature FEATURE_ALLOW_HIVE_CREATION must be enabled
	 *      as a prerequisite for `launchHive()` function to succeed
	 */
	uint32 public constant FEATURE_ALLOW_HIVE_CREATION = 0x0000_0001;

	/**
	 * @notice Enables asset linking with hives
	 *
	 * @dev Feature FEATURE_ALLOW_ASSET_LINKING must be enabled
	 *      as a prerequisite for `linkAsset()` function to succeed
	 */
	uint32 public constant FEATURE_ALLOW_ASSET_LINKING = 0x0000_0002;

	/**
	 * @notice Enables asset unlink from hives
	 *
	 * @dev Feature FEATURE_ALLOW_ASSET_UNLINKING must be enabled
	 *      as a prerequisite for `unlinkAsset()` function to succeed
	 */
	uint32 public constant FEATURE_ALLOW_ASSET_UNLINKING = 0x0000_0004;

	/**
	 * @notice registers DPTs with Hive registry on other behalf using meta-tx
	 *
	 * @dev Role ROLE_SHARES_REGISTRAR is required to execute `registerDPTRequest` functions
	 *
	 */
	uint32 public constant ROLE_DPT_REGISTRAR = 0x0001_0000;

	/**
	 * @notice allows to update pods of whitelisted list which are allowed to create hive
	 *
	 * @dev Role ROLE_POD_WHITELIST_MANAGER is required to execute `whitelistPods` & 'delistPods' functions
	 *
	 */
	uint32 public constant ROLE_POD_WHITELIST_MANAGER = 0x0002_0000;

	/**
	 * @notice allows to add new asset global category to hive registry
	 *
	 * @dev Role ROLE_CATEGORY_MANAGER is required to execute `addCategory` functions
	 *
	 */
	uint32 public constant ROLE_CATEGORY_MANAGER = 0x0004_0000;

	/**
	 * @notice allows to set ERC20 token address associated with particular hive
	 *
	 * @dev Role ROLE_HIVE_TOKEN_MANAGER is required to execute `updateHiveToken` functions
	 *
	 */
	uint32 public constant ROLE_HIVE_TOKEN_MANAGER = 0x0008_0000;

	/**
	 * @dev "Constructor replacement" for upgradeable, must be execute immediately after proxy deployment
	 *      see https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#initializers
	 *
	 */
	function postConstruct(address _personalityContract, address _iNftContract, address _podStakingContract) public initializer {
		// execute parent initializer(s)
		__EIP712_init_unchained("HiveRegistry", "1");
		_postConstruct(msg.sender);

		// initialize immutables
		iNftContract = _iNftContract;
		podStakingContract = _podStakingContract;
		personalityContract = _personalityContract;

		// we have pushed first place as dummy, to start indexing from 1 onwards
		hives.push();
		globalCategories.push();

		// add default global categories
		globalCategories.push(CategoryInfo({
			category: "Intelligence_POD",
			allowedCollection: _personalityContract
		}));
		categoryIndex["Intelligence_POD"] = uint16(globalCategories.length - 1);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function eip712RegisterAsDPT(RegisterAsDPTRequest calldata _req, bytes calldata _signature) external virtual {
		// verify the request validity
		require(_req.validFromTimestamp <= block.timestamp, "not yet valid");
		require(_req.expiresAtTimestamp > block.timestamp, "expired");

		// verify and use nonce
		__useNonce(_req.dptOwner, _req.nonce);

		// derive the request signer
		// this also verifies that the signature is valid
		address signer = _hashTypedDataV4(__hashStruct(_req)).recover(_signature);

		// Register the DPT
		__registerDPT(_req.asset, signer);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function registerAsDPT(TradeableShares.SharesSubject calldata _dpt) external virtual {
		// Register the DPT with the sender as the authorized party
		__registerDPT(_dpt, msg.sender);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function fastForwardTheNonce(address _issuer, uint256 _nonce) external {
		// verify the access permission
		require(isSenderInRole(ROLE_DPT_REGISTRAR), "access denied");

		// make sure nonce is not decreasing
		require(nonces[_issuer] < _nonce, "new nonce must be bigger than the current one");

		// rewind the nonce to the value requested
		nonces[_issuer] = _nonce;

		// emit an event
		emit NonceUsed(_issuer, _nonce - 1);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function createHive(uint256 _podId, string calldata _hiveURI) external {
		// make sure hive creation is allowed
		require(isFeatureEnabled(FEATURE_ALLOW_HIVE_CREATION), "hive creation disabled");

		// make sure supplied podId is whitelisted and personalityContract is set
		require(personalityContract != address(0) && whitelistedPods[_podId], "not allowed");

		// wrap the inputs into SharesSubject struct
		TradeableShares.SharesSubject memory pod = TradeableShares.SharesSubject({
			tokenAddress: personalityContract,
			tokenId: _podId
		});
		// verify pod ownership
		require(
			ERC721(personalityContract).ownerOf(_podId) == msg.sender || __isPodStaked(pod) || __isPodLinkedWithINFT(pod),
			"not authorized"
		);

		// calculate the key
		bytes32 podKey = SharesSubjectLib.getSharesKey(personalityContract, _podId);
		// make sure hive is not exist against particular pod
		require(hiveIndex[podKey] == 0, "already exists");

		// make sure pod is not liked as asset
		require(linkedAssets[podKey].hiveId == 0, "pod linked as an asset");

		// update state variables
		hives.push(pod);
		hiveIndex[podKey] = hives.length - 1;
		hiveURI[hives.length - 1] = _hiveURI;

		// emit an event
		emit HiveCreated(msg.sender, hives.length - 1, pod.tokenAddress, pod.tokenId, block.timestamp);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function linkAsset(
		TradeableShares.SharesSubject calldata _asset,
		uint16 _hiveId,
		string calldata _categoryName
	) external {
		// delegate to linkAsset (with categoryId)
		linkAsset(_asset, _hiveId, categoryIndex[_categoryName]);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function linkAsset(
		TradeableShares.SharesSubject calldata _asset,
		uint16 _hiveId,
		uint16 _categoryId
	) public {
		// make sure asset linking is allowed
		require(isFeatureEnabled(FEATURE_ALLOW_ASSET_LINKING), "asset linking is disabled");

		// verify asset ownership
		require(
			ERC721(_asset.tokenAddress).ownerOf(_asset.tokenId) == msg.sender
			|| (_asset.tokenAddress == personalityContract && (__isPodStaked(_asset) || __isPodLinkedWithINFT(_asset))),
			"not authorized"
		);

		// validate hive ID
		require(_hiveId > 0, "invalid hiveId");

		// validate category ID
		require(_categoryId > 0 && _categoryId < globalCategories.length, "invalid category");

		// make sure asset linked under allowed category only
		require(
			globalCategories[_categoryId].allowedCollection == address(0)
			|| globalCategories[_categoryId].allowedCollection == _asset.tokenAddress,
			"asset linking restricted for supplied category"
		);

		bytes32 assetKey = SharesSubjectLib.getSharesKey(_asset.tokenAddress, _asset.tokenId);
		// make sure asset is not already linked with other hive
		require(linkedAssets[assetKey].hiveId == 0, "asset already linked");

		// make sure hive is not been create again requested asset
		require(hiveIndex[assetKey] == 0, "asset is associated with hive");

		// increase total number of asset linked with hive registry
		totalNumOfAssetsLinked++;
		// update state variable
		assetCatalogue[_hiveId][_categoryId].push(_asset);
		linkedAssets[assetKey] = AssetLinkDetails({
			hiveId: _hiveId,
			categoryId: _categoryId,
			assetIndex: uint16(assetCatalogue[_hiveId][_categoryId].length - 1)
		});

		// emit an event
		emit AssetLinked(msg.sender, _asset.tokenAddress, _asset.tokenId, _hiveId, _categoryId, block.timestamp);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function unlinkAsset(TradeableShares.SharesSubject calldata _asset) external {
		// make sure asset unlinking is allowed
		require(isFeatureEnabled(FEATURE_ALLOW_ASSET_UNLINKING), "asset unlinking is disabled");

		bytes32 assetKey = SharesSubjectLib.getSharesKey(_asset.tokenAddress, _asset.tokenId);
		// make sure asset is linked with any hive
		require(linkedAssets[assetKey].hiveId != 0, "unlinked asset");

		// verify ownership of asset
		require(
			ERC721(_asset.tokenAddress).ownerOf(_asset.tokenId) == msg.sender
			|| (_asset.tokenAddress == personalityContract && (__isPodStaked(_asset) || __isPodLinkedWithINFT(_asset))),
			"not authorized"
		);

		// get linked asset details
		AssetLinkDetails memory assetLinkDetails = linkedAssets[assetKey];
		uint256 linkedAssetsLength = assetCatalogue[assetLinkDetails.hiveId][assetLinkDetails.categoryId].length;

		// if more then 1 asset is been linked with hive under particular category,
		// then we need to swap indexing of last connected asset with requested asset index
		if(linkedAssetsLength > 1) {
			TradeableShares.SharesSubject memory lastAsset = assetCatalogue[assetLinkDetails.hiveId][assetLinkDetails.categoryId][linkedAssetsLength - 1];
			bytes32 lastAssetKey = SharesSubjectLib.getSharesKey(lastAsset.tokenAddress, lastAsset.tokenId);

			// swap indexing of asset
			assetCatalogue[assetLinkDetails.hiveId][assetLinkDetails.categoryId][assetLinkDetails.assetIndex] = lastAsset;
			linkedAssets[lastAssetKey].assetIndex = assetLinkDetails.assetIndex;
		}

		// delete request asset details
		assetCatalogue[assetLinkDetails.hiveId][assetLinkDetails.categoryId].pop();
		delete linkedAssets[assetKey];
		// update total number of asset linked with hive registry
		totalNumOfAssetsLinked--;

		// emit an event
		emit AssetUnlinked(
			msg.sender,
			_asset.tokenAddress,
			_asset.tokenId,
			assetLinkDetails.hiveId,
			assetLinkDetails.categoryId,
			block.timestamp
		);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function setHiveTokenAddress(uint256 _hiveId, address _tokenAddress) external {
		// verify the access permission
		require(isSenderInRole(ROLE_HIVE_TOKEN_MANAGER), "access denied");

		// valid hive ID
		require(_hiveId > 0 && _hiveId < hives.length, "invalid hiveId");

		// make sure token is not address been set for particular hive
		require(hiveToken[_hiveId] == address(0), "token address is already set");

		// update hive token address
		hiveToken[_hiveId] = _tokenAddress;

		// emit an event
		emit HiveTokenUpdated(msg.sender, _hiveId, _tokenAddress);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function updateHiveURI(uint256 _hiveId, string calldata _hiveURI) external {
		// validate supplied hive ID
		require(_hiveId > 0 && _hiveId < hives.length, "invalid hiveId");

		TradeableShares.SharesSubject memory nftDetail = hives[_hiveId];
		// verify hive ownership
		require(
			ERC721(nftDetail.tokenAddress).ownerOf(nftDetail.tokenId) == msg.sender
			|| __isPodStaked(nftDetail)
			|| __isPodLinkedWithINFT(nftDetail),
			"not authorized"
		);

		// update hive metadata URI
		hiveURI[_hiveId] = _hiveURI;

		// emit an event
		emit HiveUriUpdated(msg.sender, _hiveId, _hiveURI);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function addCategory(string calldata _categoryName, address _allowedCollection) external {
		// verify the access permission
		require(isSenderInRole(ROLE_CATEGORY_MANAGER), "access denied");

		// make sure request category hasn't already been added
		require(categoryIndex[_categoryName] == 0, "category exists!");

		// add category to global category catalogue
		globalCategories.push(CategoryInfo({
			category: _categoryName,
			allowedCollection: _allowedCollection
		}));

		// update new category index
		categoryIndex[_categoryName] = uint16(globalCategories.length - 1);

		// emit an event
		emit CategoryAdded(msg.sender, globalCategories.length - 1, _categoryName, _allowedCollection);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function whitelistPods(uint256[] calldata _pods) external {
		// verify the access permission
		require(isSenderInRole(ROLE_POD_WHITELIST_MANAGER), "access denied");

		uint256 length = _pods.length;
		for(uint256 i = 0; i < length; i++) {
			// whitelist pods if not already whitelisted
			if(whitelistedPods[_pods[i]] == false) {
				// whitelist pod
				whitelistedPods[_pods[i]] = true;

				// emit an event
				emit PodWhitelisted(msg.sender, _pods[i]);
			}
		}
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function delistPods(uint256[] calldata _pods) external {
		// verify the access permission
		require(isSenderInRole(ROLE_POD_WHITELIST_MANAGER), "access denied");

		uint256 length = _pods.length;
		for(uint256 i = 0; i < length; i++) {
			// delist pods if whitelisted
			if(whitelistedPods[_pods[i]] == true) {
				//delist pod
				whitelistedPods[_pods[i]] = false;

				// emit an event
				emit PodDelisted(msg.sender, _pods[i]);
			}
		}
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getLinkedAssetDetails(TradeableShares.SharesSubject calldata _asset) external view returns(
		uint256 hiveId,
		uint256 categoryId,
		string memory category
	) {
		bytes32 assetKey = SharesSubjectLib.getSharesKey(_asset.tokenAddress, _asset.tokenId);

		// throw expection if asset is not linked
		require(linkedAssets[assetKey].hiveId !=0, "not linked");

		return (
			linkedAssets[assetKey].hiveId,
			linkedAssets[assetKey].categoryId,
			globalCategories[linkedAssets[assetKey].categoryId].category
		);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function isAssetLinked(TradeableShares.SharesSubject calldata _asset) external view returns (bool status) {
		bytes32 assetKey = SharesSubjectLib.getSharesKey(_asset.tokenAddress, _asset.tokenId);

		return (linkedAssets[assetKey].hiveId != 0);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getNumOfAssetsLinkedWithHive(uint16 _hiveId) external view returns (uint256 numOfAssets) {
		uint256 length = globalCategories.length;
		// returns total number of Asset linked to hive
		for(uint16 i = 1; i < length; i++) {
			numOfAssets += assetCatalogue[_hiveId][i].length;
		}

		return numOfAssets;
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getNumOfAssetsLinkedWithHive(uint16 _hiveId, uint16 _category) external view returns (uint256 numOfAssets) {
		// returns number of Asset linked to hive under particular category
		return assetCatalogue[_hiveId][_category].length;
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getCategoryIndex(string memory _category) external view returns (uint16 categoryId) {
		return categoryIndex[_category];
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getHiveId(uint256 _podId) external view returns (uint256 hiveId) {
		return hiveIndex[SharesSubjectLib.getSharesKey(personalityContract, _podId)];
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getHiveCreatorPod(uint256 _hiveId) external view returns (TradeableShares.SharesSubject memory pod) {
		// throw expection if hiveId is invalid
		require(_hiveId != 0 && _hiveId < hives.length, "invalid hiveId");

		return hives[_hiveId];
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getHiveToken(uint256 _hiveId) external view returns (address tokenAddr) {
		return hiveToken[_hiveId];
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getHiveURI(uint16 _hiveId) external view returns (string memory hiveUri) {
		return hiveURI[_hiveId];
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getHiveDetails(
		uint16 _hiveId
	) external view returns (
		TradeableShares.SharesSubject memory pod,
		address hiveOwner,
		address hiveTokenAddr,
		string memory hiveUri
	) {
		// throw expection if hiveId is invalid
		require(_hiveId != 0 && _hiveId < hives.length, "invalid hiveId");

		return (
			hives[_hiveId],
			ERC721(hives[_hiveId].tokenAddress).ownerOf(hives[_hiveId].tokenId),
			hiveToken[_hiveId],
			hiveURI[_hiveId]
		);
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function isPodWhitelisted(uint256 _podId) external view returns (bool status) {
		return whitelistedPods[_podId];
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getNumOfHives() external view returns (uint256 noOfHives) {
		return hives.length - 1;
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getNumOfGlobalCategories() external view returns (uint256 noOfCategories) {
		return globalCategories.length - 1;
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function isDPTRegistered(TradeableShares.SharesSubject calldata _dpt) external view returns (bool status) {
		return dptLinkStatus[SharesSubjectLib.getSharesKey(_dpt.tokenAddress, _dpt.tokenId)];
	}

	/**
	 * @inheritdoc HiveRegistry
	 */
	function getNonce(address clientAddress) external view returns (uint256 nonce) {
		// read the nonce from the storage
		return nonces[clientAddress];
	}

	/**
	 * @dev Internal function to check pod stake state
	 *
	 * @param _pod The TradeableShares.SharesSubject struct representing the pod.
	 * @return status true if pod is staked and owned by requested user, otherwise false
	 */
	function __isPodStaked(TradeableShares.SharesSubject memory _pod) internal view returns (bool status) {
		// if podStakingContract is not set, no need to process further
		if(podStakingContract == address(0)) {
			return false;
		}

		// get number of stake been created for particular pod
		uint256 numStakes = NFTStaking(podStakingContract).numStakes(uint32(_pod.tokenId));
		// if number of stake is zero means pod is not stacked
		if(numStakes == 0) {
			return false;
		}

		// retrieve owner and unstaked time of latest stake
		(address owner, , uint32 unstakedOn) = NFTStaking(podStakingContract).tokenStakes(uint32(_pod.tokenId), numStakes - 1);

		// if unstake time is non-zero indicate pod is already be unstaked.
		return (unstakedOn == 0 && owner == msg.sender);
	}

	/**
	 * @dev Internal function to check pod iNft fuse state
	 *
	 * @param _pod The TradeableShares.SharesSubject struct representing the pod.
	 * @return status true if pod is been fused and owned by requested user, otherwise false
	 */
	function __isPodLinkedWithINFT(TradeableShares.SharesSubject memory _pod) internal view returns (bool status) {
		// if iNftContract is not set, no need to process further
		if(iNftContract == address(0)) {
			return false;
		}

		// retrieve record ID of fused Pod
		uint256 recordId = IntelligentNFTv2(iNftContract).personalityBindings(_pod.tokenAddress, _pod.tokenId);
		// if recordId is zero, indicate pod is not fused here
		return (recordId != 0 && IntelligentNFTv2(iNftContract).ownerOf(recordId) == msg.sender);
	}

	/**
	 * @dev Internal function to register a DPT.
	 *
	 * @param _dpt The TradeableShares.SharesSubject struct representing the DPT.
	 * @param _authorizedBy The address authorizing the registration.
	 */
	function __registerDPT(TradeableShares.SharesSubject calldata _dpt, address _authorizedBy) internal {
		// Ensure the sender is authorized to register the DPT
		require(
			// allow REGISTRAR to register
			isSenderInRole(ROLE_DPT_REGISTRAR)
			// allow REGISTRAR to register via EIP712
			|| isOperatorInRole(_authorizedBy, ROLE_DPT_REGISTRAR),
			"not authorized"
		);

		// derive the DPT key
		bytes32 dptKey = SharesSubjectLib.getSharesKey(_dpt.tokenAddress, _dpt.tokenId);
		// verify DPT register state
		require(!dptLinkStatus[dptKey], "DPT is already registered!");

		// update DPT register state
		dptLinkStatus[dptKey] = true;

		// emit an event
		emit DPTRegistered(_authorizedBy, _dpt.tokenAddress, _dpt.tokenId, block.timestamp);
	}

	/**
	 * @dev Verifies the nonce is valid and marks it as used
	 *      Throws if nonce is already used or if it is invalid
	 *
	 * @param _issuer the owner of the nonce
	 * @param _nonce the nonce to be used
	 */
	function __useNonce(address _issuer, uint256 _nonce) internal {
		// verify the nonce wasn't yet used and use it
		require(nonces[_issuer]++ == _nonce, "invalid nonce");

		// emit an event
		emit NonceUsed(_issuer, _nonce);
	}

	/**
	 * @notice RegisterAsDPTRequest typeHash
	 */
	function __hashType(RegisterAsDPTRequest calldata) internal pure returns (bytes32) {
		// hashType(RegisterAsDPTRequest) = keccak256("RegisterAsDPTRequest(TradeableShares.SharesSubject dpt,address dptHolder,uint256 validFromTimestamp,uint256 expiresAtTimestamp,uint256 nonce)")
		return 0x5e5980812e14d500287e9b3d75ae309eac0fb0d30f0d40d19ea443de698eef00;
	}

	/**
	 * @notice RegisterDPTRequest hashStruct
	 */
	function __hashStruct(RegisterAsDPTRequest calldata _request) internal pure returns (bytes32) {
		return keccak256(abi.encode(
			__hashType(_request),
			TypedStructLib.hashStruct(_request.asset),
			_request.dptOwner,
			_request.validFromTimestamp,
			_request.expiresAtTimestamp,
			_request.nonce
		));
	}
}
