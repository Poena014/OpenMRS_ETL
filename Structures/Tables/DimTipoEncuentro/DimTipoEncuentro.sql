use OpenmrsETL
go

DROP TABLE IF EXISTS DimTipoEncuentro

CREATE TABLE DimTipoEncuentro(
	TipoEncuentroKey INT Primary Key IDENTITY(1,1),
	EncounterTypeId INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Descripcion VARCHAR(500) NOT NULL,
	EstaRetirado BIT NOT NULL,
	FechaCreacion DATETIME NOT NULL,
	FechaRetiro DATETIME NULL,
	FechaProceso DATETIME NOT NULL
)

CREATE INDEX primary_ind ON DimTipoEncuentro (TipoEncuentroKey)
CREATE UNIQUE INDEX encounter_type_id_ind ON DimTipoEncuentro (EncounterTypeId)
GO
