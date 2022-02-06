const StakingRewardsFactory = artifacts.require("StakingRewardsFactory")
module.exports = function (deployer) {
    REWARDS_TOKEN = "0xd11ee576a8c4c5a27cc833cae4fb5030f27f3673";
    REWARDS_GENESIS = 1644192000; // 2-7 8 HKT
    deployer.deploy(StakingRewardsFactory, REWARDS_TOKEN, REWARDS_GENESIS);
}