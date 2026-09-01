use OpenmrsETL
GO

DELETE FROM FactEncuentroClinicos
DBCC CHECKIDENT('FactEncuentroClinicos', RESEED, 0)

DELETE FROM StageFactEncuentroClinicos
GO
