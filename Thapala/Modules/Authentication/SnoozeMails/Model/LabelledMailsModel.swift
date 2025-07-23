//
//  LabelledMailsModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/10/24.
//
import SwiftUI
import Foundation



// Top-level response
struct LabelledMailsModel: Codable {
    let message: String
    let data: [LabelledMailsDataModel]
}

struct LabelledMailsDataModel: Codable, Identifiable {
    let labelId: Int
    let labelName: String
    var isChecked: Bool = false // Default when decoding

    var id: Int { labelId }

    private enum CodingKeys: String, CodingKey {
        case labelId
        case labelName
        case isChecked
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        labelId = try container.decode(Int.self, forKey: .labelId)
        labelName = try container.decode(String.self, forKey: .labelName)
        isChecked = try container.decodeIfPresent(Bool.self, forKey: .isChecked) ?? false
    }

    init(labelId: Int, labelName: String, isChecked: Bool = false) {
        self.labelId = labelId
        self.labelName = labelName
        self.isChecked = isChecked
    }
}


