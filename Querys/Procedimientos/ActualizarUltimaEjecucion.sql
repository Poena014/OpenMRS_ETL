USE OpenmrsETL;
GO

CREATE OR ALTER PROCEDURE dbo.ActualizarUltimaEjecucion
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FechaEjecucion VARCHAR(23) = CONVERT(VARCHAR(23), GETDATE(), 121);

    IF EXISTS (SELECT 1 FROM dbo.Parametros WHERE Nombre = 'FechaUltimaEjecucion')
        UPDATE dbo.Parametros
        SET Valor = @FechaEjecucion
        WHERE Nombre = 'FechaUltimaEjecucion';
    ELSE
        INSERT INTO dbo.Parametros (Nombre, Valor)
        VALUES ('FechaUltimaEjecucion', @FechaEjecucion);
END
GO