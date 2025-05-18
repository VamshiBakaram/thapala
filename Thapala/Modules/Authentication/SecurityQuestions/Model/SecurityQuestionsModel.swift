//
//  SecurityQuestionsModel.swift
//  Thapala
//
//  Created by ahex on 29/04/24.
//

import Foundation

struct SecurityQuestionsModel: Decodable {
    let message: String?
    let data: [SecurityQuestion]?
}

struct SecurityQuestion: Codable, Hashable {
    let id: Int?
    let question: String?
}

struct SaveSecurityQuestion: Encodable {
    let questionId: Int
    let securityAnswer: String
}

struct SecurityQuestionResponseModel: Decodable {
    let message: String?
    let status: Int?
}
