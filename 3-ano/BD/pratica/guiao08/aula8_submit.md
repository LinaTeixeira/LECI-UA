---
title: 'BD: Guião 8'

---

# BD: Guião 8


## ​8.1
 
### *a)*

```
CREATE PROC removeEmp @Ssn char(9)
AS
    DELETE FROM works_on WHERE Essn = @Ssn;
    DELETE FROM dependent WHERE Essn = @Ssn;
    UPDATE department set Mgr_ssn = NULL WHERE Mgr_ssn = @Ssn;
    UPDATE employee SET Super_snn = NULL WHERE Super_ssn = @Ssn;
    DELETE FROM employee WHERE Ssn = @Ssn;
    END;
```

### *b)* 

```
CREATE PROC Managers_OldestManager( @Ssn char(9) OUTPUT, @nyears OUTPUT)
AS
    SELECT *, 
    FROM employee JOIN department on department.Mgr_Ssn = employee.Ssn;
    Select @Ssn = Mgr_Ssn, @nyears = Mgr_start_date
    FROM department
    GROUP BY DATEDIFF(YEAR, Mgr_start_date, GETDATE()) ASC
    END;
```

### *c)* 

```
CREATE TRIGGER noMgr_multipleDeps ON department
AFTER INSERT, UPDATE
AS
    DECLARE @Ssn as char(9);
    SELECT @Ssn = Mgr_ssn FROM inserted;
    IF (SELECT Mgr_Ssn FROM department WHERE Mgr_Ssn=@Ssn) is NOT NULL
        BEGIN
            RAISERROR('Employee already is a department manager', 16, 1);
            ROLLBACK TRAN;
        END
    ELSE 
        PRINT 'Log: Done'
END
    

```

### *d)* 

```
CREATE TRIGGER sal_Lower ON employee
AFTER INSERT
AS
BEGIN
    DECLARE @Mgr_Sal decimal(10,2);
    DECLARE @E_Sal decimal(10,2);
    DECLARE @ESsn as char (9);
    DECLARE @Mgr_Ssn as char(9);
    SELECT @ESsn = Ssn FROM inserted;
    SELECT @Mgr_Ssn = (SELECT Mgr_Ssn 
                        FROM department JOIN employee on Dno = Dnumber 
                        WHERE Ssn = @ESsn);
    SELECT @Mgr_Sal = (SELECT Salary FROM employee WHERE Ssn= @Mgr_Ssn);
    SELECT @E_Sal = (SELECT Salary FROM employee WHERE Ssn=@ESsn);
    
    IF (@E_Sal > @Mgr_Sal)
    BEGIN
        PRINT('Employee salary adjusted');
        UPDATE employee
        SET Salary = (@Mgr_Sal - 1)
        WHERE Ssn = @ESsn
    END
END
        
```

### *e)* 

```
CREATE FUNCTION fn_EmpProjects (@Ssn char(9))
RETURNS TABLE
AS
RETURN (
    SELECT P.Pname P.Plocation
    FROM project P 
    JOIN works_on W ON P.Pnumber = W.Pno
    WHERE W.Essn = @Ssn
);
```

### *f)* 

```
CREATE FUNCTION fn_DepHighSalary (@Dno int)
RETURNS TABLE
AS
RETURN (
    SELECT Fname, Lname, Salary
    FROM employee
    WHERE Dno = @Dno AND Salary > (
        -- Sub-pesquisa para calcular a média do departamento
        SELECT AVG(Salary) 
        FROM employee 
        WHERE Dno = @Dno
    )
);
```

### *g)* 

```

CREATE FUNCTION dbo.employeeDeptHighAverage (@dnum INT)
RETURNS @ResultTable TABLE (
    pname VARCHAR(50),
    pnumber INT,
    plocation VARCHAR(50),
    dnum INT,
    budget DECIMAL(12, 2),
    totalbudget DECIMAL(12, 2)
)
AS
BEGIN
    DECLARE @v_pname VARCHAR(50);
    DECLARE @v_pnumber INT;
    DECLARE @v_plocation VARCHAR(50);
    DECLARE @v_dnum INT;
    DECLARE @v_budget DECIMAL(12, 2);
    
    DECLARE @v_totalbudget DECIMAL(12, 2) = 0.00;

    DECLARE project_cursor CURSOR FOR
    SELECT 
        p.pname,
        p.pnumber,
        p.plocation,
        p.dnum,
        ISNULL(SUM((w.hours / 40.0) * e.salary), 0) AS budget
    FROM Project p
    LEFT JOIN Works_on w ON p.pnumber = w.pno
    LEFT JOIN Employee e ON w.essn = e.ssn
    WHERE p.dnum = @dnum
    GROUP BY p.pname, p.pnumber, p.plocation, p.dnum
    ORDER by p.pnumber; 

    OPEN project_cursor;
    FETCH NEXT FROM project_cursor INTO @v_pname, @v_pnumber @v_plocation, @v_dnum, @v_budget;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @v_totalbudget = @v_totalbudget + @v_budget;

        INSERT INTO @ResultTable (pname, pnumber, plocation, dnum, budget, totalbudget)
        VALUES (@v_pname, @v_pnumber, @v_plocation, @v_dnum, @v_budget, @v_totalbudget);

        FETCH NEXT FROM project_cursor INTO @v_pname, @v_pnumber, @v_plocation, @v_dnum @v_budget;
    END

    CLOSE project_cursor;
    DEALLOCATE project_cursor;

    RETURN;
END;
GO

```

### *h)* 

```
CREATE TRIGGER trg_backup_dept_after ON department
AFTER DELETE
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'department_deleted')
    BEGIN
        SELECT * INTO department_deleted FROM deleted;
    END
    ELSE
    BEGIN
        INSERT INTO department_deleted SELECT * FROM deleted;
    END
END;
```

### *i)* 

```
Tanto Stored Procedures como Funções representam blocos de código reutilizávies que não têm de ser recompilados sempre que são chamados pois ficam guardados em memória cache, o que garante rapidez de execução.
Quanto às diferenças entre as duas: SPs podem ter, opcionalmente, um valor de retorno, enquanto que UDFs têm de o ter obrigatoriamente; Funções podem ainda ser utilizadas como fonte de dados numa expressão SQL enquanto que Procedimentos não; Stored Procedures oferecem formas de tratamento de erros (Try-Catch, RAISERROR) ao contrario de Funções.
Uma SP é mais util em situações em que é necessario alterar dados e garantir que não ocorrem erros. Por exemplo numa base de dados de uma loja, podemos usar uma SP para gerir compras e stock de produtos. Assim, se um pagamento falhar ou se não houver stock suficiente a SP consegue cancelar as mudanças à base de dados, caso contrário, a SP pode alterar as tabelas relevantes(de produtos em stock, por exemplo).
Uma UDF deve ser utilizada para incorporar lógica mais complexa, sem alterar dados. Por exemplo, numa base de dados de uma loja, uma UDF poderia servir como forma de calcular o valor total de uma compra. Servindo apenas para consultar os preços dos artigos comprados(e o respetivo desconto) e retornar o valor total da compra.
```
