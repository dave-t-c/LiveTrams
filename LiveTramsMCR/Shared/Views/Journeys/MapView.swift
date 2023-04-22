//
//  MapView.swift
//  LiveTramsMCR (iOS)
//  Created by shaundon (https://gist.github.com/shaundon/00be84deb3450e31db90a31d5d5b7adc)
//  Modified
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinatesFromOrigin: [CLLocationCoordinate2D]
    var lineCoordinatesFromInterchange: [CLLocationCoordinate2D]? = nil
    let lineColorFromOrigin: Color
    var lineColorFromInterchange: Color? = nil
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
    
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        mapView.addOverlay(polyline)
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            mapView.addOverlay(polylineFromInterchange)
        }
        
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.region = region
        
        view.overlays.forEach {
            if !($0 is MKUserLocation) {
                view.removeOverlay($0)
            }
        }
        
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        view.addOverlay(polyline)
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            view.addOverlay(polylineFromInterchange)
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        guard let routePolyline = overlay as? RoutePolyline else {
                   return MKOverlayRenderer(overlay: overlay)
        }
        
        let renderer = MKPolylineRenderer(polyline: routePolyline)
        renderer.strokeColor = routePolyline.routeColor
        renderer.lineWidth = 5
        return renderer
        
    }
}

class RoutePolyline: MKPolyline {
    var routeColor: UIColor = UIColor.clear
}
