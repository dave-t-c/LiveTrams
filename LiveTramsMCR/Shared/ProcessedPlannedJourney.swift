//
//  ProcessedPlannedJourney.swift
//  LiveTramsMCR
//
//  Created by David Cook on 15/10/2022.
//

import Foundation


class ProcessedPlannedJourney {
    var plannedJourney: PlannedJourney
    var formattedTerminiFromOrigin: String = ""
    
    
    init(plannedJourney: PlannedJourney) {
        self.plannedJourney = plannedJourney
        
        if plannedJourney.terminiFromOrigin.count == 1 {
            formattedTerminiFromOrigin += " " + plannedJourney.terminiFromOrigin[0].stopName
        }
        else {
            for (index, stop) in plannedJourney.terminiFromOrigin.enumerated() {
                if(index == plannedJourney.terminiFromOrigin.endIndex - 2)
                {
                    formattedTerminiFromOrigin += " " + stop.stopName
                }
                else if(index == plannedJourney.terminiFromOrigin.endIndex - 1)
                {
                    formattedTerminiFromOrigin += " or " + stop.stopName + "."
                }
                else{
                    formattedTerminiFromOrigin += " " + stop.stopName + ","
                }
                
                
            }
        }
        
    }
    
    
}
