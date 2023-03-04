//
//  StopRequest.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 23/04/2022.
//

import Foundation

class StopRequest: ObservableObject {
    @Published var stops = [Stop]()
    
    func requestStops(completion:@escaping ([Stop]) -> ()) {
        guard let url = URL(string: "https://api.livetramsmcr.com/v1/stops") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200{
                        return
                    }
                } 
                var stops: [Stop] = []
                do {
                    if data != nil {
                        stops = try JSONDecoder().decode([Stop].self, from: data!)
                    }
                    completion(stops)
                }
                catch {
                    completion(stops)
                }
            }
        }.resume()
        
    }
    
    func requestStopsAsync() async throws ->  [Stop] {
        guard let url = URL(string: "https://api.livetramsmcr.com/v1/stops") else {
            print("Invalid url...")
            return []
        }
        var data: Data
        var response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200{
                    return []
                }
            }
        }
        catch {
            return []
        }
        
        var stops: [Stop] = []
        do {
            stops = try JSONDecoder().decode([Stop].self, from: data)
            return stops
        }
        catch {
            return stops
        }
        
    }
}
