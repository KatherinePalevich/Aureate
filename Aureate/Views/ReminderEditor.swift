//
//  ReminderEditor.swift
//  Aureate
//
//  Created by Katherine Palevich on 11/19/21.
//

import SwiftUI
import EventKit
import EventKitUI

struct ReminderEditor: View {
    var reminder: EKReminder
    
    @State private var showIt = false
        var body: some View {
            Button("Reminders") { showIt = true }
                .sheet(isPresented: $showIt) {
                    ReminderViewer(reminder: reminder)
                }
        }
}
