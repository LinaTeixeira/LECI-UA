Create schema GestaoEncomendas
Go

Create table GestaoEncomendas.FORNECEDOR(
	num_InfoFiscal int NOT NULL,
	Codigo_interno varchar(10) NOT NULL,
	Endereço varchar(30),
	num_Fax int,
	nome varchar(30) NOT NULL,

	UNIQUE(Codigo_interno),
	PRIMARY KEY(num_InfoFiscal));
	

Create table GestaoEncomendas.METODOPAGAMENTO(
	ID int NOT NULL,
	fornecedor_numInfoFiscal int NOT NULL,
	Designaçao varchar(20),
	
	PRIMARY KEY(ID),
	FOREIGN KEY(fornecedor_numInfoFiscal) REFERENCES GestaoEncomendas.FORNECEDOR(num_InfoFiscal));

Create table GestaoEncomendas.UTILIZA(
	ID int NOT NULL,
	fornecedor_numInfoFiscal int NOT NULL,

	PRIMARY KEY(ID, fornecedor_numInfoFiscal),
	FOREIGN KEY(fornecedor_numInfoFiscal) REFERENCES GestaoEncomendas.FORNECEDOR(num_InfoFiscal),
	FOREIGN KEY(ID) REFERENCES GestaoEncomendas.METODOPAGAMENTO(ID));

Create table GestaoEncomendas.TIPOFORNECEDOR(
	ID int NOT NULL,
	designação varchar(15),

	PRIMARY KEY(ID)
);

Create table GestaoEncomendas.METODO(
	no_InfoFiscal int NOT NULL,
	tipoFornecedor_ID int NOT NULL,

	PRIMARY KEY(no_InfoFiscal, tipoFornecedor_ID),
	FOREIGN KEY(no_InfoFiscal) REFERENCES GestaoEncomendas.FORNECEDOR(num_InfoFiscal),
	FOREIGN KEY(tipoFornecedor_ID) REFERENCES GestaoEncomendas.TIPOFORNECEDOR(ID)
);

Create table GestaoEncomendas.ENCOMENDA(
	numEncomenda int NOT NULL,
	DataEnvio int,

	PRIMARY KEY(numEncomenda)
);

Alter table GestaoEncomendas.ENCOMENDA ADD num_InfoFiscal int NOT NULL;
Alter table GestaoEncomendas.ENCOMENDA ADD CONSTRAINT fk_InfoFiscal 
FOREIGN KEY (num_InfoFiscal) REFERENCES GestaoEncomendas.FORNECEDOR(num_InfoFiscal);


Create table GestaoEncomendas.PRODUTO(
	Codigo int NOT NULL,
	Nome varchar(20) NOT NULL, 
	Preço int,
	TaxaIva int DEFAULT 23,
	UnidadesEmStock int,

	PRIMARY KEY(Codigo)
);

Create table GestaoEncomendas.CONTEM(
	numEncomenda int NOT NULL,
	ProdutoCodigo int NOT NULL,
	numItens int NOT NULL,
	
	PRIMARY KEY(numEncomenda, ProdutoCodigo),
	FOREIGN KEY(numEncomenda) REFERENCES GestaoEncomendas.ENCOMENDA(numEncomenda),
	FOREIGN KEY(ProdutoCodigo) REFERENCES GestaoEncomendas.PRODUTO(Codigo),
	
);

	