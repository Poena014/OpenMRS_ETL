CREATE TABLE DimMedicamento(
    MedicamentoKey INT IDENTITY(1,1),
    MedicamentoId INT NOT NULL,
    Nombre VARCHAR(255),
    Fortaleza VARCHAR(50),
    ConceptoId INT,
    EstaRetirado BIT DEFAULT 0
)
GO

CREATE UNIQUE NONCLUSTERED INDEX ind_DimMedicamento
ON DimMedicamento (MedicamentoKey);

ALTER TABLE DimMedicamento 
ADD CONSTRAINT PK_Medicamento PRIMARY KEY (MedicamentoKey);

