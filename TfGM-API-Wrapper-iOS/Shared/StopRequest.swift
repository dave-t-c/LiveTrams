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
            guard let url = URL(string: "https://dccompsci-tfgm-api-wrapper.azurewebsites.net/api/stops") else {
                print("Invalid url...")
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                let stops = try! JSONDecoder().decode([Stop].self, from: data!)
                DispatchQueue.main.async {
                    completion(stops)
                }
            }.resume()
            
        }
}
