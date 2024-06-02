//
//  JourneyPlannerV2Request.swift
//  LiveTramsMCR
//
//  Created by David Cook on 06/10/2023.
//

import Foundation

class JourneyPlannerV2Request: ObservableObject {
    @Published var plannedJourneyV2: PlannedJourneyV2Response?
    
    func planJourney(originName: String, destinationName: String) async throws -> PlannedJourneyV2Response? {
        let escapedOriginName = originName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let escapedDestinationName = destinationName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        guard let url = URL(string: "https://api.production.livetramsmcr.com/v2/journey-planner/\(escapedOriginName!)/\(escapedDestinationName!)") else {
            print("Invalid url...")
            return plannedJourneyV2
        }
        var data: Data
        var response: URLResponse
        var plannedJourneyV2: PlannedJourneyV2Response?
        do {
            (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200{
                    return plannedJourneyV2
                }
            }
            plannedJourneyV2 = try JSONDecoder().decode(PlannedJourneyV2Response.self, from: data)
            
            return plannedJourneyV2
        }
        catch {
            return plannedJourneyV2
        }
    }
}

