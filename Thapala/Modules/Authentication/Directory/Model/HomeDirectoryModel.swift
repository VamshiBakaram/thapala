//
//  HomeDirectoryModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/10/24.
//

import Foundation

enum DirectoryOption {
    case tContacts
    case test
    case test2
}

struct DirectoryResponse: Decodable {
    let message: String
    let data: DirectoryUserData
}

struct DirectoryUserData: Decodable {
    let blockedUsers: [Int]?
    let results: [Users]
    let totalCount: DirectoryTotalCount
}

struct Users: Decodable, Identifiable {
    let userId: Int
    let firstname: String
    let lastname: String
    let tCode: String
    let groupIds: [Int]
    let country: String?
    let place: String?
    let city: String?
    let profile: String?
    let croppedProfile: String?
    let state: String?
    let blockedUsers: [Int]?
    
    // Computed property for full name
    var fullName: String {
        "\(firstname) \(lastname)"
    }
    
    // Conforming to Identifiable
    var id: Int {
        userId
    }
    
    // CodingKeys if needed for different case conventions
    enum CodingKeys: String, CodingKey {
        case userId
        case firstname
        case lastname
        case tCode
        case groupIds
        case country
        case place
        case city
        case profile
        case croppedProfile
        case state
        case blockedUsers
    }
}

struct DirectoryTotalCount: Decodable {
    let totalCount: Int
}




// Dummy Contact model
struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}



// Get profile Data By ID

struct ProfileResponse: Identifiable, Decodable {
    var id: Int?
    var message: String
    var bio: BioData
    var user: user
}

struct BioData: Decodable {
    var id: Int
    var birthDate: String?
    var userId: Int
    var phoneNumber: String?
    var gender: String?
    var nationality: String?
    var languages: String?
    var hobbies: String?
    var profile: String
    var croppedProfile: String
    var azureProfileName: String
    var privateKey: String?
    var country: String?
    var place: String?
    var aboutUs: String?
    var city: String?
    var state: String?
    var screenName: String?
    var createdAt: String
    var updatedAt: String
}

struct user: Decodable {
    var tCode: String
    var firstName: String
    var lastName: String
    var tCodeHidden: Bool
}


// Post create Group

struct CreateGroupResponse: Codable {
    let message: String
    let data: GroupData
}

struct GroupData: Codable {
    let id: Int
    let groupName: String
    let userId: Int
    let updatedAt: String
    let createdAt: String
}

struct CreateGroupRequest: Codable {
    let groupName: String
}

// Get Group List

struct GroupResponse: Codable {
    let message: String
    let data: [GroupList]
}

struct GroupList: Codable, Identifiable {
    let id: Int
    let groupName: String
    let createdAt: String
    let updatedAt: String
    let totalMembers: Int
}

// country codes

struct CountryCodes: Decodable, Hashable {
    let name: String
    let dial_code: String
    let code: String
}

struct CountryData: Codable, Equatable {
    var countries: [SingleCountry]

    enum CodingKeys: String, CodingKey {
        case countries = "Countries"
    }
}

struct SingleCountry: Codable, Identifiable, Hashable {
    var id = UUID()
    var countryName: String
    var states: [States]

    enum CodingKeys: String, CodingKey {
        case countryName = "CountryName"
        case states = "States"
    }
}

struct States: Codable, Identifiable, Hashable {
    var id = UUID()
    var stateName: String
    var cities: [String]

    enum CodingKeys: String, CodingKey {
        case stateName = "StateName"
        case cities = "Cities"
    }
}
