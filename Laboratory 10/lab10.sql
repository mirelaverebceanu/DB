--1. Sa se modifice declansatorul inregistrare _ noua, in asa fel, incat in cazul actualizarii auditoriului sa apara mesajul de informare, care, in afara de disciplina si ora,
-- va afisa codul grupei afectate, ziua, blocul, auditoriul vechi si auditoriul nou. 
DROP TRIGGER IF EXISTS inregistrare_noua
GO
CREATE TRIGGER inregistrare_noua ON plan_studii.orarul
	AFTER UPDATE
	AS SET NOCOUNT ON 
		IF UPDATE (Auditoriu)
			SELECT	'Lectia la disciplina ' + UPPER(Disciplina)+ 
					' de la ora '+ CAST(inserted.Ora AS VARCHAR(5))+
					', pentru Cod grupa '+ Cod_Grupa+
					' din ziua de '+ inserted.Zi +
					', blocul '+inserted.Bloc+
					' din auditoriul vechi: '+ CAST(del.Auditoriu AS CHAR(10))+
					'se modifica in auditoriul nou '+ CAST(inserted.Auditoriu AS CHAR(10))
			FROM inserted JOIN grupe g ON inserted.Id_Grupa=g.Id_Grupa
						  JOIN plan_studii.discipline d ON inserted.Id_Disciplina = d.Id_Disciplina 
						  JOIN deleted del ON del.Id_Grupa=g.Id_Grupa
						 
UPDATE plan_studii.orarul SET Auditoriu =512 WHERE Zi='Lu'
GO

--2. Sa se creeze declansatorul, care ar asigura popularea corecta (consecutiva) a tabelelor studenti si studenti_reusita, si ar permite evitarea erorilor la nivelul cheilor exteme.
GO

CREATE TRIGGER populate_table on studenti.studenti_reusita
	INSTEAD OF INSERT
	AS SET NOCOUNT ON
		DECLARE @Id_Student int 
		,@Nume_Student varchar(50) ='Cirnat'
		,@Prenume_Student varchar(50) ='Nadejda'
		SELECT @Id_Student = Id_Student FROM inserted
		INSERT INTO studenti.studenti VALUES(@Id_Student, @Nume_Student, @Prenume_Student)
		INSERT INTO studenti.studenti_reusita 
		select * from inserted;

insert into studenti.studenti_reusita values(450,108,101,1,'Testul 1', null, null)
select * from studenti.studenti
select DISTINCT * from studenti.studenti_reusita
GO

--3. Sa se creeze un declansator, care ar interzice micsorarea notelor in tabelul studenti_reusita si modificarea valorilor campului Data_Evaluare, unde valorile acestui camp sunt nenule. 
--	 Declansatorul trebuie sa se lanseze, numai daca sunt afectate datele studentilor din grupa "CIB 1 71 ". Se va afisa un mesaj de avertizare in cazul tentativei de a incalca constrangerea. 
GO

CREATE TRIGGER change_column ON studenti.studenti_reusita
AFTER UPDATE
AS
SET NOCOUNT ON
 IF UPDATE(NOTA)
DECLARE @ID_GRUPA INT = (select Id_Grupa from grupe where Cod_Grupa='CIB171')
IF (SELECT AVG(NOTA) FROM deleted WHERE Id_Grupa=@ID_GRUPA AND NOTA IS NOT NULL)>(SELECT AVG(NOTA) FROM inserted WHERE Id_Grupa=@ID_GRUPA AND NOTA IS NOT NULL)
BEGIN
PRINT('Nu se permite miscrorarea notelor pentru grupa CIB171')
ROLLBACK TRANSACTION
END
IF UPDATE(DATA_EVALUARE) 
BEGIN
PRINT 'Nu este permisa modificarea pe coloana Data_Evaluare'
ROLLBACK TRANSACTION
end
UPDATE studenti.studenti_reusita SET Nota=nota-1 WHERE Id_Grupa= (select Id_Grupa from grupe where Cod_Grupa='CIB171')
UPDATE studenti.studenti_reusita SET Data_Evaluare='2018-01-25' WHERE Id_Grupa= (select Id_Grupa from grupe where Cod_Grupa='CIB171')
SELECT * FROM studenti.studenti_reusita

--4. Sa se creeze un declansator DDL care ar interzice modificarea coloanei Id_Disciplina in tabelele bazei de date universitatea cu afisarea mesajului respectiv. 
GO 
CREATE TRIGGER modify_column on database
FOR Alter_Table
AS 
SET NOCOUNT ON
DECLARE @data_nastere varchar(50)
SELECT @data_nastere=EVENTDATA().value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]', 'nvarchar(100)') 
IF @data_nastere='Data_Nastere_Student'
BEGIN 
PRINT ('Nu poate fi modificata coloana Data_Nastere_Student')
rollback;
END

ALTER TABLE studenti.studenti ALTER COLUMN Data_Nastere_Student date

--5. Sa se creeze un declansator DDL care ar interzice modificarea schemei bazei de date in afara orelor de lucru.
GO 
CREATE TRIGGER modify_scheme ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @Curent_time DATETIME  
DECLARE @start DATETIME  
DECLARE @end DATETIME  
DECLARE @s FLOAT  
DECLARE @e FLOAT  
SELECT @Curent_time = GETDATE() 
SELECT @start = '2011-12-22 9:00:00.000'  
SELECT @end = '2011-12-22 18:00:00.000' 
SELECT @s =(cast(@Curent_time as float) - floor(cast(@Curent_time as float)))- (cast(@start as float) - floor(cast(@start as FLOAT))),                
@e = (cast(@Curent_time as float) - floor(cast(@Curent_time as float))) -(cast(@end as float) - floor(cast(@end as FLOAT))) 
 
 IF @s<0 OR @e>0   
 BEGIN   
 Print ('Înafara orelor de lucru nu potoate fi modificată baza de date')  
  ROLLBACK   
  END

ALTER TABLE plan_studii.discipline ADD try1 int
--6. Sa se creeze un declansator DDL care, la modificarea proprietatilor coloanei Id_Profesor dintr-un tabel, ar face schimbari asemanatoare in mod automat in restul tabelelor.
GO 
CREATE TRIGGER modify_propreties ON DATABASE
FOR ALTER_TABLE
AS
SET NOCOUNT ON
DECLARE @Prenume_Profesor varchar(25)
DECLARE @int_I varchar(500) 
DECLARE @int_M varchar(500) 
DECLARE @den_T varchar(50)
SELECT @Prenume_Profesor=EVENTDATA(). value('(/EVENT_INSTANCE/AlterTableActionList/*/Columns/Name)[1]','nvarchar(max)')
IF @Prenume_Profesor='Prenume_Profesor'
	BEGIN
	SELECT @int_I = EVENTDATA().value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]','nvarchar(max)') 
	SELECT @den_T = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]','nvarchar(max)')
	 SELECT @int_M = REPLACE(@int_I, @den_T, 'profesori');EXECUTE (@int_M) 
	 SELECT @int_M = REPLACE(@int_I, @den_T, 'profesori_new');EXECUTE (@int_M)

	    PRINT 'Datele au fost modificate'    
	END
 
 ALTER TABLE profesori alter column Prenume_Profesor varchar(20)