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

        let selectedStop = configuration.stopDetail.tlaref
        do  {
            let serviceRequester = ServicesRequest()
            let formattedServices = try await serviceRequester.requestServices(tlaref: selectedStop)
            let entry = SimpleEntry(date: Date(), configuration: configuration, formattedServices: formattedServices)
            entries.append(entry)
        }
        catch {
            let entry = SimpleEntry(date: Date(), configuration: configuration, formattedServices: FormattedServices(destinations: [:], messages: [], lastUpdated: ""), updateInformation: "No service infomration available")
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        let stopKeys: [StopKeys] = [
            StopKeys(stopName: "Deansgate - Castlefield", tlaref: "GMX"),
            StopKeys(stopName: "Cornbrook", tlaref: "CNK"),
            StopKeys(stopName: "Altrincham", tlaref: "ALT")
        ]

        let stopDetails = stopKeys.map { stopKey in
            return StopDetail(id: stopKey.tlaref.hashValue, tlaref: stopKey.tlaref, stopName: stopKey.stopName)
        }

        return stopDetails.map { stopDetail in
            return AppIntentRecommendation(intent: ConfigurationAppIntent(stopDetail: stopDetail), description: stopDetail.stopName)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let formattedServices: FormattedServices
    var updateInformation: String = ""
}

struct LiveTramsMCRWatchOSExtensionEntryView : View {
    var entry: Provider.Entry
    private let maxDestinationsToShow: Int = 1

    var body: some View {
        let destinationCount: Int = entry.formattedServices.destinations.count
        let destinationsToShow: Int = destinationCount > maxDestinationsToShow ? maxDestinationsToShow : destinationCount
        let orderedServices = ServicesHelper().getDestinationsAsOrderedDict(destinations: entry.formattedServices.destinations, limit: destinationsToShow)
        ForEach(orderedServices.keys, id: \.self) { stopName in
            let trams: [Tram] = entry.formattedServices.destinations[stopName]!
            let tramTimes = trams.map {$0.wait}
            let formattedTramTimes = tramTimes.joined(separator: ", ") + " mins"

            VStack{
                HStack{
                    Text("Next tram from \(entry.configuration.stopDetail.stopName)")
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.trailing)
                    Spacer()
                }
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
                }
                Spacer()
            }

        }
        /*VStack {
            HStack{
                Text("Wythenshawe Town Centre")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            HStack{
                Text("Manchester Airport: 9 mins")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
        }.font(.footnote)*/
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
                    ConfigurationAppIntent(stopDetail: StopDetail(id: 1, tlaref: "ALT", stopName: "Altrincham")),
                formattedServices: FormattedServices(destinations: 
                                                        [
                                                            "Manchester Airport": [Tram(destination: "Manchester Airport", carriages: "Single", status: "Due", wait: "8")]], messages: [], lastUpdated: ""))
}
