//
//  FindNearestStopIntent.swift
//  LiveTramsMCR
//
//  Created by David Cook on 05/04/2023.
//

import AppIntents
import SwiftUI
import OrderedCollections

struct FindNearestStopIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Find nearest stop"
    
    static var description = IntentDescription("Find the nearest tram stop to your location")
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        
        let dialogString: IntentDialog = IntentDialog("Placeholder")
        
        return .result(dialog: dialogString, view: FindNearestStopView())
    }
    
}

private struct FindNearestStopView: View {
    
    var body: some View {
        Text("Placeholder")
    }
}
