--1. Sa se creeze proceduri stocate in baza exercitiilor (2 exercitii) din capitolul 4. 
--   Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective . 
CREATE PROCEDURE ex1_1_lab9
       @Id_st smallint =100
AS
		SELECT DISTINCT Nume_Profesor
				,Prenume_Profesor
		FROM cadre_didactice.profesori, studenti.studenti_reusita
		WHERE profesori.Id_Profesor=studenti_reusita.Id_Profesor
		AND  Id_Student=@Id_st;

EXEC ex1_1_lab9;
DROP PROCEDURE ex1_1_lab9;

CREATE PROCEDURE ex1_2_lab9
		@test varchar(255) ='Testul 2',
		@disciplina varchar(255) = 'Baze de Date'
AS
		SELECT count(Id_Student) nr_students
		FROM studenti.studenti_reusita, plan_studii.discipline
		WHERE studenti_reusita.Id_Disciplina = discipline.Id_Disciplina
		AND Tip_Evaluare = @test
		AND Disciplina LIKE @disciplina
EXEC ex1_2_lab9;


DROP PROCEDURE ex1_2_lab9;
--2. Sa se creeze o procedura stocata, care nu are niciun parametru de intrare si poseda un parametru de iesire.
-- Parametrul de iesire trebuie sa returneze numarul de studenti, care nu au sustinut cel putin o forma de evaluare (nota mai mica de 5 sau valoare NULL).

CREATE PROCEDURE ex2_lab9
		@nr_studenti smallint  OUTPUT
AS 
SET @nr_studenti=(SELECT count(DISTINCT studenti_reusita.Id_Student)
					FROM studenti.studenti_reusita
					WHERE Nota<5
					OR Nota = NULL);
SET NOCOUNT ON
DECLARE @nr_studenti smallint 
EXECUTE ex2_lab9 @nr_studenti OUTPUT
	IF @nr_studenti>0
BEGIN
	PRINT CAST(@nr_studenti as varchar(10))+' studenti nu au sustinut cel putin o forma de evaluare.'
END

--3. Sa se creeze o procedura stocata, care ar insera in baza de date informatii despre un student nou. 
--	in calitate de parametri de intrare sa serveasca datele personale ale studentului nou si Cod_ Grupa. 
--	Sa se genereze toate intrarile-cheie necesare in tabelul studenti_reusita. Notele de evaluare sa fie inserate ca NULL.

CREATE PROCEDURE ex3_lab9
		@id int =700
		,@nume_st varchar(50) ='Speianu'
		,@prenume_st varchar(50) = 'Dana'
		,@birth_date date ='1998-10-05'
		,@address varchar(500)= NULL
		,@cod_grupa char(6) ='TI171'
AS
INSERT INTO studenti.studenti
VALUES (@id, @nume_st, @prenume_st, @birth_date, @address)
INSERT INTO studenti.studenti_reusita
VALUES (	@id
			,100
			,100
			,(SELECT Id_Grupa FROM grupe WHERE Cod_Grupa =@cod_grupa)
			,'Testul 2'
			, NULL
			, NULL)

EXEC ex3_lab9;

sp_help "studenti.studenti";
sp_help "studenti.studenti_reusita";
SELECT * FROM studenti.studenti;
SELECT * FROM studenti.studenti_reusita;
SELECT * from plan_studii.discipline;

--4. Fie ca un profesor se elibereaza din functie la mijlocul semestrului. Sa se creeze o procedura stocata care ar reatribui inregistrarile din tabelul studenti_reusita unui alt profesor. 
--	Parametri de intrare: numele si prenumele profesorului vechi, numele si prenumele profesorului nou, disciplina. in cazul in care datele inserate sunt incorecte sau incomplete, 
--	sa se afiseze un mesaj de avertizare.

SELECT* FROM cadre_didactice.profesori;

