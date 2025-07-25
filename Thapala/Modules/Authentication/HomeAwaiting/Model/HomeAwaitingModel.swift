//
//  HomeAwaitingModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import Foundation

struct DummyData:Identifiable{
    let id = UUID()
    let image:String
    let title:String
    let subTitle:String
    let finalTitle:String
}

enum Option {
    case email
    case print
    case outline
}

enum OutlineOption {
    case draft
    case tDraft
    case schedule
    case tLetters
    case tCards
}

// Drafts Model
struct HomeDraftsModel: Decodable {
    let message: String?
    let data: [HomeDraftsDataModel]?
    let count: DraftsCount?
}

struct DraftsCount: Decodable {
    let totalCount: Int?
}

struct HomeDraftsDataModel: Decodable, Identifiable, Hashable {
    let id, emailID, threadID, isChecked: Int?
    let status: Status?
    let type: TypeEnum?
    let userID: Int?
    let labels: [QueueLabelItems]?
    let subject, body: String?
    let firstName: String?
    let lastName: String?
    let tCode: String?
    let attachments: [String]?
    let parentSubject: String?
    let draft, passwordProtected: Int?
    let passwordHint: String?
    let createdAt: String?
    var isSelected: Bool = false
    let recipients: [Recipients]
    var scheduledTime : Int?
    enum CodingKeys: String, CodingKey {
        case id
        case emailID = "emailId"
        case threadID = "threadId"
        case isChecked, status, type
        case userID = "userId"
        case labels, subject, body, draft, passwordProtected, passwordHint, createdAt
        case firstName, lastName, tCode, attachments, parentSubject
        case recipients ,scheduledTime
    }
}


enum Status: String, Decodable {
    case draft = "draft"
    case scheduled = "scheduled"
}

enum TypeEnum: String, Decodable {
    case from = "from"
    case to = "to"
}

struct QueueLabelItems: Decodable, Hashable {
    let labelId: Int
    let labelName: String
    var id: Int { labelId } // For Identifiable
}

struct Recipients: Decodable, Hashable {
    let type: String
    let user: RecipientUser
}

struct RecipientUser: Decodable, Hashable {
    let id: Int
    let tCode: String
    let lastname: String
    let firstname: String
    let tCodeHidden: Int
}


//-----------------------------------------------
// create Label post APi

struct CreateLabelResponse: Codable {
    let message: String
    let data: Labeldata
}

// The `data` object inside the response
struct Labeldata: Codable, Identifiable {
    let id: Int
    let userId: Int
    let labelName: String
    let updatedAt: String
    let createdAt: String
}

// create label pay load

struct CreateLabelRequest: Codable {
    let labelName: String
}


//------------------------------------------------

// Apply Label post APi
struct ApplyLabelResponse: Codable {
    let message: String
}

// payload
struct ApplyLabelRequest: Codable {
    let labelIds: [Int]
    let threadIds: [Int]
}
