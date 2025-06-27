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
    let count: EmailCountData?
}

struct PostboxDataModel: Codable, Identifiable {
    let id: Int?
    let firstname: String?
    let lastname: String?
    let tCode: String
    let tCodeHidden: Int
    let threadId: Int?
    let status: String?
    let readReceiptStatus: Int
    let passwordHash: String?
    let passwordHint: String?
    let passwordProtected: Int
    let isChecked: Int
    let type: String
    let snooze: Int
    let snoozeAt: StringOrInt?
    let labels: [String]
    let subject: String
    let body: String
    let sentAt: Int?
    let senderUserId: Int
    let senderProfile: String?
    let attachments: [String]
    let emailCountInThread: Int
    var starred: Int
    let hasDraft: Int
    let snoozeAtThread: StringOrInt?
    let snoozeThread: StringOrInt??
    var isStarred: Bool = false

    // Coding keys for mapping JSON keys to Swift properties
    enum CodingKeys: String, CodingKey {
        case id, firstname, lastname, tCode, tCodeHidden, threadId, status, readReceiptStatus,
             passwordHash, passwordHint, passwordProtected, isChecked, type, snooze, snoozeAt,
             labels, subject, body, sentAt, senderUserId, senderProfile, attachments,
             emailCountInThread, starred, hasDraft, snoozeAtThread, snoozeThread
    }
}


struct EmailCountData: Codable {
    let totalCount: Int
    let readCount: String
    let unreadCount: String
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

struct StringOrInt: Codable {
    let value: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.value = String(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self.value = stringValue
        } else {
            self.value = nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}
