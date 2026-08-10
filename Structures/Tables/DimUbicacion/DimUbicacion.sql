use OpenmrsETL
go

DROP TABLE IF EXISTS DimUbicacion

CREATE TABLE DimUbicacion(
	UbicacionKey INT Primary Key Identity(1,1),
	DireccionId INT NOT NULL,
	DireccionCompleta VARCHAR(500) NOT NULL,
	Pais Varchar(100) NOT NULL,
	Ciudad VARCHAR(100) NOT NULL,
	Departamento VARCHAR(100) NOT NULL,
	CodigoPostal VARCHAR(10) NOT NULL
)

CREATE INDEX primary_ind ON DimUbicacion (UbicacionKey)
GO