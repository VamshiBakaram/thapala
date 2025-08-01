//
//  SnoozedMailsModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/10/24.
//

import SwiftUI
import Foundation

struct SnoozedMailsModel: Decodable {
    let message: String?
    let data: [SnoozedMailsDataModel]?
    let count: SnoozedEmailCount?
}


struct SnoozedMailsDataModel: Decodable,Identifiable {
    let id = UUID()
    let emailId: Int?
    let threadId: Int?
    let status: String?
    let readReceiptStatus: Int?
    let timeOfRead: Int?
    let type: String?
    let userId: Int?
    let sentAt: Int?
    let snooze: Int?
    let snoozeAt: Int?
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
    let attachments: [String]?
    let labels: [snnozedLabelItems]?
    let emailCountInThread: Int?
    let hasDraft: Int?
    let snoozeAtThread: Int?
    let snoozeThread: Int?
}

struct SnoozedEmailCount: Decodable {
    let totalCount: Int?
}


struct snnozedLabelItems: Codable, Identifiable, Equatable {
    let labelId: Int
    let labelName: String
    var id: Int { labelId } // For Identifiable
}
