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
        //Form {
            Section {
                TextField("Title", text: $reminder.title ?? "")
                TextField("Notes", text: $reminder.notes ?? "").toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading){
                            Button(action: {
                                try! Reminders.eventStore.save(reminder, commit: true)
                                }, label: {
                                    Image(systemName: "arrowshape.turn.up.right.circle")
                                })
                            Button(action: {
                                dismiss()
                                }, label: {
                                    Image(systemName: "x.circle")
                                })
                        }
                }
            }
            Section {
                DatePicker(
                    "Due  Date",
                    selection: $date,
                    displayedComponents: [.date]
                )
                    .frame(maxWidth: .infinity)
                    .datePickerStyle(.graphical)
            }
        //}
        .navigationBarTitle( "MAIN" )
        .onDisappear {
            try! Reminders.eventStore.save(reminder, commit: true)
        }
        
    }
}
