SELECT
    v.visit_id,
    v.patient_id,
    v.visit_type_id,
    v.location_id,
    v.date_started,
    v.date_stopped,

    -- Cantidad de visitas.
    1 AS CantidadVisitas,

    -- Duración en minutos.    
    CASE
        WHEN v.date_stopped IS NOT NULL
        THEN TIMESTAMPDIFF(
            MINUTE,
            v.date_started,
            v.date_stopped
        )
        ELSE NULL
    END AS DuracionMinutos,

    -- Estado de la visita.
    CASE
        WHEN v.date_stopped IS NULL THEN 1
        ELSE 0
    END AS EstaActiva

FROM openmrs.visit v
WHERE v.voided = 0;