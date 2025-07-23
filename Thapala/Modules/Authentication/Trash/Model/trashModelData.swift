//
//  trashModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 26/03/25.
//

import Foundation

struct trashResponse: Codable {
    let message: String
    let data: [Emaildata]
    let count: EmailCount
}

struct Emaildata: Codable, Identifiable {
    var id: Int { threadId }  // For SwiftUI List or ForEach use
    let emailId: Int
    let threadId: Int
    let deletedAt: Int?
    let status: String?
    let readReceiptStatus: Int?
    let isChecked: Int?
    let timeOfRead: Int?
    let type: String?
    let userId: Int?
    let sentAt: Int?
    let subject: String?
    let body: String?
    let passwordProtected: Int
    let passwordHint: String?
    let passwordHash: String?
    let tCodeHidden: Int?
    let firstname: String?
    let lastname: String?
    let tCode: String?
    let senderProfile: String?
    let attachments: [attachments]
    let labels: [LabelItems]
    let emailCountInThread: Int
    let hasDraft: Int
}

struct EmailCount: Codable {
    let totalCount: Int
}

struct LabelItems: Codable, Identifiable, Equatable {
    let labelId: Int
    let labelName: String
    var id: Int { labelId } // For Identifiable
}

struct attachments: Codable {
    // Add fields here once attachment details are known
}

// --------------------------------------------------------------------------------------------------------------

// Get records file Trash Data
struct FileTrashResponse: Codable {
    let message: String
    let data: [TrashItem]
}

struct TrashItem: Codable, Identifiable {
    let id: Int
    let fileName: String
    let azureFileName: String
    let fileLink: String
    let fileSize: String
    let folderId: Int
    let isDeleted: Int
    let deletedAt: Int
    let userId: Int
    let type: String
    let subFolderType: String
    let createdAt: String
    let updatedAt: String
    let isChecked: Int
    
    var cleanedFileName: String {
        return fileName.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
    }
    
    var cleanedFileLink: String {
        return fileLink.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
    }

    var cleanedFileSize: String {
        return fileSize.replacingOccurrences(of: "Optional(\"", with: "").replacingOccurrences(of: "\")", with: "")
    }
}


// --------------------------------------------------------------------------------------------------------------


// Get file folder Trash Data

struct TrashResponseModel: Codable {
    let message: String
    let data: [TrashFolder]
}

struct TrashFolder: Identifiable, Codable {
    let id: Int
    let folderName: String
    let userId: Int
    let parentId: Int
    let type: String
    let isDeleted: Bool
    let deletedAt: Int
    let subFolderType: String
    let `default`: Bool
    let createdAt: String
    let updatedAt: String
    var isChecked: Int
}

// --------------------------------------------------------------------------------------------------------------

// Planner Get Trash

struct PlannerTrashResponse: Codable {
    let message: String
    let data: PlannerTrashData
}

struct PlannerTrashData: Codable {
    let plannerTrash: [PlannerTrashItem]
    let totalCount: Int
}

struct PlannerTrashItem: Codable {
    var id: Int
    var type: String
    var title: String
    var note: String
    let startDateTime: String?
    let endDateTime: String?
    let userId: Int
    let repeatValue: String?
    let createdTimeStamp: Int?
    let status: String?
    let reminder: String?
    let theme: String?
    let labels: [Int]
    let isDeleted: Bool
    let deletedAt: String?
    var createdAt: String
    var updatedAt: String
    var isChecked: Int

    enum CodingKeys: String, CodingKey {
        case id, type, title, note, startDateTime, endDateTime, userId
        case repeatValue = "repeat"
        case createdTimeStamp, status, reminder, theme, labels, isDeleted, deletedAt, createdAt, updatedAt, isChecked
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        title = try container.decode(String.self, forKey: .title)
        note = try container.decode(String.self, forKey: .note)
        startDateTime = try container.decodeIfPresent(String.self, forKey: .startDateTime)
        endDateTime = try container.decodeIfPresent(String.self, forKey: .endDateTime)
        userId = try container.decode(Int.self, forKey: .userId)
        repeatValue = try container.decode(String.self, forKey: .repeatValue)
        createdTimeStamp = try container.decode(Int.self, forKey: .createdTimeStamp)
        status = try container.decodeIfPresent(String.self, forKey: .status)

        // Handle reminder as String or Int
        if let reminderString = try? container.decode(String.self, forKey: .reminder) {
            reminder = reminderString
        } else if let reminderInt = try? container.decode(Int.self, forKey: .reminder) {
            reminder = String(reminderInt)
        } else {
            reminder = nil
        }

        theme = try container.decodeIfPresent(String.self, forKey: .theme)
        labels = try container.decode([Int].self, forKey: .labels)
        isDeleted = try container.decode(Bool.self, forKey: .isDeleted)

        // Handle deletedAt as String or Int
        if let deletedAtString = try? container.decode(String.self, forKey: .deletedAt) {
            deletedAt = deletedAtString
        } else if let deletedAtInt = try? container.decode(Int.self, forKey: .deletedAt) {
            deletedAt = String(deletedAtInt)
        } else {
            deletedAt = nil
        }

        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        isChecked = try container.decode(Int.self, forKey: .isChecked)
    }
}



// --------------------------------------------------------------------------------------------------------------

// Restore list item put Api

struct PlannerRestoreResponse: Codable {
    let message: String
}
// Restore put Api Payload
struct UpdateRequest: Codable {
    let ids: [Int]
}

// --------------------------------------------------------------------------------------------------------------
// delete list item Delete Api

struct DeletePlannerResponse: Codable {
    let message: String
}

struct RequestBody: Codable {
    let ids: [Int]
}

// --------------------------------------------------------------------------------------------------------------

// Restore files Tab and subfolders of files ,folders Data - post Api

struct RestoreResponse: Codable {
    let message: String
}

// Restore files - payload

struct RestoreRequest: Codable {
    let recordIds: [Int]
    let fileIds: [Int]
}

// --------------------------------------------------------------------------------------------------------------

// Delete files Tab and subfolders of files ,folders Data - post Api

struct DeletefolderResponse: Codable {
    let message: String
}

// files payload
struct DeleteFileRequests: Codable {
    let recordIds: [Int]
    let fileIds: [FileID]
}

struct FileID: Codable {
    let id: Int
    let azureFileName: String
    let type: String
    let fileSize: String
}

// folder payload

struct DeleteFolderRequests: Codable {
    let recordIds: [Int]
    let fileIds: [Int]
}

// --------------------------------------------------------------------------------------------------------------



//Restore mails  - put Api


struct RestoreMailsResponse: Codable {
    let message: String
}

// restore Mails payload

struct RestoreMailsPayload: Codable {
    let threadId: [Int]
}


// delete mail - delete Api

struct DeleteEmailResponse: Codable {
    let message: String
    let deleteCount: Int
}

struct DeleteEmailRequest: Codable {
    let emailIds: [Int]
}
