//
//  AppIntent.swift
//  LiveTramsMCRWatchOSExtension
//
//  Created by David Cook on 10/01/2024.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("View live services for a stop")

    // Selected stop name
    @Parameter(title: "Stop name")
    var stopName: String


    init(stopDetail: String) {
        self.stopName = stopDetail
    }


    init() {
    }
}


