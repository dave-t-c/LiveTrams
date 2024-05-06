//
//  Home.swift
//  LiveTramsMCR Watch App
//
//  Created by David Cook on 16/02/2023.
//

import SwiftUI
import CoreData

struct Home: View {
    @State var stops: [Stop] = []
    @State private var searchText = ""
    
    @StateObject private var favouritesStore = FavouriteStopStore()
    
    var searchResults: [Stop] {
        if searchText.isEmpty {
            return stops
        } else {
            return stops.filter { $0.stopName.contains(searchText)}
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                
                if (!favouritesStore.stops.isEmpty && searchText.isEmpty)
                {
                    Section(header: Text("Favourites")){
                        ForEach(favouritesStore.stops.sorted {$0.stopName < $1.stopName}) { stop in
                            NavigationLink(destination: StopDetail(stop: stop, stops: stops).environmentObject(favouritesStore)) {
                                VStack(alignment: .leading) {
                                    Text(stop.stopName)
                                    Text(stop.street ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("All Stops"))
                {
                    ForEach(searchResults.sorted { $0.stopName < $1.stopName }) { stop in
                        NavigationLink(destination: StopDetail(stop: stop, stops: stops).environmentObject(favouritesStore)) {
                            VStack(alignment: .leading) {
                                Text(stop.stopName)
                                Text("Zone \(stop.stopZone)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                
                                HStack {
                                    let routeColors = GetRouteColors(stop: stop)
                                    ForEach(routeColors, id: \.self) {color in
                                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                                            .fill(color)
                                            .frame(width: 15, height: 5)
                                            .padding(.trailing, 2)
                                        
                                    }
                                    
                                }
                                Spacer()
                            }
                            
                            
                        }
                    }
                    
                    if (stops.count == 0){
                        HStack{
                            Spacer()
                            Text("Service information is currently unavailable")
                            Spacer()
                        }
                    }
                }
                
            }
            .searchable(text: $searchText)
            .navigationTitle("Stops")
            .onAppear(){
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
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

func GetRouteColors(stop: Stop) -> [Color] {
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
