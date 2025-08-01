//
//  ContactsModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//

import Foundation

struct ContactsModel: Decodable {
    let message: String?
    let data: [ContactsDataModel]?
}

struct ContactsDataModel: Decodable,Identifiable {
    let roomID: String?
    let id: Int?
    let tCodeHidden: Int?
    let firstname: String?
    let lastname: String?
    let tCode: String?
    let profile: String?

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case id, tCodeHidden, firstname, lastname, tCode, profile
    }
}

