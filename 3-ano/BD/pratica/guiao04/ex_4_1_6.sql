CREATE SCHEMA gestaoATL;
GO

CREATE TABLE gestaoATL.PESSOA (
    numero_CC VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(150),
    morada VARCHAR(255),
    data_nascimento DATE
);

CREATE TABLE gestaoATL.ATIVIDADE (
    identificador INT PRIMARY KEY,
    designacao VARCHAR(150),
    custo DECIMAL(10,2)
);

CREATE TABLE gestaoATL.PROFESSOR (
    n_funcionario INT PRIMARY KEY,
    email VARCHAR(150),
    contacto_telefonico VARCHAR(20),
    pessoa_numeroCC VARCHAR(20),
    FOREIGN KEY (pessoa_numeroCC) REFERENCES gestaoATL.PESSOA(numero_CC)
);

CREATE TABLE gestaoATL.TURMA (
    identificador INT PRIMARY KEY,
    designacao VARCHAR(150),
    classe VARCHAR(50),
    n_max_alunos INT,
    ano_letivo VARCHAR(20),
    prof_n_funcionario INT,
    FOREIGN KEY (prof_n_funcionario) REFERENCES gestaoATL.PROFESSOR(n_funcionario)
);

CREATE TABLE gestaoATL.ALUNO (
    pessoa_numeroCC VARCHAR(20) PRIMARY KEY,
    turma_id INT,
    FOREIGN KEY (pessoa_numeroCC) REFERENCES gestaoATL.PESSOA(numero_CC),
    FOREIGN KEY (turma_id) REFERENCES gestaoATL.TURMA(identificador)
);

CREATE TABLE gestaoATL.PESSOA_COM_AUTORIZACAO (
    pessoa_numeroCC VARCHAR(20) PRIMARY KEY,
    contacto_telefonico VARCHAR(20),
    email VARCHAR(150),
    FOREIGN KEY (pessoa_numeroCC) REFERENCES gestaoATL.PESSOA(numero_CC)
);

CREATE TABLE gestaoATL.ENCARREGADO_EDUCACAO (
    pessoa_numeroCC VARCHAR(20) PRIMARY KEY,
    contacto_telefonico VARCHAR(20),
    FOREIGN KEY (pessoa_numeroCC) REFERENCES gestaoATL.PESSOA_COM_AUTORIZACAO(pessoa_numeroCC)
);

CREATE TABLE gestaoATL.NAO_ENCARREGADO_EDUCACAO (
    pessoa_numeroCC VARCHAR(20) PRIMARY KEY,
    contacto_telefonico VARCHAR(20),
    FOREIGN KEY (pessoa_numeroCC) REFERENCES gestaoATL.PESSOA_COM_AUTORIZACAO(pessoa_numeroCC)
);

CREATE TABLE gestaoATL.RELACAO (
    tipo VARCHAR(50),
    aluno_numeroCC VARCHAR(20),
    pessoaComAutorizacao_numeroCC VARCHAR(20),
    PRIMARY KEY (aluno_numeroCC, pessoaComAutorizacao_numeroCC),
    FOREIGN KEY (aluno_numeroCC) REFERENCES gestaoATL.ALUNO(pessoa_numeroCC),
    FOREIGN KEY (pessoaComAutorizacao_numeroCC) REFERENCES gestaoATL.PESSOA_COM_AUTORIZACAO(pessoa_numeroCC)
);

CREATE TABLE gestaoATL.PARTICIPA (
    atividade_identificador INT,
    aluno_CC VARCHAR(20),
    PRIMARY KEY (atividade_identificador, aluno_CC),
    FOREIGN KEY (atividade_identificador) REFERENCES gestaoATL.ATIVIDADE(identificador),
    FOREIGN KEY (aluno_CC) REFERENCES gestaoATL.ALUNO(pessoa_numeroCC)
);

CREATE TABLE gestaoATL.INCLUI (
    atividade_id INT,
    turma_id INT,
    PRIMARY KEY (atividade_id, turma_id),
    FOREIGN KEY (atividade_id) REFERENCES gestaoATL.ATIVIDADE(identificador),
    FOREIGN KEY (turma_id) REFERENCES gestaoATL.TURMA(identificador)
);