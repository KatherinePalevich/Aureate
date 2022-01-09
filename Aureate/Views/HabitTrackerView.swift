//
//  HabitTrackerView.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/21/21.
//

import SwiftUI
import CoreData

enum HabitSortOrder {
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

struct HabitTrackerView: View {
    var body: some View {
        HabitTrackerView2()
    }
}

struct HabitTrackerView2: View {
    @State private var sortOrder: SortOrder = .byName
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)
    
    var body: some View {
        HabitTrackerView3(fetchRequest:fetchRequest, sortOrder: $sortOrder)
            .onReceive(didSave) {_ in
                // CoreData doesn't automatically fetch when relations change.
                if sortOrder == .byName {
                    // Toggle twice has the effect of forcing a new fetch request to be made.
                    sortOrder.toggle()
                    sortOrder.toggle()
                }
            }
    }
    
    private var fetchRequest: FetchRequest<Habit> {
        switch sortOrder {
        case .byName:
            return FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.name, ascending: true)])
        case .byLast:
            return FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Habit.date, ascending: false)])
        }
    }
}

struct HabitTrackerView3: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var fetchRequest:FetchRequest<Habit>
    
    @Binding var sortOrder: SortOrder
    
    private var habits: FetchedResults<Habit> {
        fetchRequest.wrappedValue
    }
    
    /// Controls the presentation of the entry creation sheet.
    @State private var newEntryIsPresented = false
    
    var body: some View {
        habitList
            .navigationBarTitle(Text("\(habits.count) Entries"))
            .navigationBarItems(
                leading: EditButton(),
                trailing: HStack {
                    newHabitButton
                    toggleOrderingButton
                })
    }
    
    private var entryList: some View {
        List {
            ForEach(habits) { habit in
                NavigationLink(destination: editorView(for: habit)) {
                    HabitRow(habit: habit)
                }
            }
            .onDelete(perform: deleteHabits)
        }
        .listStyle(PlainListStyle())
    }
    
    /// The view that edits a entry in the list.
    private func editorView(for habit: Habit) -> some View {
        EntryEditor(
            context:viewContext,
            habit: habit)
            .navigationBarTitle(habit.wrappedName)
    }
    
    /// The button that presents the entry creation sheet.
    private var newHabitButton: some View {
        Button(
            action: {
                self.newHabitIsPresented = true
            },
            label: {
                Label("Add Habit ", systemImage: "plus.circle").imageScale(.large)
                    .padding(2.5)
            })
            .sheet(
                isPresented: $newHabitIsPresented,
                content: { self.newHabitCreationSheet })
    }
    
    /// The entry creation sheet.
    private var newHabitCreationSheet: some View {
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = viewContext
        return HabitCreationSheet(
            context:childContext,
            entry: Habit(context: childContext),
            dismissAction: {
                self.newHabitIsPresented = false
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
    
    private func deleteHabits(offsets: IndexSet) {
        withAnimation {
            offsets.map { habits[$0] }.forEach(viewContext.delete)
            
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
    
    /// The button that toggles between name/last added ordering.
    private var toggleOrderingButton: some View {
        switch sortOrder {
        case .byName:
            return Button(action: toggleSortOrder, label: {
                HStack {
                    Text("Habit Name")
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

struct HabitRow: View {
    @ObservedObject var habit: Habit
    
    var body: some View {
        VStack(alignment:.leading) {
            Text(habit.wrappedName)
        }
    }
}
