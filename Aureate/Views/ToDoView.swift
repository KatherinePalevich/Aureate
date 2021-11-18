//
//  ToDoView.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/21/21.
//

import SwiftUI
import EventKit

struct ToDoView: View {
    @ObservedObject var calendar = Reminders(date: Date())
    
    var body: some View {
        Text("This is the To-Do Page")
        RemindersView(calendarReminders: calendar.dayReminders)
    }
}
    
struct RemindersView : View {
    var calendarReminders : [EKReminder]
    @State private var selectedReminder : EKReminder?
    
    var body: some View {
        List {
            ForEach(calendarReminders, id: \.self) { reminder in
                ReminderRow(reminder: reminder).onTapGesture {
                    selectedReminder = reminder
                }
            }
        }
    }
}

struct ReminderRow: View {
    var reminder: EKReminder
    
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
