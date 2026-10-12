# Informe Power BI de OpenMRS ETL

Esta carpeta contiene una copia editable y versionable del proyecto de Power BI.
El proyecto original ubicado en `Documentos` no se modifica.

## Apertura

Abrir `Informes Power BI.pbip` con Power BI Desktop. Las carpetas
`Informes Power BI.Report` e `Informes Power BI.SemanticModel` deben permanecer
junto al archivo PBIP y conservar sus nombres.

## Origen de datos

El modelo está configurado para conectarse mediante autenticación de Windows a
`JUANRIVERAPC`, base de datos `OpenmrsETL_Validacion`. En otro equipo, actualizar
el servidor desde **Archivo > Opciones y configuración > Configuración de origen
de datos** antes de ejecutar la actualización. El proyecto no almacena
credenciales.

## Páginas

- **Resumen:** totales y tendencias mensuales de las tres tablas de hechos.
- **Diagnósticos:** indicadores, diez diagnósticos más frecuentes y tendencia mensual.
- **Medicamentos:** indicadores, diez medicamentos con más órdenes y tendencia mensual.
- **Signos vitales:** indicadores, tabla estadística por tipo y tendencia mensual.

Los conteos representan filas de hechos. Los indicadores de pacientes usan
`DISTINCTCOUNT(PacienteKey)` dentro de cada tabla; no representan necesariamente
la misma población entre páginas.

Las tendencias no muestran el último mes cuando la fecha máxima disponible no
coincide con el cierre de ese mes. Esto evita interpretar una carga parcial como
una caída real. La tabla de signos vitales conserva la unidad de cada medición y
presenta conteo, promedio, mínimo y máximo, por lo que sus valores no deben
compararse entre unidades diferentes.

## Regeneración

Desde la raíz del repositorio:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tools\build_powerbi_report.ps1
```

## Verificación en Power BI Desktop

1. Abrir el PBIP y confirmar que las cuatro páginas cargan sin errores.
2. Pulsar **Actualizar** únicamente después de validar la carga en SQL Server.
3. Confirmar títulos, etiquetas, orden descendente y filtro Top 10.
4. Confirmar que un último mes parcial no se muestre en las tendencias.
5. Guardar una copia PBIX de entrega cuando el diseño y los datos estén validados.
