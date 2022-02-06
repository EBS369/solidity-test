// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./IStakingRewards.sol";
import "./RewardsDistributionRecipient.sol";

contract StakingRewards is
  IStakingRewards,
  RewardsDistributionRecipient,
  ReentrancyGuard
{
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  /* ========== STATE VARIABLES ========== */
  IERC20 public rewardsToken;
  IERC20 public stakingToken;
  uint256 public periodFinish = 0;
  uint256 public rewardRate = 0;
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
  ) {
    rewardsToken = IERC20(_rewardsToken);
    stakingToken = IERC20(_stakingToken);
    rewardsDistribution = _rewardsDistribution;
  }

  /* ========== VIEWS ========== */

  function totalSupply() external view override returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address account) external view override returns (uint256) {
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
          .mul(1e24)
          .div(periodFinish)
      );
  }

  function earned(address account) public view override returns (uint256) {
    return
      _balances[account]
        .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
        .div(1e24)
        .add(rewards[account]);
  }

  function viewLockingTimeStamp(address account) public view override returns (uint256) {
    return _lockingTimeStamp[account];
  }

  /* ========== MUTATIVE FUNCTIONS ========== */

  function stake(uint256 amount)
    external
    override
    updateReward(msg.sender)
  {
    require(_lockingTimeStamp[msg.sender] <= 0);
    _totalSupply = _totalSupply.add(amount);
    _balances[msg.sender] = _balances[msg.sender].add(amount);
    _lockingTimeStamp[msg.sender] = 0;
    stakingToken.safeTransferFrom(msg.sender, address(this), amount);
    emit Staked(msg.sender, amount);
  }

  function stakeTransferWithBalance(
    uint256 amount,
    address useraddress,
    uint256 lockingPeriod
  ) external updateReward(useraddress) {
    require(_balances[useraddress] <= 0, "Already staked by user");
    _totalSupply = _totalSupply.add(amount);
    _balances[useraddress] = _balances[useraddress].add(amount);
    _lockingTimeStamp[useraddress] = lockingPeriod; // setting user locking ts
    stakingToken.safeTransferFrom(msg.sender, address(this), amount);
    emit Staked(useraddress, amount);
  }

  function withdraw(uint256 amount)
    public
    override
    nonReentrant
    updateReward(msg.sender)
  {
    if (_lockingTimeStamp[msg.sender] > 0) {
      _totalSupply = _totalSupply.sub(amount);
      _balances[msg.sender] = _balances[msg.sender].sub(amount);
      stakingToken.safeTransfer(msg.sender, amount);
      emit Withdrawn(msg.sender, amount);
    } else if (_lockingTimeStamp[msg.sender] <= 0) {
      _totalSupply = _totalSupply.sub(amount);
      _balances[msg.sender] = _balances[msg.sender].sub(amount);
      stakingToken.safeTransfer(msg.sender, amount);
      emit Withdrawn(msg.sender, amount);
    }
  }

  function getReward() public override updateReward(msg.sender) {
    uint256 reward = rewards[msg.sender];
    if (reward > 0) {
      rewards[msg.sender] = 0;
      rewardsToken.safeTransfer(msg.sender, reward);
      emit RewardPaid(msg.sender, reward);
    }
  }

  function quit() external override {
    withdraw(_balances[msg.sender]);
    getReward();
  }

  /* ========== RESTRICTED FUNCTIONS ========== */

  function claimRewardAmount(uint256 reward, uint256 rewardsDuration)
    external
    override
    onlyRewardsDistribution
    updateReward(address(0))
  {
    require(
      block.timestamp.add(rewardsDuration) >= periodFinish,
      "Cannot reduce existing period"
    );

    if (block.timestamp >= periodFinish) {
      rewardRate = reward.div(rewardsDuration);
    } else {
      uint256 remaining = periodFinish.sub(block.timestamp);
      uint256 leftover = remaining.mul(rewardRate);
      rewardRate = reward.add(leftover).div(rewardsDuration);
    }

    uint256 balance = rewardsToken.balanceOf(address(this));
    require(
      rewardRate <= balance.div(rewardsDuration),
      "Provided reward too high"
    );

    lastUpdateTime = block.timestamp;
    periodFinish = block.timestamp.add(rewardsDuration);
    emit RewardAdded(reward, periodFinish);
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

  event DefaultInitialization();
  event RewardAdded(uint256 reward, uint256 periodFinish);
  event Staked(address indexed user, uint256 amount);
  event Withdrawn(address indexed user, uint256 amount);
  event RewardPaid(address indexed user, uint256 reward);
  event Recovered(
        address indexed tokenAddress,
        address indexed to,
        uint256 amount
  );
}