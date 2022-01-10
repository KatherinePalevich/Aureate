//
//  HabitCreationSheet.swift
//  Aureate
//
//  Created by Katherine Palevich on 1/8/22.
//

import CoreData
import SwiftUI

struct HabitCreationSheet: View {
    let context: NSManagedObjectContext
    /// Manages editing of the new habit
    @ObservedObject var habit: Habit

    /// Executed when user cancels or saves the new habit.
    let dismissAction: () -> Void

    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""

    var body: some View {
        NavigationView {
            HabitForm(habit: habit)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("New Habit")
                .navigationBarItems(
                    leading: Button(
                        action: self.dismissAction,
                        label: { Text("Cancel") }),
                    trailing: Button(
                        action: self.save,
                        label: { Text("Save") }))
        }
    }

    private func save() {
        do {
            habit.date = Date()
            try context.save()
            dismissAction()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}
