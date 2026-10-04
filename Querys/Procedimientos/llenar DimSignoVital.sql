USE OpenmrsETL
GO

SET IDENTITY_INSERT DimSignoVital ON;
GO

INSERT INTO DimSignoVital (SignoVitalKey,SignoVitalId,Nombre,Unidad,EstaRetirado)
VALUES (0,0,'N/NOMBRE','N/UNIDAD',1);
GO

SET IDENTITY_INSERT DimSignoVital OFF;
GO

SELECT
    c.concept_id AS SignoVitalId,
    COALESCE(
        (SELECT cn.name FROM concept_name cn
          WHERE cn.concept_id = c.concept_id AND cn.locale = 'es' AND cn.voided = 0
            AND cn.concept_name_type = 'FULLY_SPECIFIED' LIMIT 1),
        (SELECT cn2.name FROM concept_name cn2
          WHERE cn2.concept_id = c.concept_id AND cn2.locale = 'en' AND cn2.voided = 0
            AND cn2.concept_name_type = 'FULLY_SPECIFIED' LIMIT 1),
        'N/NOMBRE'
    ) AS Nombre,
    IFNULL(cnu.units, 'N/UNIDAD') AS Unidad,
    COALESCE(c.retired, 0) AS EstaRetirado
FROM concept c
JOIN concept_numeric cnu ON cnu.concept_id = c.concept_id
WHERE c.concept_id IN (
    SELECT DISTINCT o.concept_id FROM obs o
    WHERE o.voided = 0 AND o.concept_id IN (4165, 4167, 4168, 4169, 4171, 4173)
);
