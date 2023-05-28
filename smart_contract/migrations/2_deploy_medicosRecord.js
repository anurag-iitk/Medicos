const MedicosRecord = artifacts.require("MedicosRecord");

module.exports = function (deployer) {
  deployer.deploy(MedicosRecord);
};
