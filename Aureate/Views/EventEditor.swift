//
//  EventEditor.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/18/21.
//

import SwiftUI
import EventKit
import EventKitUI

struct EventEditor: View {
    var event: EKEvent
    
    @State private var showIt = false
        var body: some View {
            Button("Events") { showIt = true }
                .sheet(isPresented: $showIt) {
                    EventViewer(event: event, isShowing: $showIt)
                }
        }
}
