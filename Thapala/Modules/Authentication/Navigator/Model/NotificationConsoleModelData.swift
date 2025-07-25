//
//  NotificationConsoleModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 15/04/25.
//

import Foundation

// get all alert Notifications

struct AlertResponse: Codable {
    let message: String
    let data: [AlertData]
}

struct AlertData: Codable {
    let allNotifications: Bool
    let newEmail: Bool
    let scheduledSent: Bool
    let newMessage: Bool
    let addOrRemove: Bool
    let connectionExpired: Bool
    let chatDetails: Bool
    let doIt: Bool
    let reminder: Bool
    let note: Bool
    let diary: Bool
    let datebook: Bool
    let fcmTokens: [String]
    let deviceType: String

    enum CodingKeys: String, CodingKey {
        case allNotifications = "AllNotifications"
        case newEmail
        case scheduledSent
        case newMessage
        case addOrRemove
        case connectionExpired
        case chatDetails
        case doIt
        case reminder
        case note
        case diary
        case datebook
        case fcmTokens
        case deviceType
    }
}

// put update Alerts

struct AlertSettingsResponse: Codable {
    let message: String
    let data: alertSettingsData
}

struct alertSettingsData: Codable {
    let id: Int
    let userId: Int
    let AllNotifications: Bool
    let newEmail: Bool
    let scheduledSent: Bool
    let newMessage: Bool
    let addOrRemove: Bool
    let connectionExpired: Bool
    let chatDetails: Bool
    let doIt: Bool
    let reminder: Bool
    let note: Bool
    let diary: Bool
    let datebook: Bool
    let fcmTokens: [String]
    let deviceType: String
    let createdAt: String
    let updatedAt: String
}

// payload put update alerts

struct NotificationSettings: Codable {
    var AllNotifications: Bool
    var newEmail: Bool
    var scheduledSent: Bool
    var newMessage: Bool
    var addOrRemove: Bool
    var chatDetails: Bool
    var connectionExpired: Bool
    var datebook: Bool
    var diary: Bool
    var doIt: Bool
    var note: Bool
    var reminder: Bool
}
