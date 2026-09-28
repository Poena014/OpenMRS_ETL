use OpenmrsETL
go

DROP TABLE IF EXISTS DimPaciente

CREATE TABLE DimPaciente(
	PacienteKey INT IDENTITY(1,1),
	PacienteId INT NOT NULL,
	Nombres VARCHAR(255) NOT NULL,
	Apellidos VARCHAR(255) NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	FechaIngreso DATETIME NOT NULL
)

ALTER TABLE DimPaciente 
ADD CONSTRAINT PK_Paciente  PRIMARY KEY (PacienteKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimPaciente
ON DimPaciente (PacienteKey);