//
//  ServicesViewModel.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 01/05/2022.
//

import Foundation
import OrderedCollections

class ServicesViewModel : ObservableObject {
    
    @Published var services = FormattedServices(destinations: [:], messages: [], lastUpdated: "")
    
    @Published var stop: Stop? = nil
    
    @MainActor
    func refreshServices() async {
            self.services = try! await ServicesRequest().requestServices(tlaref: stop!.tlaref)
    }
    
    func getDestinationsAlphabetical() -> [String] {
        // Get the destinations
        let dests = services.destinations.keys
        
        return Array(dests).sorted {
            $0 < $1
        }
    }
}
