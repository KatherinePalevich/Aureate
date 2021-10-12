//
//  EntryForm.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/1/21.
//

import SwiftUI
import CoreData

/// The Item editor form, embedded in both
/// `ItemCreationSheet` and `ItemEditor`.
struct EntryForm: View {
    /// Manages the item form
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var entry: Entry
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    private let pasteboard = UIPasteboard.general

    var body: some View {
        List {
            TextField("Entry", text: $entry.wrappedName)
            TextEditor(text: $entry.wrappedText)
        }
        .listStyle(GroupedListStyle())
    }

}

struct ItemForm_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
