param(
    [string]$ProjectRoot = (Join-Path $PSScriptRoot '..\powerbi')
)

$ErrorActionPreference = 'Stop'

$reportRoot = Join-Path $ProjectRoot 'Informes Power BI.Report'
$definitionRoot = Join-Path $reportRoot 'definition'
$pagesRoot = Join-Path $definitionRoot 'pages'

function Read-JsonFile([string]$Path) {
    return Get-Content -LiteralPath $Path -Raw -Encoding utf8 | ConvertFrom-Json
}

function Write-JsonFile([string]$Path, $Value) {
    $directory = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $directory)) {
        New-Item -ItemType Directory -Path $directory | Out-Null
    }

    $json = $Value | ConvertTo-Json -Depth 100
    [IO.File]::WriteAllText($Path, $json + [Environment]::NewLine, [Text.UTF8Encoding]::new($false))
}

function Copy-JsonObject($Value) {
    return ($Value | ConvertTo-Json -Depth 100 | ConvertFrom-Json)
}

function New-Literal([string]$Value) {
    return @{ Literal = @{ Value = $Value } }
}

function New-Color([string]$Hex) {
    return @{ solid = @{ color = @{ expr = (New-Literal "'$Hex'") } } }
}

function Set-ContainerStyle($Visual, [string]$Title) {
    $containerStyle = @{
        title = @(
            @{
                properties = @{
                    show = @{ expr = (New-Literal 'true') }
                    text = @{ expr = (New-Literal "'$Title'") }
                    fontColor = (New-Color '#FFFFFF')
                    background = (New-Color '#0F6B63')
                    fontSize = @{ expr = (New-Literal '17D') }
                    alignment = @{ expr = (New-Literal "'center'") }
                    heading = @{ expr = (New-Literal "'Heading3'") }
                }
            }
        )
        subTitle = @(
            @{ properties = @{ show = @{ expr = (New-Literal 'false') } } }
        )
        border = @(
            @{
                properties = @{
                    show = @{ expr = (New-Literal 'true') }
                    color = (New-Color '#D0D7DE')
                    radius = @{ expr = (New-Literal '4D') }
                }
            }
        )
        background = @(
            @{
                properties = @{
                    show = @{ expr = (New-Literal 'true') }
                    color = (New-Color '#FFFFFF')
                    transparency = @{ expr = (New-Literal '0D') }
                }
            }
        )
    }

    if ($null -eq $Visual.visual.PSObject.Properties['visualContainerObjects']) {
        $Visual.visual | Add-Member -NotePropertyName visualContainerObjects -NotePropertyValue $containerStyle
    }
    else {
        $Visual.visual.visualContainerObjects = $containerStyle
    }
}

function Set-Position($Visual, [string]$Name, [double]$X, [double]$Y, [double]$Width, [double]$Height, [int]$Order) {
    $Visual.name = $Name
    $Visual.position.x = $X
    $Visual.position.y = $Y
    $Visual.position.width = $Width
    $Visual.position.height = $Height
    $Visual.position.z = $Order
    $Visual.position.tabOrder = $Order
}

function Set-ChartColor($Visual, [string]$Color, [bool]$ShowLabels, [string]$Metadata = '') {
    $dataPoint = @{ properties = @{ fill = (New-Color $Color) } }
    if ($Metadata) {
        $dataPoint.selector = @{ metadata = $Metadata }
    }

    $chartObjects = @{
        dataPoint = @(
            $dataPoint
        )
        labels = @(
            @{
                properties = @{
                    show = @{ expr = (New-Literal $ShowLabels.ToString().ToLowerInvariant()) }
                    color = (New-Color '#374151')
                    labelDisplayUnits = @{ expr = (New-Literal '1D') }
                    labelPrecision = @{ expr = (New-Literal '0L') }
                }
            }
        )
    }

    if ($null -eq $Visual.visual.PSObject.Properties['objects']) {
        $Visual.visual | Add-Member -NotePropertyName objects -NotePropertyValue $chartObjects
    }
    else {
        $Visual.visual.objects = $chartObjects
    }
}

