//
//  EKEvent+Identifiable.swift
//  Aureate
//
//  Created by Katherine Palevich on 10/23/21.
//

import Foundation
import EventKit

extension EKEvent: Identifiable {
    public var id : String {
        eventIdentifier
    }
}
