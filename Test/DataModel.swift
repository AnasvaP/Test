//
//  MyManager.swift
//  Test
//
//  Created by Anastasiia Poliuchovych on 22.03.2023.
//

import Foundation

// MARK: - User
struct DataModel: Codable, Identifiable {
    let login: String
    let id: Int
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}

struct Repos: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
    }
}
