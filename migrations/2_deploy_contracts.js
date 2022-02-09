const StakingRewardsFactory = artifacts.require("StakingRewardsFactory")
const fs = require('fs');

module.exports = function (deployer) {
    REWARDS_TOKEN = "0xd11ee576a8c4c5a27cc833cae4fb5030f27f3673"; // $AVAX-$NEW LP
    STAKING_REWARDS_GENESIS = 1644390000; //  2022/02/09 (YYYY/MM/DD) Wednesday 15:00 HKT

    deployer.deploy(StakingRewardsFactory, REWARDS_TOKEN, STAKING_REWARDS_GENESIS);

    const contract = JSON.parse(fs.readFileSync('./build/contracts/StakingRewardsFactory.json', 'utf8'));
    console.log(JSON.stringify(contract.abi));
}
