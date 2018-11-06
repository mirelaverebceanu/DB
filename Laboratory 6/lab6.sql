--1. Sa se scrie o instructiune T-SQL, care ar popula co Joana Adresa _ Postala _ Profesor din tabelul profesori 
--cu valoarea 'mun. Chisinau', unde adresa este necunoscuta. 

UPDATE dbo.profesori 
SET Adresa_Postala_Profesor = 'mun. Chisinau' 
WHERE Adresa_Postala_Profesor IS NULL;

SELECT * from profesori;

--2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte: 
--a) Campul Cod_ Grupa sa accepte numai valorile unice si sa nu accepte valori necunoscute. 
--b) Sa se tina cont ca cheie primarii, deja, este definitii asupra coloanei Id_ Grupa. 

ALTER TABLE grupe 
ADD UNIQUE (Cod_Grupa);

ALTER TABLE grupe
ALTER COLUMN Cod_Grupa char(6) NOT NULL;

-- 3. La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa si Prof_Indrumator, ambele de tip INT. 
--   Sa se populeze campurile nou-create cu cele mai potrivite candidaturi in baza criteriilor de mai jos:
-- a) Seful grupei trebuie sa aiba cea mai buna reusita (medie) din grupa la toate formele de evaluare si la toate disciplinele.
--    Un student nu poate fi sef de grupa la mai multe grupe. 
-- b) Profesorul indrumator trebuie sa predea un numar maximal posibil de discipline la grupa data. 
--    Daca nu exista o singura candidatura, care corespunde primei cerinte, atunci este ales din grupul de candidati acel cu identificatorul (Id_Profesor) minimal. 
--    Un profesor nu poate fi indrumator la mai multe grupe.
-- c) Sa se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor in tabelul grupe, pentru selectarea candidatilor si inserarea datelor.

ALTER TABLE grupe 
ADD Sef_Grupa int;
ALTER TABLE grupe
ADD Prof_Indrumator int;


--select  Id_Student,Cod_Grupa
--from (select g.Cod_Grupa,MAX(Nota_medie) as Max_Nota_Medie
--      from (select Id_Student,AVG(Nota) Nota_medie
--            from studenti_reusita r
--            group by Id_Student) table1
--      inner join studenti_reusita r
--      on r.Id_Grupa=r.Id_Grupa
--      inner join grupe g
--      on g.Id_Grupa=r.Id_Grupa
--      where table1.Id_Student=r.Id_Student
--      group by g.Cod_Grupa) table2
--	  inner join (select top(10) Id_Student,AVG(Nota) Nota_medie
--                  from studenti_reusita r
--                  group by Id_Student
--                  order by AVG(NOTA) DESC)table3
--      on table2.Max_Nota_Medie=table3.Nota_Medie

DECLARE c1 CURSOR FOR 
SELECT id_grupa FROM grupe 

DECLARE @gid int
    ,@sid int
    ,@pid int

OPEN c1
FETCH NEXT FROM c1 into @gid 
WHILE @@FETCH_STATUS = 0
BEGIN
 SELECT TOP 1 @sid=id_student
   FROM studenti_reusita
   WHERE id_grupa = @gid and Id_Student NOT IN (SELECT isnull(Sef_Grupa,'') FROM grupe)
   GROUP BY id_student
   ORDER BY avg (NOTA) DESC

 SELECT TOP 1 @pid=id_profesor
      FROM studenti_reusita
      WHERE id_grupa = @gid AND Id_profesor NOT IN (SELECT isnull (Prof_Indrumator, '') FROM grupe)
      GROUP BY id_profesor
      ORDER BY count (DISTINCT id_disciplina) DESC, id_profesor
 
 UPDATE grupe
    SET   Sef_Grupa = @sid
      ,Prof_Indrumator = @pid
  WHERE Id_Grupa=@gid
 
-- PRINT @gid
-- PRINT @sid
-- PRINT @pid
 FETCH NEXT FROM c1 into @gid 
END

CLOSE c1
DEALLOCATE c1

SELECT * FROM grupe;

--4. Sa se scrie o instructiune T-SQL, care ar mari toate notele de evaluare sefilor de grupe cu un punct. Nota maximala (10) nu poate fi miirita.
  SELECT case nota when 10 then Nota
         else nota+1 end new_nota
  FROM studenti_reusita
  WHERE Id_Student IN
  (SELECT  Sef_Grupa
  FROM grupe);


