const MedicosRecordManager = artifacts.require("MedicosRecordManager");

module.exports = function (deployer) {
  deployer.deploy(MedicosRecordManager);
};
