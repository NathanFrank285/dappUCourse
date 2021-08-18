pragma solidity ^0.5.0;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;

    address[] public stakers;
    mapping (address => uint) public stakingBalance;
    mapping (address => bool) public hasStaked;
    mapping (address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
    }

    // 1. Stake tokens, put money into the app, deposit
    function stakeTokens(uint _amount) public {
        // transfer mock dai to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // update staking balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // Add user to stakers array *only* if they havent staked already
        if(!hasStaked[msg.sender]){
            stakers.push(msg.sender);
        }

        // update the staking status
        hasStaked[msg.sender] = true;
        isStaking[msg.sender] = true;
    }

    // 2. Unstake tokens, take money from the app, withdraw


    // 3. Issuing tokens, earn interest from staking


}
