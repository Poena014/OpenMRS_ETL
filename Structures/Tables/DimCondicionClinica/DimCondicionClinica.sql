use OpenmrsETL
go

DROP TABLE IF EXISTS DimCondicionClinica

CREATE TABLE DimCondicionClinica(
	CondicionClinicaKey INT Primary Key,
	CondicionClinicaId INT NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	ConceptoAsociado INT,
	EsRecurrente INT,
	CategoriaConceptoId INT
)

CREATE INDEX primary_ind ON DimCondicionClinica (CondicionClinicaKey)
GO