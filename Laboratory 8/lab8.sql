 --1. Sa se creeze doua viziuni in baza interogarilor formulate in doua exercitii indicate din capitolul 4.
-- Prima viziune sa fie construita in Editorul de interogari, iar a doua, utilizand View Designer.

--a) creare viziune prin Editorul de interogari, exemplul 22

CREATE VIEW exemplul22 AS
SELECT Nume_Profesor
      ,Prenume_Profesor
	  ,count(distinct Id_Disciplina) AS Nr_discipline
FROM cadre_didactice.profesori 
INNER JOIN studenti.studenti_reusita ON studenti_reusita.Id_Profesor=profesori.Id_Profesor
GROUP BY Nume_Profesor, Prenume_Profesor;

SELECT * FROM exemplul22;

CREATE VIEW View_nr2_VW AS
SELECT  Id_Disciplina,discipline.Disciplina
FROM plan_studii.discipline
WHERE LEN(discipline.Disciplina)>20;

SELECT * FROM View_nr2_VW;

DROP VIEW View_nr2_VW;

--2. Sa se scrie cate un exemplu de instructiuni INSERT, UPDATE, DELETE asupra viziunilor create. 
-- Sa se adauge comentariile respective referitoare la rezultatele executarii acestor instructiuni. 

--a)
SELECT * FROM View_nr2_VW;

INSERT INTO View_nr2_VW 
VALUES (301,'Object Oriented Programming');

INSERT INTO View_nr2_VW 
VALUES (302,'Object Oriented Programming 2');

DELETE FROM View_nr2_VW WHERE Id_Disciplina =302;

UPDATE View_nr2_VW SET Disciplina='Programarea orientata pe obiecte 2'
WHERE Id_Disciplina=302;

--b)
SELECT * FROM exemplul22;

INSERT INTO exemplul22
VALUES ('Munteanu','Maria', 2);

-- Nu putem executa operațiuni DML asupra viziunilor create pe baza mai multor tabele

--3. Sa se scrie instructiunile SQL care ar modifica viziunile create (in exercitiul 1) in ~a fel, incat sa nu fie posibila modificarea sau ~tergerea
--tabelelor pe care acestea sunt definite ~i viziunile sa nu accepte operatiuni DML, daca conditiile clauzei WHERE nu sunt satis:facute. 

ALTER VIEW View_nr2_VW 
WITH SCHEMABINDING
AS
SELECT  Id_Disciplina,discipline.Disciplina
FROM plan_studii.discipline
WHERE LEN(discipline.Disciplina)>20
WITH CHECK OPTION;

ALTER VIEW View_1_lab8
WITH SCHEMABINDING
AS
SELECT studenti.studenti.Nume_Student, studenti.studenti.Prenume_Student, studenti.studenti_reusita.Id_Profesor
FROM            studenti.studenti INNER JOIN
                         studenti.studenti_reusita ON studenti.studenti.Id_Student = studenti.studenti_reusita.Id_Student INNER JOIN
                         plan_studii.discipline ON studenti.studenti_reusita.Id_Disciplina = plan_studii.discipline.Id_Disciplina
WHERE        (plan_studii.discipline.Nr_ore_plan_disciplina < 60)
WITH CHECK OPTION;
GO

--4. Sa se scrie instructiunile de testare a proprietatilor noi definite.

SELECT * FROM View_nr2_VW;

SELECT * FROM View_1_lab8;

INSERT INTO View_1_lab8
VALUES ('Speianu', 'Dana', 117);

UPDATE View_1_lab8 SET Id_Profesor=117
WHERE Nume_Student = 'Brasovianu';

DELETE FROM View_1_lab8 WHERE Id_Profesor=117;






--5. Sa se rescrie 2 interogari formulate in exercitiile din capitolul 4, in ~a fel. incat interogarile imbricate sa fie redate sub forma expresiilor CTE.

WITH exemplul1_CTE AS
(SELECT Disciplina 
		,convert(decimal(7,5), avg(Nota*1.0)) media
From plan_studii.discipline, studenti.studenti_reusita
where discipline.Id_Disciplina=studenti_reusita.Id_Disciplina
group by disciplina
having convert(decimal(7,5), avg(Nota*1.0))<
(Select convert(decimal(7,5), avg(Nota*1.0))
From plan_studii.discipline, studenti.studenti_reusita
where discipline.Id_Disciplina=studenti_reusita.Id_Disciplina
and Disciplina='Baze de date'))
SELECT * FROM exemplul1_CTE;

WITH exemplul2_CTE AS (
SELECT distinct Nume_Student, Prenume_Student, avg(nota) media
FROM studenti.studenti
INNER JOIN studenti.studenti_reusita ON studenti.Id_Student=studenti_reusita.Id_Student
where Id_Disciplina Not IN (
SELECT  distinct ID_disciplina
FROM studenti.studenti_reusita
WHERE Id_Profesor IN
(SELECT Id_Profesor
FROM cadre_didactice.profesori
where Adresa_Postala_Profesor  like '%31 August%')
and Nota<5)
group by Nume_Student, Prenume_Student)
SELECT media FROM exemplul2_CTE;

--6. Se considera un graf orientat, precum eel din figura de mai jos ~i fie se dore~te parcursa calea de la nodul id = 3 la nodul unde id = 0. 
-- Sa se faca reprezentarea grafului orientat in forma de expresie-tabel recursiv. Sa se observe instructiunea de dupa UNION ALL a membrului recursiv, 
-- precum ~i partea de pana la UNION ALL reprezentata de membrul-ancora. 

DECLARE @Table_ex6 TABLE
(
ID INT,
pred_ID INT
)

INSERT  @Table_ex6
SELECT 5, NULL UNION ALL
SELECT 4, NULL UNION ALL
SELECT 3, NULL UNION ALL
SELECT 0, 5 UNION ALL
SELECT 2, 4 UNION ALL
SELECT 2, 3 UNION ALL
SELECT 1, 2 UNION ALL
SELECT 0, 1;

WITH graph_lab8
AS 
(
SELECT *, pred_ID as pred_Nod, 0 AS generatie 
FROM @Table_ex6
WHERE pred_ID IS NULL
AND ID=3
UNION ALL
SELECT graph.*, graph_lab8.ID AS pred_Nod, generatie +1
FROM @Table_ex6 AS graph
INNER JOIN graph_lab8
ON graph.pred_ID=graph_lab8.ID
)
SELECT * FROM graph_lab8