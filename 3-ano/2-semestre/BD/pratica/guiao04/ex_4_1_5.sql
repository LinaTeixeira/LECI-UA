Create schema GestaoConferencias
Go

Create table GestaoConferencias.INSTITUICAO(
	Nome varchar(20) NOT NULL,
	Endereco varchar(30) NOT NULL,

	PRIMARY KEY (Nome, Endereco)
);

Create table GestaoConferencias.CONFERENCIA(
	ID varchar(10) NOT NULL,

	PRIMARY KEY (ID)
);

create table GestaoConferencias.AUTOR(
	Nome varchar(20) NOT NULL,
	Email varchar(20),
	Instituicao_Nome varchar(20) NOT NULL,
	Instituicao_Endereco varchar(30) NOT NULL,

	PRIMARY KEY(Nome),
	UNIQUE(Email),
	FOREIGN KEY(Instituicao_Nome, Instituicao_Endereco) REFERENCES GestaoConferencias.INSTITUICAO(Nome, Endereco),
);

create table GestaoConferencias.ARTIGO(
	num_Registo int NOT NULL,
	titulo varchar(30) NOT NULL,
	Conferencia_ID varchar(10),

	PRIMARY KEY(num_Registo),
	FOREIGN KEY(Conferencia_ID) REFERENCES GestaoConferencias.CONFERENCIA(ID)
);

create table GestaoConferencias.ESCREVE(
	Autor_Nome varchar(20) NOT NULL,
	Artigo_numRegisto int NOT NULL,

	PRIMARY KEY(Autor_Nome, Artigo_numRegisto),
	FOREIGN KEY(Autor_Nome) REFERENCES GestaoConferencias.AUTOR(Nome),
	FOREIGN KEY(Artigo_numRegisto) REFERENCES GestaoConferencias.ARTIGO(num_Registo)
);

create table GestaoConferencias.PARTICIPANTE(
	Nome varchar(20) NOT NULL,
	Email varchar(20) NOT NULL,
	Morada varchar(30),
	Instituicao_Nome varchar(20) NOT NULL,
	Instituicao_Endereco varchar(30) NOT NULL,

	PRIMARY KEY(Nome),
	UNIQUE(Email),
	FOREIGN KEY(Instituicao_Nome, Instituicao_Endereco) REFERENCES GestaoConferencias.INSTITUICAO(Nome, Endereco)
); 

create table GestaoConferencias.COMPROVATIVO(
	Localizacao_Eletronica varchar(30) NOT NULL,
	Instituicao_Nome varchar(20) NOT NULL,
	Instituicao_Endereco varchar(30) NOT NULL,

	PRIMARY KEY(Localizacao_Eletronica),
	FOREIGN KEY(Instituicao_Nome, Instituicao_Endereco) REFERENCES GestaoConferencias.INSTITUICAO(Nome, Endereco)
);

Create table GestaoConferencias.ESTUDANTE(
	Participante_Nome varchar(20) NOT NULL,
	Comprovativo_LocalEletronica varchar(30) NOT NULL,

	PRIMARY KEY(Participante_Nome),
	FOREIGN KEY(Participante_Nome) REFERENCES GestaoConferencias.PARTICIPANTE(Nome),
	FOREIGN KEY(Comprovativo_LocalEletronica) REFERENCES GestaoConferencias.COMPROVATIVO(Localizacao_Eletronica)
);

Create table GestaoConferencias.NAOESTUDANTE(
	Participante_Nome varchar(20) NOT NULL,
	Ref_Transacao_Bancaria varchar(30) NOT NULL,

	PRIMARY KEY(Participante_Nome),
	FOREIGN KEY(Participante_Nome) REFERENCES GestaoConferencias.PARTICIPANTE(Nome)
	);

Create table GestaoConferencias.INSCRICAO(
	Participante_Nome varchar(20) NOT NULL,
	Conferencia_ID varchar(10) NOT NULL,
	Data_Inscricao int,

	PRIMARY KEY (Participante_Nome, Conferencia_ID),
	FOREIGN KEY(Participante_Nome) REFERENCES GestaoConferencias.PARTICIPANTE(Nome),
	FOREIGN KEY(Conferencia_ID) REFERENCES GestaoConferencias.CONFERENCIA(ID),
	

);

	

