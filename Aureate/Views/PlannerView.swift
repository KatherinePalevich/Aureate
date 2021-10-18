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
        Text("\(date)")
        Text("These are the day's events")
        VStack {
            ForEach(events, id: \.self) { event in
                Text(event.title)
                Text("\(event.startDate)")
            }
        }
    }
}

func populateEvents(date: Date, calendar: Events) -> [EKEvent]{
    calendar.populateEvents(date: date)
    return calendar.events
}
