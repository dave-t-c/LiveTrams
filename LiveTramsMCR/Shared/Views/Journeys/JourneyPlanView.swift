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
    @State private var showBottomSheet = true
    @State private var routeHelper = RouteHelper()
    
    
    
    var body: some View {
        if (processedPlannedJourney != nil && plannedJourney != nil)
        {
            let routeCoordinatesFromOrigin = routeHelper.getRouteCoordinatesFromOriginToInterchange(plannedJourney: plannedJourney)
            
            /*var routeCoordinatesFromInterchange: OrderedDictionary<String, CLLocationCoordinate2D> = [:]
            if plannedJourney?.interchangeStop != nil {
                routeCoordinatesFromInterchange = routeHelper.getRouteCoordinatesFromInterchange(plannedJourney: plannedJourney)
            }*/
            
            let routeCoordinatesFromInterchange = routeHelper.getRouteCoordinatesFromInterchange(plannedJourney: plannedJourney)
            
            // Extract this to a view model
            
            // Extract other views?
            
            let allCoordinates = routeCoordinatesFromOrigin.map{ $0.value } + routeCoordinatesFromInterchange.map { $0.value }
            
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
            
            MapView(
                region: region,
                lineCoordinatesFromOrigin: routeCoordinatesFromOrigin,
                lineCoordinatesFromInterchange: routeCoordinatesFromInterchange,
                lineColorFromOrigin: processedPlannedJourney!.routeFromOriginUIColors.first!,
                lineColorFromInterchange: processedPlannedJourney!.routeFromInterchangeUIColors.first!)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(10)
            .ignoresSafeArea(.container)
        } else {
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 53.481091, longitude: -2.244779), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
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
