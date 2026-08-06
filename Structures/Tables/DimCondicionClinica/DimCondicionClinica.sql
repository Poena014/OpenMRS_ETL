use OpenmrsETL
go

CREATE TABLE DimConceptoClinico(
	id INT,
	campo1 VARCHAR(50)
)

CREATE INDEX primary_ind ON DimConceptoClinico (id)
GO