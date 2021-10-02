//
//  Entry+Helper.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/28/21.
//

import UIKit
import Foundation

extension Entry {
    
    //Date of the drive when it was created
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
    
}
