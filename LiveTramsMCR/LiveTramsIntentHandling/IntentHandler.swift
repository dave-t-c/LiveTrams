//
//  IntentHandler.swift
//  LiveTramsIntentHandling
//
//  Created by David Cook on 04/03/2023.
//

import Intents

class IntentHandler: INExtension, LiveTramStopSelectionIntentHandling {
    func provideStopOptionsCollection(for intent: LiveTramStopSelectionIntent, with completion: @escaping (INObjectCollection<StopSelection>?, Error?) -> Void) {
        
        Task {
            do {
                // Get all stops
                let stops: [Stop] = try await StopRequest().requestStopsAsync()
                
                // Use identifier as tlaref, e.g. ALT
                // Use display as stop name
                let createdStops: [StopSelection] = stops.map { stop in
                    StopSelection(identifier: stop.tlaref, display: stop.stopName)
                }
                
                let createdStopsCollection = INObjectCollection(items: createdStops)
                completion(createdStopsCollection, nil)
            }
            catch {
                completion(nil, nil)
            }
            
        }
        
    }
    
    
    func provideStopOptionsCollection(for intent: LiveTramStopSelectionIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<StopSelection>?, Error?) -> Void) {
        
        Task {
            do {
                // Get all stops
                let stops: [Stop] = try await StopRequest().requestStopsAsync()
                
                // Use identifier as tlaref, e.g. ALT
                // Use display as stop name
                var filteredStops: [Stop] = stops
                
                if (searchTerm != nil)
                {
                    filteredStops = stops.filter { $0.stopName.contains(searchTerm!) }
                }
                
                let createdStops: [StopSelection] = filteredStops.map { stop in
                    return  StopSelection(identifier: stop.tlaref, display: stop.stopName)
                }
                
                let createdStopsCollection = INObjectCollection(items: createdStops)
                completion(createdStopsCollection, nil)
            }
            catch {
                completion(nil, nil)
            }
        }
        
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
