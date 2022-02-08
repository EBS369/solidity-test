const StakingRewardsFactory = artifacts.require("StakingRewardsFactory")
module.exports = function (deployer) {
    REWARDS_TOKEN = "0xd11ee576a8c4c5a27cc833cae4fb5030f27f3673"; // LP Rewards
    REWARDS_GENESIS = 1644346800; // 2/9/2022 03:00 HKT
    deployer.deploy(StakingRewardsFactory, REWARDS_TOKEN, REWARDS_GENESIS);
}