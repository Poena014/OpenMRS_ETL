USE OpenmrsETL
GO

CREATE OR ALTER PROCEDURE dbo.ActualizarPaciente(
    @IdPaciente INT,
    @Nombres VARCHAR(255),
	@Apellidos VARCHAR(255),
	@Sexo VARCHAR(1),
	@FechaNacimiento DATE,
	@FechaIngreso DATETIME 
)
AS
BEGIN

    DECLARE @IdPacienteActual INT,
        @NombresActual VARCHAR(255),
        @ApellidosActual VARCHAR(255),
        @SexoActual VARCHAR(1),
        @FechaNacimientoActual DATE,
        @FechaIngresoActual DATETIME 

    SELECT @IdPacienteActual=PacienteId,
    @NombresActual=Nombres,
    @ApellidosActual=Apellidos,
    @SexoActual=Sexo,
    @FechaNacimientoActual=FechaNacimiento,
    @FechaIngresoActual=FechaIngreso
    FROM dbo.DimPaciente
    WHERE PacienteId=@IdPaciente


    ----CON SDC 1
    IF (@Nombres<> @NombresActual OR @Apellidos<>@ApellidosActual OR @FechaNacimientoActual<>@FechaNacimiento )
    BEGIN

        UPDATE dbo.DimPaciente
        SET Nombres=@Nombres,
        Apellidos=@Apellidos,
        FechaNacimiento=@FechaNacimiento,
        FechaIngreso=@FechaIngreso
        WHERE PacienteId=@IdPaciente

    END



END