//
//  ChangePasswordModel.swift
//  Thapala
//
//  Created by ahex on 30/04/24.
//

import Foundation
struct CreatePasswordModel: Decodable {
    let message:String?
    let user:UserDetailsModel?
}
struct UserDetailsModel:Decodable{
    let countryCode:String?
    let firstname:String?
    let id:Int?
    let lastname:String?
    let phoneNumber:String?
    let tCode:String?
}

struct CreatePasswordParams: Encodable {
    let password: String
    let timeZone: String
}
