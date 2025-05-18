//
//  SecurityAnswerModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 24/05/24.
//

import Foundation

struct SecurityAnswerModel: Decodable {
    let message, resetToken: String?
    let status:Int?
}
