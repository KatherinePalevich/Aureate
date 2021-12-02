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
    @State var date = Date()
    
    var body: some View {
        Form {
            Section {
                TextField("Title", text: $reminder.title ?? "")
                TextField("Notes", text: $reminder.notes ?? "")
            }
//            Section {
//                DatePicker(
//                            "Due  Date",
//                            selection: $date,
//                            displayedComponents: [.date]
//                            )
//                                .frame(maxWidth: .infinity)
//                                .datePickerStyle(.graphical)
//            }
        }.onDisappear {
            try! Reminders.eventStore.save(reminder, commit: true)
        }
    }
}
