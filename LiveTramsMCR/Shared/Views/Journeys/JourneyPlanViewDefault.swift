//
//  JourneyPlanViewDefault.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 07/05/2023.
//

import Foundation
import SwiftUI
import MapKit


struct JourneyPlanViewDefault: View {
    @State private var originStop: String = ""
    @State private var destinationStop: String = ""
    @State private var plannedJourney: PlannedJourney?
    @State private var processedPlannedJourney: ProcessedPlannedJourney?
    @State private var journeyPlannerRequest = JourneyPlannerRequest()
    @State private var serviceInformation: [FormattedServices] = []
    @State private var gettingJourneyRequest: Bool = false
    @State private var showBottomSheet = true
    @State private var journeyData: ProcessedJourneyData? = nil
    @State private var plannerDetent = PresentationDetent.fraction(0.3)
    
    var initialOrigin: String =  ""
    var stops: [String] = []
    private let routeHelper = RouteHelper()
    private let servicesRequest = ServicesRequest()
    
    var availableDestinationStops: [String] {
        let stopsCopy = stops
        return stopsCopy.filter { $0 != originStop }
    }
    
    var availableOriginStops: [String] {
        let stopsCopy = stops
        return stopsCopy.filter { $0 != destinationStop }
    }
    
    var body: some View {
        if (journeyData != nil)
        {
            
            let journeyData = journeyData!
            
            MapView(
                region: journeyData.region,
                lineCoordinatesFromOrigin: journeyData.routeCoordinatesFromOrigin,
                lineCoordinatesFromInterchange: journeyData.routeCoordinatesFromInterchange,
                lineColorFromOrigin: journeyData.lineColorFromOrigin,
                lineColorFromInterchange: journeyData.lineColorFromInterchange)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(10)
            .ignoresSafeArea(.container)
        } else {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.481091, longitude: -2.244779), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))))
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .ignoresSafeArea(.all)
        }
        Text("")
        
        .sheet(isPresented: $showBottomSheet) {
            List {
                Section{
                    
                    VStack{
                        Text("Journey Planner")
                            .font(.headline)
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
                                journeyData = ProcessedJourneyData(plannedJourney: plannedJourney!, processedPlannedJourney: processedPlannedJourney!)
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
                        
                        if (plannedJourney!.requiresInterchange){
                            InterchangeJourneyView(plannedJourney: plannedJourney!, processedPlannedJourney: processedPlannedJourney!)
                        }
                        else{
                            NonInterchangeJourneyView(plannedJourney: plannedJourney, processedPlannedJourney: processedPlannedJourney)
                        }
                        
                        ServiceInformationView(serviceInformation: serviceInformation)
                    }
                    
                    
                    
                }
                
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium, .large, .fraction(0.3), .fraction(0.1)], selection: $plannerDetent)
            .interactiveDismissDisabled(true)
            .presentationBackgroundInteraction(
                .enabled(upThrough: .medium)
            )

            
        }
    }
}
