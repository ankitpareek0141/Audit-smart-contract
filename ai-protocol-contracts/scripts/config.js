// import BigNumber BN from web3
const {BN} = require("web3-utils");

// deployed smart contract addresses configuration defines which
// smart contracts require deployment and which are already deployed
// empty address means smart contract requires deployment

// a collection of all known addresses (smart contracts and external), deployment settings
const Config = ((network) => {
	switch(network) {
		// Mainnet Configuration
		case "mainnet":
			return {
				// ALI ERC20 v2
				AliERC20v2: "0x6B0b3a982b4634aC68dD83a4DBF02311cE324181",
				// where initial ALI token supply goes to
				ALI_H0: "0x0738F702D1a7364d356729Cb8845701885C487A1",
				// Personality Pod ERC721
				PersonalityPodERC721: "0xDd70AF84BA86F29bf437756B655110D134b5651C",
				// The Revenants NFT (AletheaNFT)
				TheRevenants: "0xc2D6B32E533e7A8dA404aBb13790a5a2F606aD75",
				// iNFT v2
				IntelligentNFTv2: "0xa189121eE045AEAA8DA80b72F7a1132e3B216237",
				// iNFT Linker
				IntelliLinker: "0x365B6813Bc993748708EDc62AF72FDDfA1B50D7b",
				// 10k Sale (or Restricted Sale)
				FixedSupplySale: "0xf56F453054a104Dafcff4aA9c0CF16936A3A0Cb6",
				// Personality Minter (OpenSea Factory Implementation for PersonalityPodERC721)
				PersonalityMinter: "0x86758d1c5aB95FF324F7E0b2cDEc38c86eebe768", // 0xd04Ae66aEa0b7f74157b1dab957B0C927D71B679
				// option ID ranges for the Personality Minter
				PERSONALITY_OPTIONS: [101, 8109, 8909, 8989],
				// Authorized OpenSea NFT Minter address which mints tokens via the Minter/Factory
				OPENSEA_MINTER_ADDR: "0xa5409ec958C83C3f309868babACA7c86DCB077c1",
				// 1,012 Personality Pod Airdrop contract
				PersonalityDrop: "0x3bDd5Ed3532d2BeD52e299e21BeCCD506a8d6258",
				// Personality Staking (NFT Staking)
				PersonalityStaking: "0xAbEffb353dae4A177057e9a3e4A663386cF54758",
				// Sophia beingAI iNFT (AletheaNFT)
				SophiaBeing: "0x75c804fFb01b16B7592a0B9644835244E2140728",
				// "Arkive" Mystery Box (AletheaNFT)
				ArkiveERC721: "0xcE69a87C02bAA8C5F17Ed7eB8B1C2657aFC2E1aF",
				// "Arkive" Mystery Box Minter (OpenSea Factory Implementation for Arkive)
				ArkiveMinter: "0x437684F7357BddA8328e629EAa595c9F23060AaC",
				// option ID ranges for the "Arkive" Mystery Box Minter
				ARKIVE_OPTIONS: [1, 9001],
				// "Arkive" Airdrop contract
				ArkiveDrop: "0xF5194433bde2beCE5c3ac294EcA78a1126c169CF",
				// iNFT Linker v2 (Upgradeable) – Implementation
				IntelliLinkerV2Impl: "0x8DcC656FDb71Ffc9813f809FDbf4f29c1cED9f85",
				// iNFT Linker v2 (Upgradeable) – Proxy (ERC1967)
				IntelliLinkerV2Proxy: "0xB9F02FC926b2ab66CAdd6eA1Ee90FB0D8698790b",
			};
		// Rinkeby Configuration
		case "rinkeby":
			return {
				// 0x6aa7f44D404A38cC9d9eB5E6f3e7E25305E2ed39 // Kovan
				// ALI ERC20 v2
				AliERC20v2: "0x088effA8E63DF55F3736f04ED25581326f9798BA",
				// 0xEd6003e7A6494Db4ABabEB7bDf994A3951ac6e69 // Kovan
				// where initial ALI token supply goes to
				ALI_H0: "0x5F185Da55f7BBD9217E3b3CeE06b180721FA6d34",
				// Personality Pod ERC721
				PersonalityPodERC721: "0x88F4F4c6F5390D47b5F40c80025477CC24B86031",
				// The Revenants NFT (AletheaNFT)
				TheRevenants: "0x1B8fC14101A0fABb01b0422C7eecfDDA840246cE",
				// iNFT v2
				IntelligentNFTv2: "0x7CA09B3016327061E14e154Fb6dc1997F774C0Ff",
				// iNFT Linker
				IntelliLinker: "0x27eC121D2edc32815399Ce80822382eabf4f549C",
				// 10k Sale (or Restricted Sale)
				FixedSupplySale: "0x0A70c6b844425f844cF5b46725c7f92F26fa2F17",
				// Personality Minter (OpenSea Factory Implementation for PersonalityPodERC721)
				PersonalityMinter: "0x76145954700D7744c4FbC81Fe7312969cFAA2Df4",
				// option ID ranges for the Personality Minter
				PERSONALITY_OPTIONS: [101, 8109, 8909, 8989],
				// Authorized OpenSea NFT Minter address which mints tokens via the Minter/Factory
				OPENSEA_MINTER_ADDR: "0xF57B2c51dED3A29e6891aba85459d600256Cf317",
				// 1,012 Personality Pod Airdrop contract
				PersonalityDrop: "0x58774C8E2ba92D885398A282Ed7Cbd7a283fad8d",
				// Personality Staking (NFT Staking)
				PersonalityStaking: "0xb020C909328945581D70D065CE17C977986d4ccA",
				// Sophia beingAI iNFT (AletheaNFT)
				SophiaBeing: "0x051384C9d3E068048e60519f42770Af54b2A9294",
				// "Arkive" Mystery Box (AletheaNFT)
				ArkiveERC721: "0x8c70E036263CEf079b64db312f2fFCeAe4F211cD",
				// "Arkive" Mystery Box Minter (OpenSea Factory Implementation for Arkive)
				ArkiveMinter: "0x4cED34703b371da2CBD402c43D8a99d48Cb187F3",
				// option ID ranges for the "Arkive" Mystery Box Minter
				ARKIVE_OPTIONS: [1, 10_001],
				// "Arkive" Airdrop contract
				ArkiveDrop: "0x0d44f2dAfEA28F4d2056d6078aeE022f7a0DA7c4",
				// iNFT Linker v2 (Upgradeable) – Implementation
				IntelliLinkerV2Impl: "0x9e6c9C703633D1c5F48960A378751142f2191C4A",
				// iNFT Linker v2 (Upgradeable) – Proxy (ERC1967)
				IntelliLinkerV2Proxy: "0x65D4BCfEAac707a1CdC7e72D9286038167f3836A",
			};
		// Görli (matic/polygon L1 testnet - goerli) Configuration
		case "goerli":
			return {
				// ALI ERC20 v2
				AliERC20v2: "0x3ACd26F0b5080C30c066a2055A4254A5BB05F22a",
				// where initial ALI token supply goes to
				ALI_H0: "0x5F185Da55f7BBD9217E3b3CeE06b180721FA6d34",
				// Personality Pod ERC721
				PersonalityPodERC721: "0x785b1246E57b9f72C6bb19e5aC3178aEffb0Fe73",
				// The Revenants NFT (AletheaNFT)
				TheRevenants: "0x8920Df4215934E5f6c8935F0049E9b9d8dDF3656",
				// iNFT v2
				IntelligentNFTv2: "0x63d49c8D35C9fB523515756337cef0991B304696",
				// iNFT Linker
				IntelliLinker: "0x761A2430FA69158c24Cb92CE4bc5d55F82931911",
				// 10k Sale (or Restricted Sale)
				FixedSupplySale: "0x307015ef34a1baEb9Bf6fcbED03611235Bdd01aD",
				// 1,012 Personality Pod Airdrop contract
				PersonalityDrop: "0xb638410212e8D22630c224BE0B038b4c8c78ea8A",
				// Personality Staking (NFT Staking)
				PersonalityStaking: "0x70d0f35dd27BC79303A2eAfD30db419742d6FaF9",
				// Sophia beingAI iNFT (AletheaNFT)
				SophiaBeing: "0xC6729C6cFc6B872acF641EB3EA628C9F038e5ABb",
				// iNFT Linker v2 (Upgradeable) – Implementation
				IntelliLinkerV2Impl: "0xB8F89a404f8777945a36c119d3A75e522Db3576e",
				// iNFT Linker v2 (Upgradeable) – Proxy (ERC1967)
				IntelliLinkerV2Proxy: "0xbF3Df254b65e527b20c255947E627f6856ff743B",
			};
		// Polygon Mainnet Configuration
		case "polygon":
			return {
				// Polygon ALI ERC20 v2
				PolygonAliERC20v2: "0xbfc70507384047aa74c29cdc8c5cb88d0f7213ac",
				// Polygon Character (WhitelabelNFT)
				PolygonCharacter: "0x89612559086c6A6C298603142091a4633c4b3e33",
				// Polygon Character Factory (NFTFactory, mints Polygon Character)
				CharacterFactory: "0xaC70A3A292B7C9539FD1c7a8d1CA2aE43E24b80B",
			};
		// Alternative Polygon Mainnet Configuration
		// Used for Polygon tests in the Mainnnet
		case "polygon2":
			return {
				// Polygon ALI ERC20 v2
				PolygonAliERC20v2: "0xD8EE3E8E84798125eC820336380C3aa83DD6923D",
				// Polygon Character (WhitelabelNFT)
				PolygonCharacter: "0x74a845ADC5A0487887Ccc6437cCA2Ee2E5Ee8a8B",
				// Polygon Character Factory (NFTFactory, mints Polygon Character)
				CharacterFactory: "0x4F08873580939bA69794DA22169057847AC2B87c",
			};
		// mumbai (matic/polygon L1 testnet - mumbai) Configuration
		case "mumbai":
			return {
				// Polygon ALI ERC20 v2
				PolygonAliERC20v2: "0x6F9d04BACFcb5fa14035160Cf77B9972334298eD",
				// Polygon Character (WhitelabelNFT)
				PolygonCharacter: "0xb9dC34976c110b53837DEfE0051bdDfF0c9364E4",
				// Polygon Character Factory (NFTFactory, mints Polygon Character)
				CharacterFactory: "0x6a0426233BC2965e99F2441Ed1b20C9E7e773B1C",
			};
		// any other network is not supported
		default:
			throw "unknown network " + network;
	}
});

module.exports = Config;
