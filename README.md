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

1. Use lowest privilege accessibility function modifiers
2. Do not modify contract state with modifier
3. Use global variable vs local variable naming conventions
4. Do not introduce irrelevant branching
5. Only one contract per Solidity file
7. Consider LP / rebase token as staking receipt
8. Minimal deposit amount (i.e. 1e16 for 0.01 of 18 decimal token)

## Critical

1. Unimplemented inherited functions (StakingRewards)
2. Missing reentrancy protections
3. Unimplemented locking timestamp
4. Missing checks
5. Locking timestamp setter exposed to user
6. viewLockingTimeStamp() should accept an user address
7. Locking timestamp attack @ stakeTransferWithBalance
8. Unimplemented / Partially implemented lost token recovery
9. Pause contract (Unprotected Public & External functions)
