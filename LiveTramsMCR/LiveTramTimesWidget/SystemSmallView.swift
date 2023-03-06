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
        let orderedServices = ServicesHelper().getDestinationsAsOrderedDict(destinations: self.formattedServices.destinations, limit: destinationsToShow)
        Spacer()
        ForEach(orderedServices.keys, id: \.self) { stopName in
            let trams: [Tram] = formattedServices.destinations[stopName]!
            let tramTimes = trams.map {$0.wait}
            let formattedTramTimes = tramTimes.joined(separator: ", ") + " mins"
            VStack {
                Text(stopName)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Text(formattedTramTimes)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
            }
            Spacer()
        }
        if(self.formattedServices.destinations.isEmpty)
        {
            Text("No service information available")
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Spacer()
        }
    }
}
