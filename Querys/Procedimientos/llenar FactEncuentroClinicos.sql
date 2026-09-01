use openmrs
GO

SELECT
	e.encounter_id encounterId,
	e.patient_id pacienteId,
	MIN(ep.provider_id) providerId,
	MIN(pa.person_address_id) direccionId,
	e.encounter_type encounterTypeId,
	e.encounter_datetime fechaEncuentro,
	e.date_created fechaCreacion,
	e.visit_id visitId,
	e.voided estaAnulado,
	1 cantidadEncuentros,
	NOW() fechaProceso
FROM encounter e
LEFT JOIN encounter_provider ep ON e.encounter_id = ep.encounter_id
	AND ep.voided = 0
LEFT JOIN person_address pa ON e.patient_id = pa.person_id
	AND pa.voided = 0
	AND pa.preferred = 1
GROUP BY
	e.encounter_id,
	e.patient_id,
	e.encounter_type,
	e.encounter_datetime,
	e.date_created,
	e.visit_id,
	e.voided
ORDER BY e.encounter_id ASC
