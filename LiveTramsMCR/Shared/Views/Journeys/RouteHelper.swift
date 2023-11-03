//
//  RouteHelper.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/04/2023.
//

import Foundation
import OrderedCollections
import MapKit
import SwiftUI

struct RouteHelper {
    func getRouteCoordinatesFromOriginNoInterchange(plannedJourney: PlannedJourneyV2?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
        
        var routeCoordinates: OrderedDictionary<String, CLLocationCoordinate2D> = [:]
        
        if plannedJourney == nil {
            return routeCoordinates
        }
        
        let plannedJourney = plannedJourney!
        
        routeCoordinates[plannedJourney.originStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney.originStop.latitude, longitude: plannedJourney.originStop.longitude)
        
        for stop in plannedJourney.stopsFromOrigin {
            routeCoordinates[stop.stopName] = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        }
        
        routeCoordinates[plannedJourney.destinationStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney.destinationStop.latitude, longitude: plannedJourney.destinationStop.longitude)
        
        
        return routeCoordinates
    }

    func getRouteCoordinatesFromOriginToInterchange(plannedJourney: PlannedJourneyV2?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
        var routeCoordinates: OrderedDictionary<String, CLLocationCoordinate2D> = [:]
        
        if plannedJourney == nil || plannedJourney!.interchangeStop == nil {
            return routeCoordinates
        }
        
        let plannedJourney = plannedJourney!
        
        routeCoordinates[plannedJourney.originStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney.originStop.latitude, longitude: plannedJourney.originStop.longitude)
        
        for stop in plannedJourney.stopsFromOrigin {
            routeCoordinates[stop.stopName] = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        }
        
        routeCoordinates[plannedJourney.interchangeStop!.stopName] = CLLocationCoordinate2D(latitude: plannedJourney.interchangeStop!.latitude, longitude: plannedJourney.interchangeStop!.longitude)
        
        
        return routeCoordinates
    }

    func getRouteCoordinatesFromInterchange(plannedJourney: PlannedJourneyV2?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
        var routeCoordinates: OrderedDictionary<String, CLLocationCoordinate2D> = [:]
        
        if plannedJourney == nil || plannedJourney!.interchangeStop == nil {
            return routeCoordinates
        }
        
        let plannedJourney = plannedJourney!
        
        routeCoordinates[plannedJourney.interchangeStop!.stopName] = CLLocationCoordinate2D(latitude: plannedJourney.interchangeStop!.latitude, longitude: plannedJourney.interchangeStop!.longitude)
        
        for stop in plannedJourney.stopsFromInterchange! {
            routeCoordinates[stop.stopName] = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        }
        
        routeCoordinates[plannedJourney.destinationStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney.destinationStop.latitude, longitude: plannedJourney.destinationStop.longitude)
        
        
        return routeCoordinates
    }
    
    func GenerateRouteColor (hex:String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return Color.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return Color(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0
        )
    }
    
    public func generateAllRoutePolylines(routes: [RouteV2], enableRouteColor: Bool) -> [RoutePolyline] {
        var routePolylines: [RoutePolyline] = []
        for route in routes {
            let lineCoordinates = route.polylineCoordinates.map {CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])}
            let polyline = RoutePolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
            polyline.routeColor = enableRouteColor ? UIColor(self.GenerateRouteColor(hex: route.colour)) : .darkGray
            routePolylines.append(polyline)
        }
        return routePolylines
    }
    
    public func generateRouteAnnotations(routes: [RouteV2], displayMode: ColorScheme) -> [StopAnnotation] {
        var stopAnnotations: [StopAnnotation] = []
        var stops: [Stop] = []
        for route in routes {
            stops.append(contentsOf: route.stopsDetail)
        }
        
        let distinctStops = Array(Set(stops))
        
        for stop in distinctStops {
            let coordinate = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
            
            let annotation = StopAnnotation()
            annotation.title = stop.stopName
            annotation.coordinate = coordinate
            annotation.stopColor = displayMode == .dark ? .white : .black
            stopAnnotations.append(annotation)
        }
        
        return stopAnnotations
    }
}
