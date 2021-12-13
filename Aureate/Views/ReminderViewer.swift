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
    
    @Environment(\.dismiss) var dismiss
    
    func setDate() -> Void{
        date = (reminder.dueDateComponents?.date)!
    }
    
    var body: some View {
        Form {
            TextField("Title", text: $reminder.title ?? "")
            TextField("Notes", text: $reminder.notes ?? "")
            
//            Section {
//                DatePicker(
//                    "Due  Date",
//                    selection: $date,
//                    displayedComponents: [.date]
//                )
//                    .frame(maxWidth: .infinity)
//                    .datePickerStyle(.graphical)
//            }
        }.toolbar(){
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "xmark.circle")
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    try! Reminders.eventStore.save(reminder, commit: true)
                    dismiss()
                }, label: {
                    Text("Save")
                })
            }
        }
    }
}
