use OpenmrsETL
GO

CREATE TABLE DimSignoVital(
	SignoVitalKey INT IDENTITY(1,1),
	SignoVitalId INT NOT NULL,
	Nombre VARCHAR(255) NOT NULL,
	Unidad VARCHAR(50),
	EstaRetirado BIT DEFAULT 0
)
GO

ALTER TABLE DimSignoVital
ADD CONSTRAINT PK_SignoVital PRIMARY KEY (SignoVitalKey);
GO

CREATE UNIQUE NONCLUSTERED INDEX ind_DimSignoVital
ON DimSignoVital (SignoVitalKey);
GO

SET IDENTITY_INSERT DimSignoVital ON;
INSERT INTO DimSignoVital (SignoVitalKey, SignoVitalId, Nombre, Unidad, EstaRetirado)
VALUES (0, 0, 'N/NOMBRE', 'N/UNIDAD', 1);
SET IDENTITY_INSERT DimSignoVital OFF;
GO
