//
//  EKCalendarItem+Identifiable.swift
//  Aureate
//
//  Created by Katherine Palevich on 11/20/21.
//

import Foundation
import EventKit

extension EKCalendarItem : Identifiable {
    @objc public var id : String{
        calendarItemIdentifier
    }
}
