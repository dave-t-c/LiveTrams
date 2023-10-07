//
//  InterchangeJourneyView.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/04/2023.
//

import Foundation
import SwiftUI
import MapKit

struct InterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourneyV2
    var processedPlannedJourney: ProcessedPlannedJourneyV2
    private let deviceIdiom = UIDevice.current.userInterfaceIdiom
    private let routeHelper = RouteHelper()
    
    var body: some View {
        
        VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
            
            HStack {
                Image(systemName: "smallcircle.filled.circle")
                    .frame(width: 30)
                    .scaleEffect(1.5)
                    .padding(.leading, 3.5)
                    .padding(.bottom, 3.5)
                Text(plannedJourney.originStop.stopName)
                Spacer()
            }
            HStack(spacing: 0) {
                ForEach(Array(processedPlannedJourney.routeFromOriginUIColors.enumerated()), id: \.element) { index, routeColor in
                    if(index == 0){
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .center)
                            .padding(.leading, 15.5 - (2.5 * CGFloat(processedPlannedJourney.routeFromOriginUIColors.count - 1)))
                        
                    } else {
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .leading)
                        
                    }
                }
                
                Spacer()
                VStack{
                    Text("Take the tram towards" + processedPlannedJourney.formattedTerminiFromOrigin)
                        .padding(.leading, 15)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(processedPlannedJourney.formattedStopsFromOriginTime)
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
                Text(plannedJourney.interchangeStop!.stopName)
                Spacer()
            }
            
            
            HStack(spacing: 0) {
                ForEach(Array(processedPlannedJourney.routeFromInterchangeUIColors.enumerated()), id: \.element) { index, routeColor in
                    if(index == 0){
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .center)
                            .padding(.leading, 15.5 - (2.5 * CGFloat(processedPlannedJourney.routeFromInterchangeUIColors.count - 1)))
                        
                    } else {
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .leading)
                        
                    }
                }
                
                Spacer()
                VStack{
                    Text("Take the tram towards" + processedPlannedJourney.formattedTerminiFromInterchange)
                        .padding(.leading, 15)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(processedPlannedJourney.formattedStopsFromInterchangeTime)
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
                Text(plannedJourney.destinationStop.stopName)
                Spacer()
            }
            
            Spacer()
            
        }
    }
}
