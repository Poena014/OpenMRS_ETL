SELECT
    c.concept_id AS EnfermedadId,
    COALESCE(
        (SELECT cn.name FROM concept_name cn
          WHERE cn.concept_id = c.concept_id
            AND cn.locale = 'es' AND cn.voided = 0
            AND cn.concept_name_type = 'FULLY_SPECIFIED'
          LIMIT 1),
        (SELECT cn2.name FROM concept_name cn2
          WHERE cn2.concept_id = c.concept_id
            AND cn2.locale = 'en' AND cn2.voided = 0
            AND cn2.concept_name_type = 'FULLY_SPECIFIED'
          LIMIT 1)
    ) AS Nombre,
    COALESCE(
        CASE LEFT(icd.icd10, 1)
            WHEN 'A' THEN 'Infecciosas y parasitarias'
            WHEN 'B' THEN 'Infecciosas y parasitarias'
            WHEN 'C' THEN 'Tumores'
            WHEN 'D' THEN 'Tumores / Enfermedades de la sangre'
            WHEN 'E' THEN 'Endocrinas, nutricionales y metabólicas'
            WHEN 'F' THEN 'Mentales y del comportamiento'
            WHEN 'G' THEN 'Del sistema nervioso'
            WHEN 'H' THEN 'Ojo y oído'
            WHEN 'I' THEN 'Circulatorias'
            WHEN 'J' THEN 'Respiratorias'
            WHEN 'K' THEN 'Digestivas'
            WHEN 'L' THEN 'Piel'
            WHEN 'M' THEN 'Musculoesqueléticas'
            WHEN 'N' THEN 'Genitourinarias'
            WHEN 'O' THEN 'Embarazo y parto'
            WHEN 'P' THEN 'Perinatales'
            WHEN 'Q' THEN 'Malformaciones congénitas'
            WHEN 'R' THEN 'Síntomas y hallazgos anormales'
            WHEN 'S' THEN 'Traumatismos'
            WHEN 'T' THEN 'Traumatismos / Intoxicaciones'
            WHEN 'Z' THEN 'Factores de salud'
            ELSE NULL
        END,
        'Sin categoría'
    ) AS tipoEnfermedad
FROM concept c
LEFT JOIN (
    SELECT m.concept_id, MIN(t.code) AS icd10
    FROM concept_reference_map m
    JOIN concept_reference_term t
        ON t.concept_reference_term_id = m.concept_reference_term_id
       AND t.retired = 0
    JOIN concept_reference_source s
        ON s.concept_source_id = t.concept_source_id
       AND s.name = 'ICD-10-WHO'
    GROUP BY m.concept_id
) icd ON icd.concept_id = c.concept_id
WHERE c.retired = 0
  AND c.concept_id IN (
      SELECT DISTINCT diagnosis_coded FROM encounter_diagnosis WHERE voided = 0
  );