use OpenmrsETL
GO

delete from DimTipoEncuentro
dbcc checkident('DimTipoEncuentro',RESEED,0)

--SELECT * FROM DimTipoEncuentro
