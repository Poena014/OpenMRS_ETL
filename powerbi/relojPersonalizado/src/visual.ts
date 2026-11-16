/*
*  Power BI Visual CLI
*
*  Copyright (c) Microsoft Corporation
*  All rights reserved.
*  MIT License
*/
"use strict";

import powerbi from "powerbi-visuals-api";
import { FormattingSettingsService } from "powerbi-visuals-utils-formattingmodel";
import "./../style/visual.less";

import VisualConstructorOptions = powerbi.extensibility.visual.VisualConstructorOptions;
import VisualUpdateOptions = powerbi.extensibility.visual.VisualUpdateOptions;
import IVisual = powerbi.extensibility.visual.IVisual;
import IVisualEventService = powerbi.extensibility.IVisualEventService;

import { VisualFormattingSettingsModel } from "./settings";

export class Visual implements IVisual {
    private events: IVisualEventService;
    private target: HTMLElement;
    private root: HTMLElement;
    private timeEl: HTMLElement;
    private dateEl: HTMLElement;
    private timer: number | undefined;
    private formattingSettings: VisualFormattingSettingsModel;
    private formattingSettingsService: FormattingSettingsService;

    constructor(options: VisualConstructorOptions) {
        this.events = options.host.eventService;
        this.formattingSettingsService = new FormattingSettingsService();
        this.target = options.element;

        this.root = document.createElement("div");
        this.root.className = "clock-root";

        this.timeEl = document.createElement("div");
        this.timeEl.className = "clock-time";

        this.dateEl = document.createElement("div");
        this.dateEl.className = "clock-date";

        this.root.appendChild(this.timeEl);
        this.root.appendChild(this.dateEl);
        this.target.appendChild(this.root);
    }

    public update(options: VisualUpdateOptions) {
        this.events.renderingStarted(options);

        try {
            this.formattingSettings = this.formattingSettingsService.populateFormattingSettingsModel(
                VisualFormattingSettingsModel,
                options.dataViews && options.dataViews[0]
            );

            this.applyFormatting();
            this.startClock();
            this.render();

            this.events.renderingFinished(options);
        } catch (error) {
            this.events.renderingFailed(options, String(error));
        }
    }

    private applyFormatting(): void {
        const card = this.formattingSettings.clockCard;

        const fontColor = card.fontColor.value.value || "#1F2937";
        const backgroundColor = card.backgroundColor.value.value || "#FFFFFF";
        const fontSize = card.fontSize.value || 48;

        this.timeEl.style.color = fontColor;
        this.dateEl.style.color = fontColor;
        this.root.style.backgroundColor = backgroundColor;

        this.timeEl.style.fontSize = `${fontSize}px`;
        this.dateEl.style.fontSize = `${Math.max(10, Math.round(fontSize * 0.4))}px`;

        this.dateEl.style.display = card.showDate.value ? "block" : "none";
    }

    private startClock(): void {
        if (this.timer !== undefined) {
            window.clearInterval(this.timer);
            this.timer = undefined;
        }
        this.timer = window.setInterval(() => this.render(), 1000);
    }

    private render(): void {
        if (!this.formattingSettings) {
            return;
        }

        const card = this.formattingSettings.clockCard;
        const now = new Date();

        const use24h = card.timeFormat.value.value !== "12h";
        const showSeconds = card.showSeconds.value;

        const time = now.toLocaleTimeString("es-MX", {
            hour: "2-digit",
            minute: "2-digit",
            second: showSeconds ? "2-digit" : undefined,
            hour12: !use24h
        });

        const date = now.toLocaleDateString("es-MX", {
            weekday: "long",
            year: "numeric",
            month: "long",
            day: "numeric"
        });

        this.timeEl.textContent = time;
        this.dateEl.textContent = date;
    }

    public destroy(): void {
        if (this.timer !== undefined) {
            window.clearInterval(this.timer);
            this.timer = undefined;
        }
    }

    /**
     * Returns properties pane formatting model content hierarchies, properties and latest formatting values.
     */
    public getFormattingModel(): powerbi.visuals.FormattingModel {
        return this.formattingSettingsService.buildFormattingModel(this.formattingSettings);
    }
}
