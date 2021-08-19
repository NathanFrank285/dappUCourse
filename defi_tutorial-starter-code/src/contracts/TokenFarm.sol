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

    //! my implementation
    // function unstakeTokens(uint _amount) public {
    //     require(stakingBalance[msg.sender] > 0, 'Cannot unstake 0 tokens');
    //     require(_amount <= stakingBalance[msg.sender], 'you cannot remove more than you are staking');

    //     // transfer tokens back to the user
    //     daiToken.transfer(payable(msg.sender), _amount);

    //     // update user's staking balance
    //     stakingBalance[msg.sender] = stakingBalance[msg.sender] - _amount;

    //     if (stakingBalance[msg.sender] == 0) {
    //         isStaking[msg.sender] = false;
    //     }

    // }

    function unstakeTokens(uint _amount) public {
        // fetch staking balance from the contract
        uint balance = stakingBalance[msg.sender];

        // Require amount to be > 0
        require(balance > 0, 'cannot withdraw 0 tokens');

        // Transfer the Mock Dai back to the caller
        daiToken.transfer(msg.sender, balance);

        // Reset staking balance
        stakingBalance[msg.sender] = 0;

        // Set isStaking to false
        isStaking[msg.sender] = false;

    }


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
