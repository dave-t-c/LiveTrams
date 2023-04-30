//
//  ServiceInformationView.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/04/2023.
//

import Foundation
import SwiftUI

struct ServiceInformationView: View {
    var serviceInformation: [FormattedServices]
    
    var body: some View {
        
        let distinctMessages = getDistinctMessages(serviceInformation: serviceInformation)
        if !distinctMessages.isEmpty {
            VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                Text("Service updates for your journey:")
                    .font(.headline)
                    .padding(.top, 10)
                
                ForEach(distinctMessages, id: \.self) { message in
                    Text(message)
                        .padding(.top, 10)
                }
            }
            .padding(.bottom, 0)
        }
    }
    
    func getDistinctMessages(serviceInformation: [FormattedServices]) -> [String] {
        var combinedMessages: [String] = []
        
        for information in serviceInformation {
            combinedMessages.append(contentsOf: information.messages)
        }
        
        return Array(Set(combinedMessages))
    }
}


