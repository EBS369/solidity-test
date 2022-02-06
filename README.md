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

## Critical

1. Should implement all functions from interface when inheriting
2. Reentrancy protection on state modifying functions
3. Should not allow user to set locking timestamp manually
4. Wrong viewLockingTimeStamp() signature, should include address parameter since lookup source is a map[address]uint256
5. Setter for rewardDuration is needed