function New-MeasureProjection([string]$Entity, [string]$Property, [string]$Format = '0') {
    return @{
        field = @{
            Measure = @{
                Expression = @{ SourceRef = @{ Entity = $Entity } }
                Property = $Property
            }
        }
        queryRef = "$Entity.$Property"
        nativeQueryRef = $Property
        format = $Format
    }
}

function New-Card($Template, [string]$Name, [string]$Title, $Measures) {
    $card = Copy-JsonObject $Template
    Set-Position $card $Name 40 45 1840 220 0

    $projections = @()
    $selectors = @(
        @{
            properties = @{ horizontalAlignment = @{ expr = (New-Literal "'center'") } }
            selector = @{ id = 'default' }
        }
    )

    foreach ($measure in $Measures) {
        $projections += New-MeasureProjection $measure.Entity $measure.Property $measure.Format
        $precision = if ($measure.Format -match '[.%]') { '1L' } else { '0L' }
        $selectors += @{
            properties = @{
                labelDisplayUnits = @{ expr = (New-Literal '1D') }
                labelPrecision = @{ expr = (New-Literal $precision) }
            }
            selector = @{ metadata = "$($measure.Entity).$($measure.Property)" }
        }
    }

    $card.visual.query.queryState.Data.projections = $projections
    $card.visual.query.sortDefinition.sort[0].field.Measure.Expression.SourceRef.Entity = $Measures[0].Entity
    $card.visual.query.sortDefinition.sort[0].field.Measure.Property = $Measures[0].Property
    $card.visual.objects.value = $selectors
    Set-ContainerStyle $card $Title
    return $card
}

function New-Line($Template, [string]$Name, [string]$Title, [string]$Entity, [string]$Property, [string]$Color, [double]$X, [double]$Y, [double]$Width, [double]$Height, [int]$Order) {
    $line = Copy-JsonObject $Template
    Set-Position $line $Name $X $Y $Width $Height $Order
    $line.visual.query.queryState.Y.projections = @(New-MeasureProjection $Entity $Property)
    Set-ContainerStyle $line $Title
    Set-ChartColor $line $Color $false "$Entity.$Property"
    return $line
}

function New-ColumnProjection([string]$Entity, [string]$Property) {
    return @{
        field = @{
            Column = @{
                Expression = @{ SourceRef = @{ Entity = $Entity } }
                Property = $Property
            }
        }
        queryRef = "$Entity.$Property"
        nativeQueryRef = $Property
    }
}

function New-VitalsTable($Template, [string]$Name, [string]$Title, [double]$X, [double]$Y, [double]$Width, [double]$Height, [int]$Order) {
    $table = Copy-JsonObject $Template
    Set-Position $table $Name $X $Y $Width $Height $Order
    $table.visual.visualType = 'tableEx'
    $table.visual.query.queryState = @{
        Values = @{
            projections = @(
                (New-ColumnProjection 'DimSignoVital' 'Nombre'),
                (New-ColumnProjection 'DimSignoVital' 'Unidad'),
                (New-MeasureProjection 'FactVitales' 'Observaciones vitales' '0'),
                (New-MeasureProjection 'FactVitales' 'Valor promedio' '0.00'),
                (New-MeasureProjection 'FactVitales' 'Valor mínimo' '0.00'),
                (New-MeasureProjection 'FactVitales' 'Valor máximo' '0.00')
            )
        }
    }
    $table.visual.query.PSObject.Properties.Remove('sortDefinition')
    $table.visual.objects = @{
        total = @(
            @{
                properties = @{
                    totals = @{ expr = (New-Literal 'false') }
                }
            }
        )
    }
    $table.PSObject.Properties.Remove('filterConfig')
    Set-ContainerStyle $table $Title
    return $table
}

