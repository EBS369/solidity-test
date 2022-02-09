// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStakingRewards {
    // Views
    function balanceOf(address _account) external view returns (uint256);

    function earned(address _account) external view returns (uint256);

    function getRewardForDuration() external view returns (uint256);

    function getTotalSupply() external view returns (uint256);

    function lastTimeRewardApplicable() external view returns (uint256);

    function rewardPerToken() external view returns (uint256);

    function viewLockingTimeStamp(address _account)
        external
        view
        returns (uint256);

    // Mutative
    function getReward() external;

    function quit() external;

    function stake(uint256 _amount) external;

    function stakeTransferWithBalance(uint256 _amount, address _account)
        external;

    function withdraw(uint256 _amount) external;
}
