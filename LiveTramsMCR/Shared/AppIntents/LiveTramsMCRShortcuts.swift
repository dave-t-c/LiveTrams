//
//  LiveTramsMCRShortcuts.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 01/04/2023.
//

import AppIntents

struct LiveTramsMCRShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] = [
        AppShortcut(
            intent: GetNextTramIntent(),
            phrases: [
                "Ask \(.applicationName) for live services",
                "Ask \(.applicationName) for the next tram",
                "Get the next tram from \(.applicationName)"
            ]
        )
    ]
}
