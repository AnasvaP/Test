//
//  CoreDataManager.swift
//  Test
//
//  Created by Anastasiia Poliuchovych on 22.03.2023.
//

import Foundation
import CoreData
import Combine

class CoreDataManager {
    
    func saveUser(login: String, avatarUrl: String, context: NSManagedObjectContext) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            guard !login.isEmpty else {
                promise(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "User login can't be empty"])))
                return
            }
            let favUser = User(context: context)
            favUser.login = login
            favUser.avatarURL = avatarUrl
            do {
                try context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    @Published var users = [User]()
    
    func loadData(context: NSManagedObjectContext) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        context.perform {
            do {
                let users = try context.fetch(request)
                DispatchQueue.main.async {
                    self.users = users
                    for i in users{
                        print(i.login)
                    }
                }
            } catch {
                print("Error fetching users: \(error)")
            }
        }
    }
}
