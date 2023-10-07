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
    var plannedJourney: PlannedJourneyV2
    var processedPlannedJourney: ProcessedPlannedJourneyV2
    var routeCoordinatesFromOrigin: OrderedDictionary<String, CLLocationCoordinate2D>
    var routeCoordinatesFromInterchange: OrderedDictionary<String, CLLocationCoordinate2D>
    var region: MKCoordinateRegion
    var lineColorFromOrigin: Color
    var lineColorFromInterchange: Color? = nil
    private var routeHelper = RouteHelper()
    
    init(plannedJourney: PlannedJourneyV2, processedPlannedJourney: ProcessedPlannedJourneyV2) {
        self.plannedJourney = plannedJourney
        self.processedPlannedJourney = processedPlannedJourney
        
        lineColorFromOrigin = processedPlannedJourney.routeFromOriginUIColors.first ?? .clear
        
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
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!

        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.5,
                                    longitudeDelta: (maxLong - minLong) * 2.6)
        self.region = MKCoordinateRegion(center: center, span: span)
        
    }
}
