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
    @State private var newReminderIsPresented = false

    
    var body: some View {
        RemindersView(reminders: reminders)
            .navigationBarItems(
                trailing: HStack {
                    newReminderButton
                }
            )
    }
    
    /// The button that presents the reminder creation sheet.
    private var newReminderButton: some View {
        Button(
            action: {
                self.newReminderIsPresented = true
            },
            label: {
                Label("Add Event ", systemImage: "plus.circle").imageScale(.large)
                    .padding(2.5)
                
            })
            .sheet(
                isPresented: $newReminderIsPresented,
                content: { self.newReminderCreationSheet })
    }
    
    /// The reminder creation sheet.
    private var newReminderCreationSheet: some View {
        @State var reminder = EKReminder(eventStore: Reminders.eventStore)
        reminder.title = ""
        reminder.notes = ""
        reminder.calendar = Reminders.eventStore.defaultCalendarForNewReminders()
        return NavigationView{ReminderViewer(reminder: $reminder)}
    }
}

struct RemindersView : View {
    @ObservedObject var reminders : Reminders
    var body: some View {
        List {
            if(reminders.dayReminders.isEmpty){
                Text("No Reminders to Complete! Use the \"+\" in the upper right corner to add a new task")

            }
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
        Toggle(reminder.title, isOn: $reminder.isCompleted)
            .onChange(of: reminder.isCompleted) { newValue in
                complete(reminder)
            }
    }
}

func complete(_ reminder: EKReminder){
    reminder.isCompleted = true
    do {
        try Reminders.eventStore.save(reminder, commit: true)
    } catch {
        print("Cannot save")
        return
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
