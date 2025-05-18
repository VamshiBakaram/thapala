//
//  PicktCodeModel.swift
//  Thapala
//
//  Created by ahex on 09/05/24.
//

import Foundation

struct VerifytCodeModel: Decodable {
    let message: String?
    let suggestions: [Int]?
    let manualOption: Bool?
    let status: Int?
}

struct VerifytCode: Encodable {
    let tCode: String
}

struct GenerateTCodeModel:Decodable{
    let message:String?
    let tCode:String?
}

struct CreateTCode: Encodable {
    let tCode: String
}

struct CreateTCodeModel:Decodable{
    let message:String?
    let status: Int?
}
