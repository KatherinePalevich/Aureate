//
//  Calendar.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/9/21.
//

import Foundation
import EventKit

class Calendar: ObservableObject {
    @Published public var events : [EKEvent] = []
    
    private var eventStore = EKEventStore()

    public init(date: Date) {
        eventStore.requestAccess(to: EKEntityType.event){ (granted, error) in
            if !granted {
                fatalError("Cannot access events")
            }
            self.populateEvents(date: date)
        }
    }
    
    private func populateEvents(date: Date){
        //three years forward and backward in time
        let startDate = date.addingTimeInterval(TimeInterval(60 * 60 * 24 * (-30 * 36)))
        let endDate = date.addingTimeInterval(TimeInterval(60 * 60 * 24 * (30 * 36)))
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: eventStore.calendars(for: EKEntityType.event))
        
        events = eventStore.events(matching: predicate)
        
    }
    
}
