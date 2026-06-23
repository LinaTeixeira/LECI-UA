# BD: Guião 5

## ​Problema 5.1

### _a)_

```
(π Pname, Pnumber (project) ⨝ Pnumber = Pno works_on) ⨝ Essn = Ssn (π Fname, Lname, Ssn (employee))

```

### _b)_

```
π Fname, Lname (employee ⨝ Super_ssn=Chefe.Ssn (ρ Chefe (π Ssn (σ Fname='Carlos' ∧ Minit='D' ∧ Lname='Gomes' (employee)))))
```

### _c)_

```
γ Pname ;sum(Hours) -> Total_hours (project⨝Pnumber=Pno works_on)
```

### _d)_

```
σ Dno=3 ∧ Hours>20 ∧ Pname='Aveiro Digital' ((employee ⨝Ssn=Essn works_on) ⨝Pno=Pnumber project)
```

### _e)_

```
π Fname, Minit, Lname (σ Essn = null (employee⟕Ssn = Essn works_on))
```

### _f)_

```
γ Dname; avg(Salary) -> avg_F_Salary (σ Sex='F' (employee⨝Dnumber=Dno department))
```

### _g)_

```
σNum_Dependentes > 2 (γ Fname,Minit,Lname;count(Essn) -> Num_Dependentes (employee⨝Essn=Ssn dependent))
```

### _h)_

```
π Fname,Lname (employee ⨝ ( (ρ ssn←Mgr_ssn (π Mgr_ssn (department))) - (ρ ssn←Essn (π Essn (dependent))) ) )

```

### _i)_

```
π Fname, Lname ( employee ⨝ ( (ρ Ssn←Essn (π Essn (works_on ⨝ (σ Plocation='Aveiro' (ρ Pno←Pnumber (project)))))) - (π Ssn (employee ⨝ (σ Dlocation='Aveiro' (ρ Dno←Dnumber (dept_location))))) ) )

```

## ​Problema 5.2

### _a)_

```
(πnif fornecedor)- (πfornecedor encomenda)
```

### _b)_

```
γ produto.nome; avg(item.unidades) -> media_unidades (encomenda⨝numero=numEnc (produto⨝codigo=codProd item))
```

### _c)_

```
γ ;avg(numeroItens)-> MediaProdutosPorEncomenda (γ numero; count(numEnc)->numeroItens (encomenda⨝numero=numEnc item))
```

### _d)_

```
τ fornecedor.nome  (πfornecedor.nome, produto.codigo, produto.nome, produto.unidades (produto⨝codigo=codProd (π nif,nome,codProd (fornecedor⨝(item⨝(ρ numEnc←numero, nif←fornecedor (πfornecedor,numero encomenda)))))))
```

## ​Problema 5.3

### _a)_

```
π nome (paciente ⨝ (π numUtente (paciente) - π numUtente (prescricao)))
```

### _b)_

```
γ especialidade; count(numPresc)→Total (medico ⨝ (ρ numSNS←numMedico (prescricao)))

```

### _c)_

```
γ farmacia; count(numPresc)→Total (prescricao)
```

### _d)_

```
π nome (farmaco ⨝ ( (π numRegFarm (farmaco ⨝ (σ numReg=906 (farmaceutica)))) - (π numRegFarm (presc_farmaco)) ))

```

### _e)_

```
γ farmacia, nomeFarmaceutica ; count(nomeFarmaco)->total_vendidos ( prescricao ⨝ presc_farmaco ⨝ ( ρ numRegFarm<-numReg, nomeFarmaceutica<-nome ( farmaceutica ) ) )
```

### _f)_

```
π nome (paciente ⨝ (π numUtente (σ numMedico != numMedico2 (prescricao ⨝ (ρ numMedico2←numMedico, numPresc2←numPresc, farmacia2←farmacia, dataProc2←dataProc (prescricao))))))

```
