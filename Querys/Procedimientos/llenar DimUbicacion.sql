SET IDENTITY_INSERT NombreTabla ON;
GO

INSERT INTO DimUbicaciones (UbicacionKey, DireccionId, Pais,Ciudad, Departamento, CodigoPostal)
VALUES (0,'NO HAY','NO HAY','NO HAY','NO HAY','0000');
GO

SET IDENTITY_INSERT NombreTabla OFF;
GO


select DISTINCT 
UPPER(CONCAT_WS(', ', pa.address1, pa.county_district, pa.city_village, pa.state_province, pa.country)) direccionId,
UPPER(IFNULL(pa.city_village,'N/CIUDAD')) ciudad,
UPPER(IFNULL(pa.state_province,'N/DEPARTAMENTO')) departamento ,
UPPER(IFNULL(pa.country,'N/PAIS')) pais,
UPPER(IFNULL(pa.postal_code,'N/POSTAL')) codigoPostal
from obs o 
join person p on o.person_id =p.person_id 
join person_address pa on p.person_id =pa.person_id 

