use OpenmrsETL
GO 

CREATE TABLE FactVisita(
	VisitaKey INT IDENTITY(1,1) NOT NULL,
	VisitaID INT NOT NULL,
	PacienteKey INT NOT NULL,
	FechaInicioKey INT NOT NULL,
	FechaInicio DATETIME NOT NULL,
	FechaFinKey INT,
	FechaFin DATETIME,
	UbicacionKey INT NOT NULL,
	TipoVisitaKey INT NOT NULL,
	CantidadVisitas INT NOT NULL,
	DuracionMinutos INT,
	EstaActiva BIT NOT NULL
)

ALTER TABLE FactVisita ADD CONSTRAINT PK_Visita PRIMARY KEY (VisitaKey);

ALTER TABLE FactVisita
ADD CONSTRAINT FK_DimPaciente_Visita
FOREIGN KEY (PacienteKey) REFERENCES DimPaciente(PacienteKey);
GO

ALTER TABLE FactVisita
ADD CONSTRAINT FK_DimTiempoInicio_Visita
FOREIGN KEY (FechaInicioKey) REFERENCES DimTiempo(TiempoKey);
GO

ALTER TABLE FactVisita
ADD CONSTRAINT FK_DimTiempoFin_Visita
FOREIGN KEY (FechaFinKey) REFERENCES DimTiempo(TiempoKey);
GO

ALTER TABLE FactVisita
ADD CONSTRAINT FK_DimUbicacion_Visita
FOREIGN KEY (UbicacionKey) REFERENCES DimUbicacion(UbicacionKey);
GO

ALTER TABLE FactVisita
ADD CONSTRAINT FK_DimTipoVisita_Visita
FOREIGN KEY (TipoVisitaKey) REFERENCES DimTipoVisita(TipoVisitaKey);
GO
