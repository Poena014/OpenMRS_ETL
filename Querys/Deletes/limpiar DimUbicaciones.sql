use OpenmrsETL
GO

delete from DimUbicacion
dbcc checkident('DimUbicacion',RESEED,0)