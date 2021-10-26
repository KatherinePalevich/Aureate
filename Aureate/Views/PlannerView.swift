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
    @State private var selectedEvent : EKEvent?
    @State private var newEventIsPresented = false
    
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
                
                EventRow(event: event).onTapGesture {
                    selectedEvent = event
                }
            }
        }.sheet(item: $selectedEvent) { item in
            EventViewer(event: item)
            
        }
        .navigationBarItems(
            trailing: HStack {
                newEntryButton
            }
        )
    }
    
    /// The button that presents the entry creation sheet.
    private var newEntryButton: some View {
        Button(
            action: {
                self.newEventIsPresented = true
            },
            label: {
                Label("Add Event ", systemImage: "plus").imageScale(.medium)
                    .padding(2.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .fill(Color.accentColor)
                    )
                
            })
            .sheet(
                isPresented: $newEventIsPresented,
                content: { self.newEventCreationSheet })
    }
    
    /// The event creation sheet.
    private var newEventCreationSheet: some View {
        let event = EKEvent(eventStore: Events.eventStore)
        return EventViewer(event: event)
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
