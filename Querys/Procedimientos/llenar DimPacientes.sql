use openmrs
GO

--VERSION1
select a.person_id,
UPPER(CONCAT(IFNULL(pn.given_name,'') , ' ',IFNULL(pn.middle_name,''))) nombres,
UPPER(CONCAT(IFNULL(pn.family_name,'') , ' ',IFNULL(pn.family_name2,''))) apellidos,
a.gender sexo,
a.birthdate fechaNacimiento,
UPPER(pa.address1) direccion,
UPPER(pa.city_village) ciudad,
a.date_created fechaIngreso,
a.date_voided  fechaBaja,
NOW() fechaProceso
from person a
JOIN person_address pa ON a.person_id =pa.person_id 
JOIN person_name pn ON a.person_id=pn.person_id

--VERSION2
select a.person_id,
UPPER(CONCAT(IFNULL(pn.given_name,'') , ' ',IFNULL(pn.middle_name,''))) nombres,
UPPER(CONCAT(IFNULL(pn.family_name,'') , ' ',IFNULL(pn.family_name2,''))) apellidos,
a.gender sexo,
a.birthdate fechaNacimiento,
a.date_created fechaIngreso,
a.date_voided  fechaBaja,
NOW() fechaProceso
from person a
JOIN person_address pa ON a.person_id =pa.person_id 
JOIN person_name pn ON a.person_id=pn.person_id

