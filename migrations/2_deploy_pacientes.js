const ContratoPaciente = artifacts.require("ContratoPaciente");
module.exports = function(deployer) {
  deployer.deploy(ContratoPaciente);
};
