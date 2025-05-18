//
//  CreateAccountModel.swift
//  Thapala
//
//  Created by ahex on 26/04/24.
//

import Foundation


struct CountryCode: Decodable, Hashable {
    let name: String
    let dial_code: String
    let code: String
}

struct CreateAccount: Encodable {
    let firstname: String
    let lastname: String
    let countryCode: String
    let country:String
    let phoneNumber: String
}

struct CreateAccountModel: Decodable {
    let message: String?
    let status: Int?
    let sessionId: String?
}
