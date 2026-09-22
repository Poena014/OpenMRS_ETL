use OpenmrsETL
go

CREATE TABLE DimEnfermedad(
	EnfermedadKey INT IDENTITY(1,1),
	EnfermedadId INT,
	Nombre VARCHAR(200),
	tipoEnfermedad VARCHAR(200),
	PorcentajeMortalidad Decimal(18,2)
)

ALTER TABLE DimEnfermedad 
ADD CONSTRAINT PK_Enfermedad  PRIMARY KEY (EnfermedadKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimEnfermedad
ON DimEnfermedad (EnfermedadKey);