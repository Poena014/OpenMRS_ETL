select DISTINCT 
pa.person_address_id direccionId,
UPPER(CONCAT(IFNULL(pa.address1,''),' // ',IFNULL(pa.city_village,'N/Ciudad'),' ',IFNULL(pa.state_province,'N/Departamento'),' ',IFNULL(pa.country,'N/PAIS'),' ',IFNULL(pa.postal_code,'N/POSTAL'))) direccionCompleta,
UPPER(IFNULL(pa.city_village,'N/CIUDAD')) ciudad,
UPPER(IFNULL(pa.state_province,'N/DEPARTAMENTO')) departamento ,
UPPER(IFNULL(pa.country,'N/PAIS')) pais,
UPPER(IFNULL(pa.postal_code,'N/POSTAL')) codigoPostal
from obs o 
join person p on o.person_id =p.person_id 
join person_address pa on p.person_id =pa.person_id 


select *
from obs o 
join person p on o.person_id =p.person_id 
join person_address pa on p.person_id =pa.person_id 