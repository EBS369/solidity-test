// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

abstract contract RewardsDistributionRecipient {
    address public rewardsDistribution;

    function claimRewardAmount(uint256 _reward, uint256 _duration)
        external
        virtual;

    function setRewardsDistribution(address _rewardsDistribution)
        external
        onlyRewardsDistribution
    {
        rewardsDistribution = _rewardsDistribution;
    }

    modifier onlyRewardsDistribution() {
        require(
            msg.sender == rewardsDistribution,
            "Caller is not RewardsDistribution contract"
        );
        _;
    }
}