function New-BarFromTemplate($Template, [string]$Name, [string]$Title, [string]$Color, [double]$X, [double]$Y, [double]$Width, [double]$Height, [int]$Order) {
    $bar = Copy-JsonObject $Template
    Set-Position $bar $Name $X $Y $Width $Height $Order
    Set-ContainerStyle $bar $Title
    Set-ChartColor $bar $Color $true
    return $bar
}

function Replace-InJson($Value, [hashtable]$Replacements) {
    $json = $Value | ConvertTo-Json -Depth 100
    foreach ($key in $Replacements.Keys) {
        $json = $json.Replace($key, $Replacements[$key])
    }
    return $json | ConvertFrom-Json
}

function Write-Page([string]$PageId, [string]$DisplayName, $PageTemplate, $Visuals) {
    $pagePath = Join-Path $pagesRoot $PageId
    $visualsPath = Join-Path $pagePath 'visuals'
    if (-not (Test-Path -LiteralPath $visualsPath)) {
        New-Item -ItemType Directory -Path $visualsPath | Out-Null
    }

    $page = Copy-JsonObject $PageTemplate
    $page.name = $PageId
    $page.displayName = $DisplayName
    $page.displayOption = 'FitToPage'
    $page.width = 1920
    $page.height = 1080
    Write-JsonFile (Join-Path $pagePath 'page.json') $page

    foreach ($visual in $Visuals) {
        Write-JsonFile (Join-Path (Join-Path $visualsPath $visual.name) 'visual.json') $visual
    }
}

$diagnosticsPageId = 'c1364fbc91b49e0a8e35'
$medicationsPageId = '2494a929456618b536c7'
$summaryPageId = '0a1b2c3d4e5f60718293'
$vitalsPageId = '9f8e7d6c5b4a30291817'

$pageTemplate = Read-JsonFile (Join-Path $pagesRoot "$diagnosticsPageId\page.json")
$cardTemplate = Read-JsonFile (Join-Path $pagesRoot "$diagnosticsPageId\visuals\26b8f5a529b8c8a10bbf\visual.json")
$diagnosticsBarTemplate = Read-JsonFile (Join-Path $pagesRoot "$diagnosticsPageId\visuals\428976026fb247696421\visual.json")
$medicationsBarTemplate = Read-JsonFile (Join-Path $pagesRoot "$medicationsPageId\visuals\22d7aa14febe23135532\visual.json")
$lineTemplate = Read-JsonFile (Join-Path $pagesRoot "$medicationsPageId\visuals\e7e8c0a712eefe4e05fb\visual.json")

$summaryCard = New-Card $cardTemplate '10000000000000000001' 'Resumen ejecutivo' @(
    @{ Entity = 'FactDiagnosticos'; Property = 'Diagnósticos'; Format = '0' },
    @{ Entity = 'FactMedicamentos'; Property = 'Ördenes de Medicamentos'; Format = '0' },
    @{ Entity = 'FactVitales'; Property = 'Observaciones vitales'; Format = '0' },
    @{ Entity = 'FactDiagnosticos'; Property = 'Pacientes con diagnósticos'; Format = '0' },
    @{ Entity = 'FactMedicamentos'; Property = 'Pacientes con órdenes'; Format = '0' },
    @{ Entity = 'FactVitales'; Property = 'Pacientes con signos vitales'; Format = '0' }
)
$summaryDiagnosisLine = New-Line $lineTemplate '10000000000000000002' 'Diagnósticos por mes' 'FactDiagnosticos' 'Diagnósticos meses completos' '#2F6B9A' 40 310 600 700 1
$summaryMedicationLine = New-Line $lineTemplate '10000000000000000003' 'Órdenes de medicamentos por mes' 'FactMedicamentos' 'Órdenes meses completos' '#0F766E' 660 310 600 700 2
$summaryVitalsLine = New-Line $lineTemplate '10000000000000000004' 'Observaciones vitales por mes' 'FactVitales' 'Observaciones meses completos' '#C46535' 1280 310 600 700 3
Write-Page $summaryPageId 'Resumen' $pageTemplate @($summaryCard, $summaryDiagnosisLine, $summaryMedicationLine, $summaryVitalsLine)

