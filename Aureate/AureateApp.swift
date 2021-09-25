//
//  AureateApp.swift
//  Aureate
//
//  Created by Katherine Palevich on 9/20/21.
//

import SwiftUI

@main
struct AureateApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
