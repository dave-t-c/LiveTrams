//
//  SystemSmallView.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 02/03/2023.
//

import SwiftUI

struct SystemSmallView: View {
    var formattedServices: FormattedServices
    
    private let maxDestinationsToShow: Int = 2
    
    var body: some View {
        let destinationCount: Int = self.formattedServices.destinations.count
        let destinationsToShow: Int = destinationCount > maxDestinationsToShow ? maxDestinationsToShow : destinationCount
        let filteredKeys = Array(formattedServices.destinations.keys.prefix(destinationsToShow))
        
        ForEach(filteredKeys, id: \.self) { stopName in
            let trams: [Tram] = formattedServices.destinations[stopName]!
            let tramTimes = trams.map {$0.wait}
            let formattedTramTimes = tramTimes.joined(separator: ", ") + " mins"
            VStack {
                Text(stopName)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .leading])
                Text(formattedTramTimes)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
            }
            Spacer()
            
        }
    }
}
