//
//  ServicesHelper.swift
//  LiveTramsMCR
//
//  Created by David Cook on 05/03/2023.
//

import Foundation
import OrderedCollections

class ServicesHelper {
    public func getDestinationsAsOrderedDict(destinations: [String: [Tram]], limit: Int) -> OrderedDictionary<String, [Tram]> {
        
        let tupleArray: [(String, Int)] = destinations.map { (key: String, value: [Tram]) in
            return (key, Int(value.first!.wait)!)
        }
        var orderedDestinations: [(String, Int)] = tupleArray.sorted(by: {$0.1 < $1.1})
        orderedDestinations = Array(orderedDestinations.prefix(limit))
        
        var orderedDestinationsDict: OrderedDictionary<String, [Tram]> = OrderedDictionary()
        
        for entry in orderedDestinations {
            orderedDestinationsDict[entry.0] = destinations[entry.0]
        }
        return orderedDestinationsDict
    }
}
