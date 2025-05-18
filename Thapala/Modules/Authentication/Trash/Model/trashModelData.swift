//
//  trashModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 26/03/25.
//

import Foundation

// Get All Trash Data
struct trashResponse: Codable {
    let message: String
    let data: [datas]
    let count: EmailCount
}

struct datas: Codable {
    // if data comes in app check api in swagger and change this model data
}

struct EmailCount: Codable {
    let totalCount: Int
}


// Get records file Trash Data
struct FileTrashResponse: Codable {
    let message: String
    let data: [TrashItem]
}

struct TrashItem: Codable {
    //if data comes in app check api in swagger and change this model data
}



// Planner Get Trash


import Foundation

import Foundation

struct PlannerTrashResponse: Codable {
    let message: String
    let data: PlannerTrashData
}

struct PlannerTrashData: Codable {
    let plannerTrash: [PlannerTrashItem]
    let totalCount: Int
}

struct PlannerTrashItem: Codable {
    var id: Int
    var type: String
    var title: String
    var note: String
    let startDateTime: String?
    let endDateTime: String?
    let userId: Int
    let repeatValue: String // Renamed from `repeat`
    let createdTimeStamp: Int
    let status: String?
    let reminder: Int
    let theme: String?
    let labels: [Int]
    let isDeleted: Bool
    let deletedAt: String?
    var createdAt: String
    var updatedAt: String
    var isChecked: Int

    enum CodingKeys: String, CodingKey {
        case id, type, title, note, startDateTime, endDateTime, userId
        case repeatValue = "repeat"
        case createdTimeStamp, status, reminder, theme, labels, isDeleted, deletedAt, createdAt, updatedAt, isChecked
    }
}




// Restore list item put Api

struct PlannerRestoreResponse: Codable {
    let message: String
}
// Restore put Api Payload
struct UpdateRequest: Codable {
    let ids: [Int]
}


// delete list item Delete Api

struct DeletePlannerResponse: Codable {
    let message: String
}

struct RequestBody: Codable {
    let ids: [Int]
}

