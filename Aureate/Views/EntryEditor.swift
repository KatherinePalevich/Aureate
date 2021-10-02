//
//  EntryEditor.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/1/21.
//

import CoreData
import SwiftUI

/// The Entry editor view, designed to be the destination of
/// a NavigationLink.
struct EntryEditor: View {
    let context: NSManagedObjectContext
    /// Manages editing the entry
    @ObservedObject var entry: Entry

    var body: some View {
      EntryForm(entry: entry)
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
