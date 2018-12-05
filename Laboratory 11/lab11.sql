--1. Sa se creeze un dosar Backup_lab11. Sa se execute un backup complet al bazei de date universitatea in acest dosar. 
--Fisierul copiei de rezerva sa se numeasca exercitiu11.bak. Sa se scrie instructiunea SQL respectiva.
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device01')
EXEC sp_dropdevice 'device01' , 'delfile';
EXEC sp_addumpdevice 'DISK', 'device01','D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\Backup_lab1\device01_exercitiul1.bak'
GO 
BACKUP DATABASE universitatea
TO device01 WITH FORMAT,
NAME = N'universitatea-Full Database Backup'
GO

--2 Sa se scrie instructiunea unui backup diferentiat al bazei de date universitatea.
--  Fisierul copiei de rezerva sa se numeasca exercitiul2.bak. 
IF EXISTS (SELECT * FROM master.dbo.sysdevices WHERE name='device02')
EXEC sp_dropdevice 'device02' , 'delfile';

EXEC sp_addumpdevice 'DISK', 'device02','D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\Backup_lab1\device02_exercitiul2.bak'
GO 
BACKUP DATABASE universitatea
TO device02 WITH FORMAT,
NAME = N'universitatea-Differential Database Backup'
GO
  
--3 Sa se scrie instructiunea unui backup al jurnalului de tranzactii al bazei de date universitatea. 
--Fisierul copiei de rezerva sa se numeasca exercitiul3.bak


GO
EXEC sp_addumpdevice 'DISK', 'backup_Log', 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\Backup_lab1\exercitiul3.bak'

GO
BACKUP LOG universitatea TO backup_Log
GO

--4 Sa se execute restaurarea consecutiva a tuturor copiilor de rezerva create. Recuperarea trebuie sa fie realizata intr-o baza de date noua universitatea_lab11.
-- Fisierele bazei de date noise afla in dosarul BD_lab11. Sa se scrie instructiunile SQL respective 

IF EXISTS (SELECT * FROM master.sys.databases WHERE name='universitatea_lab11')
DROP DATABASE universitatea_lab11;
GO
RESTORE DATABASE universitatea_lab11
FROM DISK ='D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\Backup_lab1\device01_exercitiul1.bak'
WITH MOVE 'universitatea' TO 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\BD_lab11\data.mdf',
MOVE 'universitatea_File2' TO 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\BD_lab11\data1.ndf',
MOVE 'universitatea_File3' TO 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\BD_lab11\data2.ndf',
MOVE 'Indexes' TO 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\BD_lab11\data3.ndf',
MOVE 'universitatea_log' TO 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\BD_lab11\log.ldf',
NORECOVERY
GO
RESTORE LOG universitatea_lab11
FROM DISK = 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\Backup_lab1\exercitiul3.bak'
WITH NORECOVERY
GO
RESTORE DATABASE universitatea_lab11
FROM DISK = 'D:\SQL\MSSQL14.MSSQLSERVER\Laboratoare\Backup_lab1\device02_exercitiul2.bak'
WITH 
NORECOVERY
GO