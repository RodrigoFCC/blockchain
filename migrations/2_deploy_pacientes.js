const Pacientes = artifacts.require("Pacientes");
module.exports = function(deployer) {
  deployer.deploy(Pacientes);
};
