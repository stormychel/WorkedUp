//
//  WorkedUpWidget.swift
//  WorkedUpWidget
//
//  Created by Michel Storms on 22/12/2024.
//

import WidgetKit
import SwiftUI

struct WorkedUpProvider: TimelineProvider {
    func placeholder(in context: Context) -> WorkedUpEntry {
        WorkedUpEntry(date: Date(), totalTime: "00:00")
    }

    func getSnapshot(in context: Context, completion: @escaping (WorkedUpEntry) -> ()) {
        let entry = WorkedUpEntry(date: Date(), totalTime: getTotalTimeString())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WorkedUpEntry] = []
        
        // Generate a timeline entry every 60 seconds
        let currentDate = Date()
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        let entry = WorkedUpEntry(date: currentDate, totalTime: getTotalTimeString())
        
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }

    private func getTotalTimeString() -> String {
        // Your existing code for getting the total time worked
        let hhmm = SwiftHelpers.minutesToHoursAndMinutes(SwiftHelpers.getTotal())
        return String(format: "%02d:%02d", hhmm.hours, hhmm.leftMinutes)
    }
}

struct WorkedUpEntry: TimelineEntry {
    let date: Date
    let totalTime: String
}

struct WorkedUpWidgetEntryView: View {
    var entry: WorkedUpProvider.Entry

    var body: some View {
        VStack {
            Text("Total time worked this week")
                .font(.headline)
            Text(entry.totalTime)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .padding()
    }
}

//@main
struct WorkedUpWidget: Widget {
    let kind: String = "WorkedUpWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WorkedUpProvider()) { entry in
            WorkedUpWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Worked Up Time Tracker")
        .description("Track total time worked on Upwork this week.")
    }
}
