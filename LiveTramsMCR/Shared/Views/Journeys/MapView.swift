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
    @Environment(\.colorScheme) private var displayMode
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
        
        
        
        var stopAnnotations: [StopAnnotation] = []
        var routePolylines: [RoutePolyline] = []
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin.map {$0.value}, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        routePolylines.append(polyline)
        for (index, stop) in lineCoordinatesFromOrigin.keys.enumerated() {
            let annotation = StopAnnotation()
            if index == 0 {
                annotation.subtitle = "Start"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange != nil{
                annotation.subtitle = "Change here"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange == nil{
                annotation.subtitle = "Destination"
                annotation.stopSize = CGSize(width: 30, height: 30)
            }
            
            annotation.stopColor = displayMode == .dark ? .white : .black
            annotation.coordinate = lineCoordinatesFromOrigin[stop]!
            annotation.title = stop
            stopAnnotations.append(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            routePolylines.append(polylineFromInterchange)
            
            for (index, stop) in lineCoordinatesFromInterchange!.keys.enumerated() {
                if index == 0 {
                    continue
                }
                
                let annotation = StopAnnotation()
                
                if index == lineCoordinatesFromInterchange!.keys.count - 1 {
                    annotation.subtitle = "Destination"
                    annotation.stopSize = CGSize(width: 30, height: 30)
                }
                 
                annotation.stopColor = displayMode == .dark ? .white : .black
                annotation.coordinate = lineCoordinatesFromInterchange![stop]!
                annotation.title = stop
                stopAnnotations.append(annotation)
            }
        }
        
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        mapView.addOverlays(routePolylines)
        mapView.addAnnotations(stopAnnotations)
        mapView.region = region
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        view.region = region
        
        view.overlays.forEach {
            view.removeOverlay($0)
        }
        
        view.annotations.forEach {
            view.removeAnnotation($0)
        }
        
        
        var stopAnnotations: [StopAnnotation] = []
        var routePolylines: [RoutePolyline] = []
        let polyline = RoutePolyline(coordinates: lineCoordinatesFromOrigin.map {$0.value}, count: lineCoordinatesFromOrigin.count)
        polyline.routeColor = UIColor(lineColorFromOrigin)
        routePolylines.append(polyline)
        for (index, stop) in lineCoordinatesFromOrigin.keys.enumerated() {
            let annotation = StopAnnotation()
            annotation.stopColor = displayMode == .dark ? .white : .black
            annotation.coordinate = lineCoordinatesFromOrigin[stop]!
            annotation.title = stop
            annotation.stopColor = polyline.routeColor

            if index == 0 {
                annotation.subtitle = "Start"
                annotation.stopSize = CGSize(width: 30, height: 30)
                annotation.stopColor = .white
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange != nil{
                annotation.subtitle = "Change here"
                annotation.stopSize = CGSize(width: 30, height: 30)
                annotation.stopColor = .white
            }
            
            if index == lineCoordinatesFromOrigin.keys.count - 1 && lineColorFromInterchange == nil{
                annotation.subtitle = "Destination"
                annotation.stopSize = CGSize(width: 30, height: 30)
                annotation.stopColor = .white
            }
            stopAnnotations.append(annotation)
        }
        
        if (lineCoordinatesFromInterchange != nil && lineColorFromInterchange != nil) {
            let polylineFromInterchange = RoutePolyline(coordinates: lineCoordinatesFromInterchange!.map {$0.value}, count: lineCoordinatesFromInterchange!.count)
            polylineFromInterchange.routeColor = UIColor(lineColorFromInterchange!)
            routePolylines.append(polylineFromInterchange)
            
            
            for (index, stop) in lineCoordinatesFromInterchange!.keys.enumerated() {
                if index == 0 {
                    continue
                }
                
                let annotation = StopAnnotation()
                annotation.stopColor = displayMode == .dark ? .white : .black
                annotation.coordinate = lineCoordinatesFromInterchange![stop]!
                annotation.title = stop
                annotation.stopColor = polylineFromInterchange.routeColor
                
                if index == lineCoordinatesFromInterchange!.keys.count - 1 {
                    annotation.subtitle = "Destination"
                    annotation.stopSize = CGSize(width: 30, height: 30)
                    annotation.stopColor = .white
                }
                
                stopAnnotations.append(annotation)
            }
        }
        
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        view.addOverlays(routePolylines)
        view.addAnnotations(stopAnnotations)
        view.region = region
        view.setRegion(region, animated: true)
        
        print("Updated view: \(view.region.span.latitudeDelta)")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    var lastSeenLatitudeDelta: CLLocationDegrees = 0
    let maxSize: CGSize = CGSize(width: 20, height: 20)
    
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
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation?.title)
            annotationView.canShowCallout = true
            annotationView.image = UIImage(systemName: "circle.inset.filled")?.withTintColor(annotation!.stopColor)
            
            let width = (2 / mapView.region.span.latitudeDelta)
            let height = (2 / mapView.region.span.latitudeDelta)
            var size = CGSize(width: width, height: height)
            
            if (width > maxSize.width) {
                size = maxSize
            }
            
            
            annotationView.image = UIGraphicsImageRenderer(size: size).image {
                 _ in annotationView.image!.draw(in:CGRect(origin: .zero, size: size))
            }
            
            
            annotationView.collisionMode = .circle
            return annotationView
        }
        

        return nil
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let latitudeDeltaChange = lastSeenLatitudeDelta.magnitude - mapView.region.span.latitudeDelta.magnitude
        
        if (latitudeDeltaChange.magnitude < 0.01)
        {
            lastSeenLatitudeDelta = mapView.region.span.latitudeDelta.magnitude
            return
        }
        
        resetMapAnnotations(mapView: mapView)
        
        lastSeenLatitudeDelta = mapView.region.span.latitudeDelta.magnitude
    }
    
    private func resetMapAnnotations(mapView: MKMapView) {
        
        let existingAnnotations = mapView.annotations
        mapView.annotations.forEach {
            mapView.removeAnnotation($0)
        }
        
        mapView.addAnnotations(existingAnnotations)
                
    }
}

class RoutePolyline: MKPolyline {
    var routeColor: UIColor = UIColor.clear
}

class StopAnnotation: MKPointAnnotation {
    var stopColor: UIColor = .white
    var stopSize: CGSize = CGSize(width: 15, height: 15)
}

class StopAnnotationButton: UIButton {
    var action: StopAnnotationButtionActions = .SetOrigin
}

enum StopAnnotationButtionActions {
    case SetOrigin
    case SetDestination
}
