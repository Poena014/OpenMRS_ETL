use OpenmrsETL
GO

delete from DimEnfermedad
dbcc checkident('DimEnfermedad',RESEED,0)