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
        var destinationsToShow: Int = destinationCount > maxDestinationsToShow ? maxDestinationsToShow : destinationCount
        
        var takenKeys = Array(self.formattedServices.destinations.keys).prefix(destinationsToShow)
        
        let filteredTrams = formattedServices.destinations.filter {takenKeys.contains($0.key)}
        
        let filteredServices = FormattedServices(destinations: filteredTrams, messages: self.formattedServices.messages)
        
        ForEach(Array(filteredServices.destinations.keys), id: \.self) { dest in
            let trams: [Tram]? = filteredServices.destinations[dest]
            let tramTimes = trams?.map {$0.wait}
            let formattedTramTimes = tramTimes!.joined(separator: ", ") + " mins"
            VStack {
                Text(dest)
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
