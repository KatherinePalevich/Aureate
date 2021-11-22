//
//  Reminders.swift
//  Aureate
//
//  Created by Katherine Palevich on 11/9/21.
//

import Foundation
import EventKit
import Combine
import SwiftUI

class Reminders: ObservableObject {
    @Published public var dayReminders : [EKReminder] = []
    @Published public var weekReminders : [EKReminder] = []
    private var cancellables = Set<AnyCancellable>()
    
    public static let eventStore = EKEventStore()
    @Published public var date : Date {
        didSet {
            populateDayReminders(date: date)
            //populateWeekReminders(date: date)
        }
    }
    
    public init(date: Date) {
        self.date = date
        Reminders.eventStore.requestAccess(to: EKEntityType.reminder){ (granted, error) in
            if !granted {
                fatalError("Cannot access events")
            }
            self.populateDayReminders(date: self.date)
            //self.populateWeekReminders(date: self.date)
        }
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink{ _ in
                DispatchQueue.main.async {
                    Reminders.eventStore.refreshSourcesIfNecessary()
                    self.populateDayReminders(date: self.date)
                    //self.populateWeekReminders(date: self.date)
                }
            }.store(in: &cancellables)
    }
    
    private func populateDayReminders(date: Date){
        let predicate = Reminders.eventStore.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: Reminders.eventStore.calendars(for: EKEntityType.reminder))
        Reminders.eventStore.fetchReminders(matching: predicate, completion: { (reminders: [EKReminder]?) -> Void in
            self.dayReminders = reminders!
        })
    }
    
    //    private func populateWeekReminders(date: Date){
    //        // Get the appropriate calendar.
    //        let calendar = Calendar.current
    //
    //        let beginningOfWeek = (calendar.nextWeekend(startingAfter: date, direction: .backward)?.end)?.addingTimeInterval(-60 * 60 * 24)
    //        var endOfWeek = (calendar.nextWeekend(startingAfter: date, direction: .forward)?.end)!.addingTimeInterval(-60 * 60 * 24)
    //        if(calendar.isDateInWeekend(date) && calendar.isDateInWeekend(date.addingTimeInterval(60 * 60 * 24))){
    //            endOfWeek = date
    //        }
    //
    //
    //        let predicate = Events.eventStore.predicateForEvents(withStart: beginningOfWeek!, end: endOfWeek, calendars: Events.eventStore.calendars(for: EKEntityType.event))
    //        weekReminders = Events.eventStore.events(matching: predicate)
    //
    //    }
    
}
