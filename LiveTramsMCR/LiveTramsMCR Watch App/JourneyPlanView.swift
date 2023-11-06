//
//  JourneyPlanView.swift
//  LiveTramsMCR Watch App
//
//  Created by David Cook on 19/02/2023.
//

import SwiftUI

struct JourneyPlanView: View {
    
    var initialOrigin: String =  ""
    var stops: [String] = []
    
    @State private var originStop: String = ""
    
    @State private var destinationStop: String = ""
    @State private var plannedJourneyResponse: PlannedJourneyV2Response?
    @State private var processedPlannedJourney: ProcessedPlannedJourneyV2?
    @State private var journeyPlannerRequest = JourneyPlannerV2Request()
    
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
                        Spacer()
                        Image(systemName: "arrow.triangle.swap")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                let temp = destinationStop
                                destinationStop = originStop
                                originStop = temp
                            }
                    }
                    .listRowBackground(Color.clear)
                
                Picker("Destination", selection: $destinationStop){
                    Text("Select Stop").tag("")
                    ForEach(availableDestinationStops, id: \.self) { stop in
                        Text(stop).tag(stop)
                    }
                }
                
            }
            Section{
                HStack{
                    Spacer()
                    Button(action: {
                        Task {
                            plannedJourneyResponse = try! await journeyPlannerRequest.planJourney(originName: originStop, destinationName: destinationStop)
                            if(plannedJourneyResponse == nil){
                                return
                            }
                            processedPlannedJourney = ProcessedPlannedJourneyV2(plannedJourney: plannedJourneyResponse!)
                        }
                    }) {
                        Label("Plan Journey", systemImage: "tram.fill")
                    }
                    .padding()
                    Spacer()
                }
            }
            
            
            if(plannedJourneyResponse != nil)
            {
                
                Text(processedPlannedJourney!.formattedTime)
                    .font(.title3)
        
                if (plannedJourneyResponse!.plannedJourney.requiresInterchange){
                    InterchangeJourneyView(plannedJourney: plannedJourneyResponse?.plannedJourney, processedPlannedJourney: processedPlannedJourney)
                }
                else{
                    NonInterchangeJourneyView(plannedJourney: plannedJourneyResponse?.plannedJourney, processedPlannedJourney: processedPlannedJourney)
                }
                
            }
        }
        .navigationTitle("Journey Planner")
    }
}

struct NonInterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourneyV2?
    var processedPlannedJourney: ProcessedPlannedJourneyV2?
    
    
    var body: some View {
        Section {
            VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                Text("Start: \(processedPlannedJourney!.plannedJourney.plannedJourney.originStop.stopName)")
                    .font(.title3)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                ForEach(Array(processedPlannedJourney!.routeFromOriginUIColors.enumerated()), id: \.element) { index, routeColor in
                    if(index == 0){
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(routeColor)
                            .frame(height: 10, alignment: .center)
                        
                    } else {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(routeColor)
                            .frame(height: 10, alignment: .center)
                        
                    }
                }
                
                Spacer()
                VStack{
                    Text("Take the tram towards" + processedPlannedJourney!.formattedTerminiFromOrigin)
                        .font(.title3)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(processedPlannedJourney!.formattedStopsFromOriginTime)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
        }
            
        Section {
            VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                Text("Exit at \(processedPlannedJourney!.plannedJourney.plannedJourney.destinationStop.stopName)")
                    .font(.title3)
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                let stopsFromOrigin = processedPlannedJourney!.plannedJourney.plannedJourney.stopsFromOrigin
                if(stopsFromOrigin.count > 0)
                {
                    Text("After \(stopsFromOrigin.last!.stopName)")
                        .fixedSize(horizontal: false, vertical: true)
                    
                }
            }
        }
        
    }
}

struct InterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourneyV2?
    var processedPlannedJourney: ProcessedPlannedJourneyV2?
    
    
    var body: some View {
            
            Section {
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    Text("Start: \(processedPlannedJourney!.plannedJourney.plannedJourney.originStop.stopName)")
                    .font(.title3)
                    .padding(.trailing, 10)
                    .padding(.bottom, 10)
                ForEach(Array(processedPlannedJourney!.routeFromOriginUIColors.enumerated()), id: \.element) { index, routeColor in
                    if(index == 0){
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(routeColor)
                            .frame(height: 10, alignment: .center)
                        
                    } else {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(routeColor)
                            .frame(height: 10, alignment: .center)
                        
                    }
                }
                
                Spacer()
                VStack{
                    Text("Take the tram towards" + processedPlannedJourney!.formattedTerminiFromOrigin)
                        .font(.title3)
                        .padding(.trailing, 10)
                        .padding(.bottom, 10)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(processedPlannedJourney!.formattedStopsFromOriginTime)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            
            Section {
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    Text("Change at \(processedPlannedJourney!.plannedJourney.plannedJourney.interchangeStop!.stopName)")
                        .font(.title3)
                    let stopsFromOrigin = processedPlannedJourney!.plannedJourney.plannedJourney.stopsFromOrigin
                    if(stopsFromOrigin.count > 0)
                    {
                        Text("After \(stopsFromOrigin.last!.stopName)")
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                        
                    }
                }
            }
            
            Section {
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    ForEach(Array(processedPlannedJourney!.routeFromInterchangeUIColors.enumerated()), id: \.element) { index, routeColor in
                        if(index == 0){
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(routeColor)
                                .frame(height: 10, alignment: .center)
                                .padding(.top, 10)
                            
                        } else {
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(routeColor)
                                .frame(height: 10, alignment: .center)
                            
                        }
                    }
                    
                    Spacer()
                    VStack{
                        Text("Take the tram towards" + processedPlannedJourney!.formattedTerminiFromInterchange)
                            .font(.title3)
                            .padding(.trailing, 10)
                            .padding(.bottom, 10)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(processedPlannedJourney!.formattedStopsFromInterchangeTime)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                }
            }
                
            Section {
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    Text("Exit at \(processedPlannedJourney!.plannedJourney.plannedJourney.destinationStop.stopName)")
                        .font(.title3)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                    let stopsFromInterchange = processedPlannedJourney!.plannedJourney.plannedJourney.stopsFromInterchange
                    if(stopsFromInterchange!.count > 0)
                    {
                        Text("After \(stopsFromInterchange!.last!.stopName)")
                            .fixedSize(horizontal: false, vertical: true)
                        
                    }
                }
            }
        }
    
    }
}
