//
//  StarredEmailModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/10/24.
//

import SwiftUI
import Foundation

struct StarredEmailModel: Decodable {
    let message: String?
    let data: [StarredEmailDataModel]?
    let count: StarredEmailCount?
}

struct StarredEmailCount: Decodable{
    let totalCount: Int?
}

struct StarredEmailDataModel: Decodable,Identifiable {
    let id = UUID()
    let emailId: Int?
    let threadId: Int?
    let status: String?
    let readReceiptStatus: Int?
    let timeOfRead: Int?
    let type: String?
    let userId: Int?
    let sentAt: Int?
    let subject: String?
    let body: String?
    let passwordProtected: Int?
    let passwordHint: String?
    let starred: Int?
    let isChecked: Int?
    let passwordHash: String?
    let firstname: String?
    let lastname: String?
    let tCode: String?
    let senderProfile: String?
    let attachments: [SttaredEmailAttachment]?
    let labels: [Int]?
    let emailCountInThread: Int?
    let hasDraft: Int?
    let snoozeAtThread: Int?
    let snoozeThread: Int?
    
    enum CodingKeys: String, CodingKey {
        case emailId, threadId, status, readReceiptStatus, timeOfRead, type, userId,
             sentAt, subject, body, passwordProtected, passwordHint, starred, isChecked,
             passwordHash, firstname, lastname, tCode, senderProfile, attachments,
             labels, emailCountInThread, hasDraft, snoozeAtThread, snoozeThread
    }
}

struct SttaredEmailAttachment: Decodable {
    let id: Int?
    let fileName: String?
    let fileSize: String?
    let azureFileName: String?
}

//put starred unstarred

struct StarEmailResponse: Codable {
    let message: String
}

