//
//  ServicesRequest.swift
//  TfGM-API-Wrapper-iOS
//
//  Created by David Cook on 24/04/2022.
//

import Foundation

class ServicesRequest: ObservableObject {
    @Published var services = FormattedServices(destinations: [:], messages: [])
    
    func requestServices(tlaref: String, completion:@escaping (FormattedServices) -> ()) {
            guard let url = URL(string: "https://dccompsci-tfgm-api-wrapper.azurewebsites.net/api/services/\(tlaref)") else {
                print("Invalid url...")
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                let services = try! JSONDecoder().decode(FormattedServices.self, from: data!)
                DispatchQueue.main.async {
                    completion(services)
                }
            }.resume()
            
        }
}
