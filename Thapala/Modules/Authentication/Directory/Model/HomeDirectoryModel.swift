//
//  HomeDirectoryModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/10/24.
//

import Foundation

struct DirectoryResponse: Decodable {
    let message: String
    let data: DirectoryUserData
}

struct DirectoryUserData: Decodable {
    let currentUserBlockedUsers: [Int]?
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
    var id: Int {userId}

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
    var profile: String?
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
    let createdAt: String?
    let updatedAt: String?
    let totalMembers: Int?
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



// get search Data

import Foundation

struct searchAPIResponse: Codable {
    let message: String
    let data: searchData
}

struct searchData: Codable {
    let currentUserBlockedUsers: [Int]
    let results: [Usersearch]
    let totalCount: TotalsearchCount
}

struct Usersearch: Codable, Identifiable {
    var id: Int { userId } // For SwiftUI Lists
    let userId: Int
    let firstname: String
    let lastname: String
    let tCode: String
    let userType: String
    let country: String?
    let highlight: Int
    let groupIds: [Int]
    let place: String?
    let city: String?
    let profile: String?
    let croppedProfile: String?
    let state: String?
    let blockedUsers: [Int]?
}

struct TotalsearchCount: Codable {
    let totalCount: Int
}

//---------------------------------------------------------------------------------------------------------------------------------------

// add contacts

struct Contactresponse: Codable {
    let message: String
}
// payload of add contacts
struct AddContactRequest: Codable {
    let contact: Int
    let type: String
}

//---------------------------------------------------------------------------------------------------------------------------------------

// move to groups post Api

struct MoveToresponse: Codable {
    let message: String
}

// payload of move to groups
struct MoveToRequest: Codable {
    let userIds: [Int]
}

//---------------------------------------------------------------------------------------------------------------------------------------


// report contact post Api

struct reportContactresponse: Codable {
    let message: String
}

// payload of move to groups
struct ReportRequest: Codable {
    let description: String
    let reportType: String
    let reportJSON: ReportJSON
}

struct ReportJSON: Codable {
    let tCode: String
}


//---------------------------------------------------------------------------------------------------------------------------------------

// block Contact

struct BlockUserResponse: Codable {
    let message: String
    let data: BlockUserData
}

struct BlockUserData: Codable {
    let blockedUserId: [Int]
    let chatBlockedUsers: [Int]
}

// payload of block contact

struct blockPayloadRequest: Codable {
    let type: String
}


//---------------------------------------------------------------------------------------------------------------------------------------

//Get Group list items Data

struct MembersResponse: Codable {
    let message: String?
    let blockedUsers: [Int]?
    let data: [MemberData]?
    let totalCount: Int?
    let currentPage: Int?
    let totalPages: Int?
}

struct MemberData: Codable, Identifiable {
    let id: Int
    let groupId: Int?
    let userId: Int?
    let user: UsersData?
    let userBio: UserBio?
}

struct UsersData: Codable {
    let tcode: String?
    let lastName: String?
    let firstName: String?
    let phoneNumber: String?
}

struct UserBio: Codable {
    let city: String?
    let place: String?
    let state: String?
    let country: String?
    let profile: String?
    let croppedProfile: String?
}


// Rename the Group put Api


struct RenameGroupResponse: Codable {
    let message: String
    let data: renameData
}

struct renameData: Codable, Identifiable {
    let id: Int
    let groupName: String
    let updatedAt: String // or Date if you prefer date decoding
}


struct UpdateGroupRequest: Codable {
    let groupName: String
}


//Group  delete api

struct DeleteUserResponse: Codable {
    let message: String
}
