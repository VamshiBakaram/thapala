//
//  InsertTCodeModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/08/24.
//

import Foundation

//struct InsertTCodeModel: Decodable {
//    let message: String?
//    let data: InsertTCodeDataModel?
//}
//
//struct InsertTCodeDataModel: Decodable {
//    let chatBackground: String?
//    let chatBlockedUsers, blockedUsers: [Int]?
//    let contacts: [ContactData]?
//}
//
//struct ContactData: Decodable,Identifiable {
//    let uniqueId: UUID = UUID()
//    var isSelected: Bool = false
//    let roomID: String?
//    let createdAt, expiredAt, isPinned, id: Int?
//    let firstname, lastname, tCode: String?
//    let tCodeHidden, isOnline: Int?
//    let profile: String?
//    let unreadCount: Int?
//    let recentMessage: String?
//    let recentMessageDate: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case roomID = "roomId"
//        case createdAt, expiredAt, isPinned, id, firstname, lastname, tCode, tCodeHidden, isOnline, profile, unreadCount, recentMessage, recentMessageDate
//    }
//}

struct InsertTCodeModel: Decodable {
    let message: String?
    let data: DataResponse?

    enum DataResponse: Decodable {
        case insertTCodeDataModel(InsertTCodeDataModel)
        case emptyArray

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let dataModel = try? container.decode(InsertTCodeDataModel.self) {
                self = .insertTCodeDataModel(dataModel)
            } else if let _ = try? container.decode([InsertTCodeDataModel].self) {
                self = .emptyArray
            } else {
                throw DecodingError.typeMismatch(
                    DataResponse.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "DataResponse: Expected object or array"
                    )
                )
            }
        }
    }
}

struct InsertTCodeDataModel: Decodable {
    let chatBackground: String?
    let chatBlockedUsers, blockedUsers: [Int]?
    let contacts: [ContactData]?
}

struct ContactData: Decodable, Identifiable {
    let uniqueId: UUID = UUID()
    var isSelected: Bool = false
    let roomID: String?
    let createdAt, expiredAt, isPinned, id: Int?
    let firstname, lastname, tCode: String?
    let tCodeHidden, isOnline: Int?
    let profile: String?
    let unreadCount: Int?
    let recentMessage: String?
    let recentMessageDate: Int?

    enum CodingKeys: String, CodingKey {
        case roomID = "roomId"
        case createdAt, expiredAt, isPinned, id, firstname, lastname, tCode, tCodeHidden, isOnline, profile, unreadCount, recentMessage, recentMessageDate
    }
}




// MARK: - Get All Folders
struct GetAllFoldersModel: Decodable {
    let message: String?
    let folders: [Folder]?
}

struct Folder: Decodable {
    let id: Int?
    let folderName: String?
    let parentID: Int?
    let type: FoldersType?
    let subFolderType: SubFolderType?
    let children: [Folder]?

    enum CodingKeys: String, CodingKey {
        case id, folderName
        case parentID = "parentId"
        case type, subFolderType, children
    }
}

enum SubFolderType: String, Codable {
    case files = "files"
    case mails = "mails"
    case pictures = "pictures"
    case videos = "videos"
}

enum FoldersType: String, Codable {
    case archive = "archive"
    case locker = "locker"
    case work = "work"
}
