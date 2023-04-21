//
//  NearPublicTransport.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 24/04/2022.
//

import SwiftUI
import MapKit

struct NearPublicTransport: View {
    var stop: Stop
    @State private var categories = ["Bus Stops", "National Rail", "Cafes"]
    var body: some View {
        List{
            ForEach(categories, id: \.self) {
                category in
                GenericNearTransport(stop: stop, title: category, searchTerm: category)
            }
        }
        .navigationTitle("Nearby")
    }
}


struct GenericNearTransport: View {
    var stop: Stop
    var title: String
    var searchTerm: String
    @State private var mapManager = MapManager()
    @State private var identifiedLocationsDict: [MKMapItem: Double] = [:]
    @State private var sortedKeys: [MKMapItem] = []
    var body: some View {
        
        Section(header: Text(title)){
            ForEach(Array(sortedKeys), id: \.self) {
                location in
                HStack {
                    Button {
                        location.openInMaps()
                    } label: {
                        Text(location.name!)
                    }.buttonStyle(BorderlessButtonStyle())
                    Spacer()
                    Text("\(String(Int(identifiedLocationsDict[location]!)))m")
                }
                .padding()
            }
        }
        .headerProminence(.increased)
        
        .onAppear() {
            Task.init {
                let stopLocation = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
                if (!sortedKeys.isEmpty) {
                    return
                }
                let identifiedLocations = try await mapManager.searchLocalArea(stop: stop, searchTerm: searchTerm)
                for location in identifiedLocations {
                    self.identifiedLocationsDict[location] =  stopLocation.distance(from: location.placemark.location!).rounded()
                }
                self.sortedKeys = Array(identifiedLocationsDict.keys).sorted(by: { identifiedLocationsDict[$0]! < identifiedLocationsDict[$1]! })
            }
        }
    }
}


