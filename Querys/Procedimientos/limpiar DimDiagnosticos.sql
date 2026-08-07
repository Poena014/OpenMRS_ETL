use OpenmrsETL
GO

delete from DimDiagnosticos
dbcc checkident('DimDiagnosticos',RESEED,0)