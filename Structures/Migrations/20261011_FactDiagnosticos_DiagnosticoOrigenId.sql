USE OpenmrsETL;
GO

IF COL_LENGTH('dbo.FactDiagnosticos', 'DiagnosticoOrigenId') IS NULL
BEGIN
    ALTER TABLE dbo.FactDiagnosticos
    ADD DiagnosticoOrigenId INT NULL;
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE object_id = OBJECT_ID('dbo.FactDiagnosticos')
      AND name = 'UX_FactDiagnosticos_DiagnosticoOrigenId'
)
BEGIN
    CREATE UNIQUE NONCLUSTERED INDEX UX_FactDiagnosticos_DiagnosticoOrigenId
    ON dbo.FactDiagnosticos (DiagnosticoOrigenId)
    WHERE DiagnosticoOrigenId IS NOT NULL
    WITH (IGNORE_DUP_KEY = ON);
END;
GO
