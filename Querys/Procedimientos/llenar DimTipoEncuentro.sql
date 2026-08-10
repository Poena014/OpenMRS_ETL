use openmrs
GO

SELECT
et.encounter_type_id encounterTypeId,
UPPER(et.name) nombre,
IFNULL(UPPER(et.description), 'N/A') descripcion,
et.retired estaRetirado,
et.date_created fechaCreacion,
et.date_retired fechaRetiro,
NOW() fechaProceso
FROM encounter_type et
ORDER BY et.encounter_type_id ASC
