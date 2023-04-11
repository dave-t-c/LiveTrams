//
//  StopViewModel.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 07/03/2023.
//

import OrderedCollections
import CoreLocation

@MainActor
class StopViewModel: ObservableObject {
    @Published var currentStopTlaref: String?
    @Published var nearestStops: [Stop] = []
    @Published var stops: [Stop] = []
    private var locationManager: LocationManager = LocationManager()
    private let maxNearestStops = 3
    var stopDistances: OrderedDictionary<String, Double> = OrderedDictionary<String, Double>()
    
    
    func UpdateNearestStops() async -> Void {
        do {
            
            let location = locationManager.lastSeenLocation
            let maxRetries = 10
            var currAttempts = 0
            while((location == nil || stops.isEmpty) && currAttempts < maxRetries)
            {
                let duration = UInt64(0.25 * 1_000_000_000)
                try await Task.sleep(nanoseconds: duration)
                currAttempts += 1
            }
            
            if (location == nil)
            {
                return
            }
            
            var stopDistances = Dictionary<String, Double>()
            self.stops.forEach {stop in
                let stopLocation = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
                let distanceFromLocation = location?.distance(from: stopLocation)
                stopDistances[stop.tlaref] = distanceFromLocation
            }
            
            let sortedDict = stopDistances.sorted {$0.1 < $1.1}
            
            self.stopDistances = OrderedDictionary<String, Double>()
            
            
            for entry in sortedDict {
                self.stopDistances[entry.key] = entry.value
            }
            
            let orderedKeys = self.stopDistances.keys.prefix(maxNearestStops)
            self.nearestStops = []
            orderedKeys.forEach { key in
                let stop = self.stops.first(where: { $0.tlaref == key })
                self.nearestStops.append(stop!)
            }
        }
        
        catch {
            return
        }
    }
    
    func GetFormattedStopDistance(stop: Stop) -> String {
        let stopDistance = stopDistances[stop.tlaref]
        if stopDistance == nil {
            return ""
        }
        
        if (stopDistance! >= 1000) {
            let kmDistance = stopDistance! / 1000
            let formattedDistance = (kmDistance * 100).rounded() / 100
            return "\(String(formattedDistance)) km"
        }
        
        let fomrmattedDistance = stopDistance!.rounded()
        let formattedDistanceString = String(format: "%.0f", fomrmattedDistance)
        return "\(String(formattedDistanceString))m"

    }
}

enum SelectedStopView: String {
    case services = "services"
    case nearby = "nearby"
    case planJourney = "planJourney"
}
