//
//  ConveyedModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 03/10/24.
//

import Foundation

//struct ConveyedModel: Decodable {
//    let message: String?
//    let data: [ConveyedData]?
//    let count: Count?
//}
//
//struct ConveyedData: Decodable,Identifiable {
//    let id: Int?
//    let firstname, lastname, tCode: String?
//    let threadID: Int?
//    let status: ConveyStatus?
//    let readReceiptStatus: Int?
//    let passwordHash, passwordHint: String?
//    let passwordProtected, isChecked: Int?
//    let type: String?
//    let starred: Int?
//    let labels: [String]?
//    let subject: String?
//    let body: String?
//    let sentAt, senderUserID: Int?
//    var senderProfile: String?
//    let attachments: [ConveyAttachment]?
//    let hasDraft, emailCountInThread: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, firstname, lastname, tCode
//        case threadID = "threadId"
//        case status, readReceiptStatus, passwordHash, passwordHint, passwordProtected, isChecked, type, starred, labels, subject, body, sentAt
//        case senderUserID = "senderUserId"
//        case senderProfile, attachments, hasDraft, emailCountInThread
//    }
//}
//
//struct ConveyAttachment: Decodable {
//     let id: Int?
//     let fileName, fileSize, azureFileName: String?
// }
//
//enum ConveyStatus: String, Decodable {
//     case awaited = "awaited"
// }
//
//enum ConveyTypeEnum: String, Decodable {
//     case from = "from"
// }


struct ConveyedModel: Decodable {
    let message: String?
    let data: [ConveyedData]?
    let count: CountConveyed?
}

struct CountConveyed: Decodable {
    let totalCount: Int?
}

//struct ConveyedData: Decodable, Identifiable {
//    var id: Int {
//        return threadID ?? 0
//    }
//    
//    var firstname: String?
//    var lastname: String?
//    var tCode: String?
//    var threadID: Int?
//    var status: StatusConveyed?
//    var readReceiptStatus: Int?
//    var passwordHash: String?
//    var passwordHint: String?
//    var passwordProtected: Int?
//    var isChecked: Int?
//    var type: TypeEnumConveyed?
//    var starred: Int?
//    var labels: [Label]?
//    var subject: String?
//    var body: String?
//    var sentAt: Int?
//    var senderUserID: Int?
//    var senderProfile: String?
//    var attachments: [AttachmentConveyed]?
//    var hasDraft: Int?
//    var emailCountInThread: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, firstname, lastname, tCode
//        case threadID = "threadId"
//        case status, readReceiptStatus, passwordHash, passwordHint, passwordProtected, isChecked, type, starred, labels, subject, body, sentAt
//        case senderUserID = "senderUserId"
//        case senderProfile, attachments, hasDraft, emailCountInThread
//    }
//}
struct ConveyedData: Identifiable, Decodable {
    var id: Int {
        return threadID ?? 0
    }
    
    var firstname: String?
    var lastname: String?
    var tCode: String?
    var threadID: Int?
    var status: StatusConveyed?
    var readReceiptStatus: Int?
    var passwordHash: String?
    var passwordHint: String?
    var passwordProtected: Int?
    var isChecked: Int?
    var type: TypeEnumConveyed?
    var starred: Int?
    var labels: [Label]?
    var subject: String?
    var body: String?
    var sentAt: Int?
    var senderUserID: Int?
    var senderProfile: String? = nil
    var attachments: [AttachmentConveyed]?
    var hasDraft: Int?
    var emailCountInThread: Int?
    var isStarred: Bool = false
    
    // Explicit initializer for Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.firstname = try? container.decode(String.self, forKey: .firstname)
        self.lastname = try? container.decode(String.self, forKey: .lastname)
        self.tCode = try? container.decode(String.self, forKey: .tCode)
        self.threadID = try? container.decode(Int.self, forKey: .threadID)
        self.status = try? container.decode(StatusConveyed.self, forKey: .status)
        self.readReceiptStatus = try? container.decode(Int.self, forKey: .readReceiptStatus)
        self.passwordHash = try? container.decode(String.self, forKey: .passwordHash)
        self.passwordHint = try? container.decode(String.self, forKey: .passwordHint)
        self.passwordProtected = try? container.decode(Int.self, forKey: .passwordProtected)
        self.isChecked = try? container.decode(Int.self, forKey: .isChecked)
        self.type = try? container.decode(TypeEnumConveyed.self, forKey: .type)
        self.starred = try? container.decode(Int.self, forKey: .starred)
        self.labels = try? container.decode([Label].self, forKey: .labels)
        self.subject = try? container.decode(String.self, forKey: .subject)
        self.body = try? container.decode(String.self, forKey: .body)
        self.sentAt = try? container.decode(Int.self, forKey: .sentAt)
        self.senderUserID = try? container.decode(Int.self, forKey: .senderUserID)
        self.senderProfile = try? container.decode(String.self, forKey: .senderProfile)
        self.attachments = try? container.decode([AttachmentConveyed].self, forKey: .attachments)
        self.hasDraft = try? container.decode(Int.self, forKey: .hasDraft)
        self.emailCountInThread = try? container.decode(Int.self, forKey: .emailCountInThread)
    }
    
    enum CodingKeys: String, CodingKey {
        case firstname, lastname, tCode
        case threadID = "threadId"
        case status, readReceiptStatus, passwordHash, passwordHint, passwordProtected, isChecked, type, starred, labels, subject, body, sentAt
        case senderUserID = "senderUserId"
        case senderProfile, attachments, hasDraft, emailCountInThread
    }
}


struct AttachmentConveyed: Decodable {
    let id: Int
    let fileName: String?
    let fileSize: String?
    let azureFileName: String?
}

enum StatusConveyed: String, Decodable {
    case awaited = "awaited"
    // Add a fallback case if JSON contains an unexpected value
    case unknown

    // Handle unknown enum cases to avoid decoding failures
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = StatusConveyed(rawValue: rawValue ?? "") ?? .unknown
    }
}

enum TypeEnumConveyed: String, Decodable {
    case from = "from"
    // Add a fallback case for unknown values
    case unknown

    // Handle unknown enum cases similarly
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try? container.decode(String.self)
        self = TypeEnumConveyed(rawValue: rawValue ?? "") ?? .unknown
    }
}
