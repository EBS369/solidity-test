# Solidity Test
The repairing of [a broken Solidity smart contract project](https://github.com/EBS369/solidity-test/commit/636d68088199400193bf53757a2bbeefeb62febd)

## Status
Functional

## Live (AVAX Fuji Testnet)

### Staking Rewards Factory Contract & TX
https://testnet.snowtrace.io/address/0xc190ea9803f93c2e0f9c82f68cc6dbad053e8928#code

#### Deploy Staking Rewards Factory
https://testnet.snowtrace.io/tx/0x79f618676769cd977516ae691d02d8f0f20cb02c725968a139e05b770984e4fb

#### Deploy Staking Rewards
https://testnet.snowtrace.io/tx/0x262c9e37377755d8c153aee5b788888a5f719c13c102020c2b45233676c747d3

#### Fund Staking Rewards Factory
https://testnet.snowtrace.io/tx/0xeb66902924525ee105df412967196144dd5f2969acce415ca89618aa5eae415b

#### Fund Staking Rewards
https://testnet.snowtrace.io/tx/0x65bebc0a973f5a471ebf4e6653402b5acf74282ca506c8fb08905794551b71c6

### Staking Rewards ($AVAX-$NEW LP) Contract & TX - Stake LP for LP
https://testnet.snowtrace.io/address/0x55de80bafa027222dff69090c6b9bfc4bbdad90b#code

#### Stake
https://testnet.snowtrace.io/tx/0x9732b57edc74424f3687b3bbd3c3a91af447365f3cc0abf39009f8f8b402917c
https://testnet.snowtrace.io/tx/0x88faacfe26caa0da82f82fc140aa4ac3ff40fccf1f3335c76b46363d1047ab30

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
