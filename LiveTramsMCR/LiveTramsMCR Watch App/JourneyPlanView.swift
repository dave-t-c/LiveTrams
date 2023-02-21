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
    @State private var plannedJourney: PlannedJourney?
    @State private var processedPlannedJourney: ProcessedPlannedJourney?
    @State private var journeyPlannerRequest = JourneyPlannerRequest()
    
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
                            plannedJourney = try! await journeyPlannerRequest.planJourney(originName: originStop, destinationName: destinationStop)
                            if(plannedJourney == nil){
                                return
                            }
                            processedPlannedJourney = ProcessedPlannedJourney(plannedJourney: plannedJourney!)
                        }
                    }) {
                        Label("Plan Journey", systemImage: "tram.fill")
                    }
                    .padding()
                    Spacer()
                }
            }
            
            
            if(plannedJourney != nil)
            {
                
                Text(processedPlannedJourney!.formattedTime)
                    .font(.title3)
        
                if (plannedJourney!.requiresInterchange){
                    InterchangeJourneyView(plannedJourney: plannedJourney, processedPlannedJourney: processedPlannedJourney)
                }
                else{
                    NonInterchangeJourneyView(plannedJourney: plannedJourney, processedPlannedJourney: processedPlannedJourney)
                }
                
            }
        }
        .navigationTitle("Journey Planner")
    }
}

struct NonInterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourney?
    var processedPlannedJourney: ProcessedPlannedJourney?
    
    
    var body: some View {
        Section {
            VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                Text("Start: \(processedPlannedJourney!.plannedJourney.originStop.stopName)")
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
                Text("Exit at \(processedPlannedJourney!.plannedJourney.destinationStop.stopName)")
                    .font(.title3)
                    .padding(.top, 10)
                    .padding(.trailing, 10)
                let stopsFromOrigin = processedPlannedJourney!.plannedJourney.stopsFromOrigin
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
    
    var plannedJourney: PlannedJourney?
    var processedPlannedJourney: ProcessedPlannedJourney?
    
    
    var body: some View {
            
            Section {
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                Text("Start: \(processedPlannedJourney!.plannedJourney.originStop.stopName)")
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
                    Text("Change at \(processedPlannedJourney!.plannedJourney.interchangeStop!.stopName)")
                        .font(.title3)
                    let stopsFromOrigin = processedPlannedJourney!.plannedJourney.stopsFromOrigin
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
                    Text("Exit at \(processedPlannedJourney!.plannedJourney.destinationStop.stopName)")
                        .font(.title3)
                        .padding(.top, 10)
                        .padding(.trailing, 10)
                    let stopsFromInterchange = processedPlannedJourney!.plannedJourney.stopsFromInterchange
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