UPDATE dbo.studenti_reusita 
SET Nota=Nota+1
WHERE Nota<>10 and Nota IN ( SELECT Nota
  FROM studenti_reusita
  WHERE Id_Student IN
  (SELECT  Sef_Grupa
  FROM grupe));

  SELECT * FROM studenti_reusita;

--  DECLARE @ID_SEF_1 FLOAT;
--DECLARE @ID_SEF_2 FLOAT;
--DECLARE @ID_SEF_3 FLOAT;
--DECLARE @NOTA_MAX INT =10;
--SET @ID_SEF_1=(SELECT TOP 1 sef_grupa from grupe)
--SET @ID_SEF_2=(SELECT TOP 1 sef_grupa from grupe 
--               WHERE sef_grupa IN 
--			                   (select top 2 sef_grupa from grupe
--							    order by sef_grupa asc)
--			  ORDER BY sef_grupa DESC
--                   )
--SET @ID_SEF_3=(SELECT TOP 1 sef_grupa from grupe 
--               WHERE sef_grupa IN 
--			                   (select top 3 sef_grupa from grupe
--							    order by sef_grupa asc)
--			   ORDER BY sef_grupa DESC
--                   )

--UPDATE studenti_reusita SET Nota=Nota+1 WHERE Id_Student IN(@ID_SEF_1, @ID_SEF_2, @ID_SEF_3) AND Nota!=10

 -- 5. Sa se creeze un tabel profesori_new, care include urmatoarele coloane:
 --  Id_Profesor, Nume _ Profesor, Prenume _ Profesor, Localitate, Adresa _ 1, Adresa _2.
 --  a) Coloana Id_Profesor trebuie sa fie definita drept cheie primara si, in baza ei, sa fie construit un index CLUSTERED. 
 --  b) Campul Localitate trebuie sa posede proprietatea DEF A ULT= 'mun. Chisinau'.
 --  c) Sa se insereze toate datele din tabelul profesori in tabelul profesori_new. Sa se scrie, cu acest scop, un numar potrivit de instructiuni T-SQL.
 --  in coloana Localitate sii fie inserata doar informatia despre denumirea localitatii din coloana-sursa Adresa_Postala_Profesor. in coloana Adresa_l,
 --  doar denumirea strazii. in coloana Adresa_2, sa se pastreze numarul casei si (posibil) a apartamentului. 

 CREATE TABLE profesori_new
 (Id_Profesor int PRIMARY KEY
 ,Nume_Profesor char(255)
 ,Prenume_Profesor char(255)
 ,Localitate char (255) DEFAULT('mun. Chisinau')
 ,Adresa_1 char (60)
 ,Adresa_2 char (60));
 SELECT * FROM profesori_new
 DROP INDEX ix_Id_Profesor ON profesori_new;
 SELECT* FROM profesori_new;
 CREATE CLUSTERED INDEX ix_Id_Profesor ON profesori_new (Id_Profesor);
 INSERT INTO profesori_new(Id_Profesor, Nume_Profesor, Prenume_Profesor, Localitate, Adresa_1, Adresa_2)
 SELECT Id_Profesor
        , Nume_Profesor
		, Prenume_Profesor
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 then  Substring(Adresa_Postala_Profesor,1, dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 THEN Substring(Adresa_Postala_Profesor,1, charindex(',',Adresa_Postala_Profesor)-1)
		ELSE Adresa_Postala_Profesor
		END as  localitate
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 then  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1, (dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-1)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1)+1,(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2))-(dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 1))-1)
		ELSE NULL
		END as  Adresa_1
		, CASE 
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', ''))=3 then  Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 3)+1, 5)
		WHEN LEN(Adresa_Postala_Profesor)-LEN(REPLACE(Adresa_Postala_Profesor, ',', '')) =2 THEN Substring(Adresa_Postala_Profesor,dbo.INSTR(Adresa_Postala_Profesor, ',', 1, 2)+1, 5)
		ELSE NULL
		END as  Adresa_2
		 FROM profesori;

SELECT * FROM profesori_new;

 --6. Sa se insereze datele in tabelul orarul pentru Grupa= 'CIBJ 71' (Id_ Grupa= 1) pentru ziua de luni. Toate lectiile vor avea loc in blocul de studii 'B'. 
