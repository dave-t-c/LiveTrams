//
//  MapManager.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 24/04/2022.
//

import Foundation
import MapKit

class MapManager: NSObject, ObservableObject {
    
    func openMapsFromStop(stop: Stop) {
        let coords = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        let placemark = MKPlacemark(coordinate: coords)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(stop.stopName) Tram Stop"
        mapItem.openInMaps()
    }
}
