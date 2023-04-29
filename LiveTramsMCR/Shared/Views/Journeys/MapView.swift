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
        var stopAnnotations: [StopAnnotation] = []
        for (index, stop) in lineCoordinatesFromOrigin.keys.enumerated() {
            let annotation = StopAnnotation()
            if index == 0 {
                annotation.stopColor = .cyan
                annotation.subtitle = "Start"
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange != nil{
                annotation.stopColor = .cyan
                annotation.subtitle = "Change here"
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange == nil{
                annotation.stopColor = .cyan
                annotation.subtitle = "Destination"
            }
            
            annotation.coordinate = lineCoordinatesFromOrigin[stop]!
            annotation.title = stop
            stopAnnotations.append(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            mapView.addOverlay(polylineFromInterchange)
            
            for (index, stop) in lineCoordinatesFromInterchange!.keys.enumerated() {
                if index == 0 {
                    continue
                }
                
                let annotation = StopAnnotation()
                
                if index == lineCoordinatesFromInterchange!.keys.count - 1 {
                    annotation.stopColor = .cyan
                    annotation.subtitle = "Destination"
                }
                    
                annotation.coordinate = lineCoordinatesFromInterchange![stop]!
                annotation.title = stop
                stopAnnotations.append(annotation)
            }
        }
        mapView.addAnnotations(stopAnnotations)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.region = region
        
        view.overlays.forEach {
            if !($0 is MKUserLocation) {
                view.removeOverlay($0)
            }
        }
        
        view.annotations.forEach {
            if !($0 is StopAnnotation) {
                view.removeAnnotation($0)
            }
        }
        
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin.map {$0.value}, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        view.addOverlay(polyline)
        var stopAnnotations: [StopAnnotation] = []
        for (index, stop) in lineCoordinatesFromOrigin.keys.enumerated() {
            let annotation = StopAnnotation()
            if index == 0 {
                annotation.stopColor = .cyan
                annotation.subtitle = "Start"
                annotation.stopSize = CGSize(width: 20, height: 20)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange != nil{
                annotation.stopColor = .cyan
                annotation.subtitle = "Change here"
                annotation.stopSize = CGSize(width: 20, height: 20)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange == nil{
                annotation.stopColor = .cyan
                annotation.subtitle = "Destination"
                annotation.stopSize = CGSize(width: 20, height: 20)
            }
            
            annotation.coordinate = lineCoordinatesFromOrigin[stop]!
            annotation.title = stop
            stopAnnotations.append(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            view.addOverlay(polylineFromInterchange)
            
            
            for (index, stop) in lineCoordinatesFromInterchange!.keys.enumerated() {
                if index == 0 {
                    continue
                }
                
                let annotation = StopAnnotation()
                
                if index == lineCoordinatesFromInterchange!.keys.count - 1 {
                    annotation.stopColor = .cyan
                    annotation.subtitle = "Destination"
                    annotation.stopSize = CGSize(width: 20, height: 20)
                }
                    
                
                annotation.coordinate = lineCoordinatesFromInterchange![stop]!
                annotation.title = stop
                stopAnnotations.append(annotation)
                
            }
        }
        
        view.addAnnotations(stopAnnotations)
        
        
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
        if overlay is MKPolyline {
            let routePolyline = overlay as? RoutePolyline
            let renderer = MKPolylineRenderer(polyline: routePolyline!)
            renderer.strokeColor = routePolyline!.routeColor
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is StopAnnotation {
            let annotation = annotation as? StopAnnotation
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: UUID().uuidString)
            annotationView.canShowCallout = true
            annotationView.image = UIImage(systemName: "smallcircle.filled.circle")?.withTintColor(annotation!.stopColor)
            annotationView.image = UIGraphicsImageRenderer(size: annotation!.stopSize).image {
                 _ in annotationView.image!.draw(in:CGRect(origin: .zero, size: annotation!.stopSize))
            }
            return annotationView
        }
        

        return nil
    }
}

class RoutePolyline: MKPolyline {
    var routeColor: UIColor = UIColor.clear
}

class StopAnnotation: MKPointAnnotation {
    var stopColor: UIColor = UIColor.white
    var stopSize: CGSize = CGSize(width: 10, height: 10)
}
