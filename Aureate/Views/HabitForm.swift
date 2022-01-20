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
    @State private var habitSelected = "7"
    @State private var habitOtherSelected = "Enter number of days"

    //TO DO: reread onAppear and then think about how to save the other. So onDisappear maybe. WIll "other" remember 22 is the user goes back it.
    var body: some View {
        List {
            TextField("Name", text: $habit.wrappedName)
            
            Section(header: Text("Track habit for")) {
                HStack{
                    Picker("Track habit for:", selection: $habitSelected){
                        ForEach(habitDayCountArray, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
//                    .onChange(of: habitSelected) { newHabitSelection in
//                        habit.wrappedDuration = Int32(newHabitSelection) ?? 0
//                    }
                    TextField("Enter number of days", text: $habitOtherSelected)
                        .hidden(!habitSelected.isEqual("Other"))
                           
                    Text("days")
                }
            }
            Text("\(habit.wrappedDuration)")
            Section(header: Text("Description")){
                TextEditor(text: $habit.wrappedDetails)
            }
        }
        .onAppear {
            if(habitDayCountArray.contains(String(habit.wrappedDuration))) {
                habitSelected = String(habit.wrappedDuration)
            } else {
                habitSelected = "Other"
                habitOtherSelected = String(habit.wrappedDuration)
            }
        }
        .onDisappear{
            if(habitDayCountArray.contains(habitSelected) && !habitSelected.contains("Other")) {
                habit.wrappedDuration = Int32(habitSelected) ?? 0
            } else {
                habit.wrappedDuration = Int32(habitOtherSelected) ?? 10
            }
        }
        .listStyle(GroupedListStyle())
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
