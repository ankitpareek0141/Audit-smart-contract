// SPDX-License-Identifier: MIT
// use non-strict version pragma to simplify contract imports in other projects
pragma solidity ^0.8.4;

import "../interfaces/ERC20Spec.sol";
import "./NonblockingUpgradeableLzApp.sol";

/**
 * @title LayerZero ERC20 Root Tunnel
 *
 * @notice Ethereum network (root chain - L1) exit of the ERC20 tunnel,
 *      can be used for Ethereum mainnet and Goerli testnet networks
 *
 * @notice The tunnel is used to bridge specific ERC20 token between L1/L2;
 *      we call L1 -> L2 bridging a "deposit", L2 -> L1 a "withdrawal"
 *
 * @notice The tunnel has two entrances and two exits:
 *       LzERC20RootTunnel contains Root/L1 entrance and exit,
 *       and LzERC20ChildTunnel contains Child/L2 entrance and exit
 *
 * @notice All exits and child entrance are always open, while root entrance
 *      may get paused or even closed permanently
 *
 * @notice Deposit flow:
 *      1. The user initiates a deposit on the L1 entrance by executing the deposit function
 *         `LzERC20RootTunnel.deposit` or `LzERC20RootTunnel.depositTo`
 *      2. LayerZero messaging system picks up the event emitted by the `deposit` call
 *         and delivers it to L2 chain
 *      3. The deposit completes on the L2 exit when LayerZero messaging system executes
 *         the `LzERC20ChildTunnel.lzReceive` function
 *      Note: overall, the user executes only one function and then just waits for the bridge
 *         operation to complete
 *
 * @notice Withdrawal flow:
 *      1. The user initiates a withdrawal on the L2 entrance by executing the withdraw function
 *         `LzERC20ChildTunnel.withdraw` or `LzERC20ChildTunnel.withdrawTo`
 *      2. LayerZero messaging system picks up the event emitted by the `withdraw` call
 *         and delivers it to L1 chain
 *      3. The withdrawal completes on the L1 exit when LayerZero messaging system executes
 *         the `LzERC20RootTunnel.lzReceive` function
 *      Note: overall, the user executes only one function and then just waits for the bridge
 *         operation to complete
 *
 * @dev see https://github.com/LayerZero-Labs/LayerZero
 * @dev see https://github.com/LayerZero-Labs/solidity-examples
 *
 * @author Basil Gorin
 */
