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
    @State private var originStop: String = ""
    @State private var destinationStop: String = ""
    @State private var plannedJourney: PlannedJourney?
    @State private var processedPlannedJourney: ProcessedPlannedJourney?
    @State private var journeyPlannerRequest = JourneyPlannerRequest()
    @State private var serviceInformation: [FormattedServices] = []
    @State private var gettingJourneyRequest: Bool = false
    @State private var showBottomSheet = true
    @State private var journeyData: ProcessedJourneyData? = nil
    
    var initialOrigin: String =  ""
    var stops: [String] = []
    private let routeHelper = RouteHelper()
    private let servicesRequest = ServicesRequest()
    
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
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium, .large, .fraction(0.3)])
            .interactiveDismissDisabled(true)
            .presentationBackgroundInteraction(
                .enabled(upThrough: .medium)
            )

            
        }
    }
    
}
