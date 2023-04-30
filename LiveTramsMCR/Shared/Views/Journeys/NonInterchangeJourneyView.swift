//
//  NonInterchangeJourneyView.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/04/2023.
//

import Foundation
import SwiftUI
import MapKit

struct NonInterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourney?
    var processedPlannedJourney: ProcessedPlannedJourney?
    private let deviceIdiom = UIDevice.current.userInterfaceIdiom
    private let routeHelper = RouteHelper()
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
            Spacer()
            HStack {
                Image(systemName: "smallcircle.filled.circle")
                    .frame(width: 30)
                    .scaleEffect(1.5)
                    .padding(.leading, 3.5)
                    .padding(.bottom, 3.5)
                Text(plannedJourney!.originStop.stopName)
                Spacer()
            }
            HStack(spacing: 0) {
                ForEach(Array(processedPlannedJourney!.routeFromOriginUIColors.enumerated()), id: \.element) { index, routeColor in
                    if(index == 0){
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .center)
                            .padding(.leading, 15.5 - (2.5 * CGFloat(processedPlannedJourney!.routeFromOriginUIColors.count - 1)))
                        
                    } else {
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .leading)
                        
                    }
                }
                
                Spacer()
                VStack{
                    Text("Take the tram towards" + processedPlannedJourney!.formattedTerminiFromOrigin)
                        .padding(.leading, 15)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(processedPlannedJourney!.formattedStopsFromOriginTime)
                        .padding(.top, 10)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            
            HStack {
                Image(systemName: "smallcircle.filled.circle")
                    .frame(width: 30)
                    .scaleEffect(1.5)
                    .padding(.leading, 3.5)
                    .padding(.bottom, 3.5)
                Text(plannedJourney!.destinationStop.stopName)
                Spacer()
            }
            
            Spacer()
            let routeCoordinatesFromOrigin = routeHelper.getRouteCoordinatesFromOriginNoInterchange(plannedJourney: plannedJourney)
            
            
            let allCoordinates = routeCoordinatesFromOrigin.map {$0.value}
            
            let latitudes = allCoordinates.map { $0.latitude }
            let longitudes = allCoordinates.map { $0.longitude }
            
            let avgLatitude = latitudes.reduce(0.0, +) / Double(latitudes.count)
            
            let latitudeDelta = (latitudes.max()! - latitudes.min()!) * 1.4
            
            let avgLongitude = longitudes.reduce(0.0, +) / Double(longitudes.count)
            
            let longitudeDelta = (longitudes.max()! - longitudes.min()!) * 1.4
            
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: avgLatitude, longitude: avgLongitude),
                span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
            )
            
            if deviceIdiom == .pad {
                MapView(region: region, lineCoordinatesFromOrigin: routeCoordinatesFromOrigin, lineColorFromOrigin: processedPlannedJourney!.routeFromOriginUIColors.first!)
                    .aspectRatio(4/3, contentMode: .fill)
                    .frame(maxHeight: 800)
                    .cornerRadius(15)
                    .padding([.top, .bottom])
                
            } else {
                MapView(region: region, lineCoordinatesFromOrigin: routeCoordinatesFromOrigin, lineColorFromOrigin: processedPlannedJourney!.routeFromOriginUIColors.first!)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding([.top, .bottom])
            }
            
            Spacer()
        }
    }
}
