const StakingRewardsFactory = artifacts.require("StakingRewardsFactory")
module.exports = function (deployer) {
    REWARDS_TOKEN = "0xC644559c6A788F4208331d82d7eb42c50c099aA7";
    REWARDS_GENESIS = 1644179708;
    deployer.deploy(StakingRewardsFactory, REWARDS_TOKEN, REWARDS_GENESIS);
}