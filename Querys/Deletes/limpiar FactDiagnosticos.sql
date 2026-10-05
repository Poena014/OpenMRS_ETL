use OpenmrsETL
GO

delete from FactDiagnosticos

dbcc checkident('FactDiagnosticos',RESEED,0)