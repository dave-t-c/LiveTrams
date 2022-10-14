//
//  JourneyPlannerRequest.swift
//  LiveTramsMCR
//
//  Created by David Cook on 14/10/2022.
//

import Foundation

class JourneyPlannerRequest: ObservableObject {
    @Published var plannedJourney: PlannedJourney?
    
    func planJourney(originTlaref: String, destinationTlaref: String) async throws -> PlannedJourney? {
        guard let url = URL(string: "https://dccompsci-tfgm-api-wrapper.azurewebsites.net/api/journey-planner/\(originTlaref)/\(destinationTlaref)") else {
            print("Invalid url...")
            return plannedJourney
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200{
                return plannedJourney
            }
        }
        let _ = print(data)
        return try! JSONDecoder().decode(PlannedJourney.self, from: data)
    }
}
