//
//  EventEditor.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/18/21.
//

import SwiftUI
import EventKit

struct EventEditor: View {
    //Manages editing the event (?)
    var event: EKEvent
    
    var body: some View {
//        List {
//            TextField("Title", text: event.title!)
//            TextEditor(text: entry.startDate)
//        }
//        .listStyle(GroupedListStyle())
        Text(event.title)
        Text("\(event.startDate)")
    }
}
