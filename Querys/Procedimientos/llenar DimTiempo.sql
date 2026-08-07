use OpenmrsETL
GO

DECLARE @FechaInicio DATE ='2023-01-01'
DECLARE @FechaFin DATE='2026-06-30'
DECLARE @FechaActual DATE = @FechaInicio

DECLARE @TiempoKey INT
DECLARE @Dia INT
DECLARE @Mes INT
DECLARE @Anio INT

WHILE @FechaActual<=@FechaFin
BEGIN
	SET @TiempoKey = CONVERT(INT, CONVERT(VARCHAR(8), @FechaActual, 112))
	SET @Dia=DAY(@FechaActual)
	SET @Mes=MONTH(@FechaActual)
	SET @Anio=YEAR(@FechaActual)

	INSERT INTO DimTiempo (TiempoKey,Fecha, Dia,Mes,Anio)
	VALUES (@TiempoKey,@FechaActual, @Dia,@Mes, @Anio)

	SET @FechaActual=DATEADD(DAY,1,@FechaActual)

END

SELECT * FROM DimTiempo

--TRUNCATE TABLE DimTiempo