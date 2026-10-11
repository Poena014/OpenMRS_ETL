USE OpenmrsETL
GO

CREATE OR ALTER PROCEDURE dbo.ActualizarMedicamento(
    @MedicamentoId INT,
    @Nombre VARCHAR(255),
	@Fortaleza VARCHAR(255),
	@ConceptoId INT,
	@EstaRetirado BIT
)
AS
BEGIN

    DECLARE @MedicamentoIdActual INT,
    @NombreActual VARCHAR(255),
	@FortalezaActual VARCHAR(255),
	@ConceptoIdActual INT,
	@EstaRetiradoActual BIT

    SELECT @MedicamentoIdActual=MedicamentoId,
    @NombreActual=Nombre,
    @FortalezaActual=Fortaleza,
    @ConceptoIdActual=ConceptoId,
    @EstaRetiradoActual=EstaRetirado
    FROM dbo.DimMedicamento
    WHERE MedicamentoId=@MedicamentoId


    ----CON SDC 1
    IF (@Nombre <> @Nombre OR @ConceptoId<>@ConceptoIdActual OR @EstaRetirado<>@EstaRetiradoActual )
    BEGIN

        UPDATE dbo.DimMedicamento
        SET Nombre=@Nombre,
        ConceptoId=@ConceptoId,
        EstaRetirado=@EstaRetirado
        WHERE MedicamentoId=@MedicamentoId

    END

    ----CON SDC 2
    IF ( @Fortaleza<>@FortalezaActual)
    BEGIN

        INSERT INTO dbo.DimMedicamento
        VALUES
        (@MedicamentoId, @Nombre,@Fortaleza, @ConceptoId, @Es)

    END



END