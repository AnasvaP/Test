//
//  DataController.swift
//  Test
//
//  Created by Anastasiia Poliuchovych on 23.03.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Test")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("core data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
}
