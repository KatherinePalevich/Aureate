//
//  ReminderViewer.swift
//  Aureate
//
//  Created by Katherine Palevich on 11/19/21.
//

import SwiftUI
import EventKit

struct ReminderViewer: View {
    @Binding var reminder : EKReminder
    
    var body: some View {
        Form {
            TextField("Title", text: $reminder.title)
            TextField("Notes", text: $reminder.notes ?? "")
//            DatePicker(
//                "Due  Date",
//                selection: $reminder.dueDateComponents.date ?? Date(),
//                displayedComponents: [.date]
//            )
//                .frame(maxWidth: .infinity)
//                .datePickerStyle(.graphical)
        }
        .listStyle(GroupedListStyle())
        .onDisappear {
            try! Reminders.eventStore.save(reminder, commit: true)
        }
    }
}
