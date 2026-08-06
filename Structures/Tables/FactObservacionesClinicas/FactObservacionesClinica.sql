use OpenmrsETL
GO 

DROP TABLE IF EXISTS FactCondicionClinica

CREATE TABLE FactCondicionClinica(
	PacienteId INT ,
	FechaId INT,
	LocationId INT,
	EncounterTypeId INT,
	ConceptId INT,
	CantidadObservaciones INT,
	esValida BIT
)

CREATE INDEX Paciente_Fecha_Ind ON FactCondicionClinica (PacienteId, FechaId)
GO