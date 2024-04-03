//
//  StopDetail.swift
//  LiveTramsMCR Watch App
//
//  Created by David Cook on 16/02/2023.
//

import MapKit
import SwiftUI

struct StopDetail: View {
    
    var stop: Stop
    var stops: [Stop]
    @State private var mapManager = MapManagerWatchOS()
    
    @EnvironmentObject var favouritesStore: FavouriteStopStore
    
    var body: some View {
        List {
                           
            Section{
                if (stop.routes != nil) {
                    let routeColors = GetRouteColors(stop: stop)
                    HStack{
                        
                        ForEach(routeColors, id: \.self) {color in
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(color)
                                .frame(height: 10)
                                .padding(.bottom, .zero)
                            
                        }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                
                NavigationLink (destination: ServicesView(stop: stop)) {
                    Label("View Live Departures", systemImage: "clock.fill")
                        .padding()
                }
                
                NavigationLink (destination: JourneyPlanView(initialOrigin: stop.stopName, stops: stops)) {
                    Label("Plan Journey", systemImage: "map.fill")
                        .padding()
                }
            }
            .padding(.top, 0)
            
            Section{
                Button {
                    mapManager.openMapsFromStop(stop: stop)
                } label: {
                    Label("Open in Maps", systemImage: "arrow.turn.up.right")
                }
                .padding()

                Label("Stop Zone: \(stop.stopZone)", systemImage: "tram")
                    .padding()
            }

            Section{
                if favouritesStore.stops.contains(self.stop) {
                    Button(action: {
                        // Remove stop from favourites
                        
                        favouritesStore.stops.removeAll {$0 == self.stop}
                        FavouriteStopStore.save(favouriteStops: favouritesStore.stops) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                        
                        
                    }) {
                        Label("Remove from favourites", systemImage: "star.slash")
                            .foregroundColor(.red)
                    }
                    .padding()
                    
                } else {
                    Button(action: {
                        // Adds the stop to favourites
                        favouritesStore.stops.append(self.stop)
                        FavouriteStopStore.save(favouriteStops: favouritesStore.stops) { result in
                            if case .failure(let error) = result {
                                fatalError(error.localizedDescription)
                            }
                        }
                    }) {
                        Label("Add to favourites", systemImage: "star.fill")
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(stop.stopName)
    }
}
