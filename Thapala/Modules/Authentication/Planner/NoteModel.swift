//
//  NoteModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 26/11/24.
//

//import Foundation
//
//// Top-level response
import Foundation

// create new note - post api
// Root response model
struct AddNoteResponse: Codable {
    let message: String
    let data: AddNoteData
}

// Nested `data` object
struct AddNoteData: Codable {
    let data: [Notelist]
}

// Individual note model
struct Notelist: Codable {
    let labels: [String]
    let isDeleted: Bool
    let id: Int
    let userId: Int
    let title: String
    let note: String
    let type: String
    let createdTimeStamp: Int
    let repeatFrequency: String
    let updatedAt: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case labels
        case isDeleted
        case id
        case userId
        case title
        case note
        case type
        case createdTimeStamp
        case repeatFrequency = "repeat"
        case updatedAt
        case createdAt
    }
}
// above post api payload
struct NotePayload: Codable {
    let title: String
    let task: [String]
    let note: String
    let reminder: Int?
}




struct NotesResponse: Decodable {
    let message: String
    let data: NotesData
}

struct NotesData: Decodable {
    let totalCount: TotalCount
    let data: [Note] // Update the property name to match the JSON response key

    enum CodingKeys: String, CodingKey {
        case totalCount
        case data // Map the "data" key to the `data` property
    }
}

struct Note: Decodable,Identifiable {
    let id: Int
    let type: String
    let title: String
    let note: String
    let theme: String?
    let startDateTime: String?
    let createdTimeStamp: Int
    let endDateTime: String?
    var reminder: Int?
    let userId: Int
    let repeatFrequency : String
    let status: String?
    let labels: [TagLabels]?
    let comments: String?
    
    enum CodingKeys: String, CodingKey {
        case id, type, title, note, theme, startDateTime, createdTimeStamp, endDateTime, reminder, userId
        case repeatFrequency = "repeat" // `repeat` is a reserved keyword in Swift
        case status, labels, comments
    }

}

struct TagLabels: Decodable {
    var labelId: Int
    var labelName: String
//    var isRemoved: Bool = false
}


//Get label
struct ApiRespons: Codable {
    let message: String
    let data: [Labell]
}

struct Labell: Codable, Identifiable {
    let id: Int
    let labelName: String
    var isChecked: Bool
}

//put on click of done by select Date and Time
struct UpdatedPlannerResponses: Decodable {
    let message: String
    let updatedPlannerItem: PlannerItems
}

struct PlannerItems: Decodable {
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
struct DiaryUpdateRequests: Encodable {
    let note: String
    let title: String
}
struct PlannerPayloads: Codable {
    let reminder: Int?
//    let task: [String]
    let type: String
}

struct DiaryItemsPayload: Codable {
    var reminder: Int?
    var type: String
}


// Get history schedule

struct PlannerDiaryResponse: Decodable {
    let message: String
    let data: PlannerDiaryData
}

// Data part of the response
struct PlannerDiaryData: Decodable {
    let createdAt: Int
    let history: [PlannerHistory]
}

// History item inside the "history" array
struct PlannerHistory: Decodable , Hashable {
    let plannerId: Int
    let modifiedAt: Int
}


// delete Note / move to trash - delete method

struct MoveToTrashResponse: Codable {
    let message: String
}


struct DeletePayload: Codable {
    let ids: [Int]
}