CREATE PROCEDURE ex4_lab9
		 @nume_prof_old varchar(25) ='Micu'
		,@prenum_prof_old varchar(25) ='Elena'
		,@nume_prof_new varchar(25) = 'Coada'
		,@prenum_prof_new varchar(25) ='Nadejda'
		,@disciplina varchar(50) 
AS
IF @disciplina IN
(SELECT DISTINCT discipline.Disciplina
FROM plan_studii.discipline, studenti.studenti_reusita, cadre_didactice.profesori
WHERE discipline.Id_Disciplina=studenti_reusita.Id_Disciplina
AND studenti_reusita.Id_Profesor=profesori.Id_Profesor
AND Nume_Profesor = @nume_prof_old
AND Prenume_Profesor = @prenum_prof_old)
BEGIN 
	UPDATE cadre_didactice.profesori
	SET  Nume_Profesor = @nume_prof_new, Prenume_Profesor = @prenum_prof_new
	WHERE Id_Profesor = (SELECT Id_Profesor 
					FROM cadre_didactice.profesori
					WHERE Nume_Profesor = @nume_prof_old
					AND Prenume_Profesor = @prenum_prof_old)
	PRINT @disciplina+' este predata de de profesorul nou: '+@nume_prof_new+' '+@prenum_prof_new
END
	ELSE
BEGIN
	PRINT 'Disciplina data nu este predata de '+@nume_prof_old+' '+@prenum_prof_old
END
EXECUTE ex4_lab9 @disciplina = 'Structuri de date si algoritmi'
	

--5. Sa se creeze o procedura stocata care ar forma o lista cu primii 3 cei mai buni studenti la o disciplina, si acestor studenti sa le fie marita nota la examenul
--   final cu un punct (nota maximala posibila este 10). in calitate de parametru de intrare, va servi denumirea disciplinei.
--   Procedura sa returneze urmatoarele campuri: Cod_ Grupa, Nume_Prenume_Student, Disciplina, Nota _ Veche, Nota _ Noua 

CREATE PROCEDURE ex5_lab9
		@denumire_disciplina varchar(50) 
		,@cod_grupa varchar(10) OUTPUT
		,@nume_prenume_st varchar (100) OUTPUT
		,@disciplina varchar(50) OUTPUT
		,@nota_veche int OUTPUT
		,@nota_noua int OUTPUT
AS
IF @disciplina IN (SELECT Disciplina 
					FROM plan_studii.discipline
					WHERE Disciplina IN (SELECT  Disciplina
											FROM studenti.studenti_reusita, plan_studii.discipline
											WHERE studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
											AND Disciplina = @denumire_disciplina
											AND Tip_Evaluare = 'Examen'
											AND Nota<>10))
BEGIN
SELECT DISTINCT TOP(3) concat(Nume_Student,' ',Prenume_Student) as nume_prenume, convert(decimal(7,5), avg(Nota*1.0)) as media, Cod_Grupa
					FROM studenti.studenti, studenti.studenti_reusita, plan_studii.discipline, grupe
					WHERE studenti.Id_Student=studenti_reusita.Id_Student AND studenti_reusita.Id_Disciplina=discipline.Id_Disciplina AND studenti_reusita.Id_Grupa=grupe.Id_Grupa
					AND Disciplina = @denumire_disciplina
					GROUP BY  concat(Nume_Student,' ',Prenume_Student), Cod_Grupa
					ORDER BY media DESC 
SET @nota_veche =(SELECT DISTINCT TOP(3) convert(decimal(7,5), avg(Nota*1.0)) 
					FROM studenti.studenti, studenti.studenti_reusita, plan_studii.discipline, grupe
					WHERE studenti.Id_Student=studenti_reusita.Id_Student AND studenti_reusita.Id_Disciplina=discipline.Id_Disciplina AND studenti_reusita.Id_Grupa=grupe.Id_Grupa
					AND Disciplina = @denumire_disciplina
					GROUP BY  concat(Nume_Student,' ',Prenume_Student), Cod_Grupa
					ORDER BY convert(decimal(7,5), avg(Nota*1.0)) DESC )
