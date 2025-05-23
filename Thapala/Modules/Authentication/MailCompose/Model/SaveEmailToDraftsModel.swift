//
//  SaveEmailToDraftsModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 04/07/24.
//

import Foundation

struct SaveEmailToDraftsModel: Decodable {
    let message: String?
    let emailData: EmailDraftsData?
    let userData: [SenderUserData]?
    let notFoundTCodes: [String]?
}

struct EmailDraftsData: Decodable {
    let id: Int?
    let subject, body: String?
    let passwordProtected, draft: Bool?
    let type: String?
    let attachments: [String]?
    let passwordHash, passwordHint: String?
    let scheduledStatus, scheduledTime: String?
    let senderID: Int?
    let updatedAt, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, subject, body, passwordProtected, draft, type, attachments, passwordHash, passwordHint, scheduledStatus, scheduledTime
        case senderID = "senderId"
        case updatedAt, createdAt
    }
}

struct SenderUserData: Decodable {
    let isDeleted, starred: Bool?
    var id, emailID, threadID: Int?
    let type: String?
    let userID: Int?
    let status: String?
    let readReceiptStatus: Bool?
    let timeOfRead: Int?
    let updatedAt, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case isDeleted, starred, id
        case emailID = "emailId"
        case threadID = "threadId"
        case type
        case userID = "userId"
        case status, readReceiptStatus, timeOfRead, updatedAt, createdAt
    }
}

// Draft View delete trash bottom button
struct DraftClearResponse: Codable {
    let message: String
}

struct ClearDraftRequest: Codable {
    let emailId: Int
}
