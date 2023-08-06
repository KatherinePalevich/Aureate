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
    @State private var habitDayCountArray = ["7", "14", "30", "180", "365", "Other"]
    @State private var habitSelected = "Other"
    @State private var habitOtherSelected = ""

    var body: some View {
        List {
            Section(header: Text("Name")){
                TextField("Name", text: $habit.wrappedName)
            }
            Section(header: Text("Completed Days")){
                Text("\(habit.wrappedCompletedNum)")
            }
            Section(header: Text("Track habit for")) {
                HStack{
                    Picker("Track habit for:", selection: $habitSelected){
                        ForEach(habitDayCountArray, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .frame(width: 262.0)
                    .onChange(of: habitSelected) { newHabitSelection in
                        if(!newHabitSelection.contains("Other")) {
                            habit.wrappedDuration = Int32(newHabitSelection) ?? 320
                        } else {
                            habitSelected = "Other"
                            habit.wrappedDuration = Int32(habitOtherSelected) ?? 10
                            print(habitOtherSelected)
                        }
                    }
                    Text("days").fixedSize()
                }
                TextField("days", text: $habitOtherSelected, prompt: Text("Enter number of days"))
                    .hidden(!habitSelected.isEqual("Other"))
                    .onChange(of: habitOtherSelected){ value in
                        habit.wrappedDuration = Int32(value) ?? 10
                    }
            }
            Section(header: Text("Description")){
                TextEditor(text: $habit.wrappedDetails)
            }
        }
        .onAppear {
            if(habitDayCountArray.contains(String(habit.wrappedDuration))) {
                habitSelected = String(habit.wrappedDuration)
            } else {
                habitSelected = "Other"
                if habit.duration != 0 {
                    habitOtherSelected = String(habit.wrappedDuration)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .tint(.accentColor)
    }

}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
            case true: self.hidden()
            case false: self
        }
    }
}
