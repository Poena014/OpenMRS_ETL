USE [OpenmrsETL]
GO
/****** Objeto: StoredProcedure [dbo].[ActualizarTipoVisita] Fecha de script: 11/10/2026 20:12:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[ActualizarTipoVisita](
    @TipoVisitaId INT,
    @Nombre VARCHAR(100),
	@Descripcion VARCHAR(100)
)
AS
BEGIN

    DECLARE @TipoVisitaIdActual INT,
            @NombreActual VARCHAR(100),
	        @DescripcionActual VARCHAR(100)

    SELECT  @TipoVisitaIdActual=TipoVisitaId,
            @NombreActual=Nombre,
            @DescripcionActual=Descripcion
    FROM dbo.DimTipoVisita
    WHERE TipoVisitaId=@TipoVisitaId

    ----CON SDC 1
    IF (@Descripcion <> @DescripcionActual AND @Nombre = @NombreActual AND @TipoVisitaIdActual IS NOT NULL)
    BEGIN

        UPDATE dbo.DimTipoVisita
        SET Nombre=@Nombre,
            Descripcion=@Descripcion
        WHERE TipoVisitaId=@TipoVisitaId

    END

    ----CON SDC 2
    IF (@Nombre <> @Nombre)
    BEGIN

        INSERT INTO dbo.DimTipoVisita
        VALUES (@TipoVisitaId,
                @Nombre,
                @Descripcion)
    END
END
