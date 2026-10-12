USE [OpenmrsETL]
GO
/****** Objeto: StoredProcedure [dbo].[ActualizarTipoVisita] Fecha de script: 11/10/2026 20:12:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ActualizarSigVital](
    @SignoVitalId INT,
    @Nombre VARCHAR(50),
	@Unidad VARCHAR(500),
    @EstaRetirado BIT
)
AS
BEGIN

    DECLARE @SignoVitalIdActual INT,
            @NombreActual VARCHAR(50),
	        @UnidadActual VARCHAR(500),
            @EstaRetiradoActual BIT

    SELECT TOP (1) @SignoVitalIdActual=SignoVitalId,
            @NombreActual=Nombre,
            @UnidadActual=Unidad,
            @EstaRetiradoActual=EstaRetirado
    FROM dbo.DimSignoVital
    WHERE SignoVitalId=@SignoVitalId

    ----CON SDC 1
    IF ((@Unidad <> @UnidadActual OR @EstaRetirado <> @EstaRetiradoActual) 
            AND @Nombre = @NombreActual AND @SignoVitalIdActual IS NOT NULL)
    BEGIN

        UPDATE dbo.DimSignoVital
        SET Nombre=@Nombre,
            Unidad=@Unidad,
            EstaRetirado=@EstaRetirado
        WHERE SignoVitalId=@SignoVitalId

    END

    ----CON SDC 2
    IF (@Nombre <> @NombreActual)
    BEGIN

        INSERT INTO dbo.DimSignoVital
        VALUES (@SignoVitalId,
                @Nombre,
                @Unidad,
                @EstaRetirado)
    END
END
