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
    
    @State private var originInput: String = ""
    @State private var destinationInput: String = ""
    
    @State private var suggestions: [String] = ["Piccadilly", "Navigation Road", "Victoria", "A", "A", "A"]
    
    @State private var filteredStops: [Stop] = []
    
    var body: some View {
        List {
            Section{
                VStack{
                    Picker("Origin", selection: $originInput){
                        ForEach(stops, id: \.self) { stop in
                            Text(stop.stopName).tag(stop.tlaref)
                        }
                    }
                    
                    HStack{
                        Spacer()
                        Image(systemName: "arrow.triangle.swap")
                            .imageScale(.large)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                let temp = destinationInput
                                destinationInput = originInput
                                originInput = temp
                            }
                    }
                    Picker("Destination", selection: $destinationInput){
                        ForEach(stops, id: \.self) { stop in
                            Text(stop.stopName).tag(stop.tlaref)
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
            originInput = initialOrigin.stopName
        }
    }
}
