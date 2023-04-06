//
//  GetNextTramIntent.swift
//  LiveTramsMCR (iOS)
//
//  Created by David Cook on 01/04/2023.
//

import AppIntents
import SwiftUI
import OrderedCollections

struct GetNextTramIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Get Live Trams"
    
    static var description = IntentDescription("Get live trams for a given stop")
    
    private let maxDestinationsToShow = 3
    
    @Parameter(title: "Stop", optionsProvider: StopNameOptionsProvider())
    var stop: String?
    
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        
        guard let stop = stop else {
            throw $stop.needsValueError("Which stop?")
        }
        
        let stops = try await StopRequest().requestStopsAsync()
        
        if !stops.contains(where: {$0.stopName == stop}) {
            let possibleStops = stops.filter {$0.stopName.contains(stop)}
            let stopNames = possibleStops.map { $0.stopName }
            throw $stop.needsDisambiguationError(among: stopNames)
        }
        
        let providedStop = stops.first(where: {$0.stopName == stop})!
        
        let serviceRequester = ServicesRequest()
        let services = try await serviceRequester.requestServices(tlaref: providedStop.tlaref)
        
        if services.destinations.isEmpty && services.messages.isEmpty {
            return .result(dialog: "There is currently no live service information for \(stop)")
        }
        
        if services.destinations.isEmpty && !services.messages.isEmpty {
            return .result(dialog: "There is currently no live service information for \(stop), however there is a service update: \(services.messages.first!)")
        }
        
        let destinationCount: Int = services.destinations.count
        let destinationsToShow: Int = destinationCount > maxDestinationsToShow ? maxDestinationsToShow : destinationCount
        let orderedServices = ServicesHelper().getDestinationsAsOrderedDict(destinations: services.destinations, limit: destinationsToShow)
        
        let firstDestination = orderedServices.keys.first!
        let firstDestinationFirstWait = orderedServices[firstDestination]!.first!.wait
        
        let dialogString: IntentDialog = IntentDialog("Here are the next trams from \(stop). The first is to \(firstDestination) in \(firstDestinationFirstWait) minutes")
        
        return .result(dialog: dialogString, view: NextServicesSummaryView(orderedServices: orderedServices))
    }
    
}

private struct StopNameOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [String] {
        let stopRequester = StopRequest()
        let stops = try await stopRequester.requestStopsAsync()
        return stops.map { $0.stopName }
    }
}

private struct NextServicesSummaryView: View {
    
    var orderedServices: OrderedDictionary<String, [Tram]>
    
    var body: some View {
        
        Spacer()
        ForEach(orderedServices.keys, id: \.self) { stopName in
            let trams: [Tram] = orderedServices[stopName]!
            let tramTimes = trams.map {$0.wait}
            let formattedTramTimes = tramTimes.joined(separator: ", ") + " mins"
            VStack {
                HStack {
                    Text(stopName)
                        .font(.title3)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    Text(formattedTramTimes)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
        }
    }
}
