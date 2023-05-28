const MedicosTracking = artifacts.require("MedicosTracking");

module.exports = function (deployer) {
  deployer.deploy(MedicosTracking);
};
