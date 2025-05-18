//
//  GetFolderModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 04/09/24.
//
import Foundation

struct GetFolderModel: Decodable {
    let message: String?
    let folders: [FolderModel]?
}

struct FolderModel: Decodable,Identifiable {
    var idm = UUID()
    let id: Int?
    let folderName: String?
    let parentID: Int?
    let type: SubTypeEnum?
    let subFolderType: SubFolderTypeModel?
    let children: [FolderModel]?

    enum CodingKeys: String, CodingKey {
        case id, folderName
        case parentID = "parentId"
        case type, subFolderType, children
    }
}

enum SubFolderTypeModel: String, Codable {
    case files = "files"
    case mails = "mails"
    case pictures = "pictures"
    case videos = "videos"
}

enum SubTypeEnum: String, Codable {
    case archive = "archive"
    case locker = "locker"
    case work = "work"
}
