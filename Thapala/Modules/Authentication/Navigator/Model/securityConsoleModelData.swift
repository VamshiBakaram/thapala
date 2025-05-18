//
//  securityConsoleModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 14/04/25.
//

import Foundation

struct SecurityQuestionsResponse: Codable {
    let message: String
    let data: [securityQuestion]
}

struct securityQuestion: Identifiable, Codable {
    let id: Int
    let question: String
    let userId: Int?
}

// set pin

struct PinResponse: Codable {
    let message: String
    let hashedPin: String
}

struct PinChangeRequest: Codable {
    var newPin: String
    var confirmNewPin: String
}


