use OpenmrsETL
go

DROP TABLE IF EXISTS DimPaciente

CREATE TABLE DimPaciente(
	PacienteKey INT Primary Key,
	PaciendteId INT NOT NULL,
	Nombres VARCHAR(100) NOT NULL,
	Apellidos VARCHAR(100) NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	Peso Numeric(18,6) NOT NULL,
	Direccion VARCHAR(200) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	FechaIngreso DATETIME NOT NULL,
	FechaBaja DATETIME NOT NULL
)

CREATE INDEX primary_ind ON DimPaciente (PacienteKey)
GO