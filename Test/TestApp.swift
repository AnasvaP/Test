//
//  TestApp.swift
//  Test
//
//  Created by Anastasiia Poliuchovych on 22.03.2023.
//

import SwiftUI

@main
struct TestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
