//
//  BluePrintModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 15/05/25.
//

import Foundation

struct SaveDraftResponse: Codable {
    let message: String
    let emailData: EmailData
    let userData: [Userdatum]
    let notFoundTCodes: [String]
}

struct EmailData: Codable {
    let id: Int
    let subject: String
    let body: String
    let passwordProtected: Bool
    let draft: Bool
    let type: String
    let attachments: String?
    let passwordHash: String?
    let passwordHint: String?
    let scheduledStatus: String?
    let scheduledTime: String?
    let senderId: Int
    let updatedAt: String
    let createdAt: String
}

struct Userdatum: Codable {
    let isDeleted: Bool
    let starred: Bool
    let snooze: Bool
    let id: Int
    let emailId: Int
    let threadId: Int
    let type: String
    let userId: Int
    let status: String
    let readReceiptStatus: Bool
    let timeOfRead: Int?
    let mailStatus: String
    let updatedAt: String
    let createdAt: String
}


struct EmailPayload: Codable {
    let to: [String]
    let cc: [String]
    let bcc: [String]
    let subject: String
    let body: String
}
