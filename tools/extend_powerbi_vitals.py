import argparse
import copy
import json
from pathlib import Path


VITALS_PAGE = "9f8e7d6c5b4a30291817"
CARD_ID = "40000000000000000001"
TABLE_ID = "40000000000000000002"
TREND_ID = "40000000000000000003"

YEAR_SLICER_ID = "41000000000000000001"
SEX_SLICER_ID = "41000000000000000002"
DEPARTMENT_SLICER_ID = "41000000000000000003"
AGE_CHART_ID = "41000000000000000004"
DEPARTMENT_CHART_ID = "41000000000000000005"


def load_json(path):
    with path.open("r", encoding="utf-8-sig") as stream:
        return json.load(stream)


def save_json(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="\n") as stream:
        json.dump(value, stream, ensure_ascii=False, indent=2)
        stream.write("\n")


def replace_strings(value, replacements):
    if isinstance(value, dict):
        return {key: replace_strings(item, replacements) for key, item in value.items()}
    if isinstance(value, list):
        return [replace_strings(item, replacements) for item in value]
    if isinstance(value, str):
        for source, target in replacements:
            value = value.replace(source, target)
    return value


def set_position(visual, *, x, y, width, height, z, tab_order):
    visual["position"] = {
        "x": x,
        "y": y,
        "z": z,
        "height": height,
        "width": width,
        "tabOrder": tab_order,
    }


def set_title(visual, title):
    title_objects = visual["visual"]["visualContainerObjects"]["title"]
    title_objects[0]["properties"]["text"]["expr"]["Literal"]["Value"] = f"'{title}'"


def set_data_color(visual, color):
    objects = visual["visual"].setdefault("objects", {})
    objects["dataPoint"] = [
        {
            "properties": {
                "fill": {
                    "solid": {
                        "color": {
                            "expr": {"Literal": {"Value": f"'{color}'"}}
                        }
                    }
                }
            }
        }
    ]


def clone_visual(source_path, target_dir, visual_id, position, replacements=()):
    visual = copy.deepcopy(load_json(source_path))
    visual = replace_strings(visual, replacements)
    visual["name"] = visual_id
    set_position(visual, **position)
    save_json(target_dir / visual_id / "visual.json", visual)
    return visual


def add_card_measure(card):
    projections = card["visual"]["query"]["queryState"]["Data"]["projections"]
    measure_name = "Observaciones promedio por paciente"
    if not any(item.get("nativeQueryRef") == measure_name for item in projections):
        projections.append(
            {
                "field": {
                    "Measure": {
                        "Expression": {"SourceRef": {"Entity": "FactVitales"}},
                        "Property": measure_name,
                    }
                },
                "nativeQueryRef": measure_name,
                "format": "0.00",
                "queryRef": f"FactVitales.{measure_name}",
            }
        )

    value_objects = card["visual"].setdefault("objects", {}).setdefault("value", [])
    metadata = f"FactVitales.{measure_name}"
    if not any(item.get("selector", {}).get("metadata") == metadata for item in value_objects):
        value_objects.append(
            {
                "selector": {"metadata": metadata},
                "properties": {
                    "labelDisplayUnits": {"expr": {"Literal": {"Value": "1D"}}},
                    "labelPrecision": {"expr": {"Literal": {"Value": "2L"}}},
                },
            }
        )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", default=".")
    args = parser.parse_args()

    repo = Path(args.repo).resolve()
    report = repo / "powerbi" / "Informes Power BI v2.Report" / "definition" / "pages"
    old_report = repo / "powerbi" / "Informes Power BI.Report" / "definition" / "pages"
    page_visuals = report / VITALS_PAGE / "visuals"

    card_path = page_visuals / CARD_ID / "visual.json"
    table_path = page_visuals / TABLE_ID / "visual.json"
    trend_path = page_visuals / TREND_ID / "visual.json"
    for required in (card_path, table_path, trend_path):
        if not required.exists():
            raise SystemExit(f"No se encontró el visual requerido: {required}")

    card = load_json(card_path)
    add_card_measure(card)
    set_position(card, x=40, y=45, width=1200, height=220, z=0, tab_order=0)
    save_json(card_path, card)

    table = load_json(table_path)
    set_position(table, x=40, y=310, width=820, height=700, z=1000, tab_order=1000)
    save_json(table_path, table)

    trend = load_json(trend_path)
    old_trend_path = old_report / VITALS_PAGE / "visuals" / TREND_ID / "visual.json"
    old_trend = load_json(old_trend_path)
    trend["visual"]["query"]["queryState"]["Category"] = copy.deepcopy(
        old_trend["visual"]["query"]["queryState"]["Category"]
    )
    set_position(trend, x=890, y=310, width=600, height=330, z=2000, tab_order=2000)
    save_json(trend_path, trend)

    diagnostic_visuals = report / "c1364fbc91b49e0a8e35" / "visuals"
    medication_visuals = report / "2494a929456618b536c7" / "visuals"

    clone_visual(
        diagnostic_visuals / "0a7aae69fdc7b391c360" / "visual.json",
        page_visuals,
        YEAR_SLICER_ID,
        dict(x=1270, y=45, width=300, height=100, z=3000, tab_order=3000),
    )
    clone_visual(
        diagnostic_visuals / "d1587deb73e44b214197" / "visual.json",
        page_visuals,
        SEX_SLICER_ID,
        dict(x=1590, y=45, width=290, height=100, z=4000, tab_order=4000),
    )
    clone_visual(
        medication_visuals / "2406cdf32795e0a6e0c6" / "visual.json",
        page_visuals,
        DEPARTMENT_SLICER_ID,
        dict(x=1270, y=165, width=610, height=100, z=5000, tab_order=5000),
    )

    age_chart = clone_visual(
        medication_visuals / "66b5466a9682af4ab7a2" / "visual.json",
        page_visuals,
        AGE_CHART_ID,
        dict(x=890, y=670, width=600, height=340, z=6000, tab_order=6000),
        replacements=(
            ("FactMedicamentos", "FactVitales"),
            ("Ördenes de Medicamentos", "Observaciones vitales"),
        ),
    )
    age_projection = age_chart["visual"]["query"]["queryState"]["Category"]["projections"][0]
    age_projection["nativeQueryRef"] = "RangoEdad"
    set_title(age_chart, "Observaciones por rango de edad")
    set_data_color(age_chart, "#C46535")
    save_json(page_visuals / AGE_CHART_ID / "visual.json", age_chart)

    department_chart = clone_visual(
        diagnostic_visuals / "428976026fb247696421" / "visual.json",
        page_visuals,
        DEPARTMENT_CHART_ID,
        dict(x=1520, y=310, width=360, height=700, z=7000, tab_order=7000),
        replacements=(
            ("DimEnfermedad", "DimUbicacion"),
            ("FactDiagnosticos", "FactVitales"),
            ("Diagnósticos", "Observaciones vitales"),
            ("diagnósticos", "departamentos"),
            ("Nombre", "Departamento"),
        ),
    )
    set_title(department_chart, "Top 10 departamentos")
    set_data_color(department_chart, "#C46535")
    filters = department_chart.get("filterConfig", {}).get("filters", [])
    if len(filters) > 1:
        filters[1]["displayName"] = "10 departamentos con más observaciones"
    save_json(page_visuals / DEPARTMENT_CHART_ID / "visual.json", department_chart)

    print(f"Página de Signos vitales ampliada en {page_visuals}")


if __name__ == "__main__":
    main()
