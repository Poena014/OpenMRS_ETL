/*
 *  Power BI Visualizations
 *
 *  Copyright (c) Microsoft Corporation
 *  All rights reserved.
 *  MIT License
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the ""Software""), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

"use strict";

import { formattingSettings } from "powerbi-visuals-utils-formattingmodel";

import FormattingSettingsCard = formattingSettings.SimpleCard;
import FormattingSettingsSlice = formattingSettings.Slice;
import FormattingSettingsModel = formattingSettings.Model;

/**
 * Formato del reloj
 */
class ClockCardSettings extends FormattingSettingsCard {
    fontColor = new formattingSettings.ColorPicker({
        name: "fontColor",
        displayName: "Color del texto",
        value: { value: "#1F2937" }
    });

    fontSize = new formattingSettings.NumUpDown({
        name: "fontSize",
        displayName: "Tamaño de la hora",
        value: 48
    });

    backgroundColor = new formattingSettings.ColorPicker({
        name: "backgroundColor",
        displayName: "Color de fondo",
        value: { value: "#FFFFFF" }
    });

    showDate = new formattingSettings.ToggleSwitch({
        name: "showDate",
        displayName: "Mostrar fecha",
        value: true
    });

    showSeconds = new formattingSettings.ToggleSwitch({
        name: "showSeconds",
        displayName: "Mostrar segundos",
        value: true
    });

    timeFormat = new formattingSettings.ItemDropdown({
        name: "timeFormat",
        displayName: "Formato de hora",
        value: { value: "24h", displayName: "24 horas" },
        items: [
            { value: "24h", displayName: "24 horas" },
            { value: "12h", displayName: "12 horas" }
        ]
    });

    name: string = "clock";
    displayName: string = "Reloj";
    slices: Array<FormattingSettingsSlice> = [
        this.fontColor,
        this.fontSize,
        this.backgroundColor,
        this.showDate,
        this.showSeconds,
        this.timeFormat
    ];
}

/**
 * Modelo de configuración del visual
 */
export class VisualFormattingSettingsModel extends FormattingSettingsModel {
    clockCard = new ClockCardSettings();

    cards = [this.clockCard];
}
