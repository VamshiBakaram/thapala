//
//  PostboxModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 02/07/24.
//

import Foundation

// postBoxMails Get Api
struct PostboxModel: Decodable {
    let message: String?
    let data: [PostboxDataModel]?
    let count: CountData?
}

struct CountData: Decodable {
    let totalCount: Int?
    let readCount, unreadCount: String?
}

struct PostboxDataModel: Decodable,Identifiable,Hashable {
    let id: Int?
    let firstname, lastname: String?
    let threadID: Int?
    let status: Status?
    let readReceiptStatus: Int?
    let passwordHash, passwordHint: String?
    let passwordProtected, isChecked: Int?
    let type: String?
    var starred: Int?
    let labels: [Label]?
    let subject: String?
    let body: String?
    let sentAt, senderUserID: Int?
    var isStarred: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, firstname, lastname
        case threadID = "threadId"
        case status, readReceiptStatus, passwordHash, passwordHint, passwordProtected, isChecked, type, starred, labels, subject, body, sentAt
        case senderUserID = "senderUserId"
    }
    
    enum Status: String, Codable {
        case postbox = "postbox"
    }

    enum TypeEnum: String, Codable {
        case to = "to"
    }
}



enum PostBoxOptions {
    case emails
    case print
    case chatbox
}

struct Message: Identifiable,Equatable {
    let id = UUID()
    let text: String
    let isSentByUser: Bool
    let timestamp: Date
}


// chat list Get Api

struct ContactResponse: Codable {
    let message: String
    let data: contactData
}

struct contactData: Codable {
    let chatBackground: String?
    let chatBlockedUsers: [Int]
    let blockedUsers: [Int]
    let contacts: [contact]
}

struct contact: Codable, Identifiable {
    let roomId: String
    let createdAt: Int
    let expiredAt: Int
    let isPinned: Int
    let id: Int
    let firstname: String
    let lastname: String
    let tCode: String
    let tCodeHidden: Int
    let isOnline: Int
    let profile: String?
    let unreadCount: Int
    let recentMessage: String?
    let recentMessageDate: Int?
}

// chat Box
struct SentMessage: Identifiable, Codable {
    var id = UUID()
    var message: String
    var createdAt: String
    var isRight: Bool
    var messageType: String
    var senderId: Int
    var receiverId: Int
    var connectionType: String
    var seen: Bool
    var roomId: String
    var attachments: [String]
}

// Get chat Contacts Gety api
struct ChatContactresponse: Codable {
    let message: String
    let data: [chatContacts]
}

struct chatContacts: Codable, Identifiable {
    let roomId: String
    let id: Int
    let tCodeHidden: Int
    let firstname: String
    let lastname: String
    let tCode: String
    let profile: String?
}


// GetApi chat

struct ChatAPIResponse: Codable {
    let message: String
    let data: ChatData
}

struct ChatData: Codable {
    let totalMessages: Int
    let messages: [ChatMessage]
}

struct ChatMessage: Codable, Identifiable {
    let id: Int
    let message: String
    let date: Int64
    let isRight: Bool
    let messageType: String
    let senderId: Int
    let connectionType: String
    let seen: Bool
    let receiverId: Int
    let roomId: String
    let attachments: [String]
    let createdAt: String
    let updatedAt: String

    // Optional computed property for SwiftUI-friendly Date
    var formattedDate: Date {
        Date(timeIntervalSince1970: TimeInterval(date) / 1000)
    }
}

