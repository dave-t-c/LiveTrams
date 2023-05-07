//
//  JourneyPlanView.swift
//  LiveTramsMCR
//
//  Created by David Cook on 13/10/2022.
//

import SwiftUI
import MapKit
import OrderedCollections

struct JourneyPlanView: View {
    
    var initialOrigin: String =  ""
    var stops: [String] = []
    
    var body: some View {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            JourneyPlanViewPad()
        default:
            JourneyPlanViewDefault(initialOrigin: self.initialOrigin, stops: self.stops)
        }
    }
    
}
