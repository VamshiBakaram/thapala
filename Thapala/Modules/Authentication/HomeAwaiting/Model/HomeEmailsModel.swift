//
//  HomeEmailsModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 04/06/24.
//

import Foundation

struct HomeEmailsModel: Decodable {
    let message: String?
    let data: [HomeEmailsDataModel]?
    let count: Count?
}

struct Count: Decodable {
    let totalCount: Int?
    let readCount, unreadCount: String?
}

struct HomeEmailsDataModel: Decodable,Identifiable,Hashable {
    var idm = UUID()
    let id:Int?
    var firstname, lastname: String?
    let threadID: Int?
    let status: String?
    let readReceiptStatus: Int? //1 read,0 unread
    let passwordHash, passwordHint: String?
    let passwordProtected, isChecked: Int?
    let type: String?
    var starred: Int?
    let labels: [Label]?
    let subject, body: String?
    var sentAt, senderUserID: Int?
    var isSelected: Bool = false
    let senderProfile:String?
    var isStarred: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, firstname, lastname,senderProfile
        case threadID = "threadId"
        case status, readReceiptStatus, passwordHash, passwordHint, passwordProtected, isChecked, type, starred, labels, subject, body, sentAt
        case senderUserID = "senderUserId"
    }
}

struct Label: Decodable,Hashable {
    let labelId: Int?
    let labelName: String?
}

// Delete postBox email - Delete Api
struct DeleteEmailModel: Decodable {
    let message: String?
    let status: Int?
}

// payload of delete Api
struct DeleteEmailpayload: Codable {
    let ids: [Int]
}

struct MarkAsReadEmailModel: Decodable {
    let message: String?
    let status: Int?
}
struct MarkAsUnReadEmailModel: Decodable {
    let message: String?
    let status: Int?
}

struct MoveEmailToFolderModel: Decodable {
    let message: String?
    let emailsMoved: Int?
}

struct MoveToFolderParams: Encodable {
    let folderId: Int
    var recordName: String
    var makeACopy: Bool
    var emailIds:[Int]
}

// starred model

struct StarredModel: Decodable {
    let message: String?
    let status: Int?
}

// snoozed emails

struct SnoozeResponse: Codable {
    let status: Bool
    let snoozedAt: TimeInterval
}


