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
    let labels: [label]?
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


// Placeholder for Label structure if not already defined:
struct label: Decodable, Hashable {
    let id: Int
    let name: String
}


//struct HomeDraftsModel: Codable {
//    let message: String
//    let data: [DraftEmail]
//}
//
//struct HomeDraftsDataModel: Codable {
//    let id: Int
//    let emailId: Int
//    let threadId: Int
//    let isChecked: Int
//    let status: String
//    let type: String
//    let userId: Int
//    let senderId: Int
//    let firstName: String
//    let lastName: String
//    let tCode: String
//    let recipients: [Recipients]
//    let attachments: [String] // adjust if attachments have structure
//    let labels: [String] // adjust if labels have structure
//    let emailCountInThread: Int
//    let hasDraft: Int
//    let snoozeAtThread: Int?
//    let snoozeThread: Int?
//    let subject: String
//    let body: String
//    let draft: Int
//    let emailType: String
//    let passwordProtected: Int
//    let passwordHint: String?
//    let createdAt: String
//    let parentSubject: String?
//}
//
//struct Recipients: Codable {
//    let type: String
//    let user: RecipientUser
//}
//
//struct RecipientUser: Codable {
//    let id: Int
//    let tCode: String
//    let lastname: String
//    let firstname: String
//    let tCodeHidden: Int
//}


//struct HomeDraftsModel: Codable {
//    let message: String
//    let data: [HomeDraftsDataModel]
//    let count: DraftsCount
//}
//
//struct DraftsCount: Codable {
//    let totalCount: Int
//}
//
//struct HomeDraftsDataModel: Codable {
//    let id: Int
//    let emailId: Int
//    let threadId: Int
//    let isChecked: Int
//    let status: String
//    let type: String
//    let userId: Int
//    let senderId: Int
//    let firstName: String
//    let lastName: String
//    let tCode: String
//    let recipients: [Recipients]
//    let attachments: [String]
//    let labels: [String]
//    let emailCountInThread: Int
//    let hasDraft: Int
//    let snoozeAtThread: String?
//    let snoozeThread: String?
//    let subject: String
//    let body: String
//    let draft: Int
//    let emailType: String
//    let passwordProtected: Int
//    let passwordHint: String?
//    let createdAt: String
//    let parentSubject: String?
//}
//
//struct Recipients: Codable {
//    let type: String
//    let user: RecipientsUser
//}
//
//struct RecipientsUser: Codable {
//    let id: Int
//    let tCode: String
//    let lastname: String
//    let firstname: String
//    let tCodeHidden: Int
//}
