use OpenmrsETL
go

DROP TABLE IF EXISTS DimTipoVisita

CREATE TABLE DimTipoVisita(
	TipoVisitaKey INT Primary Key IDENTITY(1,1),
	TipoVisitaId INT NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	Descripcion VARCHAR(100) NOT NULL
)

ALTER TABLE DimTipoVisita
ADD CONSTRAINT PK_TipoVisita PRIMARY KEY (TipoVisitaKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimTipoVisita
ON DimTipoVisita (TipoVisitaKey)