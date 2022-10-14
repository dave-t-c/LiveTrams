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
    
    var body: some View {
        List {
            Section{
                VStack{
                    Picker("Origin", selection: $originStop){
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
                }
                
            }
            Section{
              
            }
        }
        .navigationTitle("Journey Planner")
        .edgesIgnoringSafeArea(.bottom)
        .padding(.all)
        .onAppear{
            
        }
    }
}
