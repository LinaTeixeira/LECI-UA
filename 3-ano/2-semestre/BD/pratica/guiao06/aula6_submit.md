---
title: aula6_submit

---

# BD: Guião 6

## Problema 6.1

### *a)* Todos os tuplos da tabela autores (authors);

```
select * from authors

```

### *b)* O primeiro nome, o último nome e o telefone dos autores;

```
select au_fname, au_lname, phone from authors
```

### *c)* Consulta definida em b) mas ordenada pelo primeiro nome (ascendente) e depois o último nome (ascendente); 

```
select au_fname, au_lname, phone
from authors
order by au_fname asc, au_lname desc
```

### *d)* Consulta definida em c) mas renomeando os atributos para (first_name, last_name, telephone); 

```
select au_fname as first_name, au_lname as last_name, phone as telephone
from authors
order by first_name asc, last_name desc
```

### *e)* Consulta definida em d) mas só os autores da Califórnia (CA) cujo último nome é diferente de ‘Ringer’; 

```
select au_fname as first_name, au_lname as last_name, phone as telephone
from authors
where (state LIKE 'CA' AND au_lname NOT LIKE 'Ringer')
order by first_name asc, last_name desc

```

### *f)* Todas as editoras (publishers) que tenham ‘Bo’ em qualquer parte do nome; 

```
select * from publishers
where pub_name like '%Bo%';
```

### *g)* Nome das editoras que têm pelo menos uma publicação do tipo ‘Business’; 

```
select distinct pub_name
from publishers JOIN titles ON publishers.pub_id=titles.pub_id
where titles.type LIKE 'Business'
```

### *h)* Número total de vendas de cada editora; 

```
select pub_name, SUM(qty) as total_sales
from ((publishers JOIN titles ON publishers.pub_id=titles.pub_id) JOIN sales ON sales.title_id=titles.title_id)
GROUP BY pub_name

```

### *i)* Número total de vendas de cada editora agrupado por título; 

```
select title, SUM(qty) as total_sales
from ((publishers JOIN titles ON publishers.pub_id=titles.pub_id) JOIN sales ON sales.title_id=titles.title_id)
GROUP BY title
```

### *j)* Nome dos títulos vendidos pela loja ‘Bookbeat’; 

```
select title 
from ((titles JOIN sales ON titles.title_id=sales.title_id) JOIN stores ON sales.stor_id=stores.stor_id)
where stor_name='Bookbeat'

```

### *k)* Nome de autores que tenham publicações de tipos diferentes; 

```
select au_fname, au_lname, COUNT(distinct type)
from ((authors JOIN titleauthor ON authors.au_id=titleauthor.au_id) JOIN titles ON titles.title_id=titleauthor.title_id)
group by au_fname, au_lname
having COUNT(distinct type) > 1

```

### *l)* Para os títulos, obter o preço médio e o número total de vendas agrupado por tipo (type) e editora (pub_id);

```
select type, AVG(price) as avg_price, SUM(qty) as total_sales, publishers.pub_id
from ((titles JOIN sales ON titles.title_id=sales.title_id) JOIN publishers ON publishers.pub_id=titles.pub_id)
group by type, publishers.pub_id
```

### *m)* Obter o(s) tipo(s) de título(s) para o(s) qual(is) o máximo de dinheiro “à cabeça” (advance) é uma vez e meia superior à média do grupo (tipo);

```
select t_self.type, MAX(t_self.advance) as Max_advance, AVG(t_types.advance) as Avg_advance
from titles as t_types, titles as t_self
GROUP BY t_self.type
HAVING MAX(t_self.advance) > (AVG(t_types.advance)*1.5)

```

### *n)* Obter, para cada título, nome dos autores e valor arrecadado por estes com a sua venda;

```
select titles.title, authors.au_fname, authors.au_lname, (titles.price * titles.ytd_sales * (titles.royalty / 100.0) * (titleauthor.royaltyper / 100.0)) as author_revenue
from ((titles JOIN titleauthor ON titles.title_id = titleauthor.title_id) JOIN authors ON authors.au_id = titleauthor.au_id)
```

