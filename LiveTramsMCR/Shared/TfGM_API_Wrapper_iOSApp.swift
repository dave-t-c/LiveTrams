//
//  TfGM_API_Wrapper_iOSApp.swift
//  Shared
//
//  Created by David Cook on 22/04/2022.
//

import SwiftUI

@main
struct TfGM_API_Wrapper_iOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
