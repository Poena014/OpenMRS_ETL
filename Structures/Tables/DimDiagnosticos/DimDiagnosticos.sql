use OpenmrsETL
go

DROP TABLE IF EXISTS DimDiagnosticos

CREATE TABLE DimDiagnosticos(
	DiagnosticoKey INT Primary Key Identity(1,1),
	DiagnosticoId INT,
	NombreCompleto VARCHAR(255),
	NombreCorto VARCHAR(30),
	CategoriaConcepto VARCHAR(50),
	Cantidad INT
)

CREATE INDEX primary_ind ON DimDiagnosticos (DiagnosticoKey)
GO