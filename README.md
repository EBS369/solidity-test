# Solidity Test
The repairing of [a broken Solidity smart contract project](https://github.com/EBS369/solidity-test/commit/636d68088199400193bf53757a2bbeefeb62febd)

## Status
StakingRewards: Implemented\
Factory: Awaiting time pass genesis time to fund StakingRewards (2022/02/09 (YYYY/MM/DD) Wednesday 17:00 HKT)

## Live (AVAX Fuji Testnet)

### Staking Rewards Factory Contract & TX
https://testnet.snowtrace.io/tx/0x0862af2bbf531f052c0b82e73665e2005c0056a3fb823ff5a90d62bd108be11f
https://testnet.snowtrace.io/address/0xc586c88482776e3c36edc58430a3660d2af61dcc

### Staking Rewards ($AVAX-$NEW LP) Contract & TX - Stake LP for LP
https://testnet.snowtrace.io/tx/0x860b539f21e72290a6301800506213e3edeabf41dfb050a8110ebfce27a6a304
https://testnet.snowtrace.io/address/0x24b1d43f649aa7a724ac16d03e38df867d54f059#code

### LP ($AVAX-$NEW)
https://testnet.snowtrace.io/address/0xd11ee576a8c4c5a27cc833cae4fb5030f27f3673

## Enhancements

1. Lowest privilege accessibility function modifiers
2. ~~Emit events vs Gas optimization~~
3. Remove irrelevant branching
4. One contract per Solidity file
5. Global variable vs Local variable naming conventions, to prevent variable shadowing
6. ~~No need to inherit claimRewardAmount function from RewardsDistributionRecipient~~
7. ~~Contract destruction finalize()~~
8. ~~Proxy contract for contract upgrade?~~
9. Lost token recovery
10. ~~Avoid for loops on array~~ neglectable in this case
11. Pause contract (Complete pause or withdraw pause?)
12. Do not modify contract state inside modifier
13. Intentionally revert if stake already exists (stakeTransferWithBalance), to prevent timelock reset attacks
14. ~~C3 linearization: Ownable RewardsDistributionRecipient, not Ownable StakingRewards, StakingRewards inherits RewardsDistributionRecipient~~
15. ~~Consider unifying Ownable and RewardsDistributionRecipient (Effectively 2 Ownables)~~
16. Delete expired mapping entries for gas refund
17. Consider building an LP alike token as receipt of deposit / staking (e.g. Beefy Finance)
18. Minimal deposit amount (e.g. 1e16 for 0.01 of an 18 decimal token)
19. Consider [clone factory pattern](https://blog.logrocket.com/creating-contract-factory-clone-solidity-smart-contracts/)
20. ~~Should deploy multiple StakingRewards instances in one factory deploy() call~~
21. claimRewardAmount should be notifyRewardAmount by convention

## Critical

1. All interface functions need implementation (StakingRewards)
2. Missing reentrancy attack protections
3. Locking timestamp setter should not be exposed to user
4. viewLockingTimeStamp() signature misses address parameter (mapping(address => uint256))
5. ~~rewardDuration setter is not included~~
6. A lot of missing "require" checks
7. Timelock was not implemented
