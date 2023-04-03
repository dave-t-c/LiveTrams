//
//  ContentView.swift
//  Shared
//
//  Created by David Cook on 22/04/2022.
//

import SwiftUI
import CoreData

struct Home: View {
    @State private var searchText = ""
    @State private var stops: [Stop] = []
    
    @StateObject private var favouritesStore = FavouriteStopStore()
    @StateObject private var stopViewModel = StopViewModel()
    
    var body: some View {
        NavigationSplitView {
            
            ScrollViewReader { scrollView in
                List (selection: $stopViewModel.currentStopTlaref) {
                    if (!favouritesStore.stops.isEmpty && searchText.isEmpty)
                    {
                        Section(header: Text("Favourites")){
                            ForEach(favouritesStore.stops.sorted {$0.stopName < $1.stopName}) { stop in
                                NavigationLink(stop.stopName, value: stop.tlaref)
                            }
                        }
                    }
                    
                    Section(header: Text("All Stops")){
                        ForEach(searchResults) { stop in
                            NavigationLink(stop.stopName, value: stop.tlaref)
                                .id(stop.tlaref)
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
                        
                        self.searchText = ""
                        self.stopViewModel.currentStopTlaref = nil
                        
                        Task {
                            do {
                                if (stops.isEmpty)
                                {
                                    let duration = UInt64(1.5 * 1_000_000_000)
                                    try await Task.sleep(nanoseconds: duration)
                                    
                                    if (stops.isEmpty) {
                                        return
                                    }
                                    
                                }
                                
                                let pathTlaref = String(url.path.dropFirst())
                                scrollView.scrollTo(pathTlaref)
                                

                                let duration = UInt64(1 * 1_000_000_000)
                                try await Task.sleep(nanoseconds: duration)
                                
                                
                                self.stopViewModel.currentStopTlaref = pathTlaref
                            }
                            
                            catch {
                                return
                            }
                        }
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
        } detail: {
            if let selectedTlaref = stopViewModel.currentStopTlaref {
                if let stop = self.stops.first(where: {$0.tlaref == selectedTlaref}) {
                    StopDetail(selectedStop: stop, stopList: self.stops)
                        .environmentObject(favouritesStore)
                }
                
            } else {
                Text("No Stop selected")
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


