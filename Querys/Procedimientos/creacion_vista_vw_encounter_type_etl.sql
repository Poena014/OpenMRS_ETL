CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `openmrs`.`vw_encounter_type_etl` AS
    SELECT 
        `et`.`encounter_type_id` AS `encounterTypeId`,
        UPPER(`et`.`name`) AS `nombre`,
        CAST(LEFT(COALESCE(UPPER(`et`.`description`), 'N/A'),
                500)
            AS CHAR (500) CHARSET UTF8MB4) AS `descripcion`,
        `et`.`retired` AS `estaRetirado`,
        `et`.`date_created` AS `fechaCreacion`,
        `et`.`date_retired` AS `fechaRetiro`,
        NOW() AS `fechaProceso`,
        `et`.`date_created` AS `date_created`,
        `et`.`date_changed` AS `date_changed`
    FROM
        `openmrs`.`encounter_type` `et`