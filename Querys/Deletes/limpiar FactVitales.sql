use OpenmrsETL
GO

delete from FactVitales

dbcc checkident('FactVitales',RESEED,0)