use OpenmrsETL
GO 

DROP TABLE IF EXISTS FactCondicionClinica

CREATE TABLE FactCondicionClinica(
	PacienteKey INT NOT NULL FOREIGN KEY REFERENCES
		DimPaciente(PacienteKey),
	ConceptoClinicoKey INT NOT NULL FOREIGN KEY REFERENCES
		DimConceptoClinico(ConceptoClinicoKey),
	CondicionClinicaKey INT NOT NULL FOREIGN KEY REFERENCES
		DimCondicionClinica(CondicionClinicaKey),
	UbicacionKey INT NOT NULL FOREIGN KEY REFERENCES
		DimUbicacion(UbicacionKey),
	FechaIngreso INT NOT NULL FOREIGN KEY REFERENCES
		DimTiempo(TiempoKey),
	FechaCierre INT NOT NULL FOREIGN KEY REFERENCES
		DimTiempo(TiempoKey),
	CantidadCondicion INT NOT NULL,
	NombreCondicion INT NOT NULL
)

--CREATE INDEX primary_ind ON FactCondicionClinica (id)
--GO

--SELECT * FROM FactCondicionClinica