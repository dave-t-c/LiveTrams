//
//  LiveTramTimesWidget.swift
//  LiveTramTimesWidget
//
//  Created by David Cook on 02/03/2023.
//

import WidgetKit
import SwiftUI
import OrderedCollections

struct Provider: IntentTimelineProvider {
    
    public typealias Entry = SimpleEntry
    
    typealias Intent = LiveTramStopSelectionIntent
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), formattedServices: FormattedServicesData().testFormattedServicesData[0], tlaref: "")
    }

    func getSnapshot(for configuration: LiveTramStopSelectionIntent,
                     in context: Context,
                     completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), formattedServices: FormattedServicesData().testFormattedServicesData[0], tlaref: "")
            completion(entry)
    }

    func getTimeline(for configuration: LiveTramStopSelectionIntent,
                     in context: Context,
                     completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            var entries: [SimpleEntry] = []
            var entry: SimpleEntry
            var timeline: Timeline<SimpleEntry>
            let selectedStop = configuration.stop?.identifier
            do  {
                let serviceRequester = ServicesRequest()
                let formattedServices = try await serviceRequester.requestServices(tlaref: selectedStop!)
                entry = SimpleEntry(date: Date(), formattedServices: formattedServices, tlaref: selectedStop!)
                entries.append(entry)
                timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
            catch {
                entry = SimpleEntry(date: Date(), formattedServices: FormattedServices(destinations: [:], messages: [], lastUpdated: ""), tlaref: "")
                timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let formattedServices: FormattedServices
    let tlaref: String
}

struct LiveTramTimesWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SystemSmallView(formattedServices: entry.formattedServices)
                .widgetURL(URL(string: "livetramsmcr://services/\(entry.tlaref)"))
        case .systemMedium:
            SystemMediumView(formattedServices: entry.formattedServices)
                .widgetURL(URL(string: "livetramsmcr://services/\(entry.tlaref)"))
        case .systemLarge:
            SystemLargeView(formattedServices: entry.formattedServices)
                .widgetURL(URL(string: "livetramsmcr://services/\(entry.tlaref)"))
        default:
            SystemSmallView(formattedServices: entry.formattedServices)
                .widgetURL(URL(string: "livetramsmcr://services/\(entry.tlaref)"))
        }
        
    }
}

struct LiveTramTimesWidget: Widget {
    let kind: String = "LiveTramTimesWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: LiveTramStopSelectionIntent.self,
                            provider: Provider()) { entry in
            LiveTramTimesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Live Trams")
        .description("View live trams for a stop")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
