//
//  RouteV2Request.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 30/05/2023.
//

import Foundation
class RouteV2Request: ObservableObject {
    @Published var routes = [RouteV2]()
    
    func requestRoutesV2(completion:@escaping ([RouteV2]) -> ()) {
        guard let url = URL(string: "https://api.sandbox.livetramsmcr.com/v2/routes") else {
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
                var routes: [RouteV2] = []
                do {
                    if data != nil {
                        routes = try JSONDecoder().decode([RouteV2].self, from: data!)
                    }
                    completion(routes)
                }
                catch {
                    completion(routes)
                }
            }
        }.resume()
        
    }
}
