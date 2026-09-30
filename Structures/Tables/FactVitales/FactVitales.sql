use OpenmrsETL
GO

CREATE TABLE FactVitales(
	VitalKey INT IDENTITY(1,1),
	SignoVitalKey INT NOT NULL,
	PacienteKey INT NOT NULL,
	ProveedorKey INT NOT NULL,
	UbicacionKey INT NOT NULL,
	LocalKey INT NOT NULL,
	TiempoKey INT NOT NULL,
	TipoVisitaKey INT NOT NULL,
	TipoEncuentroKey INT NOT NULL,
	Valor DECIMAL(18,2),
	EdadSuceso INT
)
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

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimTipoVisita_Vitales
FOREIGN KEY (TipoVisitaKey) REFERENCES DimTipoVisita(TipoVisitaKey);
GO

ALTER TABLE FactVitales
ADD CONSTRAINT FK_DimTipoEncuentro_Vitales
FOREIGN KEY (TipoEncuentroKey) REFERENCES DimTipoEncuentro(TipoEncuentroKey);
GO
