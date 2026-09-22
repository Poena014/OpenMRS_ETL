use OpenmrsETL
GO 

CREATE TABLE FactDiagnosticos(
	DiagnosticoKey INT IDENTITY(1,1),
	EnfermedadKey INT NOT NULL,
	PacienteKey INT NOT NULL,
	UbicacionKey INT NOT NULL,
	TiempoKey INT NOT NULL,
	Temperatura DECIMAL(18,2),
	Peso DECIMAL(18,2),
	Edad INT,
	Seguimiento BIT
)

ALTER TABLE FactDiagnosticos 
ADD CONSTRAINT PK_Diagnosticos PRIMARY KEY (DiagnosticoKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_FactDiagnosticos
ON FactDiagnosticos (DiagnosticoKey);

ALTER TABLE FactDiagnosticos
ADD CONSTRAINT FK_DimEnfermedad_Diagnosticos
FOREIGN KEY (EnfermedadKey) REFERENCES DimEnfermedad(EnfermedadKey);
GO

ALTER TABLE FactDiagnosticos
ADD CONSTRAINT FK_DimPaciente_Diagnosticos
FOREIGN KEY (PacienteKey) REFERENCES DimPaciente(PacienteKey);
GO

ALTER TABLE FactDiagnosticos
ADD CONSTRAINT FK_DimUbicacion_Diagnosticos
FOREIGN KEY (UbicacionKey) REFERENCES DimUbicacion(UbicacionKey);
GO

ALTER TABLE FactDiagnosticos
ADD CONSTRAINT FK_DimTiempo_Diagnosticos
FOREIGN KEY (TiempoKey) REFERENCES DimTiempo(TiempoKey);
GO