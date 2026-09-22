use OpenmrsETL
go

CREATE TABLE DimEnfermedad(
	EnfermedadKey INT,
	EnfermedadId INT,
	Nombre VARCHAR(200),
	tipoEnfermedad VARCHAR(200),
	PorcentajeMortalidad Decimal(18,2)
)

CREATE INDEX primary_ind ON DimConceptoClinico (id)
GO