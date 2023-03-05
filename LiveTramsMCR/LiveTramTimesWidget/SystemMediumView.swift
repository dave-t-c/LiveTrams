//
//  SystemMediumView.swift
//  LiveTramTimesWidgetExtension
//
//  Created by David Cook on 05/03/2023.
//

import SwiftUI

struct SystemMediumView: View {
    var formattedServices: FormattedServices
    
    private let maxDestinationsToShow: Int = 4
    
    var body: some View {
        let destinationCount: Int = self.formattedServices.destinations.count
        let destinationsToShow: Int = destinationCount > maxDestinationsToShow ? maxDestinationsToShow : destinationCount
        
        let takenKeys = Array(self.formattedServices.destinations.keys).prefix(destinationsToShow)
        
        let filteredTrams = formattedServices.destinations.filter {takenKeys.contains($0.key)}
        
        let filteredServices = FormattedServices(destinations: filteredTrams, messages: self.formattedServices.messages)
        
        Spacer()
        ForEach(Array(filteredServices.destinations.keys), id: \.self) { dest in
            let trams: [Tram]? = filteredServices.destinations[dest]
            let tramTimes = trams?.map {$0.wait}
            let formattedTramTimes = tramTimes!.joined(separator: ", ") + " mins"
            HStack {
                Text(dest)
                    .font(.headline)
                    .fixedSize()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                
                Text(formattedTramTimes)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing)
            }
            Spacer()
            
            
        }
    }
}
