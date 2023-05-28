const MedicosTrackingManager = artifacts.require("MedicosTrackingManager");

module.exports = function (deployer) {
  deployer.deploy(MedicosTrackingManager);
};
