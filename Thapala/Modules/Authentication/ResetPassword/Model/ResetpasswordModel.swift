//
//  ResetpasswordModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/05/24.
//

import Foundation

struct ResetpasswordModel: Decodable {
    let message, resetToken: String?
    let status:Int?
}

struct VerifyOtp: Encodable {
    let tCode: String
    let tryAnotherWay: Int
}

struct VerifyAnswer: Encodable {
    let tCode: String
    let tryAnotherWay: Int
    let securityAnswer:String
}

struct UserResetPasswordModel:Decodable{
    let message:String?
    let status:Int?
}

struct UserResetPasswordData:Encodable{
    let newPassword:String
    let confirmPassword:String
}


