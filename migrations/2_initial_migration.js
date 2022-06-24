const PermitToken = artifacts.require("PermitToken");

module.exports = function (deployer) {
  deployer.deploy(PermitToken);
};
