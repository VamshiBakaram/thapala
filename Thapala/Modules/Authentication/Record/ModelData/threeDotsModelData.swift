//
//  threeDotsModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 27/05/25.
//

import Foundation

// Delete -post Api
struct DeleteFolderResponse: Codable {
    let message: String
}

// delete payload
struct DeleteFolderRequest: Codable {
    let recordIds: [Int]
    let fileIds: [FieldID]
    let emailIds: [Int]
}

//----------------------------------------------------

// download files - post api

struct DownloadResponse: Codable {
    let message: String
}
// download files payload
struct FilePayload: Codable {
    let fileId: Int
    let type: String
}

//----------------------------------------------------

// rename - put api
struct RenameFileResponse: Codable {
    let message: String
}

//  renam epayload
struct renamePayload: Codable {
    let recordName:String
    let subFolderType:String
}
