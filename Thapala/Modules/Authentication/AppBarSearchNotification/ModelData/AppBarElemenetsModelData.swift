//
//  AppBarElemenetsModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 16/06/25.
//

import Foundation

struct SuggestionResponse: Codable {
    let message: String
    let data: [EmailItem]
    let count: Counts
}

struct Counts: Codable {
    let totalCount: Int
}

struct EmailItem: Codable, Identifiable {
    var id: Int { emailId ?? 0 } // Conform to Identifiable

    let firstname: String?
    let lastname: String?
    let emailId: Int?
    let threadId: Int?
    let subject: String?
    let body: String?
    let labels: [labelData]
    let senderUserId: Int?
    let draft: Int?
    let senderId: Int?
    let type: String?
    let sentAt: Int?
    let tCodeHidden: Int?
    let tCode: String?
    let status: String?
    let recordId: Int?
    let snooze: Int?
    let snoozeAt: Int?
    let isDeleted: Int?
    let readReceiptStatus: Int?
    let passwordHash: String?
    let passwordHint: String?
    let passwordProtected: Int?
    let isChecked: Int?
    var starred: Int?
    let senderProfile: String?
    let attachments: [attachment]
    let emailCountInThread: Int?
    let hasDraft: Int?
    let snoozeAtThread: Int?
    let snoozeThread: Int?
}

struct attachment: Codable {
    let id: Int?
    let fileName: String?
    let azureFileName: String?
    let fileSize: String?
}


struct labelData: Codable { // <-- Add this
    let labelId: Int?
    let labelName: String?
}



enum searchOptions {
    case allMails
    case Queue
    case PostBox
    case Conveyed
}


// Get Notification

struct NotificationResponse: Codable {
    let message: String
    let data: [NotificationItem]
}

struct NotificationItem: Codable, Identifiable {
    let id: Int
    let type: String?
    let title: String?
    let body: String?
    let viewed: Bool
    let receiverId: Int?
    let senderId: Int?
    let createdAt: String?
    let updatedAt: String?
}

