//
//  RouteHelper.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/04/2023.
//

import Foundation
import OrderedCollections
import MapKit

struct RouteHelper {
    func getRouteCoordinatesFromOriginNoInterchange(plannedJourney: PlannedJourney?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
        
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

    func getRouteCoordinatesFromOriginToInterchange(plannedJourney: PlannedJourney?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
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

    func getRouteCoordinatesFromInterchange(plannedJourney: PlannedJourney?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
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
}
