//
//  ProcessedJourneyData.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 01/05/2023.
//

import Foundation
import MapKit
import OrderedCollections
import SwiftUI

class ProcessedJourneyData {
    var plannedJourney: PlannedJourney
    var processedPlannedJourney: ProcessedPlannedJourney
    var routeCoordinatesFromOrigin: OrderedDictionary<String, CLLocationCoordinate2D>
    var routeCoordinatesFromInterchange: OrderedDictionary<String, CLLocationCoordinate2D>
    var region: MKCoordinateRegion
    var lineColorFromOrigin: Color
    var lineColorFromInterchange: Color? = nil
    private var routeHelper = RouteHelper()
    
    init(plannedJourney: PlannedJourney, processedPlannedJourney: ProcessedPlannedJourney) {
        self.plannedJourney = plannedJourney
        self.processedPlannedJourney = processedPlannedJourney
        
        lineColorFromOrigin = processedPlannedJourney.routeFromOriginUIColors.first!
        
        if plannedJourney.requiresInterchange {
            routeCoordinatesFromOrigin = routeHelper.getRouteCoordinatesFromOriginToInterchange(plannedJourney: plannedJourney)
            lineColorFromInterchange = processedPlannedJourney.routeFromInterchangeUIColors.first ?? .clear
        } else {
            routeCoordinatesFromOrigin = routeHelper.getRouteCoordinatesFromOriginNoInterchange(plannedJourney: plannedJourney)
            
        }
        
        routeCoordinatesFromInterchange = routeHelper.getRouteCoordinatesFromInterchange(plannedJourney: plannedJourney)
        
        let allCoordinates = routeCoordinatesFromOrigin.map{ $0.value } + routeCoordinatesFromInterchange.map { $0.value }
        
        let latitudes = allCoordinates.map { $0.latitude }
        let longitudes = allCoordinates.map { $0.longitude }
        
        let avgLatitude = latitudes.reduce(0.0, +) / Double(latitudes.count)
        
        let latitudeDelta = (latitudes.max()! - latitudes.min()!) * 3
        
        let avgLongitude = longitudes.reduce(0.0, +) / Double(longitudes.count)
        
        let longitudeDelta = (longitudes.max()! - longitudes.min()!) * 6
        
        self.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude),
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
        
    }
}
