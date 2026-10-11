USE OpenmrsETL
GO

INSERT INTO Parametros (Nombre, Valor)
VALUES ('FechaUltimaEjecucion','2026-10-05 10:30:00.000')


SELECT TOP 1 Valor FROM dbo.Parametros
WHERE Nombre='FechaUltimaEjecucion'