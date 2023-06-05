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
    
    @StateObject private var favouritesStore = FavouriteStopStore()
    @StateObject private var stopViewModel = StopViewModel()
    
    var body: some View {
            NavigationView {
                
                ScrollViewReader { scrollView in
                    List {
                        if (searchText.isEmpty) {
                            Section(header: Text("Quick Links")) {
                                NavigationLink(destination: JourneyPlanView(initialOrigin: "", stops: self.stopViewModel.stops.map { $0.stopName })) {
                                    Label("Journey Planner", systemImage: "map.fill")
                                        .padding()
                                }
                            }
                        }
                        
                        if (!favouritesStore.stops.isEmpty && searchText.isEmpty)
                        {
                            Section(header: Text("Favourites")){
                                ForEach(favouritesStore.stops.sorted {$0.stopName < $1.stopName}) { stop in
                                    NavigationLink(destination: StopDetail(selectedStop: stop, stopList: self.stopViewModel.stops).environmentObject(favouritesStore)) {
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
                        
                        if (!self.stopViewModel.nearestStops.isEmpty && searchText.isEmpty)
                        {
                            Section(header: Text("Nearby")){
                                ForEach(self.stopViewModel.nearestStops) { stop in
                                    NavigationLink(destination: StopDetail(selectedStop: stop, stopList: self.stopViewModel.stops).environmentObject(favouritesStore)) {
                                        VStack(alignment: .leading) {
                                            Text(stop.stopName)
                                            let distanceString = self.stopViewModel.GetFormattedStopInformation(stop: stop)
                                            if (!distanceString.isEmpty)
                                            {
                                                Text(distanceString)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        Section(header: Text("All Stops")){
                            ForEach(searchResults) { stop in
                                NavigationLink(destination: StopDetail(selectedStop: stop, stopList: self.stopViewModel.stops).environmentObject(favouritesStore), tag: stop.tlaref, selection: $stopViewModel.currentStopTlaref) {
                                    VStack(alignment: .leading) {
                                        
                                        HStack {
                                            Text(stop.stopName)
                                            
                                            Text("Zone \(stop.stopZone)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                                .padding(.trailing, 5)
                                        }
                                        
                                        
                                        
                                        HStack {
                                            
                                            
                                            let routeColors = self.stopViewModel.GetRouteColors(stop: stop)
                                            ForEach(routeColors, id: \.self) {color in
                                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                                    .fill(color)
                                                    .frame(width: 20, height: 5)
                                                    .padding(.trailing, 2)
                                                
                                            }
                                            Spacer()
                                        }
                                        
                                    }
                                }.id((stop.tlaref))
                            }
                            
                            if (self.stopViewModel.stops.count == 0){
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
                                    if (self.stopViewModel.stops.isEmpty)
                                    {
                                        let duration = UInt64(1.5 * 1_000_000_000)
                                        try await Task.sleep(nanoseconds: duration)
                                        
                                        if (self.stopViewModel.stops.isEmpty) {
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
                        self.stopViewModel.stops = stops
                    }
                    
                    Task {
                        await self.stopViewModel.UpdateNearestStops()
                    }
                }
                .refreshable {
                    Task {
                        await self.stopViewModel.UpdateNearestStops()
                        
                        StopRequest().requestStops { (stops) in
                            self.stopViewModel.stops = stops
                        }
                    }
                }
                Text("No stop selected")
                    .font(.headline)
            }
    }
    
    var searchResults: [Stop] {
        if searchText.isEmpty {
            return self.stopViewModel.stops
        } else {
            return self.stopViewModel.stops.filter { $0.stopName.contains(searchText)}
        }
    }
    
}


