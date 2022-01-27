//
//  Habit+Helper.swift
//  Aureate
//
//  Created by Katherine Palevich on 1/8/22.
//

import UIKit
import Foundation

extension Habit {
    
    var wrappedDate: Date {
        get {
            date ?? Date(timeIntervalSince1970: 0)
        }
        set(newValue) {
            objectWillChange.send()
            date = newValue
        }
    }
    
    var wrappedName: String {
        get {
            name ?? ""
        }
        set(newValue) {
            objectWillChange.send()
            name = newValue
        }
    }
    
    var wrappedDetails: String {
        get {
            details ?? ""
        }
        set(newValue) {
            objectWillChange.send()
            details = newValue
        }
    }
    
    var wrappedFrequency: Int32 {
        get {
            frequency
        }
        set(newValue) {
            objectWillChange.send()
            frequency = newValue
        }
    }
    
    var wrappedDuration: Int32 {
        get {
            duration
        }
        set(newValue) {
            objectWillChange.send()
            duration = newValue
        }
    }
    
    var wrappedCompletedNum: Int32 {
        get {
            completedNum
        }
        set(newValue) {
            objectWillChange.send()
            completedNum = newValue
        }
    }
}
