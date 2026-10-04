use OpenmrsETL
GO

delete from FactMedicamentos

dbcc checkident('FactMedicamentos',RESEED,0)