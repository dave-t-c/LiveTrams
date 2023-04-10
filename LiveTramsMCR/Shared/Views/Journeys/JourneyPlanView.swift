//
//  JourneyPlanView.swift
//  LiveTramsMCR
//
//  Created by David Cook on 13/10/2022.
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
    @State private var gettingJourneyRequest: Bool = false
    
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
                            plannedJourney = try await journeyPlannerRequest.planJourney(originName: originStop, destinationName: destinationStop)
                            if(plannedJourney == nil){
                                return
                            }
                            gettingJourneyRequest = false
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
            
            if(plannedJourney != nil)
            {
                Text(processedPlannedJourney!.formattedTime).font(.headline)
                
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
                Text(plannedJourney!.destinationStop.stopName)
                Spacer()
            }
        }
    }
}

struct InterchangeJourneyView: View {
    
    var plannedJourney: PlannedJourney?
    var processedPlannedJourney: ProcessedPlannedJourney?
    
    
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
        }
    }
}
