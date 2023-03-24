//
//  TestApp.swift
//  Test
//
//  Created by Anastasiia Poliuchovych on 22.03.2023.
//

import SwiftUI

@main
struct TestApp: App {

    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
