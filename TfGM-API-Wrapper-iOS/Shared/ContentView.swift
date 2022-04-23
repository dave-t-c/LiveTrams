//
//  ContentView.swift
//  Shared
//
//  Created by David Cook on 22/04/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var stops: [Stop] = []
    var body: some View {
        NavigationView {
            
            List {
                ForEach(stops.sorted { $0.stopName < $1.stopName }) { stop in
                    StopCell(stop: stop)
                }
                
                HStack{
                    Spacer()
                    Text("\(stops.count) Stops Found")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
            }
            .navigationTitle("Stops")
            .onAppear() {
                StopRequest().requestStops { (stops) in
                    self.stops = stops
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(stops: testData)
    }
}



