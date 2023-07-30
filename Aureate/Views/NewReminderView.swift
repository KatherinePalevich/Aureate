//
//  NewReminderView.swift
//  Aureate
//
//  Created by Katherine Palevich on 7/30/23.
//

import SwiftUI

struct NewReminderView: View {
    @Binding var title : String
    @Binding var notes : String
    
    
    var body: some View {
        Form{
            TextField("Title",text: $title)
            TextField("Notes", text: $notes)
        }
        
    }
}
