// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ContratoPaciente {
    struct Paciente {
        string nome;
        string cpf;
        uint idade;
        string endereco;
    }

    // Mapeamentos principais
    mapping (address => Paciente) public pacientes; // Paciente por endereço
    mapping (string => address) public cpfParaEndereco; // CPF para endereço (controle de unicidade)
    mapping (string => bool) public cpfCadastrado; // Verificação rápida se CPF existe
    
    // Array para listar todos os endereços com pacientes
    address[] public enderecosCadastrados;

    // Eventos para acompanhamento
    event PacienteCadastrado(address indexed endereco, string cpf, string nome);
    event CPFJaCadastrado(string cpf, address enderecoExistente);

    function _ehIdadeValida(uint _idade) private pure returns(bool) {
        return _idade > 12;
    }

    function _ehNomeValido(string memory _nome) private pure returns(bool) {
        return bytes(_nome).length != 0;
    }

    function _ehCpfValido(string memory _cpf) private pure returns(bool) {
        return bytes(_cpf).length == 11;
    }

    function _ehPacienteValido(Paciente memory _paciente) private pure returns(bool) {
        return _ehIdadeValida(_paciente.idade) && _ehNomeValido(_paciente.nome) && _ehCpfValido(_paciente.cpf);
    }

    function adicionarPaciente(string memory _nome, string memory _cpf, uint _idade, string memory _endereco) public {
        // Verifica se o CPF já está cadastrado
        require(!cpfCadastrado[_cpf], "CPF ja cadastrado para outro paciente");

        Paciente memory paciente;
        paciente.nome = _nome;
        paciente.cpf = _cpf;
        paciente.idade = _idade;
        paciente.endereco = _endereco;

        require(_ehPacienteValido(paciente), "Dados do paciente invalidos");

        // Cadastra o paciente
        pacientes[msg.sender] = paciente;
        cpfParaEndereco[_cpf] = msg.sender;
        cpfCadastrado[_cpf] = true;
        enderecosCadastrados.push(msg.sender);

        emit PacienteCadastrado(msg.sender, _cpf, _nome);
    }

    function consultarPorCPF(string memory _cpf) public view returns (string memory, string memory, uint, string memory, address) {
        require(cpfCadastrado[_cpf], "Paciente nao encontrado");
        address enderecoPaciente = cpfParaEndereco[_cpf];
        Paciente memory p = pacientes[enderecoPaciente];
        return (p.nome, p.cpf, p.idade, p.endereco, enderecoPaciente);
    }

    function consultarPorEndereco(address _endereco) public view returns (string memory, string memory, uint, string memory) {
        require(bytes(pacientes[_endereco].cpf).length != 0, "Paciente nao encontrado para este endereco");
        Paciente memory p = pacientes[_endereco];
        return (p.nome, p.cpf, p.idade, p.endereco);
    }

    function getTotalPacientes() public view returns (uint) {
        return enderecosCadastrados.length;
    }

    function getEnderecoPorIndice(uint index) public view returns (address) {
        require(index < enderecosCadastrados.length, "Indice invalido");
        return enderecosCadastrados[index];
    }

    function verificarCPFCadastrado(string memory _cpf) public view returns (bool) {
        return cpfCadastrado[_cpf];
    }

    function getEnderecoPorCPF(string memory _cpf) public view returns (address) {
        require(cpfCadastrado[_cpf], "CPF nao cadastrado");
        return cpfParaEndereco[_cpf];
    }
}