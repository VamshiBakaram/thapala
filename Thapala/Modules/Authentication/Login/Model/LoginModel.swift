//
//  LoginModel.swift
//  Thapala
//
//  Created by ahex on 24/04/24.
//

import Foundation

struct Login: Encodable {
    let tCode: String
    let password: String
}

struct LoginModel: Decodable {
    let message: String?
    let user: User?
    let status:Int?
}

struct User: Decodable {
    let id: Int?
    let tCode, firstname, lastname, phoneNumber: String?
    let countryCode: String?
    let pin: String?
}

struct LoginResponse: Decodable {
    var model: LoginModel?
    var token:String?
}

struct PasswordForgot: Encodable {
    let tCode: String
}

struct forgotUserDetailsModel: Decodable {
    let message: String?
    let result: UserData?
}

struct UserData: Decodable {
    let countryCode: String?
    let phoneNumber: String?
    let securityQuestion: SecurityQuestionModel?
}

struct SecurityQuestionModel: Decodable {
    let question: String?
}

