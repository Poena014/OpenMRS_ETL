
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
GO


CREATE TABLE DimPaciente(
	PacienteKey INT IDENTITY(1,1),
	PacienteId INT NOT NULL,
	Nombres VARCHAR(255) NOT NULL,
	Apellidos VARCHAR(255) NOT NULL,
	Sexo VARCHAR(1) NOT NULL,
	FechaNacimiento DATE NOT NULL,
	FechaIngreso DATETIME NOT NULL
)
GO


--DROP TABLE DimUbicacion

CREATE TABLE DimUbicacion(
	UbicacionKey INT IDENTITY(1,1),
	DireccionId VARCHAR(1200) NOT NULL,
	Pais Varchar(255) NOT NULL,
	Ciudad VARCHAR(255) NOT NULL,
	Departamento VARCHAR(255) NOT NULL,
	CodigoPostal VARCHAR(20) NULL
)
GO


CREATE TABLE DimTiempo(
	TiempoKey INT NOT NULL,
	Fecha DATETIME NOT NULL,
	Dia TINYINT NOT NULL,
	Mes TINYINT NOT NULL,
	Anio SMALLINT NOT NULL
)
GO

CREATE TABLE DimMedicamento(
    MedicamentoKey INT IDENTITY(1,1),
    MedicamentoId INT NOT NULL,
    Nombre VARCHAR(255),
    Fortaleza VARCHAR(50),
    ConceptoId INT,
    EstaRetirado BIT DEFAULT 0
)
GO

CREATE TABLE DimLocal(
	LocalKey INT IDENTITY(1,1),
	LocalId INT NOT NULL,
	Nombre VARCHAR(255),
	Ciudad VARCHAR(100),
	Departamento VARCHAR(100),
	Pais VARCHAR(100),
	EstaRetirado BIT DEFAULT 0
)
GO

CREATE TABLE DimTipoEncuentro(
	TipoEncuentroKey INT IDENTITY(1,1),
	EncounterTypeId INT NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Descripcion VARCHAR(500) NOT NULL,
	EstaRetirado BIT NOT NULL,
	FechaCreacion DATETIME NOT NULL,
	FechaRetiro DATETIME NULL,
	FechaProceso DATETIME NOT NULL
)
GO

CREATE TABLE DimProveedor(
	ProveedorKey INT IDENTITY(1,1),
	ProviderId INT NOT NULL,
	PersonId INT NULL,
	NombreCompleto VARCHAR(255) NOT NULL,
	Identificador VARCHAR(255) NOT NULL,
	EstaRetirado BIT NOT NULL,
	FechaCreacion DATETIME NOT NULL,
	FechaRetiro DATETIME NULL,
	FechaProceso DATETIME NOT NULL
)
GO

CREATE TABLE DimTipoVisita(
	TipoVisitaKey INT IDENTITY(1,1),
	TipoVisitaId INT NOT NULL,
	Nombre VARCHAR(100) NOT NULL,
	Descripcion VARCHAR(100) NOT NULL
)
GO

CREATE TABLE DimSignoVital(
	SignoVitalKey INT IDENTITY(1,1),
	SignoVitalId INT NOT NULL,
	Nombre VARCHAR(255) NOT NULL,
	Unidad VARCHAR(50),
	EstaRetirado BIT DEFAULT 0
)
GO

--DROP TABLE FactDiagnosticos

