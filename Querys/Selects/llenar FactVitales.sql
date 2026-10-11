USE OpenmrsETL
GO

SELECT
  o.obs_id AS VitalId,
  COALESCE(o.concept_id, 0) AS SignoVitalId,
  COALESCE(o.person_id, 0) AS PacienteId,
  COALESCE(ep.provider_id, 0) AS ProveedorId,
  UPPER(IFNULL(NULLIF(CONCAT_WS(', ', pa.address1, pa.county_district, pa.city_village, pa.state_province, pa.country), ''), 'N/A')) AS UbicacionId,
  COALESCE(e.location_id, v.location_id, 0) AS LocalId,
  CAST(DATE(IFNULL(o.obs_datetime, '1900-01-01')) AS DATETIME) AS TiempoKey,
  o.value_numeric AS Valor,
  COALESCE(TIMESTAMPDIFF(YEAR, p.birthdate, o.obs_datetime), 0) AS EdadSuceso
FROM obs o
JOIN encounter e
  ON e.encounter_id = o.encounter_id
 AND e.voided = 0
JOIN encounter_provider ep
  ON ep.encounter_id = e.encounter_id
 AND ep.voided = 0
LEFT JOIN visit v
  ON v.visit_id = e.visit_id
JOIN person p
  ON p.person_id = o.person_id
LEFT JOIN person_address pa
  ON pa.person_id = p.person_id
 AND pa.voided = 0
 AND pa.preferred = 1
WHERE o.voided = 0
  AND o.concept_id IN (4165, 4167, 4168, 4169, 4171, 4173)
  AND o.value_numeric IS NOT NULL
ORDER BY o.obs_id;
