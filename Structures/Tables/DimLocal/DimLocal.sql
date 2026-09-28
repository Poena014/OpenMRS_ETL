use OpenmrsETL
GO

CREATE TABLE DimLocal(
	LocalKey INT IDENTITY(1,1),
	LocalId INT NOT NULL,
	Nombre VARCHAR(255),
	Ciudad VARCHAR(100),
	Departamento VARCHAR(100),
	Pais VARCHAR(100),
	EstaRetirado BIT DEFAULT 0
)

ALTER TABLE DimLocal 
ADD CONSTRAINT PK_Local PRIMARY KEY (LocalKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimLocal
ON DimLocal (LocalKey);

SET IDENTITY_INSERT DimLocal ON;
INSERT INTO DimLocal (LocalKey, LocalId, Nombre, Ciudad, Departamento, Pais, EstaRetirado)
VALUES (0, 0, 'Ninguno', 'N/CIUDAD', 'N/DEPARTAMENTO', 'N/PAIS', 1);
SET IDENTITY_INSERT DimLocal OFF;