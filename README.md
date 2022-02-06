## Enhancements

1. Should tighten function modifiers
2. Emit events when appropriate (consider gas fees)
3. Irrelevant branching should be removed
4. Should have only 1 contract per .sol file

## Critical

1. Should implement all functions from interface when inheriting
2. Reentrancy protection on state modifying functions
3. Should not allow user to set locking timestamp manually
4. Wrong viewLockingTimeStamp() signature, should include address parameter since lookup source is a map[address]uint256
