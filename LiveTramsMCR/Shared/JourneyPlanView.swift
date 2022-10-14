//
//  JourneyPlanView.swift
//  LiveTramsMCR
//
//  Created by David Cook on 13/10/2022.
//

import SwiftUI

struct JourneyPlanView: View {
    
    var initialOrigin: Stop
    var stops: [Stop]
    
    @State private var originStop: Stop?
    @State private var destinationStop: Stop?
    @State private var plannedJourney: PlannedJourney?
    @State private var journeyPlannerRequest = JourneyPlannerRequest()
    
    var body: some View {
        List {
            Section{
                
                VStack{
                    Picker("Origin", selection: $originStop){
                        Text("Select Stop").tag(Optional<String>(nil))
                        ForEach(stops, id: \.self) { stop in
                            Text(stop.stopName).tag(stop as Stop?)
                        }
                    }
                    .onAppear {
                        originStop = initialOrigin
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
                    Picker("Destination", selection: $destinationStop){
                        ForEach(stops, id: \.self) { stop in
                            Text(stop.stopName).tag(stop as Stop?)
                        }
                    }
                    .onAppear {
                        destinationStop = stops[0]
                    }
                }
                
            }
            Section{
                HStack{
                    Spacer()
                    Button(action: {
                        Task {
                            plannedJourney = try! await journeyPlannerRequest
                                .planJourney(originTlaref: originStop!.tlaref, destinationTlaref: destinationStop!.tlaref)
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
                if (plannedJourney!.requiresInterchange){
                    
                }
                else{
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
                        HStack {
                            Rectangle()
                                .fill(.purple)
                                .frame(width: 5, height: 100, alignment: .center)
                                .padding(.leading, 15.5)
                            Text("Take the tram towards " + plannedJourney!.terminiFromOrigin[0].stopName).padding(.leading, 15)
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
        }
        .navigationTitle("Journey Planner")
        .edgesIgnoringSafeArea(.bottom)
        .padding(.all)
        .onAppear{
            
        }
    }
}
