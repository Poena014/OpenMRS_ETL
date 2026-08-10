use openmrs
GO

SELECT
p.provider_id providerId,
p.person_id personId,
UPPER(
	COALESCE(
		NULLIF(TRIM(p.name), ''),
		NULLIF(TRIM(CONCAT_WS(' ', pn.given_name, pn.middle_name, pn.family_name, pn.family_name2)), ''),
		'N/A'
	)
) nombreCompleto,
IFNULL(p.identifier, 'N/A') identificador,
p.retired estaRetirado,
p.date_created fechaCreacion,
p.date_retired fechaRetiro,
NOW() fechaProceso
FROM provider p
LEFT JOIN person_name pn ON p.person_id = pn.person_id
	AND pn.voided = 0
	AND pn.preferred = 1
ORDER BY p.provider_id ASC
