
use master
GO

DROP DATABASE IF EXISTS OpenmrsETL
GO

CREATE DATABASE OpenmrsETL
GO

USE OpenmrsETL
GO

CREATE TABLE DimEnfermedad(
	EnfermedadKey INT IDENTITY(1,1),
	EnfermedadId INT,
	Nombre VARCHAR(255),
	tipoEnfermedad VARCHAR(255)
)

CREATE TABLE DimPaciente(
	PacienteKey INT IDENTITY(1,1),
	PacienteId INT NOT NULL,
	Nombres VARCHAR(255) NOT NULL,
	Apellidos VARCHAR(255) NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	FechaIngreso DATETIME NOT NULL
)

--DROP TABLE DimUbicacion

CREATE TABLE DimUbicacion(
	UbicacionKey INT IDENTITY(1,1),
	DireccionId VARCHAR(1000) NOT NULL,
	Pais Varchar(100) NOT NULL,
	Ciudad VARCHAR(100) NOT NULL,
	Departamento VARCHAR(100) NOT NULL,
	CodigoPostal VARCHAR(10) NULL
)


CREATE TABLE DimTiempo(
	TiempoKey INT ,
	Fecha DATETIME NOT NULL,
	Dia TINYINT NOT NULL,
	Mes TINYINT NOT NULL,
	Anio SMALLINT NOT NULL
)

--DROP TABLE FactDiagnosticos

CREATE TABLE FactDiagnosticos(
	DiagnosticoKey INT NOT NULL,
	EnfermedadKey INT NOT NULL,
	PacienteKey INT NOT NULL,
	UbicacionKey INT NOT NULL,
	TiempoKey INT NOT NULL,
	Temperatura DECIMAL(18,2),
	Peso DECIMAL(18,2),
	Altura DECIMAL(18,2),
	EdadSuceso INT,
	EsRepetido INT
)

--SELECT * FROM FactDiagnosticos

ALTER TABLE DimEnfermedad 
ADD CONSTRAINT PK_Enfermedad  PRIMARY KEY (EnfermedadKey);

ALTER TABLE DimPaciente 
ADD CONSTRAINT PK_Paciente  PRIMARY KEY (PacienteKey);

ALTER TABLE DimUbicacion 
ADD CONSTRAINT PK_Ubicacion PRIMARY KEY (UbicacionKey);

ALTER TABLE DimTiempo 
ADD CONSTRAINT PK_Tiempo  PRIMARY KEY (TiempoKey);

ALTER TABLE FactDiagnosticos 
ADD CONSTRAINT PK_Diagnosticos PRIMARY KEY (DiagnosticoKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimEnfermedad
ON DimEnfermedad (EnfermedadKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimPaciente
ON DimPaciente (PacienteKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimUbicacion
ON DimUbicacion (UbicacionKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimTiempo
ON DimTiempo (TiempoKey);

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