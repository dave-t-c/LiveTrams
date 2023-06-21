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
    private let routeHelper: RouteHelper = RouteHelper()
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        mapView.preferredConfiguration = MKStandardMapConfiguration(emphasisStyle: .muted)
        
        let baseRoutePolylines = routeHelper.generateAllRoutePolylines(routes: routes, enableRouteColor: false)
        let stopAnnotations = routeHelper.generateRouteAnnotations(routes: routes, displayMode: displayMode)
        
        mapView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        mapView.addOverlays(baseRoutePolylines)
        mapView.addAnnotations(stopAnnotations)
        mapView.region = region
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let baseRoutePolylines = routeHelper.generateAllRoutePolylines(routes: routes, enableRouteColor: false)
        let stopAnnotations = routeHelper.generateRouteAnnotations(routes: routes, displayMode: displayMode)

        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 100, right: 100)
        
        view.overlays.forEach {
            view.removeOverlay($0)
        }
        
        view.annotations.forEach {
            view.removeAnnotation($0)
        }
        
        view.addOverlays(baseRoutePolylines)
        view.addAnnotations(stopAnnotations)
        view.region = region
        view.setRegion(region, animated: true)
    }
    
    func makeCoordinator() -> DefaultMapViewCoordinator {
        DefaultMapViewCoordinator(self)
    }
    
    
}

class DefaultMapViewCoordinator: NSObject, MKMapViewDelegate {
    var parent: DefaultMapView
    
    private var lastSeenLatitudeDelta: CLLocationDegrees = 0
    private let maxSize: CGSize = CGSize(width: 20, height: 20)
    
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
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation?.title)
            annotationView.canShowCallout = true
            
            let width = (2 / mapView.region.span.latitudeDelta)
            let height = (2 / mapView.region.span.latitudeDelta)
            let size = CGSize(width: width, height: height)
            if (width > maxSize.width) {
                annotation?.stopSize = maxSize
            }
            
            annotation?.stopSize = width > maxSize.width ? maxSize : size
            
            annotationView.image = UIImage(systemName: "circle.inset.filled")?.withTintColor(annotation!.stopColor)
            annotationView.image = UIGraphicsImageRenderer(size: annotation!.stopSize).image {
                 _ in annotationView.image!.draw(in:CGRect(origin: .zero, size: annotation!.stopSize))
            }
            
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
    
    func increaseRect(rect: CGRect, byPercentage percentage: CGFloat) -> CGRect {
        let startWidth = CGRectGetWidth(rect)
        let startHeight = CGRectGetHeight(rect)
        let adjustmentWidth = (startWidth * percentage) / 2.0
        let adjustmentHeight = (startHeight * percentage) / 2.0
        return CGRectInset(rect, -adjustmentWidth, -adjustmentHeight)
    }

    let rect = CGRectMake(0, 0, 10, 10)
   
}
