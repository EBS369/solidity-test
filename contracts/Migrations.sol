// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Migrations {
    address public owner;

    // A function with the signature `last_completed_migration()`, returning a uint, is required.
    uint256 public last_completed_migration;

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    constructor() {
        owner = msg.sender;
    }

    // A function with the signature `setCompleted(uint)` is required.
    function setCompleted(uint256 _completed) public restricted {
        last_completed_migration = _completed;
    }

    function upgrade(address _new_address) public restricted {
        Migrations upgraded = Migrations(_new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
