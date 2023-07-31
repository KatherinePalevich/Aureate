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
    @State var reminder : EKReminder?
    @State var newReminderTitle : String = ""
    @State var newReminderNotes : String = ""

    
    var body: some View {
        if reminders.accessGranted {
            RemindersView(reminders: reminders)
                .navigationBarItems(
                    trailing: HStack {
                        newReminderButton
                    }
                )
        } else {
            VStack(spacing: 8){
                Image(systemName: "lock.fill")
                    .font(.system(size: 100, weight: .medium))
                Label("Aureate does not have access to your Reminders. \n Please go to Privacy Settings and allow access to use this feature!", systemImage: "heart")
                    .font(.headline)
                       .labelStyle(.titleOnly)
                       .multilineTextAlignment(.center)
                       .foregroundColor(Color.gray)
            }
            
        }
        
    }
    
    /// The button that presents the reminder creation sheet.
    private var newReminderButton: some View {
        Button(
            action: {
                newReminderTitle = ""
                newReminderNotes = ""
                self.newReminderIsPresented = true
            },
            label: {
                Label("Add Event ", systemImage: "plus.circle").imageScale(.large)
                    .padding(2.5)
                
            })
            .sheet(
                isPresented: $newReminderIsPresented,
                onDismiss: {
                    if !newReminderTitle.isEmpty || !newReminderNotes.isEmpty {
                        let reminder = EKReminder(eventStore: Reminders.eventStore)
                        reminder.title = newReminderTitle
                        reminder.notes = newReminderNotes
                        reminder.calendar = Reminders.eventStore.defaultCalendarForNewReminders()
                        do {
                            try Reminders.eventStore.save(reminder, commit: true)
                        } catch {
                            print("Cannot save")
                            return
                        }
                    }
                }, content: { self.newReminderCreationSheet })
    }
    
    /// The reminder creation sheet.
    private var newReminderCreationSheet: some View {
        return NavigationView{
            NewReminderView(title: $newReminderTitle, notes: $newReminderNotes)
                .toolbar {
                    Button("Save"){
                        newReminderIsPresented.toggle()
                    }
                }
            }
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
