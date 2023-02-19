//
//  JourneyPlannerRequest.swift
//  LiveTramsMCR
//
//  Created by David Cook on 14/10/2022.
//

import Foundation

class JourneyPlannerRequest: ObservableObject {
    @Published var plannedJourney: PlannedJourney?
    
    func planJourney(originName: String, destinationName: String) async throws -> PlannedJourney? {
        let escapedOriginName = originName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let escapedDestinationName = destinationName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let url = URL(string: "https://livetramsmcr-apim.azure-api.net/api/journey-planner/\(escapedOriginName!)/\(escapedDestinationName!)") else {
            print("Invalid url...")
            return plannedJourney
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200{
                return plannedJourney
            }
        }
        return try! JSONDecoder().decode(PlannedJourney.self, from: data)
    }
}
