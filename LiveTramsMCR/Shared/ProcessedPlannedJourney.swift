//
//  ProcessedPlannedJourney.swift
//  LiveTramsMCR
//
//  Created by David Cook on 15/10/2022.
//

import Foundation
import UIKit
import SwiftUI


class ProcessedPlannedJourney {
    var plannedJourney: PlannedJourney
    var formattedTerminiFromOrigin: String = ""
    var routeFromOriginUIColors: [Color] = []
    
    
    init(plannedJourney: PlannedJourney) {
        self.plannedJourney = plannedJourney
        self.formattedTerminiFromOrigin = generateTerminiFromOrigin()
        self.routeFromOriginUIColors = identifyRouteUIColors(routeHexColors: plannedJourney.routesFromOrigin.map {$0.colour})
    }
    
    private func identifyRouteUIColors(routeHexColors: [String]) -> [Color] {
        var createdUIColors: [Color] = []
        for hexColor in routeHexColors{
            createdUIColors.append(hexStringToUIColor(hex: hexColor))
        }
        return createdUIColors
    }
    
    private func generateTerminiFromOrigin() -> String {
        var formattedTerminiFromOrigin: String = ""
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
        
        return formattedTerminiFromOrigin
    }
    
    private func hexStringToUIColor (hex:String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return Color.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return Color(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0
        )
    }
}
