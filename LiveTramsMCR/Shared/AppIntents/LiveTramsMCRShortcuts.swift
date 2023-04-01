//
//  LiveTramsMCRShortcuts.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 01/04/2023.
//

import AppIntents

struct LiveTramsMCRShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GetNextTramIntent(),
            phrases: ["Start \(.applicationName) intent"]
        )
    }
}
