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
    var isChecked: Bool = false

    var id: Int { labelId }
}

