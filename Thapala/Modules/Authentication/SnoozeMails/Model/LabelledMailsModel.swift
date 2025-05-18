//
//  LabelledMailsModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/10/24.
//
import SwiftUI
import Foundation

struct LabelledMailsModel: Decodable {
    let message: String?
    let data: [LabelledMailsDataModel]?
}

struct LabelledMailsDataModel: Decodable,Identifiable {
    let id = UUID()
    let labelID: Int?
    let labelName: String?

    enum CodingKeys: String, CodingKey {
        case labelID = "labelId"
        case labelName
    }
}

