//
//  DoitModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 20/12/24.
//

import Foundation

struct DoitResponse: Decodable {
    let message: String
    let data: DoitData
}

struct DoitData: Decodable {
    let totalCount: TotalCounts
    let data: [Doit]
}

struct TotalCounts: Decodable {
    let total: Int
}

struct Doit: Decodable,Identifiable {
    let id: Int
    let type: String
    var title: String
    var note: String
    var theme: String?
    let startDateTime: String?
    let createdTimeStamp: Int
    let endDateTime: String?
    var reminder: Int?
    let userId: Int
    let repeatType: String
    let status: String
    let labels: [TagLabelList]?
    let comments: [Commentt]?
    
    enum CodingKeys: String, CodingKey {
        case id, type, title, note, theme
        case startDateTime, createdTimeStamp, endDateTime, reminder, userId
        case repeatType = "repeat"
        case status, labels, comments
    }
}

struct Commentt: Decodable {
    let status: String
    let comment: String
    let commentId: Int
}

struct TagLabelList: Decodable {
    var labelId: Int
    var labelName: String
//    var isRemoved: Bool = false
}

// Get tags - get Method

struct TagApiRespons: Codable {
    let message: String
    let data: [LabelTags]
}

struct LabelTags: Codable, Identifiable {
    let id: Int
    let labelName: String
    var isChecked: Bool
}

// update comment - put

struct commentResponse: Codable {
    let message: String
}


struct DoitPayload: Codable {
    let parentId: Int
    let commentId: Int
    let comment: String
    let type: String
    let status: String
}


// particular do it task history - GET method

struct PlannerDoitResponse: Decodable {
    let message: String
    let data: PlannerDoitData
}

// Data part of the response
struct PlannerDoitData: Decodable {
    let createdAt: Int
    let history: [PlannerDoitHistory]
}

// History item inside the "history" array
struct PlannerDoitHistory: Decodable , Hashable {
    let plannerId: Int
    let modifiedAt: Int
}

// Add Task - post method


struct PlannerResponse: Decodable {
    let message: String
    let data: PlannerData
}

struct PlannerData: Decodable {
    let data: [DoitAddItems]
}

struct DoitAddItems: Decodable {
    let labels: [String]
    let isDeleted: Bool
    let id: Int
    let userId: Int
    let title: String
    let note: String
    let type: String
    let createdTimeStamp: Int
    let status: String
    let repeatType: String
    let updatedAt: String
    let createdAt: String
    
    // Custom CodingKey to handle "repeat" field name
    private enum CodingKeys: String, CodingKey {
        case labels, isDeleted, id, userId, title, note, type, createdTimeStamp, status, updatedAt, createdAt
        case repeatType = "repeat"
    }
}

struct AddTaskPayload: Encodable {
    let title: String
    let task: [String]
    let note: String
}


// remove task - delete Api

struct RemoveTaskResponse: Decodable {
    let message: String
}
struct RemoveTaskRequest: Encodable , Decodable {
    let parentId: Int   // Accepts an array of parentIds
    let commentId: Int  // Accepts an array of commentIds
    let type: String
}


// Add Task to existing Doit Screen - post method

struct AddResponse: Codable {
    let message: String
}

struct AddingTaskPayload: Codable {
    let parentId: Int
    let type: String
    let status: String
    let comment: String
}


// change status in doit view - put method

struct ChangeStatusResponse: Codable {
    let message: String
}
struct ChangeStatusPayload: Codable {
    let ids: [Int]
    let status: String
}


         ///////////////////// Bottom Views//////////////////////


// on click of done on notifiction Bottom View - put method

struct UpdateDoitResponse: Decodable {
    let message: String
    let updatedPlannerItem: updateItem
}

struct updateItem: Decodable {
    let id: Int
    let type: String
    let title: String
    let note: String
    let startDateTime: String?
    let endDateTime: String?
    let userId: Int
    let `repeat`: String
    let createdTimeStamp: Int
    let status: String?
    let reminder: Int?
    let theme: String?
    let labels: [Int]
    let isDeleted: Bool
    let deletedAt: String?
    let createdAt: String
}
//struct DiaryUpdateRequest: Encodable {
//    let note: String
//    let title: String
//}
struct UpdateDoitPayload: Codable {
    let reminder: Int?
//    let task: [String]
    let task: [String]
}


