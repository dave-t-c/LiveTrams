//
//  StopView.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import SwiftUI
import Foundation

struct StopCell: View {
    @EnvironmentObject var favouritesStore: FavouriteStopStore
    
    var stop: Stop
    var body: some View {
        NavigationLink(destination: StopDetail(stop: stop).environmentObject(favouritesStore)) {
            VStack(alignment: .leading) {
                Text(stop.stopName)
                Text(stop.street)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}
