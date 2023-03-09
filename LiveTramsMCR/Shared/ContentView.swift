//
//  ContentView.swift
//  Shared
//
//  Created by David Cook on 22/04/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var searchText = ""
    @State private var stops: [Stop] = []
    
    @StateObject private var favouritesStore = FavouriteStopStore()
    @StateObject private var stopViewModel = StopViewModel()
    
    var body: some View {
        NavigationView {
            
            ScrollViewReader { scrollView in
                List {
                    if (!favouritesStore.stops.isEmpty && searchText.isEmpty)
                    {
                        Section(header: Text("Favourites")){
                            ForEach(favouritesStore.stops.sorted {$0.stopName < $1.stopName}) { stop in
                                NavigationLink(destination: StopDetail(stop: stop, stops: self.stops).environmentObject(favouritesStore)) {
                                    VStack(alignment: .leading) {
                                        Text(stop.stopName)
                                        Text(stop.street)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("All Stops")){
                        ForEach(searchResults) { stop in
                            NavigationLink(destination: StopDetail(stop: stop, stops: self.stops).environmentObject(favouritesStore), tag: stop.tlaref, selection: $stopViewModel.currentStopTlaref) {
                                VStack(alignment: .leading) {
                                    Text(stop.stopName)
                                    Text(stop.street)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }.id((stop.tlaref))
                        }
                        
                        if (self.stops.count == 0){
                            HStack{
                                Spacer()
                                Text("Service information is currently unavailable")
                                Spacer()
                            }
                        }
                        
                        HStack{
                            Spacer()
                            Text("\(searchResults.count) Stops Found")
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text("Contains Transport for Greater Manchester data")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                            Spacer()
                        }
                    }
                    .onOpenURL { url in
                        guard let url = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                            return
                        }
                        
                        if (url.scheme != "livetramsmcr") {
                            return
                        }
                        
                        if (url.host != "services")
                        {
                            return
                        }
                        
                        // Take the first char off as this will be '/'
                        if (url.path.isEmpty)
                        {
                            return
                        }
                        
                        let pathTlaref = String(url.path.dropFirst())
                        scrollView.scrollTo(pathTlaref)
                        self.stopViewModel.currentStopTlaref = pathTlaref
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Stops")
            .onAppear() {
                
                FavouriteStopStore.load { result in
                    switch result {
                    case .failure(let error):
                        fatalError(error.localizedDescription)
                    case .success(let stops):
                        favouritesStore.stops = stops
                    }
                    
                }
                
                StopRequest().requestStops { (stops) in
                    self.stops = stops
                }
                
                
            }
            .refreshable {
                StopRequest().requestStops { (stops) in
                    self.stops = stops
                }
            }
        }
    }
    
    var searchResults: [Stop] {
        if searchText.isEmpty {
            return self.stops
        } else {
            return self.stops.filter { $0.stopName.contains(searchText)}
        }
    }
    
}


