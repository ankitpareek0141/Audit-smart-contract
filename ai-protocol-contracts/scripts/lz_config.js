// see https://layerzero.gitbook.io/docs/evm-guides/ua-custom-configuration#how-to-configure
const ua_config_types = {
	inboundProofLibraryVersion: 1,
	inboundBlockConfirmations: 2,
	relayer: 3,
	outboundProofType: 4,
	outboundBlockConfirmations: 5,
	oracle: 6,
};

// used to determine the network to configure user app (UA)
const target_network = {
	"mainnet": "binance",
	"goerli": "binance_testnet",
	"binance": "mainnet",
	"binance_testnet": "goerli",
};

// see https://layerzero.gitbook.io/docs/technical-reference/testnet/testnet-addresses
// see https://layerzero.gitbook.io/docs/technical-reference/mainnet/supported-chain-ids
const chain_ids = {
	"mainnet": 101,
	"goerli": 10121,
	"binance": 102,
	"binance_testnet": 10102,
}

// export all the constants
module.exports = {
	ua_config_types,
	target_network,
	chain_ids,
};
