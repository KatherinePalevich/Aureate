//
//  ToDoView.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/21/21.
//

import SwiftUI
import EventKit

struct ToDoView: View {
    @ObservedObject var reminders = Reminders(date: Date())
    
    var body: some View {
        RemindersView(reminders: reminders)
    }
}
    
struct RemindersView : View {
    @ObservedObject var reminders : Reminders
    var body: some View {
        List {
            ForEach($reminders.dayReminders, id: \.self) { $reminder in
                NavigationLink(destination: ReminderViewer(reminder: $reminder)){
                    ReminderRow(reminder: $reminder)
                }
            }
        }
    }
}

struct ReminderRow: View {
    @Binding var reminder: EKReminder
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(reminder.title)
            //Text("\(reminder.description)")
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
