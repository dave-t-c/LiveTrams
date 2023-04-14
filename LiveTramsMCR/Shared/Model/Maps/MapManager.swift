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
    
    func searchLocalArea(stop: Stop, searchTerm: String) async throws -> [MKMapItem]{
        let coords = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
        let stopLocation = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchTerm
        let region = MKCoordinateRegion(center: coords, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)

        //Complete search
        let response = try  await search.start()
        return(self.filterMapItems(mapItems: response.mapItems, stopLocation: stopLocation))
    }
    
    //Use a sorted set hear to sort by distance to tram stop
    
    func filterMapItems(mapItems: [MKMapItem], stopLocation: CLLocation) -> [MKMapItem] {
        var filteredItems = Set<MKMapItem>()
        for mapItem in mapItems {
            if !filteredItems.contains(where: { item in item.name == mapItem.name })
            {
                filteredItems.insert(mapItem)
            }
        }
        let sortedItems = filteredItems.sorted(by: ({ stopLocation.distance(from: $0.placemark.location!) < stopLocation.distance(from: $1.placemark.location!)})).prefix(5)
        
        return Array(Set(sortedItems))
    }
    
    func findRoute(origin: CLLocation, destination: CLLocation, transportType: MKDirectionsTransportType) async throws -> MKRoute? {
        
        let originPlacemark = MKPlacemark(coordinate: origin.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)
        
        let request = MKDirections.Request()
        request.transportType = transportType
        request.source = MKMapItem(placemark: originPlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        
        let directions = MKDirections(request: request)
        
        
        let response = try await directions.calculate()
        
        return response.routes.first
    }
}
