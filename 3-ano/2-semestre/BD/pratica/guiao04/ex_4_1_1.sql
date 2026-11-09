Create Schema RentACar;

Go

Create table RentACar.CLIENTE(
	NIF int,
	Endereço varchar(30),
	Num_carta int,
	Nome varchar(30),
	
	PRIMARY KEY(NIF));

Alter table RentACar.CLIENTE alter Column NIF int NOT NULL;
Alter table RentACar.CLIENTE add unique (Num_carta)


Create table RentACar.BALCAO(
	Numero int,
	Nome varchar(15),
	Endereço varchar(30),

	PRIMARY KEY(Numero));

Alter table RentACar.BALCAO alter Column Numero int NOT NULL;

Create table RentACar.TIPO_VEICULO(
	Designação varchar(15),
	Arcondicionado varchar(3),
	Codigo int,

	PRIMARY KEY(Codigo));

Alter table RentACar.TIPO_VEICULO alter Column Codigo int NOT NULL;

Create table RentACar.VEICULO(
	Matricula varchar(6),
	Marca varchar(15),
	Ano int,
	Codigo_tipoVeiculo int,

	PRIMARY KEY(Matricula),
	FOREIGN KEY(Codigo_tipoVeiculo) REFERENCES RentACar.TIPO_VEICULO(Codigo),
	);

Alter table RentACar.VEICULO alter Column Matricula varchar(6) NOT NULL;

Create table RentACar.ALUGUER(
	Numero int,
	Duração int,
	Data int, 
	Numero_Balcao int,
	NIF_Cliente int,
	Matricula_Veiculo varchar(6),

	FOREIGN KEY(NIF_Cliente) REFERENCES RentACar.CLIENTE(NIF),
	FOREIGN KEY(Numero_Balcao) REFERENCES RentACar.BALCAO(Numero),
	FOREIGN KEY(Matricula_Veiculo) REFERENCES RentACar.VEICULO(Matricula),
	PRIMARY KEY(Numero));

Alter table RentACar.ALUGUER alter Column Numero int NOT NULL;
Alter table RentACar.ALUGUER drop column Data;
Alter table RentACar.ALUGUER add [Data] int;

Create table RentACar.SIMILARIDADE(
	Codigo_Veiculo int,
	Codigo_Similaridade int,

	FOREIGN KEY (Codigo_Veiculo) REFERENCES RentACar.TIPO_VEICULO(Codigo),
	PRIMARY KEY(Codigo_Veiculo, Codigo_Similaridade)
);

Create table RentACar.LIGEIRO(
	Codigo_tipoVeiculo int,
	Portas int,
	Combustivel varchar(10),
	numLugares int,

	FOREIGN KEY(Codigo_tipoVeiculo) REFERENCES RentACar.TIPO_VEICULO(Codigo),
	PRIMARY KEY(Codigo_tipoVeiculo));

Create table RentACar.PESADO(
	Codigo_tipoVeiculo int,
	Peso int,
	Passageiros int,

	FOREIGN KEY(Codigo_tipoVeiculo) REFERENCES RentACar.TIPO_VEICULO(Codigo),
	PRIMARY KEY(Codigo_tipoVeiculo));