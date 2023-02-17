//
//  MapManager-watchOS.swift
//  LiveTramsMCR Watch App
//
//  Created by David Cook on 16/02/2023.
//

import Foundation
import MapKit

class MapManagerWatchOS: NSObject, ObservableObject {
    
    func openMapsFromStop(stop: Stop) {
        let coords = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        let placemark = MKPlacemark(coordinate: coords)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(stop.stopName) Tram Stop"
        mapItem.openInMaps()
    }
}
