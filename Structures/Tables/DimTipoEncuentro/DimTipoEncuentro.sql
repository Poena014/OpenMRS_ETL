use OpenmrsETL
go

DROP TABLE IF EXISTS DimTipoEncuentro

CREATE TABLE DimTipoEncuentro(
	TipoEncuentroKey INT Primary Key,
	EncounterTypeId INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Descripcion VARCHAR(500) NOT NULL
)

CREATE INDEX primary_ind ON DimTipoEncuentro (TipoEncuentroKey)
GO