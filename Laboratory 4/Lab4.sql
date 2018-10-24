
--1) Aflafi toate datele despre grupele de studii de la facultate. 

SELECT *
FROM grupe;

--22) Sa se obtina numarul de discipline predate de fiecare profesor (Nume_Profesor, Prenume _ Profesor). 

SELECT Nume_Profesor
      ,Prenume_Profesor
	  ,count(distinct Id_Disciplina) AS Nr_discipline
FROM profesori 
INNER JOIN studenti_reusita ON studenti_reusita.Id_Profesor=profesori.Id_Profesor
GROUP BY Nume_Profesor, Prenume_Profesor;

SELECT DISTINCT Id_Disciplina
FROM studenti_reusita
WHERE Id_Profesor=104;

SELECT *
FROM profesori;

SELECT *
FROM studenti_reusita;


--2) Sa se obtina lista disciplinelor in ordine descrescatoare a numarului de ore. 
SELECT *
FROM discipline
ORDER BY Nr_ore_plan_disciplina DESC;

--3) Aflati cursurile (Disciplina) predate de fiecare profesor (Nume_Profesor, Prenume_Profesor) sortate descrescator dupa nume si apoi prenume.
SELECT DISTINCT Disciplina
      ,Nume_Profesor
	  ,Prenume_Profesor
FROM profesori
INNER JOIN studenti_reusita ON profesori.Id_Profesor=studenti_reusita.Id_Profesor
INNER JOIN discipline ON studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
ORDER BY Nume_Profesor DESC, Prenume_Profesor DESC;

--4) Afisati care dintre discipline au denumirea formata din mai mult de 20 de caractere?
SELECT  DISTINCT Disciplina
        ,LEN(Disciplina) as length
FROM discipline
WHERE LEN(Disciplina)>20;


--5) Sa se afiseze lista studentilor al caror nume se termina in "u" 
SELECT *
FROM studenti
WHERE Nume_Student LIKE '%u';

--6) Afisati numele si prenumele primilor 5 studenti, care au obtinut note in ordine descrescatoare la al doilea test de la disciplina Baze de date. Sa se foloseasca optiunea TOP ... WITH TIES.
SELECT TOP (5) WITH TIES
        Nume_Student
       ,Prenume_Student
	   , Disciplina
	   , Nota
	   , Tip_Evaluare
FROM studenti
INNER JOIN studenti_reusita ON studenti.Id_Student=studenti_reusita.Id_Student
INNER JOIN discipline ON studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
WHERE Disciplina = 'Baze de date' AND
      Tip_Evaluare = 'Testul 2'
ORDER BY Nota DESC;

SELECT *
FROM studenti_reusita;

-- 7) In ce grupa (Cod_ Grupa) invata studentii care locuiesc pe strada 31 August? 
SELECT DISTINCT Cod_Grupa
FROM grupe
INNER JOIN studenti_reusita ON grupe.Id_Grupa=studenti_reusita.Id_Grupa
INNER JOIN studenti ON studenti.Id_Student=studenti_reusita.Id_Student
WHERE Adresa_Postala_Student LIKE '%31 August%';

-- 28) Gasiti numele, prenumele si media grupei studentilor care au sustinut toate disciplinele predate de profesorii ce 
--locuiesc pe strada 31 August. 

SELECT distinct Nume_Student, Prenume_Student, avg(nota) media
FROM studenti
INNER JOIN studenti_reusita ON studenti.Id_Student=studenti_reusita.Id_Student
where Id_Disciplina = Any(
SELECT  distinct ID_disciplina
FROM studenti_reusita
WHERE Id_Profesor IN
(SELECT Id_Profesor
FROM profesori
where Adresa_Postala_Profesor like '%31 August%'))
and Nota>=5
group by Nume_Student, Prenume_Student;


-- 39) Gasiti denumirile disciplinelor la care nu au sustinut examenul, in medie, peste 5% de studenti.

SELECT Disciplina
FROM discipline
WHERE Id_Disciplina IN
(SELECT Id_Disciplina
FROM studenti_reusita
WHERE Tip_Evaluare = 'Examen'
AND Nota<5
GROUP BY Id_Disciplina
HAVING avg(Id_Student)>0.05);

-- 36) Gasiti numele, prenumele si adresele studentilor si ale profesorilor care locuiesc 'intr-o localitate. 
--Sa se afiseze denumirea localitatii si numarul de locuitori inclusi 'in cele doua categorii. 
--Datele se afiseaza 'in ordinea crescatoare a numarului membrilor din categoria mentionata anterior. 

SELECT   Distinct Nume_Student, Prenume_Student
		,Substring(Adresa_Postala_Student,1, charindex(',',Adresa_Postala_Student)-1) address1
		,Nume_Profesor, Prenume_Profesor
		,CASE 
		WHEN Adresa_Postala_Profesor not like '%,%' THEN Adresa_Postala_Profesor
		ELSE Substring(Adresa_Postala_Profesor,1, charindex(',',Adresa_Postala_Profesor)-1)
		END as address2
		,count(Distinct Nume_Student) nr_students
		,count(Distinct Nume_Profesor) nr_profesori
FROM profesori
	,studenti_reusita
	,studenti
where profesori.Id_Profesor=studenti_reusita.Id_Profesor
and studenti_reusita.Id_Student=studenti.Id_Student  
and Adresa_Postala_Profesor is not null
and Substring(Adresa_Postala_Student,1, charindex(',',Adresa_Postala_Student)-1) IN
(SELECT CASE 
		WHEN Adresa_Postala_Profesor not like '%,%' THEN Adresa_Postala_Profesor
		ELSE Substring(Adresa_Postala_Profesor,1, charindex(',',Adresa_Postala_Profesor)-1)
		END 
FROM profesori
where Adresa_Postala_Profesor is not null)
Group by Nume_Student, Prenume_Student, Adresa_Postala_Student,
Nume_Profesor, Prenume_Profesor, Adresa_Postala_Profesor
ORDER BY count(Distinct Nume_Student), count(Distinct Nume_Profesor);

--32. Fumizati numele, prenumele si media notelor pe grupe pentru studenti

SELECT Nume_student
		,Prenume_student
		,Cod_grupa
		,avg(nota) media_notelor
From studenti,studenti_reusita,grupe
where studenti.Id_student=studenti_reusita.Id_student
and studenti_reusita.Id_Grupa=grupe.Id_Grupa
Group by Cod_Grupa, Prenume_Student, Nume_Student
Order by Cod_Grupa;


--35. Gasiti denumirile disciplinelor si media notelor pe disciplina. Afisati numai disciplinele cu medii mai mari de 7.0. 

Select Disciplina, convert(decimal(7,5), avg(Nota*1.0)) as media
From discipline, studenti_reusita
where discipline.Id_Disciplina=studenti_reusita.Id_Disciplina
group by Disciplina
having convert(decimal(7,5), avg(Nota*1.0))>7.0;

-- 37. Gasiti disciplina sustinuta de studenti cu nota medie (la examen) cea mai inalta. 

Select top (1)
		Disciplina
		,convert(decimal(7,5), avg(Nota*1.0))		
From discipline, studenti_reusita
where discipline.Id_Disciplina=studenti_reusita.Id_Disciplina
and Tip_Evaluare='Examen'
group by Disciplina
order by convert(decimal(7,5), avg(Nota*1.0)) desc;



