//
//  DefaultMapView.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/05/2023.
//

import SwiftUI
import MapKit
import OrderedCollections

struct DefaultMapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let routes: [RouteV2]
    @Environment(\.colorScheme) private var displayMode
    @Binding var originStop: String
    @Binding var destinationStop: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
        
        let baseRoutePolylines = generateAllRoutePolylines(routes: routes)
        let stopAnnotations = generateRouteAnnotations(routes: routes)
        
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        mapView.addOverlays(baseRoutePolylines)
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
        
        
        let baseRoutePolylines = generateAllRoutePolylines(routes: routes)
        let stopAnnotations = generateRouteAnnotations(routes: routes)

        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        view.addOverlays(baseRoutePolylines)
        view.addAnnotations(stopAnnotations)
        view.region = region
        view.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> DefaultMapViewCoordinator {
        DefaultMapViewCoordinator(self)
    }
    
    private func generateAllRoutePolylines(routes: [RouteV2]) -> [RoutePolyline] {
        var routePolylines: [RoutePolyline] = []
        for route in routes {
            let lineCoordinates = route.polylineCoordinates.map {CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])}
            let polyline = RoutePolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
            polyline.routeColor = .black
            routePolylines.append(polyline)
        }
        return routePolylines
    }
    
    private func generateRouteAnnotations(routes: [RouteV2]) -> [StopAnnotation] {
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
            annotation.stopSize = CGSize(width: 15, height: 15)
            stopAnnotations.append(annotation)
        }
        
        return stopAnnotations
    }
}

class DefaultMapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: DefaultMapView
    
    init(_ parent: DefaultMapView) {
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
            
            let setOrigin = StopAnnotationButton(type: .detailDisclosure)
            setOrigin.action = .SetOrigin
            annotationView.leftCalloutAccessoryView = setOrigin
            
            let setDestination = StopAnnotationButton(type: .detailDisclosure)
            setDestination.action = .SetDestination
            annotationView.rightCalloutAccessoryView = setDestination
            return annotationView
        }
        

        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if !(view.annotation is StopAnnotation) {
            return
        }
        
        let annotation = view.annotation as! StopAnnotation
        let stopName = annotation.title
        print(stopName)
        
        if !(control is StopAnnotationButton) {
            return
        }
        
        let button = control as! StopAnnotationButton
        print(button.action)
        
        switch button.action {
        case .SetDestination:
            parent.destinationStop = stopName!
        case .SetOrigin:
            parent.originStop = stopName!
        }
    }
}
