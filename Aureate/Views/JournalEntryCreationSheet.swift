//
//  JournalEntryCreationSheet.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/27/21.
//

import CoreData
import SwiftUI

/// The Item creation sheet
struct JournalEntryCreationSheet: View {
    let context: NSManagedObjectContext
    /// Manages editing of the new entry
    @ObservedObject var entry: Entry

    /// Executed when user cancels or saves the new item.
    let dismissAction: () -> Void

    @State private var errorAlertIsPresented = false
    @State private var errorAlertTitle = ""

    var body: some View {
        NavigationView {
            EntryForm(entry: entry)
                .alert(
                    isPresented: $errorAlertIsPresented,
                    content: { Alert(title: Text(errorAlertTitle)) })
                .navigationBarTitle("New Entry")
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
            try context.save()
            dismissAction()
        } catch {
            errorAlertTitle = (error as? LocalizedError)?.errorDescription ?? "An error occurred"
            errorAlertIsPresented = true
        }
    }
}
