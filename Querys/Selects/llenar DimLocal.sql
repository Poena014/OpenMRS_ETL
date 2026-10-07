SELECT
    l.location_id AS LocalId,
    UPPER(IFNULL(NULLIF(l.name,''), 'N/NOMBRE')) AS Nombre,
    UPPER(IFNULL(NULLIF(l.city_village,''), 'N/CIUDAD')) AS Ciudad,
    UPPER(IFNULL(NULLIF(l.state_province,''), 'N/DEPARTAMENTO')) AS Departamento,
    UPPER(IFNULL(NULLIF(l.country,''), 'N/PAIS')) AS Pais,
    COALESCE(l.retired, 0) AS EstaRetirado
FROM location l
WHERE l.location_id IN (
    SELECT DISTINCT COALESCE(e.location_id, v.location_id)
    FROM drug_order do
    JOIN orders o ON o.order_id = do.order_id AND o.voided = 0
    JOIN encounter e ON e.encounter_id = o.encounter_id
    JOIN visit v ON v.visit_id = e.visit_id
    WHERE COALESCE(e.location_id, v.location_id) IS NOT NULL
);