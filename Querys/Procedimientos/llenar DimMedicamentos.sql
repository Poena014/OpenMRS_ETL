USE OpenmrsETL
GO

SET IDENTITY_INSERT DimMedicamento ON;
GO

INSERT INTO DimMedicamento (MedicamentoKey,MedicamentoId,Fortaleza,ConceptoId,EstaRetirado)
VALUES (0,0,'N/A',0,0);
GO

SET IDENTITY_INSERT DimMedicamento OFF;
GO




SELECT
    d.drug_id AS MedicamentoId,
    COALESCE(
        (SELECT cn.name FROM concept_name cn
          WHERE cn.concept_id = c.concept_id AND cn.locale = 'es' AND cn.voided = 0
            AND cn.concept_name_type = 'FULLY_SPECIFIED' LIMIT 1),
        (SELECT cn2.name FROM concept_name cn2
          WHERE cn2.concept_id = c.concept_id AND cn2.locale = 'en' AND cn2.voided = 0
            AND cn2.concept_name_type = 'FULLY_SPECIFIED' LIMIT 1),
        'N/NOMBRE'
    ) AS Nombre,
    COALESCE(d.strength, 'N/DOSIS') AS Fortaleza,
    COALESCE(d.concept_id, 0) AS ConceptoId,
    COALESCE(d.retired, 0) AS EstaRetirado
FROM drug d
JOIN concept c ON c.concept_id = d.concept_id
WHERE d.drug_id IN (
    SELECT DISTINCT do.drug_inventory_id FROM drug_order do
);
