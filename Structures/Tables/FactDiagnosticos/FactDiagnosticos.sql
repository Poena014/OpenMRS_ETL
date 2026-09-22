use OpenmrsETL
GO 

CREATE TABLE FactCondicionClinica(
	DiagnosticoKey INT NOT NULL,
	EnfermedadKey INT NOT NULL,
	PacienteKey INT NOT NULL,
	UbicacionKey INT NOT NULL,
	TiempoKey INT NOT NULL,
	temperatura DECIMAL(18,2),
	peso DECIMAL(18,2),
	edad INT,
	seguimiento BIT
)

CREATE INDEX primary_ind ON FactCondicionClinica (id)
GO