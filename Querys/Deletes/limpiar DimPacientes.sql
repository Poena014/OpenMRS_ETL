use OpenmrsETL
GO

delete from DimPaciente
dbcc checkident('DimPaciente',RESEED,0)

--SELECT * FROM DimPaciente