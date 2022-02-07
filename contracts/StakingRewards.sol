// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
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
    Ownable,
    Pausable,
    ReentrancyGuard
{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    /* ========== STATE VARIABLES ========== */
    IERC20 public rewardsToken;
    IERC20 public stakingToken;
    uint256 public periodFinish = 0;
    uint256 public rewardRate = 0;
    uint256 public rewardDuration = 7 days;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    uint256 private _totalSupply;
    mapping(address => uint256) private _balances;
    mapping(address => uint256) private _lockingTimeStamp;

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
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function lastTimeRewardApplicable() public view override returns (uint256) {
        return Math.min(block.timestamp, periodFinish);
    }

    function rewardPerToken() public view override returns (uint256) {
        if (_totalSupply == 0) {
            return rewardPerTokenStored;
        }
        return
            rewardPerTokenStored.add(
                lastTimeRewardApplicable()
                    .sub(lastUpdateTime)
                    .mul(rewardRate)
                    .mul(1e18)
                    .div(_totalSupply)
            );
    }

    function earned(address account) public view override returns (uint256) {
        return
            _balances[account]
                .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
                .div(1e18)
                .add(rewards[account]);
    }

    function getRewardForDuration() public view override returns (uint256) {
        return rewardDuration;
    }

    function viewLockingTimeStamp(address account)
        public
        view
        override
        returns (uint256)
    {
        return _lockingTimeStamp[account];
    }

    /* ========== MUTATIVE FUNCTIONS ========== */
    function stake(uint256 amount)
        public
        override
        nonReentrant
        updateReward(msg.sender)
    {
        require(_lockingTimeStamp[msg.sender] <= 0);
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        _lockingTimeStamp[msg.sender] = 0;
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(msg.sender, amount);
    }

    function stakeTransferWithBalance(uint256 amount, address account)
        public
        override
        nonReentrant
        updateReward(account)
    {
        require(_balances[account] <= 0, "Already staked by user");
        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        _lockingTimeStamp[account] = 0;
        stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        emit Staked(account, amount);
    }

    function withdraw(uint256 amount)
        public
        override
        nonReentrant
        updateReward(msg.sender)
    {
        require(amount > 0, "Nothing to withdraw");
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        stakingToken.safeTransfer(msg.sender, amount);
        emit Withdrawn(msg.sender, amount);
    }

    function getReward() public override nonReentrant updateReward(msg.sender) {
        uint256 reward = rewards[msg.sender];
        if (reward > 0) {
            rewards[msg.sender] = 0;
            rewardsToken.safeTransfer(msg.sender, reward);
            emit RewardPaid(msg.sender, reward);
        }
    }

    function quit() public override {
        withdraw(_balances[msg.sender]);
        getReward();
    }

    /* ========== RESTRICTED FUNCTIONS ========== */
    function claimRewardAmount(uint256 reward, uint256 duration)
        external
        onlyRewardsDistribution
        updateReward(address(0))
    {
        require(
            block.timestamp.add(duration) >= periodFinish,
            "Cannot reduce existing period"
        );

        if (block.timestamp >= periodFinish) {
            rewardRate = reward.div(duration);
        } else {
            uint256 remaining = periodFinish.sub(block.timestamp);
            uint256 leftover = remaining.mul(rewardRate);
            rewardRate = reward.add(leftover).div(duration);
        }

        uint256 balance = rewardsToken.balanceOf(address(this));
        require(
            rewardRate <= balance.div(duration),
            "Provided reward too high"
        );

        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp.add(duration);
        emit RewardAdded(reward, periodFinish);
    }

    function setRewardsDuration(uint256 duration) external onlyOwner {
        require(
            block.timestamp >= periodFinish,
            "Existing rewards period incomplete"
        );
        rewardDuration = duration;
        emit RewardDurationUpdated(rewardDuration);
    }

    function recoverLostNetworkToken() public onlyOwner {
        uint256 _amount = address(this).balance;
        payable(owner()).transfer(_amount);
        emit Recovered(
            0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE,
            owner(),
            _amount
        );
    }

    function recoverLostTokenERC20(address _token, uint256 _amount)
        public
        onlyOwner
    {
        IERC20(_token).safeTransferFrom(address(this), owner(), _amount);
        emit Recovered(_token, owner(), _amount);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function finalize() public onlyOwner {
        selfdestruct(payable(owner()));
    }

    /* ========== MODIFIERS ========== */
    modifier updateReward(address account) {
        rewardPerTokenStored = rewardPerToken();
        lastUpdateTime = lastTimeRewardApplicable();
        if (account != address(0)) {
            rewards[account] = earned(account);
            userRewardPerTokenPaid[account] = rewardPerTokenStored;
        }
        _;
    }

    /* ========== EVENTS ========== */
    event RewardAdded(uint256 reward, uint256 periodFinish);
    event RewardDurationUpdated(uint256 duration);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event Recovered(
        address indexed tokenAddress,
        address indexed to,
        uint256 amount
    );
}
