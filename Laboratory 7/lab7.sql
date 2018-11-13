--  6. Creati, in baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii ~i studenti. 
--  Transferati tabelul profesori din schema dbo in schema cadre didactice, tinand cont de dependentelor definite asupra tabelului mentionat.
--  in acela~i mod ~ se trateze tabelele orarul, discipline care apartin schemei plan_studii ~i tabelele studenti, studenti_reusita, care apartin schemei studenti.
--  Se scrie instructiunile SQL respective.
--CREATE SCHEMA cadre_didactice ;
--GRANT SELECT ON SCHEMA ::cadre_didactice
--TO 

--CREATE SCHEMA plan_studii;

--CREATE SCHEMA studenti;

--ALTER SCHEMA cadre_didactice
--TRANSFER dbo.profesori;

--ALTER SCHEMA dbo
--TRANSFER cadre_didactice.profesori;

--ALTER SCHEMA plan_studii
--TRANSFER dbo.discipline;

--ALTER SCHEMA plan_studii
--TRANSFER dbo.orarul;

--ALTER SCHEMA studenti
--TRANSFER dbo.studenti;

--ALTER SCHEMA studenti
--TRANSFER dbo.studenti_reusita;


-- 7. Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele tabelelor accesate sa fie descrise in mod explicit, 
-- tinand cont de faptul ca tabelele au fost mutate in scheme noi.
SELECT  DISTINCT discipline.Disciplina
        ,LEN(discipline.Disciplina) as length
FROM plan_studii.discipline
WHERE LEN(discipline.Disciplina)>20;

SELECT  DISTINCT studenti.Nume_Student
		,studenti.Prenume_Student
		,studenti_reusita.Id_Profesor
From studenti.studenti, studenti.studenti_reusita, plan_studii.discipline
where studenti.studenti.Id_Student=studenti.studenti_reusita.Id_Student
and studenti_reusita.Id_Disciplina=discipline.Id_Disciplina
and discipline.Nr_ore_plan_disciplina<60;


--8. Creati sinonimele respective pentru a simplifica interogarile construite in exercitiul precedent ~i reformulati interogarile, folosind sinonimele create. 

CREATE SYNONYM  ore FOR universitatea.plan_studii.discipline;

SELECT * from ore;

SELECT  DISTINCT ore.Disciplina
        ,LEN(ore.Disciplina) as length
FROM ore
WHERE LEN(ore.Disciplina)>20;

CREATE SYNONYM  st FOR universitatea.studenti.studenti;

SELECT * from st;

CREATE SYNONYM  reusita FOR universitatea.studenti.studenti_reusita;

SELECT  DISTINCT st.Nume_Student
		,st.Prenume_Student
		,reusita.Id_Profesor
From st, reusita, ore
where st.Id_Student=reusita.Id_Student
and reusita.Id_Disciplina=ore.Id_Disciplina
and ore.Nr_ore_plan_disciplina<60;