//
//  TfGM_API_Wrapper_iOSApp.swift
//  Shared
//
//  Created by David Cook on 22/04/2022.
//

import SwiftUI

@main
struct LiveTramsMCR: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Home()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
