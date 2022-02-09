# Solidity Test
The repairing of [a broken Solidity smart contract project](https://github.com/EBS369/solidity-test/commit/636d68088199400193bf53757a2bbeefeb62febd)

## Status
Awaiting time pass genesis time to fund StakingRewards (2022/02/09 (YYYY/MM/DD) Wednesday 14:30 HKT)

## Live (AVAX Fuji Testnet)

### Staking Rewards Factory Contract & TX
https://testnet.snowtrace.io/tx/0xcff852102d4827e821f63f85d396eff80c03a3f1a1f36bd276471058e0cdeaee
https://testnet.snowtrace.io/address/0xedec25c8fe78286e0bc8ae7825b2de0fc3375d50#code

### Staking Rewards ($AVAX-$NEW LP) Contract & TX - Stake LP for LP
https://testnet.snowtrace.io/tx/0x3ad250b0346cb9ba855d77e71207fc87e71372179fdab5795e9171ceec1fcebb
https://testnet.snowtrace.io/address/0x5aa2c93589b2ec986f0465c62aabb4d692bac213#code

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
