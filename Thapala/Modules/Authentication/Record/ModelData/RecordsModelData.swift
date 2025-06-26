//
//  RecordsModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 26/05/25.
//
// get all records Data
import Foundation
struct WorkRecordsResponse: Codable ,Equatable  {
    let message: String
    let defaultRecords: [DefaultRecord]
    let records: [FolderRecord]
    let files: [FileRecord]
    let emails: [EmailRecord]
    let totalCount: Int
}

struct DefaultRecord: Codable, Identifiable , Equatable {
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
}


struct FolderRecord: Codable, Identifiable , Equatable {
    let id: Int
    let folderName: String
    let userId: Int
    let parentId: Int
    let type: String
    let isDeleted: Bool
    let deletedAt: Int?
    let subFolderType: String
    let `default`: Bool
    let createdAt: String
    let updatedAt: String
}
struct FileRecord: Codable, Identifiable , Equatable {
    let id: Int
    let fileName: String
    let azureFileName: String
    let fileLink: String
    let fileSize: String
    let folderId: Int
    let isDeleted: Bool
    let deletedAt: String?
    let userId: Int
    let type: String
    let subFolderType: String
    let createdAt: String
    let updatedAt: String
}

struct EmailRecord: Codable, Identifiable, Equatable{
    var id: Int { emailId }

    let emailId: Int
    let firstname: String
    let lastname: String
    let recordId: Int
    let threadId: Int
    let status: String
    let readReceiptStatus: Int
    let timeOfRead: Int
    let type: String
    let userId: Int
    let sentAt: Int?
    let subject: String
    let body: String
    let passwordProtected: Int
    let passwordHint: String?
    let starred: Int
    let isChecked: Int
    let passwordHash: String?
    let tCode: String
    let senderProfile: String? // <-- Must be optional if it can be null
    let attachments: [Attachments]
    let labels: [String]
    let emailCountInThread: Int
    let hasDraft: Int
}

struct Attachments: Codable ,Equatable{
    // Still empty as per current JSON
}

struct FieldID: Codable {
    let id: Int
    let azureFileName: String
}


//create folder post Api

struct CreateFolderResponse: Codable {
    let message: String
    let newRecord: FolderRecords
}

struct FolderRecords: Codable {
    let isDeleted: Bool
    let deletedAt: Bool
    let `default`: Bool
    let id: Int
    let userId: Int
    let folderName: String
    let type: String
    let parentId: Int
    let subFolderType: String
    let updatedAt: String
    let createdAt: String
}

// create folder payload post

struct CreateFolderRequest: Codable {
    let folderName: String
    let parentId: Int
    let type: String
    let subFolderType: String
}



// file attacment - post api

struct AttachmentModels: Codable {
    let message: String
    let attachments: [AttachmentDataModels]
}

struct AttachmentDataModels: Codable, Identifiable {
    let id = UUID()
    let fileLink: String
    let fileName: String
    let azureFileName: String
    let fileSize: String

    enum CodingKeys: String, CodingKey {
        case fileLink, fileName, azureFileName, fileSize
    }
}

//--------------------------------------------------------

// file upload

struct UploadResponses: Codable {
    let message: String
    let record: [FileRecords]
}

struct FileRecords: Codable, Identifiable {
    let isDeleted: Bool
    let id: Int
    let fileLink: String
    let fileName: String
    let azureFileName: String
    let folderId: Int
    let fileSize: String
    let userId: Int
    let type: String
    let subFolderType: String
    let createdAt: String
    let updatedAt: String
}

// file paayload

struct UploadPayload: Codable {
    let files: [UploadFile]
    let folderId: Int
    let type: String
    let subFolderType: String
}

struct UploadFile: Codable {
    let fileName: String
    let azureFileName: String
    let fileLink: String
    let fileSize: String
}



//get main records - get api
struct RecordsResponse: Codable {
    let message: String
    let mainRecords: [MainRecord]
}

struct MainRecord: Codable, Identifiable {
    let id: Int
    let folderName: String?
    let userId: Int
    let parentId: Int
    let type: String
    let isDeleted: Bool
    let deletedAt: Int
    let subFolderType: String
    let `default`: Bool
    let createdAt: String
    let updatedAt: String
}


// sub records Data - Get api


