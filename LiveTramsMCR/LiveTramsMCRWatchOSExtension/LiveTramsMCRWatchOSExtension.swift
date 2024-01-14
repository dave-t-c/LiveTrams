//
//  LiveTramsMCRWatchOSExtension.swift
//  LiveTramsMCRWatchOSExtension
//
//  Created by David Cook on 10/01/2024.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), formattedServices: FormattedServicesData().testFormattedServicesData[0])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration, formattedServices: FormattedServicesData().testFormattedServicesData[0])
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        let selectedStop = configuration.stopName
        do  {
            let serviceRequester = ServicesRequest()
            let formattedServices = try await serviceRequester.requestServices(tlaref: selectedStop)
            let entry = SimpleEntry(date: Date(), configuration: configuration, formattedServices: formattedServices)
            entries.append(entry)
        }
        catch {
            let entry = SimpleEntry(date: Date(), configuration: configuration, formattedServices: FormattedServices(destinations: [:], messages: [], lastUpdated: ""))
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        let stops: [String] = [
            "St Peter's Square",
            "Piccadilly Gardens",
            "Deansgate - Castlefield",
            "Piccadilly",
            "Victoria",
            "Altrincham",
            "Bury",
            "Market Street",
            "Exchange Square",
            "Cornbrook",
            "Chorlton",
            "Sale",
            "Old Trafford",
            "Media City"
        ]

        return stops.map { stop in
            return AppIntentRecommendation(intent: ConfigurationAppIntent(stopDetail: stop), description: stop)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let formattedServices: FormattedServices
}

struct LiveTramsMCRWatchOSExtensionEntryView : View {
    var entry: Provider.Entry
    private let maxDestinationsToShow: Int = 1

    var body: some View {
        let destinationCount: Int = entry.formattedServices.destinations.count
        let destinationsToShow: Int = destinationCount > maxDestinationsToShow ? maxDestinationsToShow : destinationCount
        let orderedServices = ServicesHelper().getDestinationsAsOrderedDict(destinations: entry.formattedServices.destinations, limit: destinationsToShow)
        Text("Next tram from \(entry.configuration.stopName):")
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.25)
            .padding(.trailing)
        Spacer()

        ForEach(orderedServices.keys, id: \.self) { stopName in
            let trams: [Tram] = entry.formattedServices.destinations[stopName]!
            let tramTimes = trams.map {$0.wait}
            let formattedTramTimes = tramTimes.joined(separator: ", ") + " mins"
            VStack{
                HStack {
                    Text(stopName)
                        .font(.subheadline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    Text(formattedTramTimes)
                        .font(.subheadline)
                        .padding(.trailing)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                Spacer()
            }
        }
        if(entry.formattedServices.destinations.isEmpty)
        {
            Text("No service information available")
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.trailing)
            Spacer()
        }
    }
}

@main
struct LiveTramsMCRWatchOSExtension: Widget {
    let kind: String = "LiveTramsMCRWatchOSExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationAppIntent.self,
            provider: Provider()) { entry in
            LiveTramsMCRWatchOSExtensionEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .accessoryRectangular) {
    LiveTramsMCRWatchOSExtension()
} timeline: {
    SimpleEntry(date: .now, 
                configuration:
                    ConfigurationAppIntent(stopDetail: "Wythenshawe Town Center"),
                formattedServices: FormattedServices(destinations:
                                                        [
                                                            "Manchester Airport": [Tram(destination: "Manchester Airport", carriages: "Single", status: "Due", wait: "8")]], messages: [], lastUpdated: ""))
    SimpleEntry(date: .now,
                configuration:
                    ConfigurationAppIntent(stopDetail:  "Wythenshawe Town Center"),
                formattedServices: FormattedServices(destinations: [:], messages: [], lastUpdated: ""))
}
