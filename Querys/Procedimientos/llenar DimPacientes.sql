use openmrs
GO

--VERSION3
select
COALESCE(a.person_id, 0) AS person_id,
UPPER(IFNULL(NULLIF(CONCAT(IFNULL(pn.given_name,''), ' ', IFNULL(pn.middle_name,'')), ''), 'N/NOMBRES')) AS nombres,
UPPER(IFNULL(NULLIF(CONCAT(IFNULL(pn.family_name,''), ' ', IFNULL(pn.family_name2,'')), ''), 'N/APELLIDOS')) AS apellidos,
UPPER(IFNULL(NULLIF(a.gender,''), 'N')) AS sexo,
IFNULL(a.birthdate, '1900-01-01') AS fechaNacimiento,
IFNULL(a.date_created, NOW()) AS fechaIngreso,
NOW() AS fechaProceso
from person a
left join person_name pn
  on pn.person_id = a.person_id and pn.voided = 0 and pn.preferred = 1
order by a.person_id asc;