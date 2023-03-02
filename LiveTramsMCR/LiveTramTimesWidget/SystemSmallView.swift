//
//  SystemSmallView.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 02/03/2023.
//

import SwiftUI

struct SystemSmallView: View {
    var formattedServices: FormattedServices
    
    var body: some View {
        ForEach(Array(self.formattedServices.destinations.keys), id: \.self) { dest in
            let trams: [Tram]? = self.formattedServices.destinations[dest]
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
