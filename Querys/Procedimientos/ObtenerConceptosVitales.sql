USE OpenmrsETL
GO
CREATE OR ALTER PROCEDURE dbo.ObtenerSignosVitales
AS
-- EXEC dbo.ObtenerSignosVitales
BEGIN
  SET NOCOUNT ON;
  SELECT ISNULL(STRING_AGG(CAST(SignoVitalId AS varchar(20)), ','), '0') AS IdConceptos
  FROM dbo.DimSignoVital
  WHERE EstaRetirado = 0;   -- quita el WHERE si quieres incluir retirados
END