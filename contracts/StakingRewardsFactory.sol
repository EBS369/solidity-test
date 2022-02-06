// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./StakingRewards.sol";

contract StakingRewardsFactory is Ownable {

  address public rewardsToken;
  uint256 public stakingRewardsGenesis;

  address[] public stakingTokens;

  struct StakingRewardsInfo {
    address stakingRewards;
    uint256 rewardAmount;
    uint256 duration;
  }

  mapping(address => StakingRewardsInfo)
    public stakingRewardsInfoByStakingToken;

  constructor(address _rewardsToken, uint256 _stakingRewardsGenesis)
    Ownable()
  {

    rewardsToken = _rewardsToken;
    stakingRewardsGenesis = _stakingRewardsGenesis;
  }

  function deploy(
    address stakingToken,
    uint256 rewardAmount,
    uint256 rewardsDuration
  ) public  {
    StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[
      stakingToken
    ];
    require(
      info.stakingRewards == address(0),
      "StakingRewardsFactory::deploy: already deployed"
    );

    info.stakingRewards = address(
      new StakingRewards(address(this), rewardsToken, stakingToken)
    );
    info.rewardAmount = rewardAmount;
    info.duration = rewardsDuration;
    stakingTokens.push(stakingToken);
  }

  function update(
    address stakingToken,
    uint256 rewardAmount,
    uint256 rewardsDuration
  ) public onlyOwner {
    StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[
      stakingToken
    ];
    require(
      info.stakingRewards != address(0),
      "StakingRewardsFactory::update: not deployed"
    );

    info.rewardAmount = rewardAmount;
    info.duration = rewardsDuration;
  }

  function claimRewardAmounts() public {
    require(
      stakingTokens.length > 0,
      "StakingRewardsFactory::claimRewardAmounts: called before any deploys"
    );
    for (uint256 i = 0; i < stakingTokens.length; i++) {
      claimRewardAmount(stakingTokens[i]);
    }
  }

  function claimRewardAmount(address stakingToken) public {
    StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[
      stakingToken
    ];
    require(
      info.stakingRewards != address(0),
      "StakingRewardsFactory::claimRewardAmount: not deployed"
    );

    if (info.rewardAmount > 0 && info.duration > 0) {
      uint256 rewardAmount = info.rewardAmount;
      uint256 duration = info.duration;
      info.rewardAmount = 0;
      info.duration = 0;

      require(
        IERC20(rewardsToken).transfer(info.stakingRewards, rewardAmount),
        "StakingRewardsFactory::claimRewardAmount: transfer failed"
      );
      StakingRewards(info.stakingRewards).claimRewardAmount(
        rewardAmount,
        duration
      );
    }
  }

  function pullExtraTokens(address token, uint256 amount) external {
    IERC20(token).transfer(msg.sender, amount);
  }
}
