//
//  StopDetail.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import SwiftUI
import MapKit

struct StopDetail: View {
    
    var stop: Stop
    var stops: [Stop]
    var routes: [RouteV2]
    var stopRoutes: [RouteV2]
    var region: MKCoordinateRegion
    @State private var mapManager = MapManager()
    
    @EnvironmentObject var favouritesStore: FavouriteStopStore
    
    
    init(selectedStop: Stop, stopList: [Stop], routes: [RouteV2]) {
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
        self.stop = selectedStop
        self.stops = stopList
        self.routes = routes.reversed()
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        
        if (selectedStop.routes == nil || selectedStop.routes!.isEmpty) {
            self.stopRoutes = routes
            return
        }
        
        let stopRouteNames = selectedStop.routes!.map {$0.name}
        
        self.stopRoutes = routes.filter {stopRouteNames.contains($0.name)}.reversed()
        
        
        
    }
    
    @ViewBuilder
    var body: some View {
        GeometryReader { geometry in
            
            List {
                Section {
                    if (stop.routes != nil) {
                        let routeColors = GetRouteColors(stop: stop)
                        HStack{
                            
                            ForEach(routeColors, id: \.self) {color in
                                RoundedRectangle(cornerRadius: 25, style: .continuous)
                                    .fill(color)
                                    .frame(height: 10)
                                
                            }
                            Spacer()
                        }
                    }
                    
                    switch UIDevice.current.userInterfaceIdiom {
                    case .pad :
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: stop.latitude, longitude: stop.longitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))))
                            .frame(width: geometry.size.width * 0.95, height: geometry.size.height / 2)
                            .cornerRadius(10)
                        
                        
                    default:
                        StopDetailMap(region: self.region, routes: self.stopRoutes, stop: stop)
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(10)
                        
                    }
                }
                .listRowBackground(Color.clear)
                
                Section{
                    NavigationLink (destination: ServicesView(stop: stop)) {
                        Label("View Live Departures", systemImage: "clock.fill")
                            .padding()
                    }
                }
                
                Section{
                    NavigationLink (destination: JourneyPlanView(initialOrigin: stop.stopName, stops: stops.lazy.map { ($0.stopName)})) {
                        Label("Plan Journey", systemImage: "map.fill")
                            .padding()
                    }
                }
                
                
                Button {
                    mapManager.openMapsFromStop(stop: stop)
                } label: {
                    Label("Open in Maps", systemImage: "arrow.turn.up.right")
                }
                .padding()
                
                Label(stop.street, systemImage: "car")
                    .padding()
                Label("Stop Zone: \(stop.stopZone)", systemImage: "tram")
                    .padding()
                
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
}
private func GetRouteColors(stop: Stop) -> [Color] {
    if stop.routes == nil {
        return []
    }
    var routeColors: [Color] = []
    for route in stop.routes! {
        routeColors.append(hexStringToUIColor(hex: route.colour))
    }
    return routeColors
}

private func hexStringToUIColor (hex:String) -> Color {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return Color.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return Color(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0
    )
}
