//
//  HomeMenuModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import Foundation

struct HomeMenuData: Identifiable, Hashable {
    let id = UUID()
    let image: String
    let menuType: String

    static func == (lhs: HomeMenuData, rhs: HomeMenuData) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// signout or Logout - Post APi

struct LogoutResponse: Codable {
    let message: String?
}

// signout payload

struct LogoutRequest: Codable {
    let userId: Int?
}
