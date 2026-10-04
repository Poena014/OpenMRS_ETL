use OpenmrsETL
GO

delete from DimSignoVital
dbcc checkident('DimSignoVital',RESEED,0)