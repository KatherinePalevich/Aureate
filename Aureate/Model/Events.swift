//
//  previously called Calendar.swift
//  now called Events.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/9/21.
//

import Foundation
import EventKit
import Combine
import SwiftUI

class Events: ObservableObject {
    @Published public var events : [EKEvent] = []
    private var cancellables = Set<AnyCancellable>()
    
    public static let eventStore = EKEventStore()
    @Published public var date : Date {
        didSet {
            populateEvents(date: date)
        }
    }

    public init(date: Date) {
        self.date = date
        Events.eventStore.requestAccess(to: EKEntityType.event){ (granted, error) in
            if !granted {
                fatalError("Cannot access events")
            }
            self.populateEvents(date: self.date)
        }
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink{ _ in
                DispatchQueue.main.async {
                    self.populateEvents(date: self.date)
                }
            }.store(in: &cancellables)
    }
    
    private func populateEvents(date: Date){
        // Get the appropriate calendar.
        let calendar = Calendar.current
        
        let beginningOfDay = calendar.startOfDay(for: date)
        var dateComponents = DateComponents()
        dateComponents.minute = 0
        dateComponents.second = 0
        dateComponents.hour = 0

        let endOfDay = calendar.nextDate(after: date, matching: dateComponents, matchingPolicy: .nextTime)!
        
        let predicate = Events.eventStore.predicateForEvents(withStart: beginningOfDay, end: endOfDay, calendars: Events.eventStore.calendars(for: EKEntityType.event))
        events = Events.eventStore.events(matching: predicate)
        
    }
    
}
