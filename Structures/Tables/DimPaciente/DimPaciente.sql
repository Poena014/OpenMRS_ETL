use OpenmrsETL
go

DROP TABLE IF EXISTS DimPaciente

CREATE TABLE DimPaciente(
	PacienteKey INT Primary Key IDENTITY(1,1),
	PacienteId INT NOT NULL,
	Nombres VARCHAR(255) NOT NULL,
	Apellidos VARCHAR(255) NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	FechaIngreso DATETIME NOT NULL,
	FechaBaja DATETIME NULL,
	FechaProceso DATETIME NOT NULL
)

CREATE INDEX primary_ind ON DimPaciente (PacienteKey)
GO