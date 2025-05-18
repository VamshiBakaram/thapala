//
//  VerifyOTPModel.swift
//  Thapala
//
//  Created by ahex on 29/04/24.
//

import Foundation

struct VerifyOTPModel: Decodable {
    let message: String?
    let status: Int?
}


struct VerifyOTP: Encodable {
    let otpCode: String
}
