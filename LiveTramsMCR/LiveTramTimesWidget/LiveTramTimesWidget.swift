//
//  LiveTramTimesWidget.swift
//  LiveTramTimesWidget
//
//  Created by David Cook on 02/03/2023.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    
    public typealias Entry = SimpleEntry
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), formattedServices: FormattedServicesData().testFormattedServicesData[0], seletedStop: "PlaceHolder")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), formattedServices: FormattedServicesData().testFormattedServicesData[0], seletedStop: "Snapshot")
            completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            var entries: [SimpleEntry] = []
            var entry: SimpleEntry
            var timeline: Timeline<SimpleEntry>
            let selectedStop = "ALT"
            do  {
                let serviceRequester = ServicesRequest()
                let formattedServices = try await serviceRequester.requestServices(tlaref: selectedStop)
                entry = SimpleEntry(date: Date(), formattedServices: formattedServices, seletedStop: selectedStop)
                entries.append(entry)
                timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
            catch {
                entry = SimpleEntry(date: Date(), formattedServices: FormattedServicesData().testFormattedServicesData[0], seletedStop: "Exception")
                timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let formattedServices: FormattedServices
    let seletedStop: String
}

struct LiveTramTimesWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SystemSmallView(formattedServices: entry.formattedServices)
        default:
            SystemSmallView(formattedServices: entry.formattedServices)
        }
        
    }
}

struct LiveTramTimesWidget: Widget {
    let kind: String = "LiveTramTimesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LiveTramTimesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Live Trams")
        .description("View live tram times for a stop")
        .supportedFamilies([.systemSmall])
    }
}
