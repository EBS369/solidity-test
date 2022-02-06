## Live (AVAX Fuji Testnet)

### Yield Farm
https://testnet.snowtrace.io/address/0x85918a27e6157307df4185b157d87f9b484214a9
#### Deploy TX
https://testnet.snowtrace.io/tx/0xcb93fb9e9232c185aafa8a81c5838496096c42c4eb7c3b206f421878718b5a50

### LP ($AVAX-$NEW)
https://testnet.snowtrace.io/address/0xd11ee576a8c4c5a27cc833cae4fb5030f27f3673

## Enhancements

1. Should tighten function modifiers
2. Emit events when appropriate (consider gas fees)
3. Irrelevant branching should be removed
4. Should have only 1 contract per .sol file
5. Variables should have naming convention (_ / __ prefix | no prefix) to distinguish local variables and global variables (variable shadowing)
6. claimRewardAmount() need not be inherited from RewardsDistributionRecipient
7. Recovery for tokens sent to contract
8. finalize() method (debug only)
9. Use Ownable
10. Use OpenZeppelin library for factory
11. ~~array for loop is gas expensive, consider alternatives (EnumerableSet)~~ unnecessary as the array is small
12. uint256 should not be needed as loop counter, consider uint

## Critical

1. Should implement all functions from interface when inheriting
2. Reentrancy protection on state modifying functions
3. Should not allow user to set locking timestamp manually
4. Wrong viewLockingTimeStamp() signature, should include address parameter since lookup source is a map[address]uint256
5. Setter for rewardDuration is needed
6. Premine with genesis check missing in factory constructor
