use OpenmrsETL
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

ALTER TABLE FactMedicamentos 
ADD CONSTRAINT PK_Medicamentos PRIMARY KEY (MedicamentoPedidoKey);

CREATE UNIQUE NONCLUSTERED INDEX ind_FactMedicamentos
ON FactMedicamentos (MedicamentoPedidoKey);
Referencias (FKs) — v2
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