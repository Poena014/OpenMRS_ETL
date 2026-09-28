SELECT
  COALESCE(o.order_id, 0) AS PedidoId,
  COALESCE(do.drug_inventory_id, 0) AS MedicamentoId,
  COALESCE(o.patient_id, 0) AS PacienteId,
  COALESCE(o.orderer, 0) AS ProveedorId,
  UPPER(IFNULL(NULLIF(CONCAT_WS(', ', pa.address1, pa.county_district, pa.city_village, pa.state_province, pa.country), ''), 'N/A')) AS UbicacionId,
  COALESCE(e.location_id, v.location_id, 0) AS LocalId,
  CAST(DATE(IFNULL(IFNULL(o.date_activated, o.date_created), '1900-01-01')) AS DATETIME) AS TiempoKey,
  COALESCE(v.visit_type_id, 0) AS TipoVisitaId,
  COALESCE(do.dose, 0) AS Dosis,
  COALESCE(do.quantity, 0) AS Cantidad,
  COALESCE(do.num_refills, 0) AS NumRefills,
  COALESCE(TIMESTAMPDIFF(YEAR, p.birthdate, IFNULL(o.date_activated, o.date_created)), 0) AS EdadSuceso
FROM drug_order do
JOIN orders o
  ON o.order_id = do.order_id
 AND o.voided = 0
 AND o.patient_id IS NOT NULL
JOIN person p
  ON p.person_id = o.patient_id
LEFT JOIN encounter e
  ON e.encounter_id = o.encounter_id
LEFT JOIN visit v
  ON v.visit_id = e.visit_id
LEFT JOIN person_address pa
  ON pa.person_id = p.person_id
 AND pa.voided = 0
 AND pa.preferred = 1
WHERE do.drug_inventory_id IS NOT NULL
ORDER BY o.order_id;