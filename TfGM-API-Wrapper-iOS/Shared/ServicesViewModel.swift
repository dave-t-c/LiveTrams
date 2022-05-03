//
//  ServicesViewModel.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 01/05/2022.
//

import Foundation

class ServicesViewModel : ObservableObject {
    
    @Published var services = FormattedServices(destinations: [:], messages: [])
    
    @Published var stop: Stop? = nil
    
    @MainActor
    func refreshServices() async {
            self.services = try! await ServicesRequest().requestServices(tlaref: stop!.tlaref)
    }
    
    func getDestinationsAlphabetical() -> [String] {
        return Array(self.services.destinations.keys).sorted {
            $0 < $1
        }
    }
}
