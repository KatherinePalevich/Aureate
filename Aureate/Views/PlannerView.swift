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
    @ObservedObject var calendar = Events(date: Date())
    
    var body: some View {
        DatePicker(
            "Start Date",
            selection: $calendar.date,
            displayedComponents: [.date]
        )
            .frame(maxWidth: .infinity)
            .datePickerStyle(.graphical)
        List {
            ForEach(calendar.events, id: \.self) { event in
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

struct EventRow: View {
    var event: EKEvent
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(event.title)
            Text("\(event.startDate)")
        }
    }
}
