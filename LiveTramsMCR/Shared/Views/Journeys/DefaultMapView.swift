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
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
        
        let baseRoutePolylines = generateAllRoutePolylines(routes: routes)
        
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        mapView.addOverlays(baseRoutePolylines)
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

        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        view.addOverlays(baseRoutePolylines)
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
            polyline.routeColor = displayMode == .dark ? .lightGray : .darkGray
            routePolylines.append(polyline)
        }
        return routePolylines
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
            return annotationView
        }
        

        return nil
    }
}
