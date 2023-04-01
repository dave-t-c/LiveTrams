//
//  ServicesRequest.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 24/04/2022.
//

import Foundation
import OrderedCollections

class ServicesRequest: ObservableObject {
    @Published var services = FormattedServices(destinations: [:], messages: [])
    
    func requestServices(tlaref: String) async throws ->  FormattedServices {
        guard let url = URL(string: "https://api.livetramsmcr.com/v1/services/\(tlaref)") else {
            print("Invalid url...")
            return FormattedServices(destinations: [:], messages: [])
        }
        var data: Data
        var response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200{
                    return FormattedServices(destinations: [:], messages: [])
                }
            }
        }
        catch {
            return FormattedServices(destinations: [:], messages: [])
        }
        
        var formattedServices = FormattedServices(destinations: [:], messages: [])
        do {
            formattedServices = try JSONDecoder().decode(FormattedServices.self, from: data)
            
            return formattedServices
        }
        catch {
            print("Error: \(error)")
            return formattedServices
        }
        
    }
    
    func requestDepartureBoardServices(tlaref: String) async throws ->  DepartureBoardServices {
        guard let url = URL(string: "https://api.livetramsmcr.com/v1/services/departure-boards/\(tlaref)") else {
            print("Invalid url...")
            return DepartureBoardServices(trams: [], messages: [])
        }
        var data: Data
        var response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200{
                    return DepartureBoardServices(trams: [], messages: [])
                }
            }
        }
        catch {
            return DepartureBoardServices(trams: [], messages: [])
        }
        
        var departureBoardServices = DepartureBoardServices(trams: [], messages: [])
        do {
            departureBoardServices = try JSONDecoder().decode(DepartureBoardServices.self, from: data)
            
            return departureBoardServices
        }
        catch {
            print("Error: \(error)")
            return departureBoardServices
        }
        
    }
}
