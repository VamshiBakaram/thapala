//
//  consoleModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 03/04/25.
//

import Foundation
// Mail save settings-> Time period - post Api
struct TimeChangeResponse: Codable {
    let message: String
}
// Mail save settings-> Time Period Payload
struct TimeChangeRequest: Codable {
    let timeInHours: Int
}

// Mail save settings-> Maximum Page List Size
struct SettingsResponse: Codable {
    let message: String
    let data: [SettingsData]
}

struct SettingsData: Codable {
    let id: Int
    let defaultLanguage: String
    let timeFormat: String
    let userId: Int
    let dateFormat: String
    let awaitingPageSize: Int
    let postboxPageSize: Int
    let conveyedPageSize: Int
    let emailUndoSend: Int?
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
    let chatTheme: String?
    let calendar: String
    let taskList: String
    let timeZone: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, defaultLanguage, timeFormat, userId, dateFormat, awaitingPageSize, postboxPageSize
        case conveyedPageSize = "ConveyedPageSize"
        case emailUndoSend, dairyPageSize, notePageSize, doitPageSize, trashRecovery = "TrashRecovery"
        case mailFontSize, plannerFontSize, plannerFontFamily, mailFontFamily, chat, openChatBubbles
        case chatBackGround = "ChatBackGround"
        case openReminderBubbles, chatTheme, calendar, taskList, timeZone, createdAt, updatedAt
    }
}

//Mail save settings -> Awaiting Payload

struct SettingsPayload: Codable {
    let awaitingPageSize: Int
}

//Mail save settings -> Post-Box
struct PostboxRequestModel: Codable {
    let postboxPageSize: Int
}

//Mail save settings -> conveyed
struct ConveyedPageSizeModel: Codable {
    let conveyedPageSize: Int

    enum CodingKeys: String, CodingKey {
        case conveyedPageSize = "ConveyedPageSize"
    }
}

// Mail save settings -> chat

struct chatRequestModel: Codable {
    let chat: Bool
}

struct chatBubbleRequestModel: Codable {
    let openChatBubbles: Bool
}

// get user settings - Get Api

struct UserSettingsResponse: Codable {
    let message: String
    let settings: [Setting]
}

struct Setting: Codable , Equatable{
    let awaitingPageSize: Int
    let conveyedPageSize: Int
    let dairyPageSize: Int
    let dateFormat: String
    let defaultLanguage: String
    let emailUndoSend: Int?
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
    let timeZone: String?
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


//  theme change - Appearance - Post Api

struct ThemeResponse: Codable {
    let message: String
    let theme: String
    let accentColor: String
}
// theme change payload

struct Themepayload: Codable {
    let theme: String
    let accentColor: String
}
