//
//  PlannerView.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/21/21.
//

import SwiftUI
import EventKit
import EventKitUI

struct PlannerView: View {
    @State private var date = Date()
    @State private var events = [EKEvent]()
    var calendar = Events(date: Date())
    
    var body: some View {
        DatePicker(
            "Start Date",
            selection: $date,
            displayedComponents: [.date]
        ).onChange(of: date, perform: { _ in
            events = populateEvents(date: date, calendar: calendar)
        })
            .frame(maxWidth: .infinity)
            .datePickerStyle(.graphical)
        //Text("\(date)")
        List {
            ForEach(events, id: \.self) { event in
                NavigationLink(destination: editorView(for: event)) {
                    EventRow(event: event)
                }
            }
        }
    }
}

/// The view that edits a event in the list.
private func editorView(for event: EKEvent) -> some View {
    EventEditor(event: event)
        .navigationBarTitle("Event")
}

func populateEvents(date: Date, calendar: Events) -> [EKEvent]{
    calendar.populateEvents(date: date)
    return calendar.events
}

struct EventRow: View {
    var event: EKEvent
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(event.title)
            Text("\(event.startDate)")
        }
    }
}
