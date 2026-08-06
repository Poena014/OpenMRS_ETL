use OpenmrsETL
go

DROP TABLE IF EXISTS DimConceptoClinico

CREATE TABLE DimConceptoClinico(
	ConceptoClinicoKey INT Primary Key,
	ConceptoId INT,
	NombreCompleto VARCHAR(100),
	NombreCorto VARCHAR(30),
	ClaseConcepto INT,
	CategoriaConcepto INT
)

CREATE INDEX primary_ind ON DimConceptoClinico (ConceptoClinicoKey)
GO