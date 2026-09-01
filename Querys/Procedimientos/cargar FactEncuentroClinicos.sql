use OpenmrsETL
GO

INSERT INTO FactEncuentroClinicos (
	EncounterId,
	PacienteKey,
	ProveedorKey,
	UbicacionKey,
	TipoEncuentroKey,
	FechaEncuentroKey,
	FechaCreacionKey,
	VisitId,
	EstaAnulado,
	CantidadEncuentros,
	FechaProceso
)
SELECT
	s.EncounterId,
	dp.PacienteKey,
	dpr.ProveedorKey,
	du.UbicacionKey,
	dte.TipoEncuentroKey,
	dtEncuentro.TiempoKey FechaEncuentroKey,
	dtCreacion.TiempoKey FechaCreacionKey,
	s.VisitId,
	s.EstaAnulado,
	s.CantidadEncuentros,
	s.FechaProceso
FROM StageFactEncuentroClinicos s
JOIN (
	SELECT PacienteId, MIN(PacienteKey) PacienteKey
	FROM DimPaciente
	GROUP BY PacienteId
) dp ON s.PacienteId = dp.PacienteId
JOIN DimTipoEncuentro dte ON s.EncounterTypeId = dte.EncounterTypeId
JOIN DimTiempo dtEncuentro ON CONVERT(INT, CONVERT(VARCHAR(8), CAST(s.FechaEncuentro AS DATE), 112)) = dtEncuentro.TiempoKey
LEFT JOIN DimTiempo dtCreacion ON CONVERT(INT, CONVERT(VARCHAR(8), CAST(s.FechaCreacion AS DATE), 112)) = dtCreacion.TiempoKey
LEFT JOIN DimProveedor dpr ON s.ProviderId = dpr.ProviderId
LEFT JOIN (
	SELECT DireccionId, MIN(UbicacionKey) UbicacionKey
	FROM DimUbicacion
	GROUP BY DireccionId
) du ON s.DireccionId = du.DireccionId
WHERE NOT EXISTS (
	SELECT 1
	FROM FactEncuentroClinicos f
	WHERE f.EncounterId = s.EncounterId
)
GO
