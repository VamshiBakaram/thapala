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
    var labelName: String
    var isChecked: Bool
    var isEditing: Bool = false  // local only, not in JSON

    enum CodingKeys: String, CodingKey {
        case id, labelName, isChecked
        // omit isEditing so it's not decoded
    }
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
    var reminder: Int?
    var labelIds: [Int]
    var theme: String?

    enum CodingKeys: String, CodingKey {
        case title, task, note, reminder, labelIds, theme
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
        try container.encode(task, forKey: .task)
        try container.encode(note, forKey: .note)
        try container.encode(labelIds, forKey: .labelIds)

        // Only encode reminder if not nil
        if let reminder = reminder {
            try container.encode(reminder, forKey: .reminder)
        }

        // Only encode theme if not nil and not empty
        if let theme = theme, !theme.isEmpty {
            try container.encode(theme, forKey: .theme)
        }
    }
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

struct UpdateDoitPayload: Codable {
    let reminder: Int?
//    let task: [String]
    let task: [String]
}



// planner edit Tag Label - put Api

struct UpdateTagResponse: Decodable {
    let message: String
}


struct UpdateTagPayload: Codable {
    var labelId: Int
    var labelName: String
}

// planner edit Tag Label - Delete Api

struct DeleteTagLabelResponse: Decodable {
    let message: String
}




// overall planner search - Get Api

struct plannerSearchResponse: Decodable {
    let message: String
    let data: plannerSearchData
}



struct plannerSearchData: Decodable {
    let totalCount: TotalPlannerCount
    let diaries: [plannerData]
    
    enum CodingKeys: String, CodingKey {
        case totalCount
        case diaries = "data" // Maps the "data" key in JSON to the `diaries` property
    }
}

struct TotalPlannerCount: Decodable {
    let total: Int
}

struct plannerData: Decodable, Identifiable {
    var id: Int
    let type: String
    var title: String
    var note: String
    let theme: String?
    let startDateTime: String?
    let createdTimeStamp: Int
    let endDateTime: String?
    var reminder: Int?
    let userId: Int
    let repeatFrequency: String
    let status: String?
    let labels: [searchTagLabel]? // Changed from String to [TagLabel] to represent labels as objects
    let comments: [searchComment]? // Fixed to be an array of Comment objects instead of an array of Strings

    enum CodingKeys: String, CodingKey {
        case id, type, title, note, theme, startDateTime, createdTimeStamp, endDateTime, reminder, userId
        case repeatFrequency = "repeat" // `repeat` is a reserved keyword in Swift
        case status, labels, comments
    }
}

struct searchTagLabel: Decodable {
    var labelId: Int
    var labelName: String
}

struct searchComment: Decodable{
    let status: String?
    var comment: String
    let commentId: Int
    var isEditable: Bool = false
    var deletable: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case status, comment, commentId
    }
}
