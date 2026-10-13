USE OpenmrsETL;
GO

CREATE OR ALTER PROCEDURE dbo.ActualizarTiempo
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ValorParametro VARCHAR(500);

    SELECT @ValorParametro = Valor
    FROM dbo.Parametros
    WHERE Nombre = 'FechaUltimaEjecucion';

    IF @ValorParametro IS NULL OR ISDATE(@ValorParametro) = 0
    BEGIN
        RAISERROR('Parametro FechaUltimaEjecucion no existe o no es una fecha valida.', 16, 1);
        RETURN;
    END

    DECLARE @FechaInicio DATE = CAST(@ValorParametro AS DATE);
    DECLARE @FechaFin    DATE = CAST(GETDATE() AS DATE);

    DECLARE @MaxFecha DATETIME = NULL;

    SELECT @MaxFecha = MAX(Fecha) FROM dbo.DimTiempo;

    IF @MaxFecha IS NOT NULL AND DATEADD(DAY, 1, CAST(@MaxFecha AS DATE)) > @FechaInicio
        SET @FechaInicio = DATEADD(DAY, 1, CAST(@MaxFecha AS DATE));

    IF @FechaInicio > @FechaFin
    BEGIN
        PRINT 'Sin fechas pendientes por insertar.';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM dbo.DimTiempo WHERE TiempoKey = 0)
        INSERT INTO dbo.DimTiempo (TiempoKey, Fecha, Dia, Mes, Anio)
        VALUES (0, '1900-01-01', 1, 1, 1900);

    DECLARE @FechaActual DATE = @FechaInicio;
    DECLARE @TiempoKey INT;
    DECLARE @Dia INT;
    DECLARE @Mes INT;
    DECLARE @Anio INT;

    WHILE @FechaActual <= @FechaFin
    BEGIN
        IF NOT EXISTS (
            SELECT 1
            FROM dbo.DimTiempo
            WHERE CAST(Fecha AS DATE) = @FechaActual
        )
        BEGIN
            SET @TiempoKey = CONVERT(INT, CONVERT(VARCHAR(8), @FechaActual, 112));
            SET @Dia  = DAY(@FechaActual);
            SET @Mes  = MONTH(@FechaActual);
            SET @Anio = YEAR(@FechaActual);

            INSERT INTO dbo.DimTiempo (TiempoKey, Fecha, Dia, Mes, Anio)
            VALUES (@TiempoKey, @FechaActual, @Dia, @Mes, @Anio);
        END

        SET @FechaActual = DATEADD(DAY, 1, @FechaActual);
    END
END
