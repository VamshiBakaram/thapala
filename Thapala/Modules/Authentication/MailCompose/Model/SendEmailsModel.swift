//
//  SendEmailsModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 10/06/24.
//

import Foundation

struct SendEmailsModel: Decodable {
    let message: String?
    let emailData: SendEmailData?
    let userData: [UserDatum]?
    let notFoundTCodes: [String]?
}

struct SendEmailData: Decodable {
    let id: Int?
    let subject: String?
    let body: String?
    let passwordProtected: Bool?
    let draft: Bool?
    let type: String?
    let attachments: String?
    let passwordHash: String?
    let passwordHint: String?
    let scheduledStatus: String?
    let scheduledTime: String?
    let senderID, sentAt: Int?
    let updatedAt, createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id, subject, body, passwordProtected, draft, type, attachments, passwordHash, passwordHint, scheduledStatus, scheduledTime
        case senderID = "senderId"
        case sentAt, updatedAt, createdAt
    }
}

struct UserDatum: Decodable {
    let isDeleted: Bool?
    let starred: Bool?
    let id: Int?
    let emailID: Int?
    let threadID: Int?
    let type: String?
    let userID: Int?
    let status: String?
    let sentAt: Int?
    let readReceiptStatus: Bool?
    let timeOfRead: Int?
    let updatedAt: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case isDeleted, starred, id
        case emailID = "emailId"
        case threadID = "threadId"
        case type
        case userID = "userId"
        case status, sentAt, readReceiptStatus, timeOfRead, updatedAt, createdAt
    }
}

struct SendEmailParams: Encodable {
    let to: [String]?
    var cc: [String]? = nil
    var bcc: [String]? = nil
    let subject: String?
    let body: String?
    var scheduledTime: String? = nil
    var passwordHint: String? = nil
    var threadId: String? = nil
    var draftMailId: Int? = nil
    var replyToId: String? = nil
    var attachments: [AttachmentDataModel]? = nil
}



struct AttachmentModel: Decodable {
    let message: String?
    let attachments: [AttachmentDataModel]?
}

struct AttachmentDataModel: Codable {
    let fileLink: String?
    let fileName: String?
    let azureFileName: String?
    let fileSize: String?
}
struct TcodeSuggest: Decodable {
    var data: [TcodeData]?
}

struct TcodeData: Decodable,Identifiable,Hashable {
    var tCode: String?
    var firstname: String?
    var lastname: String?
    var id: Int?
    var tCodeHidden: Int?
    var croppedProfile: String?
}


// added this on 16/11/2024

struct EmailResponse: Decodable {
    let message: String
    let email: [Email]
}

// Email model
struct Email: Decodable {
    let threadId: Int
    let replyToId: Int?
    let subject: String
    let body: String
    let passwordProtected: Int
    let passwordHash: String?
    let passwordHint: String?
    let scheduledTime: String?
    let scheduledStatus: String?
    let draft: Int
    let sentAt: String?
    let labels: [String]
    let snoozeAtThread: String?
    let snoozeThread: String?
    let parentSubject: String
    let emailId: Int
    let recipients: [EmailRecipient]  // Renamed to avoid conflicts
    let attachments: [EmailAttachment]? // Renamed to avoid conflicts
}

// Recipient model
struct EmailRecipient: Decodable {
    let type: String
    let user: EmailUser  // Renamed for clarity
    let labels: [String]
    let userId: Int
    let starred: Int
    let connection: Int
    let timeOfRead: Int?
}

// User model
struct EmailUser: Decodable {  // Renamed for clarity
    let id: Int
    var tCode: String
    let profile: String?
    let lastname: String
    let userType: String
    let firstname: String
    let tCodeHidden: Int
}

// Attachment model
struct EmailAttachment: Decodable {  // Renamed to avoid conflicts
    let fileName: String?
    let fileURL: String?
}
