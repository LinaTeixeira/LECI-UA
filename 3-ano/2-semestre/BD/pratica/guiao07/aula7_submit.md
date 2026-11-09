# BD: Guião 7


## ​7.2 
 
### *a)*

```
Primeira forma normal pois os atributos são atomicos e não inclui nested relations, mas tem uma dependencia parcial:
FD3(_Nome_Autor_->Afiliacao_Autor)
```

### *b)* 

```
1. Decomposição até 2FN - Tratamento de dependecias parciais:
R1(_Titulo_Livro_, _Nome_Autor_, Tipo_Livro, Preco, NoPaginas, Editor, Endereco_Editor, Ano_Publicacao)
R3(_Nome_Autor_, Afiliacao_Autor)

A relação parcial(FD3) passou a ser uma nova relação(R3) com os atributos correpondentes, onde não existem dependencias parciais.

2. Decomposição até 3FN - Tratamento de dependencias transitivas:
R1(_Titulo_Livro_, _Nome_Autor_, Tipo_Livro(FK), NoPaginas, Editor(FK), Ano_Publicacao)
R2(_Tipo_Livro_, _NoPaginas_, Preco)
R3(_Nome_Autor_, Afiliacao_Autor)
R4(_Editor_, Endereco_Editor)

As dependencias transitivas(FD2, FD4) formaram novas relações em que a chave primaria é o atributo a que as dependencias se relacionam, sendo que este atributo mantém-se na relação inicial como chave estrangeira. 
```




## ​7.3
 
### *a)*

```
A Chave da relação é {A, B} pois outros atributos dependem desse conjunto, e {A, B} não são determinados por nenhuns outros atributos.
```


### *b)* 

```
Decomposição até 2FN - Tratamento de dependecias parciais:
R1(_A_,_B_,C,D,I,J)
R2(_A_,D,E)
R3(_B_,F,G,H)

```


### *c)* 

```
Decomposição até 3FN - Tratamento de dependencias transitivas:
R1(_A_,_B_,C,D(FK))
R2(_A_,D,E)
R3(_B_,F,G,H)
R4(_D_,I,J)
```


## ​7.4
 
### *a)*

```
AB e BC
```


### *b)* 

```
R1 = (D,E)
R2 = (A,B,C,D)
```


### *c)* 

```
R1 = (_D_, E)
R3 = (A,C)
R4 = (B,C,D)
```



## ​7.5
 
### *a)*

```
AB 
```

### *b)* 

```
R1 = (_A_,C,D)
R2 = (_A_,_B_,E)
```


### *c)*

```
R2 = (_A_,_B_,E)
R3 = (_C_,D)
R4 = (_A_,C)
```

### *d)* 

```
R2 = (_A_,_B_,E)
R3 = (_C_,D)
R4 = (_A_,C)
```
