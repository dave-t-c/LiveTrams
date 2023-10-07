//
//  JourneyPlanViewPad.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 07/05/2023.
//

import Foundation
import SwiftUI
import OrderedCollections
import MapKit

struct JourneyPlanViewPad: View {
    
    var initialOrigin: String =  ""
    var stops: [String] = []
    
    @State private var originStop: String = ""
    
    @State private var destinationStop: String = ""
    @State private var plannedJourney: PlannedJourney?
    @State private var processedPlannedJourney: ProcessedPlannedJourney?
    @State private var journeyPlannerRequest = JourneyPlannerRequest()
    @State private var journeyPlannerV2Request = JourneyPlannerV2Request()
    @State private var servicesRequest = ServicesRequest()
    @State private var gettingJourneyRequest: Bool = false
    @State private var journeyMapAvailable: Bool = false
    
    @State private var plannedJourneyV2: PlannedJourneyV2Response? = nil
    
    
    var availableDestinationStops: [String] {
        let stopsCopy = stops
        return stopsCopy.filter { $0 != originStop }
    }
    
    var availableOriginStops: [String] {
        let stopsCopy = stops
        return stopsCopy.filter { $0 != destinationStop }
    }
    
    
    var body: some View {
        List {
            Section{
                
                VStack{
                    Picker("Origin", selection: $originStop){
                        Text("Select Stop").tag("")
                        ForEach(availableOriginStops, id: \.self) { stop in
                            Text(stop).tag(stop)
                        }
                    }
                    .onAppear {
                        originStop = originStop == "" ? initialOrigin : originStop
                    }
                    
                    
                    HStack{
                        Image(systemName: "arrow.triangle.swap")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                let temp = destinationStop
                                destinationStop = originStop
                                originStop = temp
                            }
                        Spacer()
                    }
                    Picker("Destination", selection: $destinationStop){
                        Text("Select Stop").tag("")
                        ForEach(availableDestinationStops, id: \.self) { stop in
                            Text(stop).tag(stop)
                        }
                    }
                }
                
            }
            Section{
                HStack{
                    Spacer()
                    Button(action: {
                        Task {
                            gettingJourneyRequest = true
                            plannedJourney = try await journeyPlannerRequest.planJourney(originName: originStop, destinationName: destinationStop)
                            plannedJourneyV2 = try await journeyPlannerV2Request.planJourney(originName: originStop, destinationName: destinationStop)
                            gettingJourneyRequest = false
                            if(plannedJourney == nil){
                                return
                            }
                            
                            processedPlannedJourney = ProcessedPlannedJourney(plannedJourney: plannedJourney!)
                        }
                    }) {
                        Label("Plan Journey", systemImage: "tram.fill")
                    }
                    .padding()
                    
                    if (gettingJourneyRequest) {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    
                    Spacer()
                }
            }
            
            if(plannedJourney != nil && processedPlannedJourney != nil && plannedJourneyV2 != nil)
            {
                Section {
                    
                    Text(processedPlannedJourney!.formattedTime).font(.headline)
                    
                    if (plannedJourney!.requiresInterchange){
                        InterchangeJourneyView(plannedJourney: plannedJourney!, processedPlannedJourney: processedPlannedJourney!)
                    }
                    else{
                        NonInterchangeJourneyView(plannedJourney: plannedJourney, processedPlannedJourney: processedPlannedJourney)
                    }
                    
                    ServiceInformationView(serviceInformation: plannedJourneyV2!.serviceUpdates)
                }
                
                
                
            }
            
        }
        
        .navigationTitle("Journey Planner")
    }
}
