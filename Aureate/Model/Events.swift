//
//  Calendar.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/9/21.
//

import Foundation
import EventKit

class Events: ObservableObject {
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
    
    public func populateEvents(date: Date){
        // Get the appropriate calendar.
        let calendar = Calendar.current
        
        let beginningOfDay = calendar.startOfDay(for: date)
        var dateComponents = DateComponents()
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.hour = 0

        let endOfDay = calendar.nextDate(after: date, matching: dateComponents, matchingPolicy: .nextTime)!
        
        let predicate = eventStore.predicateForEvents(withStart: beginningOfDay, end: endOfDay, calendars: eventStore.calendars(for: EKEntityType.event))
        let timezone = TimeZone.current
        events = eventStore.events(matching: predicate)
        
    }
    
}
