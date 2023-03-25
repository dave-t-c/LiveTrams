//
//  StopViewModel.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 07/03/2023.
//

import Foundation

class StopViewModel: ObservableObject {
    @Published var currentStopTlaref: String?
}

enum SelectedStopView: String {
    case services = "services"
    case nearby = "nearby"
    case planJourney = "planJourney"
}
