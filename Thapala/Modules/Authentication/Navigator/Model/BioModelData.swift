//
//  NavigatorBioModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 02/07/24.
//

//import Foundation
//
//struct NavigatorBioModel: Decodable {
//    let message: String?
//    let bio: Bio?
//    let user: UserDataModel?
//}
//
//struct UserDataModel: Decodable {
//    let tCode, firstName, lastName: String?
//    let tCodeHidden: Bool?
//}
//
//struct Bio: Decodable {
//    let birthDate: String?
//    let userID: Int?
//    let phoneNumber, gender: String?
//    let nationality: String?
//    let languages: String?
//    let hobbies: String?
//    let profile, croppedProfile: String?
//    let country, place: String?
//    let aboutUs: String?
//    let city, state, screenName: String?
//
//    enum CodingKeys: String, CodingKey {
//        case birthDate
//        case userID = "userId"
//        case phoneNumber, gender, nationality, languages, hobbies, profile, croppedProfile, country, place, aboutUs, city, state, screenName
//    }
//}

import Foundation

struct NavigatorBioModel: Codable {
    let message: String
    let bio: Bio?
    let user: UserDataModel?
}

struct Bio: Codable {
    let id: Int
    let birthDate: String
    let userId: Int
    let phoneNumber: String
    let gender: String
    let nationality: String?
    let languages: String
    let hobbies: String?
    let profile: String?
    let croppedProfile: String?
    let azureProfileName: String?
    let privateKey: String?
    let country: String
    let place: String
    let aboutUs: String
    let city: String
    let state: String
    let screenName: String?
    let createdAt: String
    let updatedAt: String
}

struct UserDataModel: Codable {
    let tCode: String
    let firstName: String
    let lastName: String
    let tCodeHidden: Bool
}


// latest login Bio View

struct LastestLoginModel: Decodable {
    let message: String?
    let data: [LastestLoginDataModel]?
}

struct LastestLoginDataModel: Decodable {
    let createdAt: String?
    let lastLogin: Int?
}
