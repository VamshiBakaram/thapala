//
//  DiaryModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/11/24.
//

import Foundation


//put method model data
struct UpdatedPlannerResponse: Decodable {
    let message: String
    let updatedPlannerItem: PlannerItem
}

struct PlannerItem: Decodable {
    let id: Int
    let type: String
    let title: String
    let note: String
    let startDateTime: Int?
    let endDateTime: Int?
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
struct DiaryUpdateRequest: Encodable {
    let note: String
    let title: String
}
struct PlannerPayload: Codable {
    let reminder: Int?
    let type: String
}


struct updateEventPayload: Codable {
    let endDateTime: Int?
    let note: String
    let `repeat`: String
    let startDateTime: Int?
    let title: String
}

struct UpdatePlannerPayload: Codable { // add theme payload 
    let theme: String
    let task: [String]
}

// Theme Background
struct Background: Identifiable {
    let id = UUID() // Automatically generate a unique ID
    let type: BackgroundType
    let value: String
    let tooltip: String
    let plannerType: PlannerType
    let subImages: [SubImage]
}

struct SubImage: Identifiable {
    let id = UUID()
    let value: String
    let tooltip: String
}

enum BackgroundType: String {
    case none
    case color
    case image
}

enum PlannerType: String {
    case doit = "doit"
    case common = "common"
    case note = "note"
}

// remove schedule notification - put method



// Define a model for the API payload
struct DiaryItemPayload: Encodable {
    var reminder: Int?
    var type: String
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encodeNil(forKey: .reminder)  // <-- This forces null
    }
    
    enum CodingKeys: String, CodingKey {
        case reminder, type
    }
}



//Get

struct DiaryResponse: Decodable {
    let message: String
    let data: DiaryData
}

struct DiaryData: Decodable {
    let totalCount: TotalCount
    let diaries: [Diary]
    
    enum CodingKeys: String, CodingKey {
        case totalCount
        case diaries = "data" // Maps the "data" key in JSON to the `diaries` property
    }
}

struct TotalCount: Decodable {
    let total: Int
}

struct Diary: Decodable, Identifiable {
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
    let labels: [TagLabel]? // Changed from String to [TagLabel] to represent labels as objects
    let comments: [Comment]? // Fixed to be an array of Comment objects instead of an array of Strings

    enum CodingKeys: String, CodingKey {
        case id, type, title, note, theme, startDateTime, createdTimeStamp, endDateTime, reminder, userId
        case repeatFrequency = "repeat" // `repeat` is a reserved keyword in Swift
        case status, labels, comments
    }
}

struct TagLabel: Decodable {
    var labelId: Int
    var labelName: String
//    var isRemoved: Bool = false
}

struct Comment: Decodable{
    let status: String?
    var comment: String
    let commentId: Int
    var isEditable: Bool = false
    var deletable: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case status, comment, commentId
    }
}





struct AddCommentResponse: Codable {
    let message: String
}


struct CommentPayload: Codable {
    var parentId: Int
    var comment: String
    var type: String
}

struct DeleteCommentResponse: Decodable {
    let message: String
}
struct DeleteCommentRequest: Encodable , Decodable {
    let parentId: Int   // Accepts an array of parentIds
    let commentId: Int  // Accepts an array of commentIds
    let type: String
}



// create Tag label Diary post method

struct ApiResponse: Decodable {
    let message: String
    let data: [LabelData]
}

struct LabelData: Decodable, Identifiable {
    let id: Int
    let labelName: String
    let userId: Int
    let isChecked: Bool
    let updatedAt: String
    let createdAt: String
}

struct LabelPayload: Encodable {
    let labelName: String
}

// Get Bottom Tag Label List

struct ApiResponses: Codable {
    let message: String
    let data: [Labels]
}

struct Labels: Codable, Identifiable {
    let id: Int
    var labelName: String
    var isChecked: Bool
}




// Apply Tag label - post

struct AddLabelResponse: Decodable {
    let message: String
}

struct AddLabelPayload: Encodable {
    let plannerId: Int
    let labelIds: [Int] // Array of IDs
}


// edit comment label - put

struct DiaryUpdateResponse: Codable {
    var message: String
}


struct editUpdateRequest: Codable {
    var parentId: Int
    var commentId: Int
    var comment: String
    var type: String
    var status: String
}


// remove tag put method

struct RemoveLabelResponse: Codable {
    let message: String
}

struct RemoveLabelRequest: Codable {
    let plannerId: Int
    let labelId: Int
}



// create new Diary - post method

// Root response structure
struct CreateDiaryResponse: Codable {
    let message: String
    let data: CreateDiaryData
}

// Data field inside the response
struct CreateDiaryData: Codable {
    let data: [NewDiary]
}

// Individual diary object
struct NewDiary: Codable {
    let labels: [String]
    let isDeleted: Bool
    let id: Int
    let userId: Int
    let title: String
    let note: String
    let type: String
    let createdTimeStamp: Int
    let reminder: Int
    let repeatFrequency: String
    let updatedAt: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case labels, isDeleted, id, userId, title, note, type, createdTimeStamp, reminder
        case repeatFrequency = "repeat"
        case updatedAt, createdAt
    }
}

struct DiaryPayload: Encodable {
    let title: String
    let note: String
    let reminder: Int?
    var labelIds: [Int]
    var theme: String?

    enum CodingKeys: String, CodingKey {
        case title, note, reminder, labelIds, theme
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(title, forKey: .title)
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
