USE OpenmrsETL
GO

CREATE OR ALTER PROCEDURE dbo.ActualizarEnfermedad(
    @EnfermedadId INT,
    @Nombre VARCHAR(255),
	@Categoria VARCHAR(255)
)
AS
BEGIN

    DECLARE @EnfermedadIdActual INT,
    @NombreActual VARCHAR(255),
	@CategoriaActual VARCHAR(255)

    SELECT @EnfermedadIdActual=EnfermedadId,
    @NombreActual=Nombre,
    @CategoriaActual=@CategoriaActual
    FROM dbo.DimEnfermedad
    WHERE EnfermedadId=@EnfermedadId


    ----CON SDC 1
    IF (@Categoria <> @CategoriaActual)
    BEGIN

        UPDATE dbo.DimEnfermedad
        SET tipoEnfermedad=@Categoria
        WHERE EnfermedadId=@EnfermedadId

    END

    ----CON SDC 2
    IF (@Nombre <> @NombreActual)
    BEGIN

        INSERT INTO dbo.DimEnfermedad
        VALUES
        (@EnfermedadId, @Nombre,@Categoria)

    END



END