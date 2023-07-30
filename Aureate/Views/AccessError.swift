//
//  AccessError.swift
//  Aureate
//
//  Created by Katherine Palevich on 7/21/23.
//

import SwiftUI

struct AccessError: View {
    var body: some View {
        Text("Aureate is an application that requires access of the user's Calendar and Reminders.")
        Text("Please uninstall and reinstall the app, allow access to Calendar and Reminders, to allow full use.")
    }
}

struct AccessError_Previews: PreviewProvider {
    static var previews: some View {
        AccessError()
    }
}
