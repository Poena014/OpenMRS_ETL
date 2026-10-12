USE [OpenmrsETL]
GO
/****** Objeto: StoredProcedure [dbo].[ActualizarTipoVisita] Fecha de script: 11/10/2026 20:12:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ActualizarTipoEncuentro](
    @EncounterTypeId INT,
    @Nombre VARCHAR(50),
	@Descripcion VARCHAR(500),
    @EstaRetirado BIT,
    @FechaCreacion AS DATETIME,
    @FechaRetiro AS DATETIME,
    @FechaProceso AS DATETIME
)
AS
BEGIN

    DECLARE @EncounterTypeIdActual INT,
            @NombreActual VARCHAR(50),
	        @DescripcionActual VARCHAR(500),
            @EstaRetiradoActual BIT,
            @FechaCreacionActual AS DATETIME,
            @FechaRetiroActual AS DATETIME,
            @FechaProcesoActual AS DATETIME

    SELECT  @EncounterTypeIdActual=EncounterTypeId,
            @NombreActual=Nombre,
            @DescripcionActual=Descripcion,
            @EstaRetiradoActual=EstaRetirado,
            @FechaCreacionActual=FechaCreacion,
            @FechaRetiroActual=FechaRetiro,
            @FechaProcesoActual=FechaProceso
    FROM dbo.DimTipoEncuentro
    WHERE EncounterTypeId=@EncounterTypeId

    ----CON SDC 1
    IF ((@Descripcion <> @DescripcionActual OR @EstaRetirado <> @EstaRetiradoActual 
            OR @FechaRetiro <> @FechaRetiroActual OR @FechaProceso <> @FechaProcesoActual) 
            AND @Nombre = @NombreActual AND @FechaCreacion = @FechaCreacionActual 
            AND @EncounterTypeIdActual IS NOT NULL)
    BEGIN

        UPDATE dbo.DimTipoEncuentro
        SET Nombre=@Nombre,
            Descripcion=@Descripcion,
            EstaRetirado=@EstaRetirado,
            FechaCreacion=@FechaCreacion,
            FechaProceso=@FechaProceso
        WHERE EncounterTypeId=@EncounterTypeId

    END

    ----CON SDC 2
    IF (@Nombre <> @NombreActual OR @FechaCreacion <> @FechaCreacionActual)
    BEGIN

        INSERT INTO dbo.DimTipoEncuentro
        VALUES (@EncounterTypeId,
                @Nombre,
                @Descripcion,
                @EstaRetirado,
                @FechaCreacion, 
                @FechaRetiro,
                @FechaProceso)
    END
END
