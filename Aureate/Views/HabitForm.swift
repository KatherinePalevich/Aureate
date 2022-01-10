//
//  HabitForm.swift
//  Aureate
//
//  Created by Katherine Palevich on 1/8/22.
//

import SwiftUI
import CoreData

struct HabitForm: View {
    /// Manages the habit form
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var habit: Habit
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    private let pasteboard = UIPasteboard.general

    var body: some View {
        List {
            TextField("Name", text: $habit.wrappedName)
            TextEditor(text: $habit.wrappedDetails)
        }
        .listStyle(GroupedListStyle())
    }

}