contract LzERC20RootTunnelV1 is NonblockingUpgradeableLzApp {
	/**
	 * @notice Root tunnel is strictly bound to the root ERC20 token
	 *
	 * @dev Root token MUST be an ERC20 implementation throwing on non-successful transfers
	 */
	ERC20 public /*immutable*/ rootToken;

	/**
	 * @notice LayerZero specific chainId where the LzERC20ChildTunnel is deployed
	 *
	 * @dev Incoming messages must specify this chainId in order to be accepted
	 *      see https://layerzero.gitbook.io/docs/technical-reference/mainnet/supported-chain-ids
	 *      see https://layerzero.gitbook.io/docs/technical-reference/testnet/testnet-addresses
	 */
	uint16 public childTunnelChainId;

	/**
	 * @notice The address of the deployed LzERC20ChildTunnel which is bound to this LzERC20RootTunnel
	 *
	 * @dev Incoming messages must specify this LzERC20ChildTunnel address in order to be accepted
	 */
	address public childTunnelAddress;

	/**
	 * @notice Counter of the amount of tokens locked in the tunnel
	 *
	 * @dev This is used to locate accidentally sent tokens which weren't bridged
	 */
	uint256 public lockedInTunnel;

	/**
	 * @notice Enables deposits on the tunnel (tunnel entrance)
	 *      note: withdrawals are always enabled and cannot be disabled
	 *
	 * @dev Feature FEATURE_ENTRANCE_OPEN must be enabled in order for
	 *      deposit functions (`deposit` and `depositTo`) to succeed
	 */
	uint32 public constant FEATURE_ENTRANCE_OPEN = 0x0000_0001;

	/**
	 * @notice People do mistakes and may send tokens by mistake
	 *
	 * @notice Rescue manager is responsible for "rescuing" ERC20/ERC721 tokens
	 *      accidentally sent to the smart contract
	 *
	 * @dev Role ROLE_RESCUE_MANAGER allows withdrawing non-bridged ERC20/ERC721
	 *      tokens stored on the smart contract balance via `rescueTokens` function
	 */
	uint32 public constant ROLE_RESCUE_MANAGER = 0x0001_0000;

	/**
	 * @dev Fired in `lzReceive` when token withdrawal completes successfully
	 *
	 * @param stateId unique tx identifier submitted from the child chain (L2)
	 * @param from token sender address in the child chain (L2)
	 * @param to token receiver address in the root chain (L1)
	 * @param value amount of tokens withdrawn
	 */
	event WithdrawalComplete(uint256 indexed stateId, address indexed from, address indexed to, uint256 value);

	/**
	 * @dev Fired in `deposit` and `depositTo`
	 *
	 * @param from token sender address in the root chain (L1)
	 * @param to token receiver address in the child chain (L2)
	 * @param value amount of tokens deposited
	 */
	event DepositInitiated(address indexed from, address indexed to, uint256 value);

	/**
	 * @dev "Constructor replacement" for upgradeable, must be execute immediately after deployment
	 *      see https://docs.openzeppelin.com/upgrades-plugins/1.x/writing-upgradeable#initializers
	 *
	 * @dev Initializes an Ethereum network (L1) exit bound to
	 *      LayerZero Endpoint, and root ERC20 token
	 * @dev LayerZero Endpoint is a helper contract providing
	 *      L1/L2 messaging infrastructure, managed by the LayerZero
	 *
	 * @param _lzEndpoint LayerZero Endpoint contract address (maintained by LayerZero)
	 * @param _rootToken root ERC20 token address
	 */
	function postConstruct(address _lzEndpoint, address _rootToken) public initializer {
		// execute parent initializer
		_postConstruct(msg.sender);

		// verify the inputs are set
		require(_lzEndpoint != address(0), "LZ endpoint not set");
		require(_rootToken != address(0), "root token not set");

		// initialize contract internal state
		__NonblockingUpgradeableLzApp_init(_lzEndpoint);
		rootToken = ERC20(_rootToken);
	}

	/**
	 * @dev Sets the childTunnel if it is not yet set
	 *
	 * @param _childTunnelChainId child tunnel chain ID to set
	 * @param _childTunnelAddress child tunnel address to set
	 */
	function setChildTunnel(uint16 _childTunnelChainId, address _childTunnelAddress) public {
		// `setChildTunnel` must be executed during the deployment process by
		// the same account which is making a deployment (full admin)
		require(isSenderInRole(type(uint256).max), "access denied");

		// verify the chain ID is set (not zero)
		require(_childTunnelChainId != 0, "zero chain ID");
		// verify the address is set (not zero)
		require(_childTunnelAddress != address(0), "zero address");

		// verify the address is not yet set on the contract
		require(childTunnelChainId == 0 && childTunnelAddress == address(0), "child tunnel already set");

		// set the tunnel
		childTunnelChainId = _childTunnelChainId;
		childTunnelAddress = _childTunnelAddress;

		// propagate the setup to `LzAppUpgradeable`
		_setTrustedRemote(childTunnelChainId, abi.encodePacked(_childTunnelAddress, address(this)));
	}

	/**
	 * @notice L1 Tunnel Exit.
	 *      Exit is always open.
	 *
	 * @dev Auxiliary function which can be executed only within the smart contract itself
	 *      Effectively private (internal) as it is not callable by other contracts or EOAs
	 *
	 * @dev Wrapped by the ILayerZeroReceiver lzReceive catching any error and logging it
	 *      See `ILayerZeroReceiver.lzReceive`
	 */
	function _nonblockingLzReceive(uint16, bytes memory, uint64 _nonce, bytes memory _payload) internal override {
		// decode the message from the child
		// format: sender, recipient, amount
		(address _from, address _to, uint256 _value) = abi.decode(_payload, (address, address, uint256));

		// unlock the tokens from the contract by transferring them to the recipient
		rootToken.transfer(_to, _value);

		// update locked tokens counter
		lockedInTunnel -= _value;

		// emit an event
		emit WithdrawalComplete(_nonce, _from, _to, _value);
	}

	/**
	 * @notice L1 Tunnel Entrance.
	 *      Entrance can be closed/opened by the tunnel manager.
	 *
	 * @notice Initiates the deposit from the root chain (L1) to the child chain (L2)
	 *      to the same address which initiated the deposit process
	 *
	 * @notice The process is finalized in the child chain (L2) via the
	 *      `ERC20ChildTunnel.lzReceive` without the user/initiator participation
	 *
	 * @notice User pays for the deposit message delivery in native currency.
	 *      The amount to be payed can be estimated with `estimateDepositFee`
	 *
	 * @notice Specified amount of tokens is transferred into the tunnel and locked,
	 *      user needs to make sure this amount is approved for transfer
	 *
	 * @param _value amount of tokens to deposit
	 */
	function deposit(uint256 _value) public payable {
		// delegate to `depositTo`
		depositTo(msg.sender, _value);
	}

	/**
	 * @notice L1 Tunnel Entrance.
	 *      Entrance can be closed/opened by the tunnel manager.
	 *
	 * @notice Initiates the deposit from L1 to L2
	 *
	 * @notice The process is finalized in the child chain (L2) via the
	 *      `ERC20ChildTunnel.lzReceive` without user/initiator participation
	 *
	 * @notice User pays for the deposit message delivery in native currency.
	 *      The amount to be payed can be estimated with `estimateDepositFee`
	 *
	 * @notice Specified amount of tokens is transferred into the tunnel and locked,
	 *      user needs to make sure this amount is approved for transfer
	 *
	 * @param _to token recipient in the child chain (in L2)
	 * @param _value amount of tokens to deposit
	 */
	function depositTo(address _to, uint256 _value) public payable {
		// verify tunnel entrance is open
		require(isFeatureEnabled(FEATURE_ENTRANCE_OPEN), "entrance closed");

		// lock the tokens in the contract by transferring them from sender
		// in general one should check the return value of ERC20 transfer
		// we work here only with ERC20 implementations throwing on any error
		rootToken.transferFrom(msg.sender, address(this), _value);

		// notify the L2 about the deposit
		__depositNotify(msg.sender, _to, _value);
	}

	/**
	 * @dev Notifies the L2 about the initiated deposit
	 *
	 * @dev Unsafe: doesn't verify the executor (msg.sender) permissions,
	 *      must be kept private at all times
	 *
	 * @param _from token sender in the root chain (in L1)
	 * @param _to token recipient in the child chain (in L2)
	 * @param _value amount of tokens deposited
	 */
	function __depositNotify(address _from, address _to, uint256 _value) private {
		// update locked tokens counter
		lockedInTunnel += _value;

		// send a message to the child tunnel about the deposit made
		// format: sender, recipient, amount
		__sendMessageToChild(abi.encode(_from, _to, _value));

		// emit an event
		emit DepositInitiated(_from, _to, _value);
	}

	/**
	 * @notice Estimates the token transfer fee from L1 to L2; this should be supplied
	 *      as a transaction value into deposit/depositTo
	 *
	 * @param _from token sender in the root chain (in L1)
	 * @param _to token recipient in the child chain (in L2)
	 * @param _value amount of tokens withdrawn
	 * @return token transfer fee in wei
	 */
	function estimateDepositFee(address _from, address _to, uint256 _value) public view returns (uint256) {
		// delegate to `__estimateMessageFee`
		return __estimateMessageFee(abi.encode(_from, _to, _value));
	}

	/**
	 * @dev Estimates the message transfer fee from L1 to L2; this should be supplied
	 *      as a transaction value into deposit/depositTo
	 *
	 * @param message to deliver from the root chain (L1) into the child chain (L2)
	 * @return message transfer fee in wei
	 */
	function __estimateMessageFee(bytes memory message) private view returns (uint256) {
		// delegate to `__estimateMessageFee`
		return __estimateMessageFee(childTunnelChainId, message);
	}

	/**
	 * @dev Auxiliary function to send the token transfer message from
	 *      the root chain (L1) into the child chain (L2)
	 *
	 * @dev Evaluates the message transfer fee and tries to supply this fee
	 *      Throws if sender didn't supply enough value to cover the fee
	 *      Returns any excess of the funds sent back to sender
	 *      (all of the above happens in LZ code, see UltraLightNode)
	 *
	 * @param message the message to send
	 */
	function __sendMessageToChild(bytes memory message) private {
		// delegate to `__sendMessageToRoot`
		__sendMessageTo(childTunnelChainId, message);
	}

	/**
	 * @dev Restricted access function to rescue accidentally sent tokens,
	 *      the tokens are rescued via `transferFrom` function call on the
	 *      contract address specified and with the parameters specified:
	 *      `_contract.transferFrom(this, _to, _value)`
	 *
	 * @dev Requires executor to have `ROLE_RESCUE_MANAGER` permission
	 *
	 * @param _contract smart contract address to execute `transfer` function on
	 * @param _to to address in `transferFrom(this, _to, _value)`
	 * @param _value value to transfer in `transferFrom(this, _to, _value)`;
	 *      this can also be a tokenId for ERC721 transfer
	 */
	function rescueToken(address _contract, address _to, uint256 _value) public {
		// verify the access permission
		require(isSenderInRole(ROLE_RESCUE_MANAGER), "access denied");

		// verify tokens are not locked in tunnel
		require(
			_contract != address(rootToken) || _value + lockedInTunnel <= rootToken.balanceOf(address(this)),
			"locked in tunnel"
		);

		// perform the transfer as requested, without any checks
		require(ERC20(_contract).transferFrom(address(this), _to, _value));
	}
}