CREATE TABLE FactDiagnosticos(
	DiagnosticoKey INT IDENTITY(1,1) NOT NULL,
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
GO

CREATE TABLE FactMedicamentos(
	MedicamentoPedidoKey INT IDENTITY(1,1),
	MedicamentoKey INT NOT NULL,
	PacienteKey INT NOT NULL,
	ProveedorKey INT NOT NULL,
	UbicacionKey INT NOT NULL,
	LocalKey INT NOT NULL,
	TiempoKey INT NOT NULL,
	TipoVisitaKey INT NOT NULL,
	Dosis DECIMAL(10,2),
	Cantidad INT,
	NumRefills INT,
	EdadSuceso INT
)
GO


CREATE TABLE FactVitales(
	VitalKey INT IDENTITY(1,1),
	SignoVitalKey INT NOT NULL,
	PacienteKey INT NOT NULL,
	ProveedorKey INT NOT NULL,
	UbicacionKey INT NOT NULL,
	LocalKey INT NOT NULL,
	TiempoKey INT NOT NULL,
	Valor DECIMAL(18,2),
	EdadSuceso INT
)
GO

--SELECT * FROM FactDiagnosticos

ALTER TABLE DimEnfermedad 
ADD CONSTRAINT PK_Enfermedad  PRIMARY KEY (EnfermedadKey);

ALTER TABLE DimPaciente 
ADD CONSTRAINT PK_Paciente  PRIMARY KEY (PacienteKey);

ALTER TABLE DimUbicacion 
ADD CONSTRAINT PK_Ubicacion PRIMARY KEY (UbicacionKey);

ALTER TABLE DimTiempo 
ADD CONSTRAINT PK_Tiempo  PRIMARY KEY (TiempoKey);

ALTER TABLE DimMedicamento 
ADD CONSTRAINT PK_Medicamento PRIMARY KEY (MedicamentoKey);

ALTER TABLE FactDiagnosticos 
ADD CONSTRAINT PK_Diagnosticos PRIMARY KEY (DiagnosticoKey);

ALTER TABLE FactMedicamentos 
ADD CONSTRAINT PK_MedPedidos PRIMARY KEY (MedicamentoPedidoKey);

ALTER TABLE DimLocal 
ADD CONSTRAINT PK_Local PRIMARY KEY (LocalKey);

ALTER TABLE DimTipoEncuentro 
ADD CONSTRAINT PK_TipoEncuentro PRIMARY KEY (TipoEncuentroKey);

ALTER TABLE DimProveedor 
ADD CONSTRAINT PK_Proveedor PRIMARY KEY (ProveedorKey);

ALTER TABLE DimTipoVisita
ADD CONSTRAINT PK_TipoVisita PRIMARY KEY (TipoVisitaKey);

ALTER TABLE DimSignoVital
ADD CONSTRAINT PK_SignoVital PRIMARY KEY (SignoVitalKey);
GO

CREATE UNIQUE NONCLUSTERED INDEX ind_DimTipoVisita
ON DimTipoVisita (TipoVisitaKey)

CREATE UNIQUE NONCLUSTERED INDEX ind_DimProveedor
ON DimProveedor (ProveedorKey)

CREATE UNIQUE NONCLUSTERED INDEX ind_DimTipoEncuentro
ON DimTipoEncuentro (TipoEncuentroKey)

CREATE UNIQUE NONCLUSTERED INDEX ind_DimLocal
ON DimLocal (LocalKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_DimMedicamento
ON DimMedicamento (MedicamentoKey);

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

CREATE UNIQUE NONCLUSTERED INDEX ind_DimSignoVital
ON DimSignoVital (SignoVitalKey);
GO

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

CREATE UNIQUE NONCLUSTERED INDEX ind_FactMedicamentos
ON FactMedicamentos (MedicamentoPedidoKey);
GO

ALTER TABLE FactMedicamentos
ADD CONSTRAINT FK_DimMedicamento_Medicamentos
FOREIGN KEY (MedicamentoKey) REFERENCES DimMedicamento(MedicamentoKey);
GO

ALTER TABLE FactMedicamentos
ADD CONSTRAINT FK_DimPaciente_Medicamentos
FOREIGN KEY (PacienteKey) REFERENCES DimPaciente(PacienteKey);
GO

ALTER TABLE FactMedicamentos
ADD CONSTRAINT FK_DimProveedor_Medicamentos
FOREIGN KEY (ProveedorKey) REFERENCES DimProveedor(ProveedorKey);
GO

ALTER TABLE FactMedicamentos
ADD CONSTRAINT FK_DimUbicacion_Medicamentos
FOREIGN KEY (UbicacionKey) REFERENCES DimUbicacion(UbicacionKey);
GO

ALTER TABLE FactMedicamentos
ADD CONSTRAINT FK_DimLocal_Medicamentos
FOREIGN KEY (LocalKey) REFERENCES DimLocal(LocalKey);
GO

ALTER TABLE FactMedicamentos
ADD CONSTRAINT FK_DimTiempo_Medicamentos
FOREIGN KEY (TiempoKey) REFERENCES DimTiempo(TiempoKey);
GO

ALTER TABLE FactMedicamentos
ADD CONSTRAINT FK_DimTipoVisita_Medicamentos
FOREIGN KEY (TipoVisitaKey) REFERENCES DimTipoVisita(TipoVisitaKey);
GO


ALTER TABLE FactVitales
ADD CONSTRAINT PK_Vitales PRIMARY KEY (VitalKey);
GO

CREATE UNIQUE NONCLUSTERED INDEX ind_FactVitales
ON FactVitales (VitalKey);
GO

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimSignoVital_Vitales
FOREIGN KEY (SignoVitalKey) REFERENCES DimSignoVital(SignoVitalKey);
GO

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimPaciente_Vitales
FOREIGN KEY (PacienteKey) REFERENCES DimPaciente(PacienteKey);
GO

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimProveedor_Vitales
FOREIGN KEY (ProveedorKey) REFERENCES DimProveedor(ProveedorKey);
GO

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimUbicacion_Vitales
FOREIGN KEY (UbicacionKey) REFERENCES DimUbicacion(UbicacionKey);
GO

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimLocal_Vitales
FOREIGN KEY (LocalKey) REFERENCES DimLocal(LocalKey);
GO

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimTiempo_Vitales
FOREIGN KEY (TiempoKey) REFERENCES DimTiempo(TiempoKey);
GO