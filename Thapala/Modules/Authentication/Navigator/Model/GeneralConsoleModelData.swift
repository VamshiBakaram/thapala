//
//  consoleHeaderModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 11/04/25.
//

import Foundation

struct Settingsresponses: Codable {
    let message: String
    let settings: [UserSetting]
}

struct UserSetting: Codable {
    let awaitingPageSize: Int
    let conveyedPageSize: Int
    let dairyPageSize: Int
    let dateFormat: String
    let defaultLanguage: String
    let emailUndoSend: Int
    let settingsId: Int
    let notePageSize: Int
    let postboxPageSize: Int
    let timeFormat: String
    let trashRecovery: Int
    let mailFontSize: String
    let mailFontFamily: String
    let chatBackGround: Int
    let chat: Int
    let doitPageSize: Int
    let openChatBubbles: Int
    let openReminderBubbles: Int
    let chatTheme: String?
    let plannerFontFamily: String
    let plannerFontSize: String
    let calendar: String
    let taskList: String
    let timeZone: String
    let theme: String
    let hrsToMoveEmail: Int
    let accentColor: String
    let lastLogin: Int

    enum CodingKeys: String, CodingKey {
        case awaitingPageSize
        case conveyedPageSize = "ConveyedPageSize"
        case dairyPageSize
        case dateFormat
        case defaultLanguage
        case emailUndoSend
        case settingsId
        case notePageSize
        case postboxPageSize
        case timeFormat
        case trashRecovery = "TrashRecovery"
        case mailFontSize
        case mailFontFamily
        case chatBackGround = "ChatBackGround"
        case chat
        case doitPageSize
        case openChatBubbles
        case openReminderBubbles
        case chatTheme
        case plannerFontFamily
        case plannerFontSize
        case calendar
        case taskList = "TaskList"
        case timeZone
        case theme
        case hrsToMoveEmail
        case accentColor
        case lastLogin
    }
}


// Get total storage Get Api

struct StorageResponse: Codable {
    let message: String
    let data: [StorageData]
}

struct StorageData: Codable {
    let totalFilesSize: Int
    let totalFilesCount: Int
    let result: StorageResult
}

struct StorageResult: Codable {
    let id: Int
    let userId: Int
    let totalLimit: Int
    let workTotalSize: Int
    let lockerTotalSize: Int
    let archiveTotalSize: Int
    let emailTotalSize: Int
    let workTotalCount: Int
    let lockerTotalCount: Int
    let archiveTotalCount: Int
    let emailTotalCount: Int
    let createdAt: String
    let updatedAt: String
}

// save user settings
import Foundation

// Top-level response model
import Foundation

// Top-level response model
struct SettingResponse: Codable {
    let message: String
    let data: [UserSettings]
}

// Main settings data model
struct UserSettings: Codable {
    let id: Int
    let defaultLanguage: String
    let timeFormat: String
    let userId: Int
    let dateFormat: String
    let awaitingPageSize: Int
    let postboxPageSize: Int
    let conveyedPageSize: Int
    let emailUndoSend: Int
    let dairyPageSize: Int
    let notePageSize: Int
    let doitPageSize: Int
    let trashRecovery: Int
    let mailFontSize: String
    let plannerFontSize: String
    let plannerFontFamily: String
    let mailFontFamily: String
    let chat: Bool
    let openChatBubbles: Bool
    let chatBackGround: Bool
    let openReminderBubbles: Bool
    let chatTheme: String?  // Nullable
    let calendar: String
    let taskList: String
    let timeZone: String
    let createdAt: String  // You can convert this to Date if needed
    let updatedAt: String  // Same here

    // CodingKeys to handle snake_case to camelCase if needed
    enum CodingKeys: String, CodingKey {
        case id, defaultLanguage, timeFormat, userId, dateFormat,
             awaitingPageSize, postboxPageSize, conveyedPageSize = "ConveyedPageSize",
             emailUndoSend, dairyPageSize, notePageSize, doitPageSize, trashRecovery = "TrashRecovery",
             mailFontSize, plannerFontSize, plannerFontFamily, mailFontFamily, chat,
             openChatBubbles, chatBackGround = "ChatBackGround", openReminderBubbles,
             chatTheme, calendar, taskList, timeZone, createdAt, updatedAt
    }
}


 
// payload save user settings
struct DateFormatPayload: Codable {
    var dateFormat: String
}

struct TimeFormatPayload: Codable {
    var timeFormat: String
}

struct TimeZonePayload: Codable {
    var timeZone: String
}

struct AwaitingPayload: Encodable {
    var awaitingPageSize: Int
}

struct postBoxsizePayload: Encodable {
    var postboxPageSize: Int
}

struct conveyedsizePayload: Encodable {
    var ConveyedPageSize: Int
}

struct defalutfont: Encodable {
    var mailFontFamily: String
}

struct FontSize: Encodable {
    var mailFontSize: Int
}

struct tasktype: Encodable {
    var taskList: String
}

struct tDo: Encodable {
    var doitPageSize: Int
}

struct tDiary: Encodable {
    var dairyPageSize: Int
}

struct tNote: Encodable {
    var notePageSize: Int
}

struct chat: Encodable {
    var chat: Bool
}
struct chatBubble: Encodable {
    var openChatBubbles: Bool
}
struct chatBackground: Encodable {
    var ChatBackGround: Bool
}

struct Trash: Encodable {
    var TrashRecovery: Int
}

// country codes
struct Countrycode: Decodable, Hashable {
    let name: String
    let dial_code: String
    let code: String
}
