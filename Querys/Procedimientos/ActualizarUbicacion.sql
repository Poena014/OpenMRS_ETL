USE OpenmrsETL
GO

CREATE OR ALTER PROCEDURE dbo.ActualizarUbicacion(
    @DireccionId VARCHAR(1200),
    @Cuidad VARCHAR(255),
    @Departamento VARCHAR(255),
    @Pais VARCHAR(255),
    @CodigoPostal VARCHAR(20)
)
AS
BEGIN

    DECLARE @DireccionIdActual VARCHAR(1200),
    @CuidadActual VARCHAR(255),
    @DepartamentoActual VARCHAR(255),
    @PaisActual VARCHAR(255),
    @CodigoPostalActual VARCHAR(20)

    SELECT @DireccionIdActual=DireccionId,
    @CuidadActual=Ciudad,
    @DepartamentoActual=Departamento,
    @PaisActual=Pais,
    @CodigoPostalActual=CodigoPostal
    FROM dbo.DimUbicacion
    WHERE DireccionId=@DireccionId


    ----CON SDC 1
    --IF (@Categoria <> @CategoriaActual)
    --BEGIN

    --    UPDATE dbo.DimEnfermedad
    --    SET tipoEnfermedad=@Categoria
    --    WHERE EnfermedadId=@EnfermedadId

    --END

    ----CON SDC 2
    IF (@DireccionId<>@DireccionIdActual OR @Cuidad<>@CuidadActual OR @Departamento<>@DepartamentoActual OR @Pais<>@PaisActual OR @CodigoPostal<>@CodigoPostalActual)
    BEGIN

        INSERT INTO dbo.DimUbicacion
        VALUES
        (@DireccionId, @Cuidad,@Departamento,@Pais, @CodigoPostal)

    END



END