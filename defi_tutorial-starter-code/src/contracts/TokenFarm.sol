pragma solidity ^0.5.0;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;
    mapping (address => uint) public stakingBalance;

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
        
    }

    // 2. Unstake tokens, take money from the app, withdraw


    // 3. Issuing tokens, earn interest from staking


}
