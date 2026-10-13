USE OpenmrsETL
GO

SELECT
  COALESCE(ed.encounter_diagnosis_id, 0) AS DiagnosticoKey,
  COALESCE(ed.diagnosis_coded, 0) AS EnfermedadId,
  COALESCE(vt.patient_id, 0) AS PacienteId,
  COALESCE(UPPER(CONCAT_WS(', ', pa.address1, pa.county_district, pa.city_village, pa.state_province, pa.country)), '') AS UbicacionId,
  CAST(DATE(COALESCE(e.encounter_datetime, vt.date_started)) AS DATETIME) AS TiempoKey,
  COALESCE(TIMESTAMPDIFF(YEAR, p.birthdate, COALESCE(e.encounter_datetime, vt.date_started)), 0) AS edadSuceso,
  COALESCE(vit.temperatura, 0) AS temperatura,
  COALESCE(vit.peso, 0) AS peso,
  COALESCE(vit.altura, 0) AS altura,
  CASE WHEN EXISTS (
   SELECT 1
   FROM encounter_diagnosis ed2
   JOIN encounter e2 ON e2.encounter_id = ed2.encounter_id
   JOIN visit v2 ON v2.visit_id = e2.visit_id
   WHERE ed2.voided = 0 AND e2.voided = 0
     AND v2.patient_id = vt.patient_id
     AND ed2.diagnosis_coded = ed.diagnosis_coded
     AND ed2.encounter_diagnosis_id < ed.encounter_diagnosis_id
  ) THEN 1 ELSE 0 END AS veces_previas
FROM encounter_diagnosis ed
JOIN encounter e
  ON e.encounter_id = ed.encounter_id AND e.voided = 0
JOIN visit vt
  ON vt.visit_id = e.visit_id
JOIN person p
  ON p.person_id = vt.patient_id
LEFT JOIN person_address pa
  ON pa.person_id = p.person_id AND pa.voided = 0 AND pa.preferred = 1
LEFT JOIN (
    SELECT e.visit_id,
           MAX(o_temp.value_numeric)  AS temperatura,
           MAX(o_peso.value_numeric)  AS peso,
           MAX(o_talla.value_numeric) AS altura
    FROM encounter e
    LEFT JOIN obs o_temp  ON o_temp.encounter_id  = e.encounter_id AND o_temp.concept_id  = 4166 AND o_temp.voided  = 0
    LEFT JOIN obs o_peso  ON o_peso.encounter_id  = e.encounter_id AND o_peso.concept_id  = 4168 AND o_peso.voided  = 0
    LEFT JOIN obs o_talla ON o_talla.encounter_id = e.encounter_id AND o_talla.concept_id = 4167 AND o_talla.voided = 0
    WHERE e.encounter_type = 5 AND e.voided = 0
    GROUP BY e.visit_id
) vit ON vit.visit_id = vt.visit_id
WHERE ed.voided = 0
  AND ed.diagnosis_coded IS NOT NULL
  AND vt.voided = 0
  AND vt.date_stopped IS NOT NULL
ORDER BY vt.visit_id;

--CONSULTA INCREMENTAL
"
SELECT
  COALESCE(ed.encounter_diagnosis_id, 0) AS DiagnosticoKey,
  COALESCE(ed.diagnosis_coded, 0) AS EnfermedadId,
  COALESCE(vt.patient_id, 0) AS PacienteId,
  COALESCE(UPPER(CONCAT_WS(', ', pa.address1, pa.county_district, pa.city_village, pa.state_province, pa.country)), '') AS UbicacionId,
  CAST(DATE(COALESCE(e.encounter_datetime, vt.date_started)) AS DATETIME) AS TiempoKey,
  COALESCE(TIMESTAMPDIFF(YEAR, p.birthdate, COALESCE(e.encounter_datetime, vt.date_started)), 0) AS edadSuceso,
  COALESCE(vit.temperatura, 0) AS temperatura,
  COALESCE(vit.peso, 0) AS peso,
  COALESCE(vit.altura, 0) AS altura,
  CASE WHEN EXISTS (
   SELECT 1
   FROM encounter_diagnosis ed2
   JOIN encounter e2 ON e2.encounter_id = ed2.encounter_id
   JOIN visit v2 ON v2.visit_id = e2.visit_id
   WHERE ed2.voided = 0 AND e2.voided = 0
     AND v2.patient_id = vt.patient_id
     AND ed2.diagnosis_coded = ed.diagnosis_coded
     AND ed2.encounter_diagnosis_id < ed.encounter_diagnosis_id
  ) THEN 1 ELSE 0 END AS veces_previas
FROM encounter_diagnosis ed
JOIN encounter e
  ON e.encounter_id = ed.encounter_id AND e.voided = 0
JOIN visit vt
  ON vt.visit_id = e.visit_id
JOIN person p
  ON p.person_id = vt.patient_id
LEFT JOIN person_address pa
  ON pa.person_id = p.person_id AND pa.voided = 0 AND pa.preferred = 1
LEFT JOIN (
    SELECT e.visit_id,
           MAX(o_temp.value_numeric)  AS temperatura,
           MAX(o_peso.value_numeric)  AS peso,
           MAX(o_talla.value_numeric) AS altura
    FROM encounter e
    LEFT JOIN obs o_temp  ON o_temp.encounter_id  = e.encounter_id AND o_temp.concept_id  = 4166 AND o_temp.voided  = 0
    LEFT JOIN obs o_peso  ON o_peso.encounter_id  = e.encounter_id AND o_peso.concept_id  = 4168 AND o_peso.voided  = 0
    LEFT JOIN obs o_talla ON o_talla.encounter_id = e.encounter_id AND o_talla.concept_id = 4167 AND o_talla.voided = 0
    WHERE e.encounter_type = 5 AND e.voided = 0
    GROUP BY e.visit_id
) vit ON vit.visit_id = vt.visit_id
WHERE ed.voided = 0
  AND ed.diagnosis_coded IS NOT NULL
  AND vt.voided = 0
  AND vt.date_stopped IS NOT NULL
  AND vt.date_stopped > '" + @[User::FechaUltimaEjecucion] + "'
  AND vt.date_stopped <= CURDATE();"
