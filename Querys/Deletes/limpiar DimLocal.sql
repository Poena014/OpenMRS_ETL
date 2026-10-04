use OpenmrsETL
GO

delete from DimLocal
dbcc checkident('DimLocal',RESEED,0)