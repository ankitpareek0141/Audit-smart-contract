[91m
LzERC20ChildTunnelV1.__sendMessageToRoot(bytes) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#393-415) sends eth to arbitrary user
	Dangerous calls:
	- lzEndpoint.send{value: fee}(rootTunnelChainId,abi.encodePacked(rootTunnelAddress,address(this)),message,address(msg.sender),address(0),bytes()) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#401-408)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations[0m
[91m
ERC1967UpgradeUpgradeable._functionDelegateCall(address,bytes) (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#208-214) uses delegatecall to a input-controlled function id
	- (success,returndata) = target.delegatecall(data) (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#212)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#controlled-delegatecall[0m
[91m
UpgradeableAccessControl.__gap (../../share/contracts/utils/UpgradeableAccessControl.sol#77) shadows:
	- UUPSUpgradeable.__gap (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol#81)
	- ERC1967UpgradeUpgradeable.__gap (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#215)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variable-shadowing[0m
[93m
LzERC20ChildTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#216) is a local variable never initialized
LzERC20ChildTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason_scope_0 (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#221) is a local variable never initialized
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#uninitialized-local-variables[0m
[92m
postConstruct(address,address) should be declared external:
	- LzERC20ChildTunnelV1.postConstruct(address,address) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#164-175)
setRootTunnel(uint16,address) should be declared external:
	- LzERC20ChildTunnelV1.setRootTunnel(uint16,address) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#183-199)
lzReceive(uint16,bytes,uint64,bytes) should be declared external:
	- LzERC20ChildTunnelV1.lzReceive(uint16,bytes,uint64,bytes) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#207-225)
withdraw(uint256) should be declared external:
	- LzERC20ChildTunnelV1.withdraw(uint256) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#301-304)
estimateWithdrawalFee(address,address,uint256) should be declared external:
	- LzERC20ChildTunnelV1.estimateWithdrawalFee(address,address,uint256) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#360-363)
setConfig(uint16,uint16,uint256,bytes) should be declared external:
	- LzERC20ChildTunnelV1.setConfig(uint16,uint16,uint256,bytes) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#430-436)
setSendVersion(uint16) should be declared external:
	- LzERC20ChildTunnelV1.setSendVersion(uint16) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#448-454)
setReceiveVersion(uint16) should be declared external:
	- LzERC20ChildTunnelV1.setReceiveVersion(uint16) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#466-472)
forceResumeReceive(uint16,bytes) should be declared external:
	- LzERC20ChildTunnelV1.forceResumeReceive(uint16,bytes) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#485-491)
rescueToken(address,address,uint256) should be declared external:
	- LzERC20ChildTunnelV1.rescueToken(address,address,uint256) (../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#506-512)
getImplementation() should be declared external:
	- UpgradeableAccessControl.getImplementation() (../../share/contracts/utils/UpgradeableAccessControl.sol#146-149)
updateFeatures(uint256) should be declared external:
	- UpgradeableAccessControl.updateFeatures(uint256) (../../share/contracts/utils/UpgradeableAccessControl.sol#172-175)
isFeatureEnabled(uint256) should be declared external:
	- UpgradeableAccessControl.isFeatureEnabled(uint256) (../../share/contracts/utils/UpgradeableAccessControl.sol#255-258)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#public-function-that-could-be-declared-external[0m
[91m
LzERC20RootTunnelV1.__sendMessageToChild(bytes) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#422-444) sends eth to arbitrary user
	Dangerous calls:
	- lzEndpoint.send{value: fee}(childTunnelChainId,abi.encodePacked(childTunnelAddress,address(this)),message,address(msg.sender),address(0),bytes()) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#430-437)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations[0m
[91m
ERC1967UpgradeUpgradeable._functionDelegateCall(address,bytes) (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#208-214) uses delegatecall to a input-controlled function id
	- (success,returndata) = target.delegatecall(data) (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#212)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#controlled-delegatecall[0m
[91m
UpgradeableAccessControl.__gap (../../share/contracts/utils/UpgradeableAccessControl.sol#77) shadows:
	- UUPSUpgradeable.__gap (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol#81)
	- ERC1967UpgradeUpgradeable.__gap (../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#215)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#state-variable-shadowing[0m
[91m
LzERC20RootTunnelV1.__lzReceive(uint16,bytes,uint64,bytes) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#252-289) ignores return value by rootToken.transfer(_to,_value) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#282)
LzERC20RootTunnelV1.depositTo(address,uint256) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#345-356) ignores return value by rootToken.transferFrom(msg.sender,address(this),_value) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#352)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#unchecked-transfer[0m
[93m
LzERC20RootTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason_scope_0 (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#239) is a local variable never initialized
LzERC20RootTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#234) is a local variable never initialized
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#uninitialized-local-variables[0m
[92m
postConstruct(address,address) should be declared external:
	- LzERC20RootTunnelV1.postConstruct(address,address) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#182-193)
setChildTunnel(uint16,address) should be declared external:
	- LzERC20RootTunnelV1.setChildTunnel(uint16,address) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#201-217)
lzReceive(uint16,bytes,uint64,bytes) should be declared external:
	- LzERC20RootTunnelV1.lzReceive(uint16,bytes,uint64,bytes) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#225-243)
deposit(uint256) should be declared external:
	- LzERC20RootTunnelV1.deposit(uint256) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#322-325)
estimateDepositFee(address,address,uint256) should be declared external:
	- LzERC20RootTunnelV1.estimateDepositFee(address,address,uint256) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#389-392)
setConfig(uint16,uint16,uint256,bytes) should be declared external:
	- LzERC20RootTunnelV1.setConfig(uint16,uint16,uint256,bytes) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#459-465)
setSendVersion(uint16) should be declared external:
	- LzERC20RootTunnelV1.setSendVersion(uint16) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#477-483)
setReceiveVersion(uint16) should be declared external:
	- LzERC20RootTunnelV1.setReceiveVersion(uint16) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#495-501)
forceResumeReceive(uint16,bytes) should be declared external:
	- LzERC20RootTunnelV1.forceResumeReceive(uint16,bytes) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#514-520)
rescueToken(address,address,uint256) should be declared external:
	- LzERC20RootTunnelV1.rescueToken(address,address,uint256) (../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#535-547)
getImplementation() should be declared external:
	- UpgradeableAccessControl.getImplementation() (../../share/contracts/utils/UpgradeableAccessControl.sol#146-149)
updateFeatures(uint256) should be declared external:
	- UpgradeableAccessControl.updateFeatures(uint256) (../../share/contracts/utils/UpgradeableAccessControl.sol#172-175)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#public-function-that-could-be-declared-external[0mSummary
 - [arbitrary-send](#arbitrary-send) (2 results) (High)
 - [controlled-delegatecall](#controlled-delegatecall) (2 results) (High)
 - [shadowing-state](#shadowing-state) (2 results) (High)
 - [uninitialized-local](#uninitialized-local) (4 results) (Medium)
 - [external-function](#external-function) (25 results) (Optimization)
 - [unchecked-transfer](#unchecked-transfer) (2 results) (High)
## arbitrary-send
Impact: High
Confidence: Medium
 - [ ] ID-0
[LzERC20ChildTunnelV1.__sendMessageToRoot(bytes)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L393-L415) sends eth to arbitrary user
	Dangerous calls:
	- [lzEndpoint.send{value: fee}(rootTunnelChainId,abi.encodePacked(rootTunnelAddress,address(this)),message,address(msg.sender),address(0),bytes())](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L401-L408)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L393-L415


 - [ ] ID-1
[LzERC20RootTunnelV1.__sendMessageToChild(bytes)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L422-L444) sends eth to arbitrary user
	Dangerous calls:
	- [lzEndpoint.send{value: fee}(childTunnelChainId,abi.encodePacked(childTunnelAddress,address(this)),message,address(msg.sender),address(0),bytes())](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L430-L437)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L422-L444


## controlled-delegatecall
Impact: High
Confidence: Medium
 - [ ] ID-2
[ERC1967UpgradeUpgradeable._functionDelegateCall(address,bytes)](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L208-L214) uses delegatecall to a input-controlled function id
	- [(success,returndata) = target.delegatecall(data)](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L212)

../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L208-L214


 - [ ] ID-3
[ERC1967UpgradeUpgradeable._functionDelegateCall(address,bytes)](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L208-L214) uses delegatecall to a input-controlled function id
	- [(success,returndata) = target.delegatecall(data)](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L212)

../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L208-L214


## shadowing-state
Impact: High
Confidence: High
 - [ ] ID-4
[UpgradeableAccessControl.__gap](../../share/contracts/utils/UpgradeableAccessControl.sol#L77) shadows:
	- [UUPSUpgradeable.__gap](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol#L81)
	- [ERC1967UpgradeUpgradeable.__gap](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L215)

../../share/contracts/utils/UpgradeableAccessControl.sol#L77


 - [ ] ID-5
[UpgradeableAccessControl.__gap](../../share/contracts/utils/UpgradeableAccessControl.sol#L77) shadows:
	- [UUPSUpgradeable.__gap](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol#L81)
	- [ERC1967UpgradeUpgradeable.__gap](../../share/node_modules/@openzeppelin/contracts-upgradeable/proxy/ERC1967/ERC1967UpgradeUpgradeable.sol#L215)

../../share/contracts/utils/UpgradeableAccessControl.sol#L77


## uninitialized-local
Impact: Medium
Confidence: Medium
 - [ ] ID-6
[LzERC20ChildTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason_scope_0](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L221) is a local variable never initialized

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L221


 - [ ] ID-7
[LzERC20ChildTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L216) is a local variable never initialized

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L216


 - [ ] ID-8
[LzERC20RootTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L234) is a local variable never initialized

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L234


 - [ ] ID-9
[LzERC20RootTunnelV1.lzReceive(uint16,bytes,uint64,bytes).reason_scope_0](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L239) is a local variable never initialized

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L239


## external-function
Impact: Optimization
Confidence: High
 - [ ] ID-10
updateFeatures(uint256) should be declared external:
	- [UpgradeableAccessControl.updateFeatures(uint256)](../../share/contracts/utils/UpgradeableAccessControl.sol#L172-L175)

../../share/contracts/utils/UpgradeableAccessControl.sol#L172-L175


 - [ ] ID-11
getImplementation() should be declared external:
	- [UpgradeableAccessControl.getImplementation()](../../share/contracts/utils/UpgradeableAccessControl.sol#L146-L149)

../../share/contracts/utils/UpgradeableAccessControl.sol#L146-L149


 - [ ] ID-12
rescueToken(address,address,uint256) should be declared external:
	- [LzERC20ChildTunnelV1.rescueToken(address,address,uint256)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L506-L512)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L506-L512


 - [ ] ID-13
setReceiveVersion(uint16) should be declared external:
	- [LzERC20ChildTunnelV1.setReceiveVersion(uint16)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L466-L472)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L466-L472


 - [ ] ID-14
isFeatureEnabled(uint256) should be declared external:
	- [UpgradeableAccessControl.isFeatureEnabled(uint256)](../../share/contracts/utils/UpgradeableAccessControl.sol#L255-L258)

../../share/contracts/utils/UpgradeableAccessControl.sol#L255-L258


 - [ ] ID-15
withdraw(uint256) should be declared external:
	- [LzERC20ChildTunnelV1.withdraw(uint256)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L301-L304)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L301-L304


 - [ ] ID-16
estimateWithdrawalFee(address,address,uint256) should be declared external:
	- [LzERC20ChildTunnelV1.estimateWithdrawalFee(address,address,uint256)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L360-L363)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L360-L363


 - [ ] ID-17
setRootTunnel(uint16,address) should be declared external:
	- [LzERC20ChildTunnelV1.setRootTunnel(uint16,address)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L183-L199)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L183-L199


 - [ ] ID-18
lzReceive(uint16,bytes,uint64,bytes) should be declared external:
	- [LzERC20ChildTunnelV1.lzReceive(uint16,bytes,uint64,bytes)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L207-L225)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L207-L225


 - [ ] ID-19
postConstruct(address,address) should be declared external:
	- [LzERC20ChildTunnelV1.postConstruct(address,address)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L164-L175)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L164-L175


 - [ ] ID-20
setSendVersion(uint16) should be declared external:
	- [LzERC20ChildTunnelV1.setSendVersion(uint16)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L448-L454)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L448-L454


 - [ ] ID-21
setConfig(uint16,uint16,uint256,bytes) should be declared external:
	- [LzERC20ChildTunnelV1.setConfig(uint16,uint16,uint256,bytes)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L430-L436)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L430-L436


 - [ ] ID-22
forceResumeReceive(uint16,bytes) should be declared external:
	- [LzERC20ChildTunnelV1.forceResumeReceive(uint16,bytes)](../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L485-L491)

../../share/contracts/layer_zero/LzERC20ChildTunnelV1.sol#L485-L491


 - [ ] ID-23
updateFeatures(uint256) should be declared external:
	- [UpgradeableAccessControl.updateFeatures(uint256)](../../share/contracts/utils/UpgradeableAccessControl.sol#L172-L175)

/share/contracts/layer_zero analyzed (26 contracts with 45 detectors), 37 result(s) found

../../share/contracts/utils/UpgradeableAccessControl.sol#L172-L175


 - [ ] ID-24
getImplementation() should be declared external:
	- [UpgradeableAccessControl.getImplementation()](../../share/contracts/utils/UpgradeableAccessControl.sol#L146-L149)

../../share/contracts/utils/UpgradeableAccessControl.sol#L146-L149


 - [ ] ID-25
setConfig(uint16,uint16,uint256,bytes) should be declared external:
	- [LzERC20RootTunnelV1.setConfig(uint16,uint16,uint256,bytes)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L459-L465)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L459-L465


 - [ ] ID-26
setSendVersion(uint16) should be declared external:
	- [LzERC20RootTunnelV1.setSendVersion(uint16)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L477-L483)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L477-L483


 - [ ] ID-27
forceResumeReceive(uint16,bytes) should be declared external:
	- [LzERC20RootTunnelV1.forceResumeReceive(uint16,bytes)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L514-L520)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L514-L520


 - [ ] ID-28
lzReceive(uint16,bytes,uint64,bytes) should be declared external:
	- [LzERC20RootTunnelV1.lzReceive(uint16,bytes,uint64,bytes)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L225-L243)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L225-L243


 - [ ] ID-29
rescueToken(address,address,uint256) should be declared external:
	- [LzERC20RootTunnelV1.rescueToken(address,address,uint256)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L535-L547)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L535-L547


 - [ ] ID-30
deposit(uint256) should be declared external:
	- [LzERC20RootTunnelV1.deposit(uint256)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L322-L325)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L322-L325


 - [ ] ID-31
estimateDepositFee(address,address,uint256) should be declared external:
	- [LzERC20RootTunnelV1.estimateDepositFee(address,address,uint256)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L389-L392)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L389-L392


 - [ ] ID-32
postConstruct(address,address) should be declared external:
	- [LzERC20RootTunnelV1.postConstruct(address,address)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L182-L193)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L182-L193


 - [ ] ID-33
setReceiveVersion(uint16) should be declared external:
	- [LzERC20RootTunnelV1.setReceiveVersion(uint16)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L495-L501)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L495-L501


 - [ ] ID-34
setChildTunnel(uint16,address) should be declared external:
	- [LzERC20RootTunnelV1.setChildTunnel(uint16,address)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L201-L217)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L201-L217


## unchecked-transfer
Impact: High
Confidence: Medium
 - [ ] ID-35
[LzERC20RootTunnelV1.__lzReceive(uint16,bytes,uint64,bytes)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L252-L289) ignores return value by [rootToken.transfer(_to,_value)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L282)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L252-L289


 - [ ] ID-36
[LzERC20RootTunnelV1.depositTo(address,uint256)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L345-L356) ignores return value by [rootToken.transferFrom(msg.sender,address(this),_value)](../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L352)

../../share/contracts/layer_zero/LzERC20RootTunnelV1.sol#L345-L356


