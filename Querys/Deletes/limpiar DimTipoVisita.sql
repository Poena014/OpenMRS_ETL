use OpenmrsETL
GO

delete from DimTipoVisita
dbcc checkident('DimTipoVisita',RESEED,0)