### *o)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, a faturação total, o valor da faturação relativa aos autores e o valor da faturação relativa à editora;

```

select ytd_sales, title, (price * ytd_sales) as total_revenue, (price * ytd_sales * (royalty / 100.0)) as authors_revenue, (price * ytd_sales * (1 - royalty / 100.0)) as publisher_revenue
from titles

```

### *p)* Obter uma lista que incluía o número de vendas de um título (ytd_sales), o seu nome, o nome de cada autor, o valor da faturação de cada autor e o valor da faturação relativa à editora;

```

select titles.ytd_sales, titles.title, authors.au_fname, authors.au_lname, (titles.price * titles.ytd_sales * (titles.royalty / 100.0) * (titleauthor.royaltyper / 100.0)) as author_revenue, (titles.price * titles.ytd_sales * (1 - titles.royalty / 100.0)) as publisher_revenue
from ((titles JOIN titleauthor ON titles.title_id = titleauthor.title_id) JOIN authors ON authors.au_id = titleauthor.au_id)

```

### *q)* Lista de lojas que venderam pelo menos um exemplar de todos os livros;

```
select stores.stor_name
from stores JOIN sales ON stores.stor_id = sales.stor_id
group by stores.stor_name
having count(distinct sales.title_id) = (select count(title_id) from titles)

```

### *r)* Lista de lojas que venderam mais livros do que a média de todas as lojas;

```
select stores.stor_name
from stores JOIN sales ON stores.stor_id = sales.stor_id
group by stores.stor_name
having sum(sales.qty) > (select avg(total_qty) from (select sum(qty) as total_qty from sales group by stor_id) as avg_sales)

```

### *s)* Nome dos títulos que nunca foram vendidos na loja “Bookbeat”;

```
select title
from titles
where title_id not in (
    select sales.title_id 
    from sales JOIN stores ON sales.stor_id = stores.stor_id 
    where stores.stor_name = 'Bookbeat')

```

### *t)* Para cada editora, a lista de todas as lojas que nunca venderam títulos dessa editora; 

```

select publishers.pub_name, stores.stor_name
from publishers CROSS JOIN stores
where not exists (
    select sales.stor_id
    from sales JOIN titles ON sales.title_id = titles.title_id
    where titles.pub_id = publishers.pub_id and sales.stor_id = stores.stor_id)

```

## Problema 6.2

### ​5.1

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_1_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_1_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
select Pname, Pnumber, Fname, Lname
from ((Company.PROJECT join Company.WORKS_ON on Pnumber=Pno) join Company.EMPLOYEE on Essn=Ssn)
```

##### *b)* 

```
select Fname,Lname
from(Company.EMPLOYEE join (select Ssn
							from Company.EMPLOYEE
							where Fname='Carlos' AND Minit='D' AND Lname='Gomes') as Chefe on Super_ssn=Chefe.Ssn)

```

##### *c)* 

```
select Pname, SUM(Hours) as total_hours
from (Company.PROJECT join Company.WORKS_ON on Pnumber=Pno)
group by Pname
```

##### *d)* 

```
select Dno, Fname,Lname, Hours
from ((Company.EMPLOYEE join Company.WORKS_ON on Ssn=Essn) join Company.PROJECT on Pno=Pnumber)
where Dno=3 AND Hours>20 AND Pname='Aveiro Digital'
```

##### *e)* 

```
select Fname, Minit, Lname
from (Company.EMPLOYEE left outer join Company.WORKS_ON on Ssn=Essn)
where Essn is NULL
```

##### *f)* 

```
select Dname, AVG(Salary) as AVG_F_SAL
from (Company.EMPLOYEE join Company.DEPARTMENT on Dnumber=Dno)
where Sex='F'
Group by Dname
```

##### *g)* 

```
Select Fname, Minit, Lname, COUNT(Essn) as numDependents
From (Company.EMPLOYEE join Company.DEPENDENTS on Essn=Ssn)
group by Fname, Minit, Lname
having COUNT(Essn) > 2

