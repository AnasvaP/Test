//
//  MyManager.swift
//  Test
//
//  Created by Anastasiia Poliuchovych on 22.03.2023.
//

import Foundation
import Combine
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var users: [DataModel] = []
    @Published var repos: [Repos] = []
    @Published var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    let urlStrUsersData = "https://api.github.com/users"
    
    func fetchUsers() {
        let url = URL(string: urlStrUsersData)!
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [DataModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] users in
                self?.users = users
            })
            .store(in: &cancellables)
    }
    
    
    func fetchRepos(forUser login: String) {
        let url = URL(string: "https://api.github.com/users/\(login)/repos")!
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Repos].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] repos in
                self?.repos = repos
            })
            .store(in: &cancellables)
    }

}
