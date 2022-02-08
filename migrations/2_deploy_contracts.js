const StakingRewardsFactory = artifacts.require("StakingRewardsFactory")
module.exports = function (deployer) {
    REWARDS_TOKEN = "";
    REWARDS_GENESIS = 1644346800; // 9th Feb 2022 03:00 HKT
    deployer.deploy(StakingRewardsFactory, REWARDS_TOKEN, REWARDS_GENESIS);
}