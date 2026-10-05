use OpenmrsETL
GO

delete from DimProveedor
dbcc checkident('DimProveedor',RESEED,0)

--SELECT * FROM DimProveedor
