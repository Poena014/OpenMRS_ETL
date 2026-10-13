USE OpenmrsETL
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

--CONSULTA INCREMENTAL
"
SELECT
et.encounter_type_id encounterTypeId,
UPPER(et.name) nombre,
IFNULL(UPPER(et.description), 'N/A') descripcion,
et.retired estaRetirado,
et.date_created fechaCreacion,
et.date_retired fechaRetiro,
NOW() fechaProceso
FROM encounter_type et
WHERE et.date_changed BETWEEN '" + @[User::FechaUltimaEjecucion] + "' AND CURDATE()
OR et.date_created  BETWEEN '" + @[User::FechaUltimaEjecucion] + "' AND CURDATE()
;"