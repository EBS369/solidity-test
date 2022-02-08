// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./IStakingRewards.sol";
import "./RewardsDistributionRecipient.sol";

contract StakingRewards is
    IStakingRewards,
    RewardsDistributionRecipient,
    Pausable,
    ReentrancyGuard
{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /* ========== STATE VARIABLES ========== */
    IERC20 public rewardsToken;
    IERC20 public stakingToken;
    uint256 public periodFinish = 0;
    uint256 public lockingPeriod = 5 days;
    uint256 public rewardRate = 0;
    uint256 public rewardsDuration = 5 days;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 private totalSupply;
    mapping(address => uint256) private balances;
    mapping(address => uint256) private lockingTimeStamp;

    /* ========== CONSTRUCTOR ========== */
    constructor(
        address _rewardsDistribution,
        address _rewardsToken,
        address _stakingToken
    ) Ownable() {
        rewardsToken = IERC20(_rewardsToken);
        stakingToken = IERC20(_stakingToken);
        rewardsDistribution = _rewardsDistribution;
    }

    /* ========== VIEWS ========== */
    function balanceOf(address _account)
        external
        view
        override
        returns (uint256)
    {
        return balances[_account];
    }

    function earned(address _account) public view override returns (uint256) {
        return
            balances[_account]
                .mul(rewardPerToken().sub(userRewardPerTokenPaid[_account]))
                .div(1e18)
                .add(rewards[_account]);
    }

    function getRewardForDuration() external view override returns (uint256) {
        return rewardRate.mul(rewardsDuration);
    }

    function getTotalSupply() external view override returns (uint256) {
        return totalSupply;
    }

    function lastTimeRewardApplicable() public view override returns (uint256) {
        return Math.min(block.timestamp, periodFinish);
    }

    function rewardPerToken() public view override returns (uint256) {
        if (totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.add(
                lastTimeRewardApplicable()
                    .sub(lastUpdateTime)
                    .mul(rewardRate)
                    .mul(1e18)
                    .div(totalSupply)
            );
    }

    function viewLockingTimeStamp(address _account)
        external
        view
        override
        returns (uint256)
    {
        return lockingTimeStamp[_account];
    }

    /* ========== MUTATIVE FUNCTIONS ========== */
    function stake(uint256 _amount)
        external
        override
        nonReentrant
        updateReward(msg.sender)
    {
        require(_amount > 0, "Nothing to stake");
        // TODO Front-end: Warn locking period reset if stake already exists
        totalSupply = totalSupply.add(_amount);
        balances[msg.sender] = balances[msg.sender].add(_amount);
        lockingTimeStamp[msg.sender] = lockingPeriod.add(block.timestamp);
        stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
        emit Staked(msg.sender, _amount);
    }

    function stakeTransferWithBalance(uint256 _amount, address _account)
        external
        override
        nonReentrant
        updateReward(_account)
    {
        require(_amount > 0, "Nothing to stake");
        // Intentionally revert if stake already exists (lockingTimeStamp reset attack?)
        require(
            block.timestamp >= lockingTimeStamp[msg.sender],
            "Time lock is still in place"
        );
        totalSupply = totalSupply.add(_amount);
        balances[_account] = balances[_account].add(_amount);
        lockingTimeStamp[_account] = lockingPeriod.add(block.timestamp);
        stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
        emit Staked(_account, _amount);
    }

    function withdraw(uint256 _amount)
        public
        override
        nonReentrant
        updateReward(msg.sender)
    {
        require(_amount > 0, "Nothing to withdraw");
        require(
            block.timestamp >= lockingTimeStamp[msg.sender],
            "Time lock is still in place"
        );
        totalSupply = totalSupply.sub(_amount);
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        stakingToken.safeTransfer(msg.sender, _amount);
        emit Withdrawn(msg.sender, _amount);
    }

    function getReward() public override nonReentrant updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function quit() external override {
        withdraw(balances[msg.sender]);
        getReward();
    }

    /* ========== RESTRICTED FUNCTIONS ========== */
    function claimRewardAmount(uint256 _reward, uint256 _duration)
        external
        override
        onlyRewardsDistribution
        updateReward(address(0))
    {
        require(
            block.timestamp.add(_duration) >= periodFinish,
            "Cannot reduce existing period"
        );

        if (block.timestamp >= periodFinish) {
            rewardRate = _reward.div(_duration);
        } else {
            uint256 remaining = periodFinish.sub(block.timestamp);
            uint256 leftover = remaining.mul(rewardRate);
            rewardRate = _reward.add(leftover).div(_duration);
        }

        uint256 balance = rewardsToken.balanceOf(address(this));
        require(
            rewardRate <= balance.div(_duration),
            "Provided reward too high"
        );

        periodFinish = block.timestamp.add(_duration);
        lastUpdateTime = block.timestamp;
        emit RewardAdded(_reward, periodFinish);
    }

    function setRewardsDuration(uint256 _duration) external onlyOwner {
        require(
            block.timestamp >= periodFinish,
            "Existing rewards period incomplete"
        );
        rewardsDuration = _duration;
        emit rewardsDurationUpdated(rewardsDuration);
    }

    function recoverLostNetworkToken() external onlyOwner {
        uint256 _amount = address(this).balance;
        payable(owner()).transfer(_amount);
        emit Recovered(
            address(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE),
            owner(),
            _amount
        );
    }

    function recoverLostTokenERC20(address _token, uint256 _amount)
        external
        onlyOwner
    {
        IERC20(_token).safeTransferFrom(address(this), owner(), _amount);
        emit Recovered(_token, owner(), _amount);
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    /* ========== MODIFIERS ========== */
    modifier updateReward(address _account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (_account != address(0)) {
            rewards[_account] = earned(_account);
            userRewardPerTokenPaid[_account] = rewardPerTokenStored;
        }
        _;
    }

    /* ========== EVENTS ========== */
    event RewardAdded(uint256 _reward, uint256 _periodFinish);
    event rewardsDurationUpdated(uint256 _duration);
    event Staked(address indexed _user, uint256 _amount);
    event Withdrawn(address indexed _user, uint256 _amount);
    event RewardPaid(address indexed _user, uint256 _reward);
    event Recovered(
        address indexed _tokenAddress,
        address indexed _to,
        uint256 _amount
    );
}
