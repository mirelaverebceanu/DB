Task 1:
Creati o diagrama a bazei de date, folosind fonna de vizualizare standard, structura careia este descrisa la inceputul 
sarcinilor practice din capitolul 4.
![ex1](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%207/Exercise%20screens/lab7.1.PNG)

vizualizare standard:
![ex1.1](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%207/Exercise%20screens/lab.7.PNG)

Task 2:
Sa se adauge constrangeri referentiale (legate cu tabelele studenti ~i profesori) necesare coloanelor Sef_grupa ~i
Prof_Indrumator (sarcina3, capitolul 6) din tabelul grupe. 
![ex2](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%207/Exercise%20screens/lab7.2.PNG)

Task 3:
La diagrama construitii, sa se adauge ~i tabelul orarul definit in capitolul 6 al acestei lucrari: tabelul orarul contine identificatorul disciplinei (ld_Disciplina), identificatorul
profesorului (Id_Profesor) ~i blocul de studii (Bloc). Cheia tabelului este constituita din trei cfunpuri: identificatorul grupei
(Id_ Grupa), ziua lectiei (Z1), ora de inceput a lectiei (Ora), sala unde are loc lectia (Auditoriu).
![ex3](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%207/Exercise%20screens/lab7.3.PNG)

Task 4:
Tabelul orarul trebuie sa contina ~i 2 chei secundare: (Zi, Ora, Id_ Grupa, Id_ Profesor) ~i (Zi, Ora, ld_Grupa, ld_Disciplina).
![ex4](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%207/Exercise%20screens/lab.7.4.1.PNG)

Task 5:
In diagrama, de asemenea, trebuie sa se defineasca constrangerile referentiale (FK-PK) ale atributelor ld_Disciplina, ld_Profesor,
Id_ Grupa din tabelului orarul cu atributele tabelelor respective.
![ex5](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%207/Exercise%20screens/lab.7.5.PNG)

Task 6:
Creati, in baza de date universitatea, trei scheme noi: cadre_didactice, plan_studii ~i studenti. 
Transferati tabelul profesori din schema dbo in schema cadre didactice, tinand cont de dependentelor definite asupra tabelului mentionat.
in acela~i mod ~ se trateze tabelele orarul, discipline care apartin schemei plan_studii ~i tabelele studenti, studenti_reusita, care
apartin schemei studenti. Se scrie instructiunile SQL respective. 

```SQL
CREATE SCHEMA cadre_didactice ;

CREATE SCHEMA plan_studii;

CREATE SCHEMA studenti;

ALTER SCHEMA cadre_didactice
TRANSFER dbo.profesori;

ALTER SCHEMA dbo
TRANSFER cadre_didactice.profesori;

ALTER SCHEMA plan_studii
TRANSFER dbo.discipline;

ALTER SCHEMA plan_studii
TRANSFER dbo.orarul;

ALTER SCHEMA studenti
TRANSFER dbo.studenti;

ALTER SCHEMA studenti
TRANSFER dbo.studenti_reusita;
```
Task 7:
Modificati 2-3 interogari asupra bazei de date universitatea prezentate in capitolul 4 astfel ca numele tabelelor accesate sa fie
descrise in mod explicit, tinand cont de faptul ca tabelele au fost mutate in scheme noi.
```SQL
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
```
Task 8:
Creati sinonimele respective pentru a simplifica interogarile construite in exercitiul precedent ~i reformulati interogarile, 
folosind sinonimele create. 
```SQL
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
```
