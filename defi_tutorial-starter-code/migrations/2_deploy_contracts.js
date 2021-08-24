const DappToken = artifacts.require("DappToken");
const DaiToken = artifacts.require("DaiToken");
const TokenFarm = artifacts.require("TokenFarm");

module.exports = async function(deployer, network, accounts) {

  // deploy mock DAI token
  await deployer.deploy(DaiToken);
  const daiToken = await DaiToken.deployed()

  // deploy DappToken
  await deployer.deploy(DappToken)
  const dappToken = await DappToken.deployed()



  await deployer.deploy(TokenFarm, dappToken.address, daiToken.address);
  const tokenFarm = await TokenFarm.deployed()

  // tranfer all tokens to TokenFarm (1mm)
  await dappToken.transfer(tokenFarm.address, "1000000000000000000000000");

  // Transfer 100 Mock Dai to investor
  await daiToken.transfer(accounts[1], "100000000000000000000");
};

