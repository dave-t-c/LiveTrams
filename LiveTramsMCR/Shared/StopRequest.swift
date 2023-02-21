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
                let stops = try! JSONDecoder().decode([Stop].self, from: data!)
                
                completion(stops)
            }
        }.resume()
        
    }
}
