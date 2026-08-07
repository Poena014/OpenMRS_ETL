SELECT 
c.concept_id conceptId,
cn.name NombreCompleto,
IFNULL(c.short_name,'N/A') NombreCorto,
cc.name claseConcepto,
IFNULL(COUNT(1),0) cantidad
FROM visit vt
JOIN encounter e ON vt.visit_id =e.visit_id and vt.location_id =e.location_id 
JOIN encounter_diagnosis ed ON e.encounter_id =ed.encounter_id 
JOIN concept c ON ed.diagnosis_coded  =c.concept_id 
JOIN concept_name cn ON c.concept_id = cn.concept_name_id AND UPPER(cn.locale) = UPPER('es')
JOIN concept_class cc ON c.class_id =cc.concept_class_id 
WHERE e.date_created BETWEEN '20260101' AND '20260331'
GROUP BY  c.concept_id