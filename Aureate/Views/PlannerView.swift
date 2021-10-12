//
//  PlannerView.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/21/21.
//

import SwiftUI
import EventKit
import EventKitUI

struct PlannerView: View {
    @State private var date = Date()
    var calendar = Calendar(date: Date())
    
    var body: some View {
        
        DatePicker(
            "Start Date",
            selection: $date,
            displayedComponents: [.date]
        )
            .frame(maxWidth: .infinity)
            .datePickerStyle(.graphical)
        Text("\(date)")
        Text("These are the day's events")
//        calendar.events.forEach() { event in
//            Text(event.title)
//        }
    }
}

struct PlannerView_Previews: PreviewProvider {
    static var previews: some View {
        PlannerView()
    }
}