SET @nota_noua =@nota_veche+1
SET @cod_grupa =(SELECT TOP(3) Cod_Grupa
						FROM  grupe, studenti.studenti_reusita, plan_studii.discipline, studenti.studenti
						WHERE studenti_reusita.Id_Grupa=grupe.Id_Grupa AND studenti_reusita.Id_Disciplina=discipline.Id_Disciplina AND studenti.Id_Student=studenti_reusita.Id_Student 
						AND Disciplina = @denumire_disciplina
						GROUP BY  concat(Nume_Student,' ',Prenume_Student), Cod_Grupa
						ORDER BY convert(decimal(7,5), avg(Nota*1.0)) DESC )
SET @disciplina =@denumire_disciplina
SET @nume_prenume_st= (SELECT TOP(3) concat(Nume_Student,' ',Prenume_Student) as nume_prenume
						FROM studenti.studenti, studenti.studenti_reusita, plan_studii.discipline, grupe
						WHERE studenti.Id_Student=studenti_reusita.Id_Student AND studenti_reusita.Id_Disciplina=discipline.Id_Disciplina AND studenti_reusita.Id_Grupa=grupe.Id_Grupa
						AND Disciplina = @denumire_disciplina
						GROUP BY  concat(Nume_Student,' ',Prenume_Student), Cod_Grupa
						ORDER BY convert(decimal(7,5), avg(Nota*1.0)) DESC )
--UPDATE studenti.studenti_reusita SET Nota=@nota_veche+1

END
ELSE
BEGIN
	PRINT 'ERROR'
END

EXECUTE dbo.ex5_lab9 @denumire_disciplina ='Baze de date'
		,@cod_grupa=@cod_grupa  OUTPUT
		,@nume_prenume_st=@nume_prenume_st  OUTPUT
		,@disciplina=@disciplina  OUTPUT
		,@nota_veche=@nota_veche  OUTPUT
		,@nota_noua=@nota_noua  OUTPUT
PRINT 'resul '+@cod_grupa+@nume_prenume_st+@disciplina+@nota_veche+@nota_noua;
DROP PROCEDURE dbo.ex5_lab9

--6. Sa se creeze functii definite de utilizator in baza exercitiilor (2 exercitii) din capitolul 4.
--   Parametrii de intrare trebuie sa corespunda criteriilor din clauzele WHERE ale exercitiilor respective. 

CREATE FUNCTION ex6_1_lab9 (@count_student int =24)
RETURNS TABLE
AS
RETURN
(SELECT  Cod_Grupa FROM grupe,studenti.studenti_reusita,studenti.studenti
WHERE studenti_reusita.Id_Student=studenti.Id_Student
AND grupe.Id_Grupa=studenti_reusita.Id_Grupa
GROUP BY Cod_Grupa
HAVING count(DISTINCT studenti.Id_Student)>@count_student);
SELECT * FROM ex6_1_lab9(24);

CREATE FUNCTION ex6_2_lab9 (@nr_ore int =60)
RETURNS TABLE
AS
RETURN
(SELECT DISTINCT Nume_Profesor, Prenume_Profesor, Nr_ore_plan_disciplina
FROM cadre_didactice.profesori, studenti.studenti_reusita, plan_studii.discipline
WHERE profesori.Id_Profesor=studenti_reusita.Id_Profesor
AND studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
AND Nr_ore_plan_disciplina< @nr_ore);

SELECT * FROM ex6_2_lab9(60);

--7. Sa se scrie functia care ar calcula varsta studentului. Sa se defineasca urmatorul format al functiei: <nume functie>(<Data _ Nastere _Student>). 
CREATE FUNCTION dbo.ex7_lab9 (@Data_Nastere_Student date)
RETURNS int
AS
BEGIN
DECLARE @age int;
SELECT @age = floor(datediff(day, Data_Nastere_Student,(CONVERT (Date, CURRENT_TIMESTAMP)))/365.25) 
FROM studenti.studenti s
WHERE s.Data_Nastere_Student=@Data_Nastere_Student
RETURN @age;
END;

