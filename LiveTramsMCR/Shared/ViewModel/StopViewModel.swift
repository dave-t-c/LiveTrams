//
//  StopViewModel.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 07/03/2023.
//

import Foundation
import Combine

class StopViewModel: ObservableObject {
    @Published var currentStopTlaref: String?
    @Published var nearestStops: [Stop] = []
    @Published var stops: [Stop] = []
    @Published var locationManager: LocationManager = LocationManager()
    private var subscribers = Set<AnyCancellable>()
    
    init() {
        self.locationManager.$lastSeenLocation
                .sink { newLocation in
                    let _ = print("New location recieved: \(newLocation?.coordinate.latitude ?? 1)")
                }
                .store(in: &subscribers)
    }
}

enum SelectedStopView: String {
    case services = "services"
    case nearby = "nearby"
    case planJourney = "planJourney"
}
