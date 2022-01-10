//
//  HabitEditor.swift
//  Aureate
//
//  Created by Katherine Palevich on 1/8/22.
//

import SwiftUI
import CoreData

struct HabitEditor: View {
    let context: NSManagedObjectContext
    /// Manages editing the habit
    @ObservedObject var habit: Habit

    var body: some View {
      HabitForm(habit: habit)
            .onDisappear(perform: {
                // Ignore validation errors
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            })
    }
}
