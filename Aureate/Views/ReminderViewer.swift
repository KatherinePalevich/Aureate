//
//  ReminderViewer.swift
//  Aureate
//
//  Created by Katherine Palevich on 11/19/21.
//

import SwiftUI
import EventKit

struct ReminderViewer: View {
    var theReminder: EKReminder

    init(reminder: EKReminder) {

        theReminder = reminder

    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
