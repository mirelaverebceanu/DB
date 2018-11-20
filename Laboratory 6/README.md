Laboratory work nr. 6

--1. Sa se scrie o instructiune T-SQL, care ar popula co Joana Adresa _ Postala _ Profesor din tabelul profesori 
--cu valoarea 'mun. Chisinau', unde adresa este necunoscuta. 
![ex1](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.1.PNG)

--2. Sa se modifice schema tabelului grupe, ca sa corespunda urmatoarelor cerinte: 
--a) Campul Cod_ Grupa sa accepte numai valorile unice si sa nu accepte valori necunoscute. 
--b) Sa se tina cont ca cheie primarii, deja, este definitii asupra coloanei Id_ Grupa. 
![ex2](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.2.PNG)
![ex.2](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.2.1.PNG)

-- 3. La tabelul grupe, sa se adauge 2 coloane noi Sef_grupa si Prof_Indrumator, ambele de tip INT. 
--   Sa se populeze campurile nou-create cu cele mai potrivite candidaturi in baza criteriilor de mai jos:
-- a) Seful grupei trebuie sa aiba cea mai buna reusita (medie) din grupa la toate formele de evaluare si la toate disciplinele.
--    Un student nu poate fi sef de grupa la mai multe grupe. 
-- b) Profesorul indrumator trebuie sa predea un numar maximal posibil de discipline la grupa data. 
--    Daca nu exista o singura candidatura, care corespunde primei cerinte, atunci este ales din grupul de candidati acel cu identificatorul (Id_Profesor) minimal. 
--    Un profesor nu poate fi indrumator la mai multe grupe.
-- c) Sa se scrie instructiunile ALTER, SELECT, UPDATE necesare pentru crearea coloanelor in tabelul grupe, pentru selectarea candidatilor si inserarea datelor.
![ex3](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.3.PNG)
![ex.3](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.3.1.PNG)
--4. Sa se scrie o instructiune T-SQL, care ar mari toate notele de evaluare sefilor de grupe cu un punct. Nota maximala (10) nu poate fi miirita.
![ex4](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.4.PNG)

 -- 5. Sa se creeze un tabel profesori_new, care include urmatoarele coloane:
 --  Id_Profesor, Nume _ Profesor, Prenume _ Profesor, Localitate, Adresa _ 1, Adresa _2.
 --  a) Coloana Id_Profesor trebuie sa fie definita drept cheie primara si, in baza ei, sa fie construit un index CLUSTERED. 
 --  b) Campul Localitate trebuie sa posede proprietatea DEF A ULT= 'mun. Chisinau'.
 --  c) Sa se insereze toate datele din tabelul profesori in tabelul profesori_new. Sa se scrie, cu acest scop, un numar potrivit de instructiuni T-SQL.
 --  in coloana Localitate sii fie inserata doar informatia despre denumirea localitatii din coloana-sursa Adresa_Postala_Profesor. in coloana Adresa_l,
 --  doar denumirea strazii. in coloana Adresa_2, sa se pastreze numarul casei si (posibil) a apartamentului. 
 
 !Pentru a efectua exercitiul 5 am creat o functie, instr, valabila in PLSQL
 ![ex5](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.5.PNG)
 
--6. Sa se insereze datele in tabelul orarul pentru Grupa= 'CIBJ 71' (Id_ Grupa= 1) pentru ziua de luni. Toate lectiile vor avea loc in blocul de studii 'B'. 
--Mai jos, sunt prezentate detaliile de inserare: (ld_Disciplina = 107, Id_Profesor= 101, Ora ='08:00', Auditoriu = 202); 
--(Id_Disciplina = 108, Id_Profesor= 101, Ora ='11:30', Auditoriu = 501); (ld_Disciplina = 119, Id_Profesor= 117, Ora ='13:00', Auditoriu = 501);

![ex6](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.6.PNG)

-- 7. Sa se scrie expresiile T-SQL necesare pentru a popula tabelul orarul pentru grupa INFl 71 , ziua de luni.
--Datele necesare pentru inserare trebuie sa fie colectate cu ajutorul instructiunii/instructiunilor 
--SELECT ~i introduse in tabelul-destinatie, ~tiind ca: lectie #1 (Ora ='08:00', Disciplina = 'Structuri de date si algoritmi', Prof esor ='Bivol Ion')
-- lectie #2 (Ora ='11 :30', Disciplina = 'Programe aplicative', Profesor ='Mircea Sorin') lectie #3 (Ora ='13:00', Disciplina ='Baze de date', Profesor = 'Micu Elena') 

![ex7](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.7.PNG)

--8. Sa se scrie interogarile de creare a indecsilor asupra tabelelor din baza de date universitatea pentru a asigura o performanta sporita la executarea interogarilor 
--SELECT din Lucrarea practica 4. Rezultatele optimizarii sa fie analizate in baza planurilor de executie, pana la si dupa crearea indecsilor. 
--Indecsii nou-creati sa fie plasati fizic in grupul de fisiere userdatafgroupl (Crearea $i intrefinerea bazei de date - sectiunea 2.2.2)

![ex8](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.8.PNG)
![ex8](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.8.0.PNG)
![ex8](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.8.1.PNG)
![ex8](https://github.com/mirelaverebceanu/DB/blob/master/Laboratory%206/Exercise%20screens/lab6.8.2.PNG)
