use OpenmrsETL
go

DROP TABLE IF EXISTS DimUbicacion

CREATE TABLE DimUbicacion(
	UbicacionKey INT IDENTITY(1,1),
	DireccionId INT NOT NULL,
	Pais Varchar(100) NOT NULL,
	Ciudad VARCHAR(100) NOT NULL,
	Departamento VARCHAR(100) NOT NULL,
	Municipio VARCHAR(200) NOT NULL,
	CodigoPostal VARCHAR(10) NULL
)

ALTER TABLE DimUbicacion 
ADD CONSTRAINT PK_Ubicacion PRIMARY KEY (UbicacionKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimUbicacion
ON DimUbicacion (UbicacionKey);