//
//  StopDetailMap.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 05/06/2023.
//

import SwiftUI
import MapKit

struct StopDetailMap: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let route: RouteV2
    private let routeHelper: RouteHelper = RouteHelper()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
        
        let lineCoordinates = route.polylineCoordinates.map {CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])}
        let polyline = RoutePolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        polyline.routeColor = UIColor(routeHelper.GenerateRouteColor(hex: route.colour))
        
        mapView.addOverlay(polyline)
        
        mapView.region = region
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        
        view.overlays.forEach {
            view.removeOverlay($0)
        }
        
        view.annotations.forEach {
            view.removeAnnotation($0)
        }
        
        let lineCoordinates = route.polylineCoordinates.map {CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])}
        let polyline = RoutePolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        polyline.routeColor = UIColor(routeHelper.GenerateRouteColor(hex: route.colour))
        
        view.addOverlay(polyline)
        
        view.region = region
        view.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> StopDetailMapCoordinator {
        StopDetailMapCoordinator(self)
    }
}
    

class StopDetailMapCoordinator: NSObject, MKMapViewDelegate {
    var parent: StopDetailMap
    
    init(_ parent: StopDetailMap) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let routePolyline = overlay as? RoutePolyline
            let renderer = MKPolylineRenderer(polyline: routePolyline!)
            renderer.strokeColor = routePolyline!.routeColor
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}

