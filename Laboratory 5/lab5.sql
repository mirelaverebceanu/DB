--1. Completati urmatorul cod pentru a afisa eel mai mare numar dintre cele trei numere prezentate: 
--DECLARE @N1 INT, @N2 INT, @N3 INT;
--DECLARE @MAI_MARE INT; 
--SET @N1 = 60 * RAND();
--SET @N2 = 60 * RAND();
--SET @N3 = 60 * RAND();
-- -- Aici ar trebui plasate IF-urile 
-- IF @N1>@N2 and @N1>@N3
-- SET   @MAI_MARE=@N1;
-- ELSE IF @N2>@N1 and @N2>@N3
-- SET @MAI_MARE=@N2;
-- ELSE
-- SET @MAI_MARE=@N3;
--PRINT @N1; 
--PRINT @N2; 
--PRINT @N3; 
--PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2)); 

--2. Afisati primele zece date (numele, prenumele studentului) in functie de valoarea notei (cu exceptia notelor 6 si 8)
-- a studentului la primul test al disciplinei Baze de date, folosind structura de altemativa IF. .. ELSE. Sa se foloseasca variabilele. 
--DECLARE @nota int 
--DECLARE @disciplina char(255)
--SET @disciplina=(SELECT Disciplina
--				FROM discipline
--				WHERE Disciplina='Baze de date') 
--DECLARE @tip_test char(255) 
--SET @tip_test = (SELECT DISTINCT Tip_Evaluare
--				FROM studenti_reusita
--				Where Tip_Evaluare='Testul 1')
--IF (@nota in (SELECT Nota
--					FROM studenti_reusita
--					WHERE Nota not in (6,8)))
--PRINT 'No such data'
--ELSE SELECT  TOP (10) Nume_Student
--		,Prenume_Student
--		,Nota
--			FROM studenti, studenti_reusita, discipline
--			WHERE studenti.Id_Student=studenti_reusita.Id_Student
--			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
--			and Disciplina=@disciplina
--			and Tip_evaluare=@tip_test
--			ORDER BY Nota DESC;

DECLARE @first integer
SET @first=(SELECT  count(*)
			FROM studenti, studenti_reusita, discipline
			WHERE studenti.Id_Student=studenti_reusita.Id_Student
			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
			and Disciplina='Baze de date'
			and Tip_Evaluare='Testul 1'
			and Nota not in (6,8)
			)
IF @first = 10  SELECT  Nume_Student
					,Prenume_Student
					,Nota
			FROM studenti, studenti_reusita, discipline
			WHERE studenti.Id_Student=studenti_reusita.Id_Student
			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
			and Disciplina='Baze de date'
			and Tip_Evaluare='Testul 1'
			and Nota not in (6,8)
			ORDER BY Nota DESC
	ELSE  SELECT  top(10) Nume_Student
					,Prenume_Student
					,Nota
			FROM studenti, studenti_reusita, discipline
			WHERE studenti.Id_Student=studenti_reusita.Id_Student
			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
			and Disciplina='Baze de date'
			and Tip_Evaluare='Testul 1'
			and Nota not in (6,8)
			ORDER BY Nota DESC; 


--3. Rezolvati aceesi sarcina, 1, apeland la structura selectiva CASE. 

--DECLARE @N1 INT, @N2 INT, @N3 INT;
--DECLARE @MAI_MARE INT; 
--SET @N1 = 60 * RAND();
--SET @N2 = 60 * RAND();
--SET @N3 = 60 * RAND();
--SELECT @MAI_MARE=
--(
--CASE 
--WHEN @N1>@N2 and @N1>@N3 then @N1
--WHEN @N2>@N1 and @N2>@N3 then @N2
--ELSE @N3
--END
--)
--PRINT 'Mai mare = ' + CAST(@MAI_MARE AS VARCHAR(2));


--4. Modificati exercitiile din sarcinile 1 si 2 pentru a include procesarea erorilor cu TRY si CATCH, si RAISERRROR
--a)
--DECLARE @N1 INT, @N2 INT, @N3 INT;
--DECLARE @MAI_MARE INT; 
--SET @N1 = 60 ;
--SET @N2 = 60 ;
--SET @N3 = 60 ;
-- IF @N1>@N2 and @N1>@N3
-- SET   @MAI_MARE=@N1;
-- ELSE IF @N2>@N1 and @N2>@N3
-- SET @MAI_MARE=@N2;
-- ELSE
-- SET @MAI_MARE=@N3;
-- IF (@MAI_MARE=@N1 and @MAI_MARE=@N2 and @MAI_MARE=@N3)
-- BEGIN 
--RAISERROR ('Mai mare nu pot fi toate 3 numere',10,1) 
--END

BEGIN TRY 
DECLARE @N1 INT, @N2 INT, @N3 INT;
DECLARE @MAI_MARE INT; 
SET @N1 = 60 ;
SET @N2 = 60 ;
SET @N3 = 60 ;
SET @MAI_MARE=@N1/(@N2-@N3)
PRINT 'Nu exista nici o eroare' 
END TRY 
BEGIN CATCH 
PRINT ERROR_NUMBER() 
PRINT ERROR_SEVERITY() 
PRINT ERROR_STATE() 
PRINT ERROR_PROCEDURE() 
PRINT ERROR_LINE() 
PRINT ERROR_MESSAGE() 
END CATCH 
--b)

DECLARE @nota1 int 
SET @nota1 =(SELECT Distinct Nota
						FROM studenti_reusita
						WHERE Nota=6) 
DECLARE @nota2 int
SET @nota2=(SELECT Distinct Nota
						FROM studenti_reusita
						WHERE Nota=8)
DECLARE @disciplina char(255)
SET @disciplina=(SELECT Disciplina
				FROM discipline
				WHERE Disciplina='Baze de date') 
DECLARE @tip_test char(255) 
SET @tip_test = (SELECT DISTINCT Tip_Evaluare
				FROM studenti_reusita
				Where Tip_Evaluare='Testul 1')
If @nota1=6 and @nota2=8
BEGIN 
RAISERROR ('Studentul nu poate avea nota 6 si nota 8 la testul 1, baze de date',10,1) 
END

BEGIN TRY 
Declare @nrstudents char 
SET @nrstudents =(SELECT  Nume_Student
			FROM studenti, studenti_reusita, discipline
			WHERE studenti.Id_Student=studenti_reusita.Id_Student
			and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
			and Disciplina='Baze de date'
			and Tip_Evaluare='Testul 1'
			and Nota not in (6,8)
			)
PRINT 'Nu exista nici o eroare' 
END TRY 
BEGIN CATCH 
PRINT ERROR_NUMBER() 
PRINT ERROR_SEVERITY() 
PRINT ERROR_STATE() 
PRINT ERROR_PROCEDURE() 
PRINT ERROR_LINE() 
PRINT ERROR_MESSAGE() 
END CATCH 