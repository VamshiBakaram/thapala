//
//  DateBookModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/01/25.
//

import Foundation

struct DatebookResponse: Codable {
    let message: String
    let data: DatebookData
}

struct DatebookData: Codable {
    let data: [DatebookItem]
}

struct DatebookItem: Codable {
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
    let labels: [String]
    let isDeleted: Int
    let deletedAt: String?
    let createdAt: String
    let updatedAt: String
    
    // Date formatters to handle the timestamps if needed
//    var startDate: Date? {
//        if let start = startDateTime {
//            return Date(timeIntervalSince1970: TimeInterval(start))
//        }
//        return nil
//    }
//    
//    var endDate: Date? {
//        if let end = endDateTime {
//            return Date(timeIntervalSince1970: TimeInterval(end))
//        }
//        return nil
//    }
}



// Add Event - post method
// Model for the API Response
struct DatebookResponses: Codable {
    let message: String
    let data: DatebookDatas
}

// Model for the "data" field in the response
struct DatebookDatas: Codable {
    let data: [DatebookItems]
}

// Model for each Datebook item
struct DatebookItems: Codable {
    let id: Int
    let userId: Int
    let title: String
    let note: String
    let type: String
    let startDateTime: Int
    let endDateTime: Int
    let `repeat`: String
    let createdTimeStamp: Int
    let updatedAt: String
    let createdAt: String
    let isDeleted: Bool
    let labels: [String]
}


// Model for the API Payload
struct DatebookPayload: Codable {
    let endDateTime: Int
    let note: String
    let `repeat`: String
    let startDateTime: Int
    let title: String
}
