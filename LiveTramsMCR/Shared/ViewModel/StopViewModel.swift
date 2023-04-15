//
//  StopViewModel.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 07/03/2023.
//

import OrderedCollections
import CoreLocation
import MapKit

@MainActor
class StopViewModel: ObservableObject {
    @Published var currentStopTlaref: String?
    @Published var nearestStops: [Stop] = []
    @Published var stops: [Stop] = []
    private var locationManager: LocationManager = LocationManager()
    private let maxNearestStops = 6
    private let nearestStopsToDisplay = 3
    private let nearStopThresholdMetres = 5000
    private var stopDistances: OrderedDictionary<String, Double> = OrderedDictionary<String, Double>()
    private var stopRoutes: OrderedDictionary<String, MKRoute> = OrderedDictionary<String, MKRoute>()
    
    
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
            
            // Take more than the stops to display in case there are stops that are closer
            // point to point but longer for walking directions
            let orderedKeys = self.stopDistances.keys.prefix(maxNearestStops)
            
            // Check that all of these are above a 5k threshold. All stops further away than the threshold should be removed
            var filteredKeys: [String] = orderedKeys.map{ $0 }
            filteredKeys.removeAll { Int(self.stopDistances[$0]!) > nearStopThresholdMetres}
            
            if filteredKeys.isEmpty {
                self.nearestStops = []
                return
            }
            
            // For the nearest stops, find the walking distance then re-order based on calculated distance
            let mapManager = MapManager()
            var unsortedStopRoutes = Dictionary<String, MKRoute>()

            for key in orderedKeys {
                let stop = self.stops.first(where: { $0.tlaref == key })
                
                let stopLocation = CLLocation(latitude: stop!.latitude, longitude: stop!.longitude)
                
                let route = try await mapManager.findRoute(origin: location!, destination: stopLocation, transportType: .walking)
                
                if (route == nil)
                {
                    return
                }
                
                if Int(route!.distance) > nearStopThresholdMetres {
                    continue
                }
                
                unsortedStopRoutes[key] = route
            }
            
            let sortedStopRoutes = unsortedStopRoutes.sorted {$0.value.distance < $1.value.distance}
            
            self.stopRoutes = OrderedDictionary<String, MKRoute>()
            for entry in sortedStopRoutes {
                self.stopRoutes[entry.key] = entry.value
            }
            
            let nearestStopTlarefs = self.stopRoutes.keys.prefix(nearestStopsToDisplay)
            self.nearestStops = []
            for key in nearestStopTlarefs {
                let stop = self.stops.first(where: { $0.tlaref == key })
                self.nearestStops.append(stop!)
            }
        }
        
        catch {
            return
        }
    }
    
    private func GetFormattedStopDistance(stop: Stop) -> String {
        let stopDistance = stopRoutes[stop.tlaref]?.distance
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
    
    private func GetFormattedStopWalkTime(stop: Stop) -> String {
        let travelTimeSeconds = stopRoutes[stop.tlaref]?.expectedTravelTime
        if travelTimeSeconds == nil {
            return ""
        }
        
        // Convert the travel time from s to rounded up mins
        let roundedTimeInt = Int(ceil(travelTimeSeconds! / 60))

        return "\(roundedTimeInt) min walk"

    }
    
    func GetFormattedStopInformation(stop: Stop) -> String {
        let distance = self.GetFormattedStopDistance(stop: stop)
        
        let walkTime = GetFormattedStopWalkTime(stop: stop)
        
        return "\(distance) - \(walkTime)"
    }
}

enum SelectedStopView: String {
    case services = "services"
    case nearby = "nearby"
    case planJourney = "planJourney"
}
