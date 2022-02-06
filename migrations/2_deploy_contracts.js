const StakingRewardsFactory = artifacts.require("StakingRewardsFactory")
module.exports = function (deployer) {
    REWARDS_TOKEN = "";
    REWARDS_GENESIS = 1644179708;
    deployer.deploy(StakingRewardsFactory, REWARDS_TOKEN, REWARDS_GENESIS);
}