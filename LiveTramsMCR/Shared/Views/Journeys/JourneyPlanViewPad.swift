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
                            serviceInformation = []
                            plannedJourney = try await journeyPlannerRequest.planJourney(originName: originStop, destinationName: destinationStop)
                            serviceInformation.append(try await servicesRequest.requestServices(tlaref: originStop))
                            serviceInformation.append(try await servicesRequest.requestServices(tlaref: destinationStop))
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


   func getRouteCoordinatesFromOriginNoInterchange(plannedJourney: PlannedJourney?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
       var routeCoordinates: OrderedDictionary<String, CLLocationCoordinate2D> = [:]
       routeCoordinates[plannedJourney!.originStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney!.originStop.latitude, longitude: plannedJourney!.originStop.longitude)
       
       for stop in plannedJourney!.stopsFromOrigin {
           routeCoordinates[stop.stopName] = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
       }
       
       routeCoordinates[plannedJourney!.destinationStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney!.destinationStop.latitude, longitude: plannedJourney!.destinationStop.longitude)
       
       
       return routeCoordinates
   }

   func getRouteCoordinatesFromOriginToInterchange(plannedJourney: PlannedJourney?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
       var routeCoordinates: OrderedDictionary<String, CLLocationCoordinate2D> = [:]
       routeCoordinates[plannedJourney!.originStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney!.originStop.latitude, longitude: plannedJourney!.originStop.longitude)
       
       for stop in plannedJourney!.stopsFromOrigin {
           routeCoordinates[stop.stopName] = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
       }
       
       routeCoordinates[plannedJourney!.interchangeStop!.stopName] = CLLocationCoordinate2D(latitude: plannedJourney!.interchangeStop!.latitude, longitude: plannedJourney!.interchangeStop!.longitude)
       
       
       return routeCoordinates
   }

   func getRouteCoordinatesFromInterchange(plannedJourney: PlannedJourney?) -> OrderedDictionary<String, CLLocationCoordinate2D>{
       var routeCoordinates: OrderedDictionary<String, CLLocationCoordinate2D> = [:]
       
       routeCoordinates[plannedJourney!.interchangeStop!.stopName] = CLLocationCoordinate2D(latitude: plannedJourney!.interchangeStop!.latitude, longitude: plannedJourney!.interchangeStop!.longitude)
       
       for stop in plannedJourney!.stopsFromInterchange! {
           routeCoordinates[stop.stopName] = CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude)
       }
       
       routeCoordinates[plannedJourney!.destinationStop.stopName] = CLLocationCoordinate2D(latitude: plannedJourney!.destinationStop.latitude, longitude: plannedJourney!.destinationStop.longitude)
       
       
       return routeCoordinates
   }

   func getDistinctMessages(serviceInformation: [FormattedServices]) -> [String] {
       var combinedMessages: [String] = []
       
       for information in serviceInformation {
           combinedMessages.append(contentsOf: information.messages)
       }
       
       return Array(Set(combinedMessages))
   }

