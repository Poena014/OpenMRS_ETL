use OpenmrsETL
GO

delete from DimTipoEncuentro
dbcc checkident('DimTipoEncuentro',RESEED,0)