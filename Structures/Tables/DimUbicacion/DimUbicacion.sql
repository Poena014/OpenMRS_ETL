use OpenmrsETL
go

DROP TABLE IF EXISTS DimUbicacion

CREATE TABLE DimUbicacion(
	UbicacionKey INT Primary Key Identity(1,1),
	DireccionId INT NOT NULL,
	Pais Varchar(100) NOT NULL,
	Ciudad VARCHAR(100) NOT NULL,
	Departamento VARCHAR(100) NOT NULL,
	Municipio VARCHAR(200) NOT NULL
	CodigoPostal VARCHAR(10) NULL
)

CREATE INDEX primary_ind ON DimUbicacion (UbicacionKey)
GO