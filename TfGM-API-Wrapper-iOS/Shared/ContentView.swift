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
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            
            List {
                ForEach(searchResults.sorted { $0.stopName < $1.stopName }) { stop in
                    StopCell(stop: stop)
                }
                
                HStack{
                    Spacer()
                    Text("\(searchResults.count) Stops Found")
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
            }
            .searchable(text: $searchText)
            .navigationTitle("Stops")
            .onAppear() {
                StopRequest().requestStops { (stops) in
                    self.stops = stops
                }
            }
        }
    }
    
    var searchResults: [Stop] {
        if searchText.isEmpty {
            return stops
        } else {
            return stops.filter { $0.stopName.contains(searchText)}
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(stops: testData)
    }
}



