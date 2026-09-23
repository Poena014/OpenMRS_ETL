SELECT 
vt.visit_id DiagnosticoKey,
d.diagnosis_coded AS EnfermedadId,
vt.patient_id AS PacienteId,
UPPER(CONCAT_WS(', ', pa.address1, pa.county_district, pa.city_village, pa.state_province, pa.country)) AS UbicacionId,
CAST(vt.date_started AS DATE) AS TiempoKey,
TIMESTAMPDIFF(YEAR, p.birthdate, vt.date_started) AS edadSuceso,
vit.temperatura, 
vit.peso, 
vit.altura,
    (SELECT COUNT(*)
    FROM encounter_diagnosis ed2
    JOIN encounter e2 ON e2.encounter_id = ed2.encounter_id
    JOIN visit v2 ON v2.visit_id = e2.visit_id
    WHERE ed2.voided = 0 AND e2.voided = 0
        AND v2.patient_id = vt.patient_id
        AND ed2.diagnosis_coded = d.diagnosis_coded
        AND v2.date_started <= vt.date_started) AS veces_previas
FROM visit vt
JOIN person p ON p.person_id = vt.patient_id
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
LEFT JOIN encounter d_enc ON d_enc.visit_id = vt.visit_id AND d_enc.encounter_type = 3 AND d_enc.voided = 0
LEFT JOIN encounter_diagnosis d ON d.encounter_id = d_enc.encounter_id AND d.voided = 0
ORDER BY vt.visit_id;