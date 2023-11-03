//
//  ProcessedPlannedJourneyV2.swift
//  LiveTramsMCR
//
//  Created by David Cook on 06/10/2023.
//

import Foundation
import UIKit
import SwiftUI


class ProcessedPlannedJourneyV2 {
    var plannedJourney: PlannedJourneyV2Response
    var formattedTerminiFromOrigin: String = ""
    var formattedTerminiFromInterchange: String = ""
    var routeFromOriginUIColors: [Color] = []
    var routeFromInterchangeUIColors: [Color] = []
    var stopsFromOriginCount: Int = 0
    var stopsFromInterchangeCount: Int = 0
    var formattedStopsFromOriginTime: String = ""
    var formattedStopsFromOrigin: String = ""
    var formattedStopsFromInterchange: String = ""
    var formattedStopsFromInterchangeTime: String = ""
    var formattedTime: String = ""
    
    init(plannedJourney: PlannedJourneyV2Response) {
        self.plannedJourney = plannedJourney
        let plannedJourneyData = plannedJourney.plannedJourney
        self.formattedTerminiFromOrigin = summariseTermini(termini: plannedJourneyData.terminiFromOrigin)
        self.routeFromOriginUIColors = identifyRouteUIColors(routeHexColors: plannedJourneyData.routesFromOrigin.map {$0.colour})
        self.stopsFromOriginCount = plannedJourneyData.stopsFromOrigin.count
        if self.stopsFromOriginCount == 1 {
            self.formattedStopsFromOrigin = "\(self.stopsFromOriginCount) stop"
        } else {
            self.formattedStopsFromOrigin = "\(self.stopsFromOriginCount) stops"
        }
        self.formattedStopsFromOriginTime = "\(self.formattedStopsFromOrigin), \(plannedJourneyData.minutesFromOrigin) mins"
        if plannedJourneyData.requiresInterchange {
            self.routeFromInterchangeUIColors = identifyRouteUIColors(routeHexColors: plannedJourneyData.routesFromInterchange!.map {$0.colour})
            self.formattedTerminiFromInterchange = summariseTermini(termini: plannedJourneyData.terminiFromInterchange!)
            self.stopsFromInterchangeCount = plannedJourneyData.stopsFromInterchange!.count
            if self.stopsFromInterchangeCount == 1 {
                self.formattedStopsFromInterchange = "\(self.stopsFromInterchangeCount) stop"
            } else {
                self.formattedStopsFromInterchange = "\(self.stopsFromInterchangeCount) stops"
            }
            self.formattedStopsFromInterchangeTime = "\(self.formattedStopsFromInterchange), \(plannedJourneyData.minutesFromInterchange!) mins"
        }
        formattedTime = "Expected journey time: \(plannedJourneyData.totalJourneyTimeMinutes) mins"
    }
    
    private func identifyRouteUIColors(routeHexColors: [String]) -> [Color] {
        var createdUIColors: [Color] = []
        for hexColor in routeHexColors{
            createdUIColors.append(hexStringToUIColor(hex: hexColor))
        }
        return createdUIColors
    }
    
    private func summariseTermini(termini: [StopKeys]) -> String {
        var formattedTerminiFromOrigin: String = ""
        if termini.count == 1 {
            formattedTerminiFromOrigin += " " + termini[0].stopName
        }
        else {
            for (index, stop) in termini.enumerated() {
                if(index == termini.endIndex - 2)
                {
                    formattedTerminiFromOrigin += " " + stop.stopName
                }
                else if(index == termini.endIndex - 1)
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
