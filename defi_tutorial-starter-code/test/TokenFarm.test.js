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

  describe('contract has tokens', async () => {
    it('has a name', async ()=>{
      const name = await dappToken.name()
      assert.equal(name, 'DApp Token')
    })
  })


  })
