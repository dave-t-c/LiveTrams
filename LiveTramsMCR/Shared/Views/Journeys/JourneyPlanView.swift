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
                        InterchangeJourneyView(plannedJourney: plannedJourney, processedPlannedJourney: processedPlannedJourney)
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



struct ServiceInformationView: View {
    var serviceInformation: [FormattedServices]
    
    var body: some View {
        
        let distinctMessages = getDistinctMessages(serviceInformation: serviceInformation)
        if !distinctMessages.isEmpty {
            VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                Text("Service updates for your journey:")
                    .font(.headline)
                    .padding(.top, 10)
                
                ForEach(distinctMessages, id: \.self) { message in
                    Text(message)
                        .padding(.top, 10)
                }
            }
            .padding(.bottom, 0)
        }
    }
}

struct NonInterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourney?
    var processedPlannedJourney: ProcessedPlannedJourney?
    private let deviceIdiom = UIDevice.current.userInterfaceIdiom
    
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
            let routeCoordinatesFromOrigin = getRouteCoordinatesFromOriginNoInterchange(plannedJourney: plannedJourney)
            
            
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

struct InterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourney?
    var processedPlannedJourney: ProcessedPlannedJourney?
    private let deviceIdiom = UIDevice.current.userInterfaceIdiom
    
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
            
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
                Text(plannedJourney!.interchangeStop!.stopName)
                Spacer()
            }
            
            
            HStack(spacing: 0) {
                ForEach(Array(processedPlannedJourney!.routeFromInterchangeUIColors.enumerated()), id: \.element) { index, routeColor in
                    if(index == 0){
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .center)
                            .padding(.leading, 15.5 - (2.5 * CGFloat(processedPlannedJourney!.routeFromInterchangeUIColors.count - 1)))
                        
                    } else {
                        Rectangle()
                            .foregroundColor(routeColor)
                            .frame(width: 5, height: 150, alignment: .leading)
                        
                    }
                }
                
                Spacer()
                VStack{
                    Text("Take the tram towards" + processedPlannedJourney!.formattedTerminiFromInterchange)
                        .padding(.leading, 15)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(processedPlannedJourney!.formattedStopsFromInterchangeTime)
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
            
            let routeCoordinatesFromOrigin = getRouteCoordinatesFromOriginToInterchange(plannedJourney: plannedJourney)
            let routeCoordinatesFromInterchange = getRouteCoordinatesFromInterchange(plannedJourney: plannedJourney)
            
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
            
            
            if deviceIdiom == .pad {
                MapView(
                    region: region,
                    lineCoordinatesFromOrigin: routeCoordinatesFromOrigin,
                    lineCoordinatesFromInterchange: routeCoordinatesFromInterchange,
                    lineColorFromOrigin: processedPlannedJourney!.routeFromOriginUIColors.first!,
                    lineColorFromInterchange: processedPlannedJourney!.routeFromInterchangeUIColors.first!)
                .aspectRatio(4/3, contentMode: .fill)
                .frame(maxHeight: 800)
                .cornerRadius(10)
                .padding([.top, .bottom])
            } else {
                MapView(
                    region: region,
                    lineCoordinatesFromOrigin: routeCoordinatesFromOrigin,
                    lineCoordinatesFromInterchange: routeCoordinatesFromInterchange,
                    lineColorFromOrigin: processedPlannedJourney!.routeFromOriginUIColors.first!,
                    lineColorFromInterchange: processedPlannedJourney!.routeFromInterchangeUIColors.first!)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .padding([.top, .bottom])
            }
            
            
            Spacer()
            
        }
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
