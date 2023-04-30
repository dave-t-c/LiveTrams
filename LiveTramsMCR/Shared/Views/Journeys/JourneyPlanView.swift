//
//  JourneyPlanView.swift
//  LiveTramsMCR
//
//  Created by David Cook on 13/10/2022.
//

import SwiftUI
import MapKit
import OrderedCollections

struct JourneyPlanView: View {
    
    var initialOrigin: String =  ""
    var stops: [String] = []
    
    @State private var originStop: String = ""
    
    @State private var destinationStop: String = ""
    @State private var plannedJourney: PlannedJourney?
    @State private var processedPlannedJourney: ProcessedPlannedJourney?
    @State private var journeyPlannerRequest = JourneyPlannerRequest()
    @State private var servicesRequest = ServicesRequest()
    @State private var serviceInformation: [FormattedServices] = []
    @State private var gettingJourneyRequest: Bool = false
    @State private var journeyMapAvailable: Bool = false
    
    
    
    var body: some View {
        List {
            Section{
                
                VStack{
                    Picker("Origin", selection: $originStop){
                        Text("Select Stop").tag("")
                        ForEach(stops, id: \.self) { stop in
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
                        ForEach(stops, id: \.self) { stop in
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
                            var serviceInformationHolder: [FormattedServices] = []
                            plannedJourney = try await journeyPlannerRequest.planJourney(originName: originStop, destinationName: destinationStop)
                            serviceInformationHolder.append(try await servicesRequest.requestServices(tlaref: originStop))
                            serviceInformationHolder.append(try await servicesRequest.requestServices(tlaref: destinationStop))
                            serviceInformation = serviceInformationHolder
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
            
            if(plannedJourney != nil && processedPlannedJourney != nil)
            {
                Section {
                    
                    Text(processedPlannedJourney!.formattedTime).font(.headline)
                    
                    ServiceInformationView(serviceInformation: serviceInformation)
                    
                    if (plannedJourney!.requiresInterchange){
                        InterchangeJourneyView(plannedJourney: plannedJourney!, processedPlannedJourney: processedPlannedJourney!)
                    }
                    else{
                        NonInterchangeJourneyView(plannedJourney: plannedJourney, processedPlannedJourney: processedPlannedJourney)
                    }
                }
                
                
                
            }
            
        }
        
        .navigationTitle("Journey Planner")
    }
}
