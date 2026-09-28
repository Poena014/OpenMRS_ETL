use openmrs
GO

--VERSION3
select a.person_id,
UPPER(CONCAT(IFNULL(pn.given_name,''), ' ', IFNULL(pn.middle_name,''))) nombres,
UPPER(CONCAT(IFNULL(pn.family_name,''), ' ', IFNULL(pn.family_name2,''))) apellidos,
a.gender sexo, a.birthdate fechaNacimiento,
a.date_created fechaIngreso,
NOW() fechaProceso
from person a
left join person_name pn
  on pn.person_id = a.person_id and pn.voided = 0 and pn.preferred = 1
order by a.person_id asc;