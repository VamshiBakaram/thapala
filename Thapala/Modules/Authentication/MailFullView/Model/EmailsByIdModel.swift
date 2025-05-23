//
//  EmailsByIdModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 06/06/24.
//

import Foundation
struct EmailsByIdModel: Decodable {
    let message: String?
    var email: [DetailedEmailData]?
}

struct DetailedEmailData: Decodable,Identifiable {
    let id = UUID().uuidString
    let threadID: Int?
    let replyToID: Int?
    let subject, body: String?
    let passwordProtected, scheduledTime: Int?
    let passwordHash, passwordHint, scheduledStatus: String?
    let draft, sentAt, emailID: Int?
    let recipients: [Recipient]?
    let attachments: [Attachment]?
    let parentSubject:String?
    let snoozeAtThread: Int?
    let snoozeThread: Int?

    enum CodingKeys: String, CodingKey {
        case threadID = "threadId"
        case replyToID = "replyToId"
        case subject, body, passwordProtected, passwordHash, passwordHint, scheduledTime, scheduledStatus, draft, sentAt
        case emailID = "emailId"
        case recipients, attachments,parentSubject , snoozeAtThread , snoozeThread
    }
}

struct Attachment: Decodable,Hashable {
    let fileLink: String?
    let fileName, azureFileName, fileSize: String?
    let id:Int
}

struct Recipient: Decodable {
    let type: String?
    let user: EmailUserData?
    let userID, starred, timeOfRead: Int?

    enum CodingKeys: String, CodingKey {
        case type, user
        case userID = "userId"
        case starred, timeOfRead
    }
}

struct EmailUserData: Decodable {
    let id,tCodeHidden:Int?
    let tCode, lastname, firstname,profile: String?
}

struct DownloFileModel: Decodable {
    let message: String?
    let status: Int?
}

struct DownloadEmailFilesParams: Encodable {
    let fileId: Int
    var type: String
    var emailId: Int
}
