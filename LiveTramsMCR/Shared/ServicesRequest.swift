//
//  ServicesRequest.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 24/04/2022.
//

import Foundation

class ServicesRequest: ObservableObject {
    @Published var services = FormattedServices(destinations: [:], messages: [])
    
    func requestServices(tlaref: String) async throws ->  FormattedServices {
        guard let url = URL(string: "https://api.livetramsmcr.com/api/services/\(tlaref)") else {
            print("Invalid url...")
            return FormattedServices(destinations: [:], messages: [])
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200{
                return FormattedServices(destinations: [:], messages: [])
            }
        }
        return try! JSONDecoder().decode(FormattedServices.self, from: data)
    }
}
