// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./StakingRewards.sol";

contract StakingRewardsFactory is Ownable, Pausable {
    using SafeERC20 for IERC20;
    using SafeMath for uint256;

    /* ========== STATE VARIABLES ========== */
    address public rewardsToken;
    uint256 public stakingRewardsGenesis; // genesis unix epoch

    address[] public stakingTokens;

    struct StakingRewardsInfo {
        address stakingRewards;
        uint256 rewardAmount;
        uint256 duration;
    }

    mapping(address => StakingRewardsInfo)
        public stakingRewardsInfoByStakingToken;

    /* ========== CONSTRUCTOR ========== */
    constructor(address _rewardsToken, uint256 _stakingRewardsGenesis)
        Ownable()
    {
        require(
            _stakingRewardsGenesis >= block.timestamp,
            "StakingRewardsFactory::constructor: genesis too soon"
        );
        rewardsToken = _rewardsToken;
        stakingRewardsGenesis = _stakingRewardsGenesis;
    }

    /* ========== RESTRICTED FUNCTIONS ========== */
    function deploy(
        address _stakingToken,
        uint256 _rewardAmount,
        uint256 _rewardsDuration
    ) public onlyOwner {
        StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[
            _stakingToken
        ];
        require(
            info.stakingRewards == address(0),
            "StakingRewardsFactory::deploy: already deployed"
        );

        info.stakingRewards = address(
            new StakingRewards(address(this), rewardsToken, _stakingToken)
        );
        info.rewardAmount = _rewardAmount;
        info.duration = _rewardsDuration;
        stakingTokens.push(_stakingToken);
    }

    function update(
        address _stakingToken,
        uint256 _rewardAmount,
        uint256 _rewardsDuration
    ) public onlyOwner {
        StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[
            _stakingToken
        ];
        require(
            info.stakingRewards != address(0),
            "StakingRewardsFactory::deploy: not deployed"
        );

        info.stakingRewards = address(
            new StakingRewards(address(this), rewardsToken, _stakingToken)
        );
        info.rewardAmount = _rewardAmount;
        info.duration = _rewardsDuration;
        //stakingTokens.push(_stakingToken);
    }

    function setRewardsDuration(address _stakingToken, uint256 _duration)
        external
        onlyOwner
    {
        StakingRewards(_stakingToken).setRewardsDuration(_duration);
    }

    function recoverLostNetworkTokenFromStakingRewards(address _stakingToken)
        external
        onlyOwner
    {
        StakingRewards(_stakingToken).recoverLostNetworkToken();
    }

    function recoverLostTokenERC20FromStakingRewards(
        address _stakingToken,
        address _token,
        uint256 _amount
    ) external onlyOwner {
        StakingRewards(_stakingToken).recoverLostTokenERC20(_token, _amount);
    }

    function pause(address _stakingToken) external onlyOwner {
        StakingRewards(_stakingToken).pause();
    }

    function unpause(address _stakingToken) external onlyOwner {
        StakingRewards(_stakingToken).unpause();
    }

    function recoverLostNetworkToken() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function recoverLostTokenERC20(address _token, uint256 _amount)
        external
        onlyOwner
    {
        IERC20(_token).safeTransfer(owner(), _amount);
    }

    /* ========== MODIFIERS ========== */
    function notifyRewardAmounts() public whenNotPaused {
        require(
            stakingTokens.length > 0,
            "StakingRewardsFactory::notifyRewardAmounts: called before any deploys"
        );
        for (uint256 i = 0; i < stakingTokens.length; i++) {
            notifyRewardAmount(stakingTokens[i]);
        }
    }

    function notifyRewardAmount(address _stakingToken) public whenNotPaused {
        require(
            block.timestamp >= stakingRewardsGenesis,
            "StakingRewardsFactory::notifyRewardAmount: too soon"
        );

        StakingRewardsInfo storage info = stakingRewardsInfoByStakingToken[
            _stakingToken
        ];
        require(
            info.stakingRewards != address(0),
            "StakingRewardsFactory::notifyRewardAmount: not deployed"
        );

        if (info.rewardAmount > 0 && info.duration > 0) {
            uint256 rewardAmount = info.rewardAmount;
            uint256 duration = info.duration;

            info.rewardAmount = 0;
            info.duration = 0;

            require(
                // TODO ensure rewardsToken transfer returns bool
                IERC20(rewardsToken).transfer(
                    info.stakingRewards,
                    rewardAmount
                ),
                "StakingRewardsFactory::notifyRewardAmount: transfer failed"
            );
            StakingRewards(info.stakingRewards).notifyRewardAmount(
                rewardAmount,
                duration
            );
        }
    }
}