```

##### *h)* 

```
select E.Fname, E.Lname
from Company.EMPLOYEE as E JOIN (
    select Mgr_ssn AS Ssn FROM Company.DEPARTMENT
    except
    select Essn as Ssn FROM Company.DEPENDENTS) as GestoresSemDep on E.Ssn = GestoresSemDep.Ssn;
```

##### *i)* 

```
select E.Fname, E.Lname
from Company.EMPLOYEE as E JOIN (
    select W.Essn as Ssn
    from Company.WORKS_ON W
    join Company.PROJECT P on W.Pno = P.Pnumber
    where P.Plocation = 'Aveiro'
    
    except
    
    select E2.Ssn
    from Company.EMPLOYEE E2 join Company.DEPT_LOCATIONS DL on E2.Dno = DL.Dnumber
    where DL.Dlocation = 'Aveiro'
) as Filtro on E.Ssn = Filtro.Ssn;
```

### 5.2

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_2_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_2_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
select f.nome 
from gestaostock.fornecedor f 
left join gestaostock.encomenda e on f.nif = e.fornecedor 
where e.numero is null;

```

##### *b)* 

```
select p.nome, avg(i.unidades) as media_unidades 
from gestaostock.item i
join gestaostock.produto p ON i.codprod = p.codigo
group by p.nome;

```


##### *c)* 

```
select avg(cast(qtd_produtos as float)) as media_produtos_por_encomenda 
from ( select numenc, count(codprod) AS qtd_produtos 
    FROM gestaostock.item 
    group by numenc) as subquery;
```


##### *d)* 

```
select f.nome as fornecedor, p.nome as produto, sum(i.unidades) as quantidade_total
from gestaostock.encomenda e 
join gestaostock.item i ON e.numero = i.numenc
join gestaostock.fornecedor f ON e.fornecedor = f.nif
join gestaostock.produto p on i.codprod = p.codigo
group BY f.nome, p.nome;

```

### 5.3

#### a) SQL DDL Script
 
[a) SQL DDL File](ex_6_2_3_ddl.sql "SQLFileQuestion")

#### b) Data Insertion Script

[b) SQL Data Insertion File](ex_6_2_3_data.sql "SQLFileQuestion")

#### c) Queries

##### *a)*

```
select p.nome 
from prescricao.paciente p 
left join prescricao.prescricao pr ON p.numutente = pr.numutente 
where pr.numpresc is null;
```

##### *b)* 

```
select m.especialidade, count(p.numpresc) AS total_prescricoes 
from prescricao.medico m 
join prescricao.prescricao p on m.numsns = p.nummedico 
GROUP BY m.especialidade;
```


##### *c)* 

```
select farmacia, count(numpresc) as total_prescricoes 
from prescricao.prescricao 
where farmacia is not NULL 
GROUP BY farmacia;
```


##### *d)* 

```
select f.nome 
from prescricao.farmaco f
where f.numregfarm = 906
and f.nome not in ( 
    select pf.nomefarmaco 
    from prescricao.presc_farmaco pf 
    where pf.numregfarm = 906);
```

##### *e)* 

```
select p.farmacia, fa.nome as farmaceutica, count(pf.nomefarmaco) as total_farmacos
from prescricao.prescricao p
join prescricao.presc_farmaco pf on p.numpresc = pf.numpresc
join prescricao.farmaceutica fa on pf.numregfarm = fa.numreg
where p.farmacia is not NULL
GROUP BY p.farmacia, fa.nome;
```

##### *f)* 

```
select p.farmacia, fa.nome as farmaceutica, count(pf.nomefarmaco) as total_farmacos
from prescricao.prescricao p
join prescricao.presc_farmaco pf on p.numpresc = pf.numpresc
join prescricao.farmaceutica fa on pf.numregfarm = fa.numreg
where p.farmacia is not Null
GROUP BY p.farmacia, fa.nome;
```
