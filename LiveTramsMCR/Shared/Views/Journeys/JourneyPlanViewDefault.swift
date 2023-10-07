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
    @State private var processedPlannedJourneyV2: ProcessedPlannedJourneyV2?
    @State private var journeyPlannerV2Request = JourneyPlannerV2Request()
    @State private var gettingJourneyRequest: Bool = false
    @State private var showBottomSheet = true
    @State private var journeyData: ProcessedJourneyData? = nil
    @State private var plannerDetent = PresentationDetent.fraction(0.3)
    @State private var routes: [RouteV2] = []
    @State private var plannedJourneyV2: PlannedJourneyV2Response? = nil
    
    var initialOrigin: String =  ""
    var stops: [String] = []
    private let routeHelper = RouteHelper()
    private let servicesRequest = ServicesRequest()
    @Environment(\.presentationMode) var presentation
    @State private var defaultMapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.4854221, longitude: -2.2077785),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var availableDestinationStops: [String] {
        let stopsCopy = stops
        return stopsCopy.filter { $0 != originStop }
    }
    
    var availableOriginStops: [String] {
        let stopsCopy = stops
        return stopsCopy.filter { $0 != destinationStop }
    }
    
    var body: some View {
        
            ZStack {
                if (journeyData != nil && plannedJourneyV2 != nil)
                {
                    
                    let journeyData = journeyData!
                    
                    MapView(
                        region: journeyData.region,
                        lineCoordinatesFromOrigin: plannedJourneyV2!.visualisedJourney.polylineFromOrigin,
                        stopCoordinatesFromOrigin: journeyData.routeCoordinatesFromOrigin,
                        lineCoordinatesFromInterchange: plannedJourneyV2?.visualisedJourney.polylineFromInterchange,
                        stopCoordinatesFromInterchange: journeyData.routeCoordinatesFromInterchange,
                        lineColorFromOrigin: journeyData.lineColorFromOrigin,
                        lineColorFromInterchange: journeyData.lineColorFromInterchange)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .ignoresSafeArea(.container)
                } else {
                    
                    DefaultMapView(region: defaultMapRegion,
                                   routes: routes)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(10)
                    .ignoresSafeArea(.all)
                }
                
                VStack {
                    
                    HStack {
                        Button {
                            presentation.wrappedValue.dismiss()
                            showBottomSheet = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(maxWidth: 30, maxHeight: 30)
                                .foregroundColor(.gray)
                                .padding(.trailing, 300)
                        }
                    }
                    Spacer()
                }
        }
        
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showBottomSheet) {
            NavigationView {
                
                List {
                    /*HStack {
                        Text("Journey Planner")
                            .bold()
                            .font(.title)

                        Spacer()
                    }
                    .listRowBackground(Color.clear)*/
                    
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
                                    plannedJourneyV2 = try await journeyPlannerV2Request.planJourney(originName: originStop, destinationName: destinationStop)
                                    gettingJourneyRequest = false
                                    if(plannedJourneyV2 == nil){
                                        return
                                    }
                                    
                                    processedPlannedJourneyV2 = ProcessedPlannedJourneyV2(plannedJourney: plannedJourneyV2!)
                                    journeyData = ProcessedJourneyData(plannedJourney: plannedJourneyV2!.plannedJourney, processedPlannedJourney: processedPlannedJourneyV2!)
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
                    
                    if(processedPlannedJourneyV2 != nil && plannedJourneyV2 != nil)
                    {
                        Section {
                            Text(processedPlannedJourneyV2!.formattedTime).font(.headline)
                            if (plannedJourneyV2!.nextService != nil){
                                Text("Take the next tram towards \(plannedJourneyV2!.nextService!.destination.stopName) in \(plannedJourneyV2!.nextService!.wait) mins")
                                    .font(.headline)
                            }
                            
                            if (plannedJourneyV2!.plannedJourney.requiresInterchange){
                                InterchangeJourneyView(plannedJourney: plannedJourneyV2!.plannedJourney, processedPlannedJourney: processedPlannedJourneyV2!)
                                    .padding()
                            }
                            else{
                                NonInterchangeJourneyView(plannedJourney: plannedJourneyV2!.plannedJourney, processedPlannedJourney: processedPlannedJourneyV2)
                                    .padding()
                            }
                        }
                        
                        Section {
                            ServiceInformationView(serviceInformation: plannedJourneyV2!.serviceUpdates)
                        }
                    }
                }
                .navigationTitle("Journey Planner")
                .padding(.all, 0)
                
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.medium, .large, .fraction(0.3), .fraction(0.1)], selection: $plannerDetent)
            .interactiveDismissDisabled(true)
            .presentationBackgroundInteraction(
                .enabled(upThrough: .medium)
            )
            
            
        }
        .onAppear {
            RouteV2Request().requestRoutesV2 { (routes) in
                self.routes = routes
            }
            
            showBottomSheet = true
        }
    }
}
