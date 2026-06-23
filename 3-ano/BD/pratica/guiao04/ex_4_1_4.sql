CREATE SCHEMA prescricaoEletronica;
GO

CREATE TABLE prescricaoEletronica.farmacia (
    NIF VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(150),
    endereco VARCHAR(255),
    telefone VARCHAR(20)
);

CREATE TABLE prescricaoEletronica.farmaceutica (
    no_registo_nacional INT PRIMARY KEY,
    nome VARCHAR(150),
    endereco VARCHAR(255),
    telefone VARCHAR(20)
);

CREATE TABLE prescricaoEletronica.paciente (
    numeroUtente INT PRIMARY KEY,
    nome VARCHAR(150),
    dataNascimento DATE,
    endereco VARCHAR(255)
);

CREATE TABLE prescricaoEletronica.medico (
    numeroIdentificacao INT PRIMARY KEY,
    nome VARCHAR(150),
    especialidade VARCHAR(100)
);

CREATE TABLE prescricaoEletronica.farmaco (
    formula VARCHAR(100) PRIMARY KEY,
    nome_comercial VARCHAR(150),
    no_registo_nacional INT,
    FOREIGN KEY (no_registo_nacional) REFERENCES prescricaoEletronica.farmaceutica(no_registo_nacional)
);

CREATE TABLE prescricaoEletronica.prescricao (
    ID INT PRIMARY KEY,
    data DATE,
    medico_numeroIdentificacao INT,
    paciente_numeroUtente INT,
    farmacia_nif VARCHAR(20),
    FOREIGN KEY (medico_numeroIdentificacao) REFERENCES prescricaoEletronica.medico(numeroIdentificacao),
    FOREIGN KEY (paciente_numeroUtente) REFERENCES prescricaoEletronica.paciente(numeroUtente),
    FOREIGN KEY (farmacia_nif) REFERENCES prescricaoEletronica.farmacia(NIF)
);

CREATE TABLE prescricaoEletronica.vende (
    farmacia_nif VARCHAR(20),
    farmaco_formula VARCHAR(100),
    PRIMARY KEY (farmacia_nif, farmaco_formula),
    FOREIGN KEY (farmacia_nif) REFERENCES prescricaoEletronica.farmacia(NIF),
    FOREIGN KEY (farmaco_formula) REFERENCES prescricaoEletronica.farmaco(formula)
);

CREATE TABLE prescricaoEletronica.contem (
    prescricao_id INT,
    farmaco_formula VARCHAR(100),
    PRIMARY KEY (prescricao_id, farmaco_formula),
    FOREIGN KEY (prescricao_id) REFERENCES prescricaoEletronica.prescricao(ID),
    FOREIGN KEY (farmaco_formula) REFERENCES prescricaoEletronica.farmaco(formula)
);