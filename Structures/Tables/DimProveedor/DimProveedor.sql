use OpenmrsETL
go

DROP TABLE IF EXISTS DimProveedor

CREATE TABLE DimProveedor(
	ProveedorKey INT Primary Key IDENTITY(1,1),
	ProviderId INT NOT NULL,
	PersonId INT NULL,
	NombreCompleto VARCHAR(255) NOT NULL,
	Identificador VARCHAR(255) NOT NULL,
	EstaRetirado BIT NOT NULL,
	FechaCreacion DATETIME NOT NULL,
	FechaRetiro DATETIME NULL,
	FechaProceso DATETIME NOT NULL
)

CREATE INDEX primary_ind ON DimProveedor (ProveedorKey)
CREATE UNIQUE INDEX provider_id_ind ON DimProveedor (ProviderId)
GO
