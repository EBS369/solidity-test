# Solidity Test
The repairing of [a broken Solidity smart contract project](https://github.com/EBS369/solidity-test/commit/636d68088199400193bf53757a2bbeefeb62febd)

## Status
Functional

## Live (AVAX Fuji Testnet)

### Staking Rewards Factory Contract & TX
https://testnet.snowtrace.io/tx/0xcff852102d4827e821f63f85d396eff80c03a3f1a1f36bd276471058e0cdeaee
https://testnet.snowtrace.io/address/0xedec25c8fe78286e0bc8ae7825b2de0fc3375d50#code

### Staking Rewards ($AVAX-$NEW LP) Contract & TX - Stake LP for LP
https://testnet.snowtrace.io/tx/0x3ad250b0346cb9ba855d77e71207fc87e71372179fdab5795e9171ceec1fcebb
https://testnet.snowtrace.io/address/0x5aa2c93589b2ec986f0465c62aabb4d692bac213#code

#### Funding (Staking Rewards)
https://testnet.snowtrace.io/tx/0xf451190342dcf43b29db5c621c931c2012e2f4359e8d9e8a09d0927be313991a

#### Staking (Staking Rewards)
https://testnet.snowtrace.io/tx/0x4e79c971c75c43fce04a53975a4ada3749c8ab55056c442f6cba056a6dc91170

### LP ($AVAX-$NEW)
https://testnet.snowtrace.io/address/0xd11ee576a8c4c5a27cc833cae4fb5030f27f3673

## Enhancements

1. Lowest privilege accessibility function modifiers
2. Remove irrelevant branching
3. One contract per Solidity file
4. Global variable vs Local variable naming conventions, to prevent variable shadowing
5. Lost token recovery
6. ~~Avoid for loops on array~~ neglectable in this case
7. Pause contract (Public & External functions)
8. Do not modify contract state inside modifier
9. Intentionally revert if stake already exists (stakeTransferWithBalance), to prevent timelock reset attacks
10. Unifying Ownable and RewardsDistributionRecipient
11. ~~Delete expired mapping entries for gas refund~~
12. Consider building an LP alike token as receipt of deposit / staking (e.g. Beefy Finance)
13. Minimal deposit amount (e.g. 1e16 for 0.01 of an 18 decimal token)
14. ~~Consider [clone factory pattern](https://blog.logrocket.com/creating-contract-factory-clone-solidity-smart-contracts/)~~
15. claimRewardAmount should be notifyRewardAmount by convention

## Critical

1. All interface functions need implementation (StakingRewards)
2. Missing reentrancy attack protections
3. Locking timestamp setter should not be exposed to user
4. viewLockingTimeStamp() signature misses address parameter (mapping(address => uint256))
5. ~~rewardDuration setter is not included~~
6. A lot of missing "require" checks
7. Timelock was not implemented
