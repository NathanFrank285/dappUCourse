const { assert } = require('chai')

const DaiToken = artifacts.require('DaiToken')
const DappToken = artifacts.require('DappToken')
const TokenFarm = artifacts.require('TokenFarm')

require('chai')
  .use(require('chai-as-promised'))
  .should()

function tokens(amount) {
  return web3.utils.toWei(amount, "Ether");
}

contract('TokenFarm', ([owner, investor])=>{
  let daiToken, dappToken, tokenFarm

  before(async ()=> {
    // load contracts
    daiToken = await DaiToken.new()
    dappToken = await DappToken.new()
    tokenFarm = await TokenFarm.new(dappToken.address, daiToken.address)

    // Transfer all of teh Dapp tokens into the token farm
    await dappToken.transfer(tokenFarm.address, tokens('1000000'));

    // Send tokens to the investor, in the test we have to tell the function who is calling this function, which is accounts[0]
    await daiToken.transfer(investor, tokens('100'), {from: owner})

  })

  describe('Mock Dai Deployment', async () => {
    it('has a name', async ()=>{
      const name = await daiToken.name()
      assert.equal(name, 'Mock DAI Token')
    })
  })

  describe('Dapp Token Deployment', async () => {
    it('has a name', async ()=>{
      const name = await dappToken.name()
      assert.equal(name, 'DApp Token')
    })
  })

  describe('Token Farm Deployment', async () => {
    it('has a name', async ()=>{
      const name = await dappToken.name()
      assert.equal(name, 'DApp Token')
    })

    it('contract has tokens', async ()=>{
      let balance = await dappToken.balanceOf(tokenFarm.address)
      assert.equal(balance.toString(), tokens('1000000'))
    })

  })



  describe('Farming tokens', async ()=> {
    it('rewards investors for staking mDai tokens', async () => {
      let result;

      // check investor balance before staking
      result = await daiToken.balanceOf(investor)

      assert.equal(result.toString(), tokens('100'), 'investor Mock Dai wallet balance correct before staking')

      // Stake mock dai tokens
      await daiToken.approve(tokenFarm.address, tokens('100'), {from: investor})
      await tokenFarm.stakeTokens(tokens('100'), {from: investor})

      // check staking result
      result = await daiToken.balanceOf(investor)
      assert.equal(result.toString(), tokens('0'),'investor Mock Dai wallet balance correct after staking')

      // check staking result
      result = await daiToken.balanceOf(tokenFarm.address)
      assert.equal(result.toString(), tokens('100'),'Token Farm Mock Dai wallet balance correct after staking')

      // check that staking balance is correct
      result = await tokenFarm.stakingBalance(investor)
      assert.equal(result.toString(), tokens('100'),'investor staking balance correct after staking')

      // check that investor is staking
      result = await tokenFarm.isStaking(investor)
      assert.equal(result.toString(), 'true','investor staking status correct after staking')

      // Issue Tokens
      await tokenFarm.issueTokens({from: owner})

      //Check balances after issuance
      result = await dappToken.balanceOf(investor)
      assert.equal(result.toString(), tokens('100'),'investor Dapp Token wallet balance correct after issuance')

      // Ensure that only owner can issue DApp tokens
      await tokenFarm.issueTokens({from: investor}).should.be.rejected;


    })


  })




  })