$diagnosticsCard = New-Card $cardTemplate '26b8f5a529b8c8a10bbf' 'Indicadores de diagnósticos' @(
    @{ Entity = 'FactDiagnosticos'; Property = 'Diagnósticos'; Format = '0' },
    @{ Entity = 'FactDiagnosticos'; Property = 'Pacientes con diagnósticos'; Format = '0' },
    @{ Entity = 'FactDiagnosticos'; Property = 'Diagnósticos repetidos'; Format = '0' },
    @{ Entity = 'FactDiagnosticos'; Property = '% diagnósticos repetidos'; Format = '0.0%' },
    @{ Entity = 'FactDiagnosticos'; Property = 'Edad promedio al diagnóstico'; Format = '0.0' }
)
$diagnosticsBar = New-BarFromTemplate $diagnosticsBarTemplate '428976026fb247696421' '10 diagnósticos más frecuentes' '#2F6B9A' 40 310 1000 700 1
$diagnosticsLine = New-Line $lineTemplate '20000000000000000001' 'Diagnósticos por mes' 'FactDiagnosticos' 'Diagnósticos meses completos' '#2F6B9A' 1080 310 800 700 2
Write-Page $diagnosticsPageId 'Diagnósticos' $pageTemplate @($diagnosticsCard, $diagnosticsBar, $diagnosticsLine)

$medicationsCard = New-Card $cardTemplate '30000000000000000001' 'Indicadores de medicamentos' @(
    @{ Entity = 'FactMedicamentos'; Property = 'Ördenes de Medicamentos'; Format = '0' },
    @{ Entity = 'FactMedicamentos'; Property = 'Pacientes con órdenes'; Format = '0' },
    @{ Entity = 'FactMedicamentos'; Property = 'Unidades indicadas'; Format = '0' },
    @{ Entity = 'FactMedicamentos'; Property = 'Medicamentos distintos'; Format = '0' }
)
$medicationsBar = New-BarFromTemplate $medicationsBarTemplate '22d7aa14febe23135532' '10 medicamentos con más órdenes' '#0F766E' 40 310 1000 700 1
$medicationsLine = New-Line $lineTemplate 'e7e8c0a712eefe4e05fb' 'Órdenes de medicamentos por mes' 'FactMedicamentos' 'Órdenes meses completos' '#0F766E' 1080 310 800 700 2
Write-Page $medicationsPageId 'Medicamentos' $pageTemplate @($medicationsCard, $medicationsBar, $medicationsLine)

$vitalsCard = New-Card $cardTemplate '40000000000000000001' 'Indicadores de signos vitales' @(
    @{ Entity = 'FactVitales'; Property = 'Observaciones vitales'; Format = '0' },
    @{ Entity = 'FactVitales'; Property = 'Pacientes con signos vitales'; Format = '0' },
    @{ Entity = 'FactVitales'; Property = 'Tipos de signos vitales'; Format = '0' }
)
$vitalsTable = New-VitalsTable $medicationsBarTemplate '40000000000000000002' 'Estadísticas por signo vital' 40 310 1000 700 1
$vitalsLine = New-Line $lineTemplate '40000000000000000003' 'Observaciones vitales por mes' 'FactVitales' 'Observaciones meses completos' '#C46535' 1080 310 800 700 2
Write-Page $vitalsPageId 'Signos vitales' $pageTemplate @($vitalsCard, $vitalsTable, $vitalsLine)

$pagesMetadata = Read-JsonFile (Join-Path $pagesRoot 'pages.json')
$pagesMetadata.pageOrder = @($summaryPageId, $diagnosticsPageId, $medicationsPageId, $vitalsPageId)
$pagesMetadata.activePageName = $summaryPageId
Write-JsonFile (Join-Path $pagesRoot 'pages.json') $pagesMetadata

Write-Output 'Power BI report definitions regenerated successfully.'
