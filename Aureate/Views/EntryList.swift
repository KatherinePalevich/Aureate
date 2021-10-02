//
//  EntryList.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/27/21.
//

import SwiftUI
import CoreData

enum SortOrder {
    case byName
    case byLast
    mutating func toggle() {
        switch self {
        case .byName:
            self = .byLast
        case .byLast:
            self = .byName
        }
    }
    
}

struct EntryList: View {
    var body: some View {
            EntryList2()
    }
}

struct EntryList2: View {
    @State private var sortOrder: SortOrder = .byName
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        ItemList3(fetchRequest:fetchRequest, sortOrder: $sortOrder)
            .onReceive(didSave) {_ in
                // CoreData doesn't automatically fetchf when relations change.
                if sortOrder == .byName {
                    // Toggle twice has the effect of forcing a new fetch request to be made.
                    sortOrder.toggle()
                    sortOrder.toggle()
                }
            }
    }
    
    private var fetchRequest: FetchRequest<Entry> {
        switch sortOrder {
        case .byName:
            return FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.name, ascending: true)])
        case .byLast:
            return FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entry.date, ascending: false)])
        }
    }
}

struct ItemList3: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest:FetchRequest<Entry>
    
    @Binding var sortOrder: SortOrder
    
    private var entries: FetchedResults<Entry> {
        fetchRequest.wrappedValue
    }
    
    /// Controls the presentation of the item creation sheet.
    @State private var newEntryIsPresented = false
    
    var body: some View {
        entryList
            .navigationBarTitle(Text("\(entries.count) Entries"))
            .navigationBarItems(
                leading: HStack {
                    EditButton()
                    newEntryButton
                },
                trailing: toggleOrderingButton)
    }
    
    private var entryList: some View {
        List {
            ForEach(entries) { entry in
                NavigationLink(destination: editorView(for: entry)) {
                    EntryRow(entry: entry)
                        .animation(nil)
                }
            }
            .onDelete(perform: deleteEntries)
        }
        .listStyle(PlainListStyle())
    }
    
    /// The view that edits a entry in the list.
    private func editorView(for entry: Entry) -> some View {
        EntryEditor(
            context:viewContext,
            entry: entry)
            .navigationBarTitle(entry.wrappedName)
    }
    
    /// The button that presents the entry creation sheet.
    private var newEntryButton: some View {
        Button(
            action: {
                self.newEntryIsPresented = true
            },
            label: {
                Label("Add Entry ", systemImage: "plus").imageScale(.medium)
                    .padding(2.5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10.0)
                            .stroke(lineWidth: 2.0)
                            .fill(Color.accentColor)
                    )
                
            })
            .sheet(
                isPresented: $newEntryIsPresented,
                content: { self.newEntryCreationSheet })
    }
    
    /// The entry creation sheet.
    private var newEntryCreationSheet: some View {
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = viewContext
        return JournalEntryCreationSheet(
            context:childContext,
            entry: Entry(context: childContext),
            dismissAction: {
                self.newEntryIsPresented = false
                do {
                    try viewContext.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                
            })
            .environment(\.managedObjectContext, childContext)
            .accentColor(.blue)
    }
    
    private func deleteEntries(offsets: IndexSet) {
        withAnimation {
            offsets.map { entries[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    /// The button that toggles between title/author ordering.
    private var toggleOrderingButton: some View {
        switch sortOrder {
        case .byName:
            return Button(action: toggleSortOrder, label: {
                HStack {
                    Text("Entry Name")
                    Image(systemName: "tag")
                        .imageScale(.small)
                }
            })
        case .byLast:
            return Button(action: toggleSortOrder, label: {
                HStack {
                    Text("Last Added")
                    Image(systemName: "tray.2")
                        .imageScale(.small)
                }
            })
        }
    }
    
    private func toggleSortOrder() {
        sortOrder.toggle()
    }
}

struct EntryRow: View {
    @ObservedObject var entry: Entry
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(entry.wrappedName)
            Text(entry.categoriesSortKey ?? "").font(.footnote).lineLimit(1)
        }
    }
}
