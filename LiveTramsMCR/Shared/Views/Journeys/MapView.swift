//
//  MapView.swift
//  LiveTramsMCR (iOS)
//  Created by shaundon (https://gist.github.com/shaundon/00be84deb3450e31db90a31d5d5b7adc)
//  Modified
//

import SwiftUI
import MapKit
import OrderedCollections

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinatesFromOrigin: OrderedDictionary<String, CLLocationCoordinate2D>
    var lineCoordinatesFromInterchange: OrderedDictionary<String, CLLocationCoordinate2D>? = nil
    let lineColorFromOrigin: Color
    var lineColorFromInterchange: Color? = nil
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
    
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin.map {$0.value}, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        mapView.addOverlay(polyline)
        
        for stop in lineCoordinatesFromOrigin.keys {
            let annotation = MKCircle(center: lineCoordinatesFromOrigin[stop]!, radius: 10)
            annotation.title = stop
            mapView.addOverlay(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            mapView.addOverlay(polylineFromInterchange)
            
            for stop in lineCoordinatesFromInterchange!.keys {
                let annotation = MKCircle(center: lineCoordinatesFromInterchange![stop]!, radius: 10)
                annotation.title = stop
                mapView.addOverlay(annotation)
            }
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
        
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin.map {$0.value}, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        view.addOverlay(polyline)
        
        for stop in lineCoordinatesFromOrigin.keys {
            let annotation = MKCircle(center: lineCoordinatesFromOrigin[stop]!, radius: 10)
            annotation.title = stop
            view.addOverlay(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            view.addOverlay(polylineFromInterchange)
            
            for stop in lineCoordinatesFromInterchange!.keys {
                let annotation = MKCircle(center: lineCoordinatesFromInterchange![stop]!, radius: 10)
                annotation.title = stop
                view.addOverlay(annotation)
            }
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
        
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.white.withAlphaComponent(0.5)
            renderer.strokeColor = UIColor.black
            renderer.lineWidth = 2
            return renderer
        } else if overlay is MKPolyline {
            let routePolyline = overlay as? RoutePolyline
            let renderer = MKPolylineRenderer(polyline: routePolyline!)
            renderer.strokeColor = routePolyline!.routeColor
            renderer.lineWidth = 5
            return renderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
        
        
        
    }
}

class RoutePolyline: MKPolyline {
    var routeColor: UIColor = UIColor.clear
}
