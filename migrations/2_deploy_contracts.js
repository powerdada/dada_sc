var ConvertLib = artifacts.require("./ConvertLib.sol");
var DadaCollectible = artifacts.require("./DadaCollectible.sol");
module.exports = function(deployer) {
  deployer.deploy(ConvertLib);
  deployer.link(ConvertLib, DadaCollectible);
  deployer.deploy(DadaCollectible);
};
