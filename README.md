## Live (AVAX Fuji Testnet)

### Yield Farm
https://testnet.snowtrace.io/address/0x85918a27e6157307df4185b157d87f9b484214a9
#### Deploy TX
https://testnet.snowtrace.io/tx/0xcb93fb9e9232c185aafa8a81c5838496096c42c4eb7c3b206f421878718b5a50
https://testnet.snowtrace.io/tx/0xa3a579d47ac5ac252f5745c10fbf4ba20a4ed53549226b7485bc3d1bee2a1a6d

### LP ($AVAX-$NEW)
https://testnet.snowtrace.io/address/0xd11ee576a8c4c5a27cc833cae4fb5030f27f3673

## Enhancements

1. Minimal accessibility function modifiers
2. Emit events vs Gas optimization
3. Remove irrelevant branching
4. One contract per Solidity file
5. Global variable vs Local variable naming conventions, to prevent variable shadowing
6. No need to inherit claimRewardAmount function from RewardsDistributionRecipient
7. ~~Contract destruction finalize()~~
8. Proxy contract for contract upgrade?
9. Lost token recovery
10. ~~Avoid for loops on array~~ neglectable in this case

## Critical

1. Should implement all functions from interface when inheriting
2. Reentrancy protection on state modifying functions
3. Should not allow user to set locking timestamp manually
4. Wrong viewLockingTimeStamp() signature, should include address parameter since lookup source is a map[address]uint256
5. Setter for rewardDuration is needed
6. Premine with genesis check missing in factory constructor
