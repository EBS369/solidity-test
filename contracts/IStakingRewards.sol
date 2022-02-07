// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStakingRewards {
    // Views
    function balanceOf(address account) external view returns (uint256);

    function earned(address account) external view returns (uint256);

    function getRewardForDuration() external view returns (uint256);

    function lastTimeRewardApplicable() external view returns (uint256);

    function rewardPerToken() external view returns (uint256);

    function totalSupply() external view returns (uint256);

    function viewLockingTimeStamp(address account)
        external
        view
        returns (uint256);

    // Mutative
    function getReward() external;

    function quit() external;

    function stake(uint256 amount) external;

    function stakeTransferWithBalance(uint256 amount, address user) external;

    function withdraw(uint256 amount) external;
}