--Mai jos, sunt prezentate detaliile de inserare: (ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202); 
--(Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501); (ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501);

CREATE TABLE orarul( Id_Disciplina int NOT NULL,
                       Id_Profesor int, 
					   Id_Grupa smallint DEFAULT (1),
					   Zi       char(2),
					   Ora       Time,
					   Auditoriu  int,
					   Bloc       char(1) NOT NULL DEFAULT ('B')
					   PRIMARY KEY(Id_Grupa, Zi, Ora, Auditoriu));
INSERT INTO orarul (Id_Disciplina, Id_Profesor,Zi, Ora,Auditoriu) VALUES(107, 101, 'Lu', '08:00', 202)
INSERT INTO orarul (Id_Disciplina, Id_Profesor,Zi, Ora,Auditoriu) VALUES(108, 101, 'Lu', '11:30', 501)
INSERT INTO orarul (Id_Disciplina, Id_Profesor,Zi, Ora,Auditoriu) VALUES(109, 117, 'Lu', '13:00', 501)

SELECT * FROM orarul;

---- 7. Sa se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INFl 71 , ziua de luni.
--Datele necesare pentru inserare trebuie sa fie colectate cu ajutorul instructiunii/instructiunilor 
--SELECT ~i introduse in tabelul-destinatie, ~tiind ca: lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Prof esor ='Bivol Ion')
-- lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin') lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena')  


INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_grupa, Zi, Ora, Auditoriu)
SELECT DISTINCT discipline.Id_Disciplina
		,profesori.Id_Profesor
		,grupe.Id_grupa
		,'Lu' as Zi
		,'08:00' as Ora
		,118 as Auditoriu
FROM studenti_reusita, discipline, profesori, grupe
WHERE studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
AND studenti_reusita.Id_Profesor=profesori.Id_Profesor
AND studenti_reusita.Id_Grupa=grupe.Id_Grupa
AND Cod_Grupa LIKE 'INF171'
AND Disciplina in ('Structuri de date si algoritmi')

INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_grupa, Zi, Ora, Auditoriu)
SELECT DISTINCT discipline.Id_Disciplina
		,profesori.Id_Profesor
		,grupe.Id_grupa
		,'Lu' as Zi
		,'11:30' as Ora
		,115 as Auditoriu
FROM studenti_reusita, discipline, profesori, grupe
WHERE studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
AND studenti_reusita.Id_Profesor=profesori.Id_Profesor
AND studenti_reusita.Id_Grupa=grupe.Id_Grupa
AND Cod_Grupa LIKE 'INF171'
AND Disciplina in ('Programe aplicative')

INSERT INTO orarul (Id_Disciplina, Id_Profesor, Id_grupa, Zi, Ora, Auditoriu)
SELECT DISTINCT discipline.Id_Disciplina
		,profesori.Id_Profesor
		,grupe.Id_grupa
		,'Lu' as Zi
		,'13:00' as Ora
		,115 as Auditoriu
FROM studenti_reusita, discipline, profesori, grupe
WHERE studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
AND studenti_reusita.Id_Profesor=profesori.Id_Profesor
AND studenti_reusita.Id_Grupa=grupe.Id_Grupa
AND Cod_Grupa LIKE 'INF171'
AND Disciplina in ('Baze de date')


--8. Sa se scrie interogarile de creare a indecsilor asupra tabelelor din baza de date universitatea pentru a asigura o performanta sporita la executarea interogarilor 
--SELECT din Lucrarea practica 4. Rezultatele optimizarii sa fie analizate in baza planurilor de executie, pana la si dupa crearea indecsilor. 
--Indecsii nou-creati sa fie plasati fizic in grupul de fisiere userdatafgroupl (Crearea $i intrefinerea bazei de date - sectiunea 2.2.2)
DROP INDEX pk_discipline on discipline

ALTER DATABASE universitatea
ADD FILEGROUP userdatafgroupl
GO

ALTER DATABASE universitatea
ADD FILE
( NAME = Indexes,
FILENAME = 'd:\db.ndf',
SIZE = 1MB
)
TO FILEGROUP userdatafgroupl
GO

CREATE NONCLUSTERED INDEX pk_id_disciplina ON
discipline (id_disciplina)
ON [userdatafgroupl]

