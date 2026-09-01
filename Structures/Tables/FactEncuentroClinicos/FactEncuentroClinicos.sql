use OpenmrsETL
GO

DROP TABLE IF EXISTS FactEncuentroClinicos
DROP TABLE IF EXISTS StageFactEncuentroClinicos
GO

CREATE TABLE StageFactEncuentroClinicos(
	EncounterId INT NOT NULL,
	PacienteId INT NOT NULL,
	ProviderId INT NULL,
	DireccionId INT NULL,
	EncounterTypeId INT NOT NULL,
	FechaEncuentro DATETIME NOT NULL,
	FechaCreacion DATETIME NULL,
	VisitId INT NULL,
	EstaAnulado BIT NOT NULL,
	CantidadEncuentros INT NOT NULL,
	FechaProceso DATETIME NOT NULL
)
GO

CREATE TABLE FactEncuentroClinicos(
	FactEncuentroClinicoKey INT Primary Key IDENTITY(1,1),
	EncounterId INT NOT NULL,
	PacienteKey INT NOT NULL FOREIGN KEY REFERENCES DimPaciente(PacienteKey),
	ProveedorKey INT NULL FOREIGN KEY REFERENCES DimProveedor(ProveedorKey),
	UbicacionKey INT NULL FOREIGN KEY REFERENCES DimUbicacion(UbicacionKey),
	TipoEncuentroKey INT NOT NULL FOREIGN KEY REFERENCES DimTipoEncuentro(TipoEncuentroKey),
	FechaEncuentroKey INT NOT NULL FOREIGN KEY REFERENCES DimTiempo(TiempoKey),
	FechaCreacionKey INT NULL FOREIGN KEY REFERENCES DimTiempo(TiempoKey),
	VisitId INT NULL,
	EstaAnulado BIT NOT NULL,
	CantidadEncuentros INT NOT NULL,
	FechaProceso DATETIME NOT NULL
)
GO

CREATE UNIQUE INDEX encounter_id_ind ON FactEncuentroClinicos (EncounterId)
CREATE INDEX paciente_fecha_encuentro_ind ON FactEncuentroClinicos (PacienteKey, FechaEncuentroKey)
CREATE INDEX tipo_encuentro_ind ON FactEncuentroClinicos (TipoEncuentroKey)
CREATE INDEX stage_encounter_id_ind ON StageFactEncuentroClinicos (EncounterId)
GO