SELECT Nume_Student, Prenume_Student, Data_Nastere_Student, dbo.ex7_lab9(Data_Nastere_Student) age
FROM studenti.studenti;


--8. Sa se creeze o functie definita de utilizator, care ar returna datele referitoare la reusita unui student.
--	 Se defineste urmatorul format al functiei: <nume functie> (<Nume_Prenume_Student>).
--	 Sa fie afisat tabelul cu urmatoarele campuri: Nume_Prenume_Student, Disticplina, Nota, Data_Evaluare. 

CREATE FUNCTION dbo.ex8_lab9(@Nume_Prenume_Student varchar(50))
RETURNS TABLE
AS
RETURN
(
SELECT concat(Nume_Student,' ',Prenume_Student) Nume_Prenume_Student, Disciplina, Nota, Data_Evaluare
FROM studenti.studenti s
JOIN studenti.studenti_reusita r ON r.Id_Student=s.Id_Student
JOIN plan_studii.discipline d ON r.Id_Disciplina=d.Id_Disciplina
WHERE concat(Nume_Student,' ',Prenume_Student)=@Nume_Prenume_Student
);

SELECT * FROM dbo.ex8_lab9('Brasovianu Teodora');

--9. Se cere realizarea unei functii definite de utilizator, care ar gasi cel mai sarguincios sau cel mai slab student dintr-o grupa.
--	 Se defineste urmatorul format al functiei: <numefunctie> (<Cod_ Grupa>, <is_good>). Parametrul <is_good> poate accepta valorile "sarguincios" sau "slab", respectiv. 
--	 Functia sa returneze un tabel cu urmatoarele campuri Grupa, Nume_Prenume_Student, Nota Medie , is_good. Nota Medie sa fie cu precizie de 2 zecimale. 

CREATE FUNCTION dbo.ex9_lab9(@Cod_Grupa varchar(10), @is_good varchar(15))
RETURNS @tab TABLE
		(Grupa VARCHAR(10), Nume VARCHAR(50), Media DECIMAL(4,2), is_good VARCHAR(15))
AS
BEGIN 
	IF (@is_good='sarguincios')
		
		INSERT @tab 
		SELECT TOP(1) Cod_Grupa, concat(Nume_Student,' ',Prenume_Student) Nume_Prenume_Student, convert(decimal(4,2), avg(Nota*1.0)) as Media, @is_good as is_good
		FROM grupe g, studenti.studenti s, studenti.studenti_reusita r
		WHERE g.Id_Grupa=r.Id_Grupa
		AND s.Id_Student=r.Id_Student
		AND g.Cod_Grupa=@Cod_Grupa
		GROUP BY Cod_Grupa, concat(Nume_Student,' ',Prenume_Student)
		ORDER BY Media DESC	
	ELSE
		IF (@is_good='slab')
			
			INSERT @tab 
			SELECT TOP(1) Cod_Grupa, concat(Nume_Student,' ',Prenume_Student) Nume_Prenume_Student, convert(decimal(4,2), avg(Nota*1.0)) as Media, @is_good as is_good
			FROM grupe g, studenti.studenti s, studenti.studenti_reusita r
			WHERE g.Id_Grupa=r.Id_Grupa
			AND s.Id_Student=r.Id_Student
			AND g.Cod_Grupa=@Cod_Grupa
			GROUP BY Cod_Grupa, concat(Nume_Student,' ',Prenume_Student)
			ORDER BY Media ASC	
RETURN
END

SELECT * FROM dbo.ex9_lab9('INF171', 'sarguincios');
SELECT * FROM dbo.ex9_lab9('CIB171', 'slab');
DROP FUNCTION dbo.ex9_lab9