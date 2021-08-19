pragma solidity ^0.5.0;

import "./DaiToken.sol";
import "./DappToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    address public owner;
    DappToken public dappToken;
    DaiToken public daiToken;

    address[] public stakers;
    mapping (address => uint) public stakingBalance;
    mapping (address => bool) public hasStaked;
    mapping (address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'caller must be the owner');
        _;
    }

    // 1. Stake tokens, put money into the app, deposit
    function stakeTokens(uint _amount) public {
        require(_amount > 0, 'amount must be more than 0');


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

    // Unstake tokens, take money from the app, withdraw


    // Issuing tokens, earn interest from staking
    function issueTokens() public  onlyOwner {

        // issue dappTokens to all stakers
        for (uint i = 0; i < stakers.length; i++) {
            address recipient = stakers[i];
            // find how many token the user has deposisted
            uint balance = stakingBalance[recipient];

            // use a 1 to 1 stakers
            if (balance > 0){
                dappToken.transfer(recipient, balance);
            }
        }
    }



}
