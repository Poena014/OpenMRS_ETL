use OpenmrsETL
go

DROP TABLE IF EXISTS DimTipoVisita

CREATE TABLE DimTipoVisita(
	TipoVisitaKey INT Primary Key IDENTITY(1,1),
	TipoVisitaId INT NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	Descripcion VARCHAR(100) NOT NULL
)

CREATE INDEX primary_ind ON DimTipoVisita (TipoVisitaKey)
GO