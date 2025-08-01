//
//  InfoViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//

import Foundation


// info TAB
struct APIResponse: Codable {
    let message: String
    let data: ResponseData
}

struct ResponseData: Codable {
    let content: [ContentItem]
    let pagination: Pagination
}

struct ContentItem: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct Pagination: Codable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
}



// FAQ TAB
struct FAQResponse: Decodable {
    let message: String
    let data: FAQData
}

struct FAQData: Decodable {
    let faq: [FAQCategory]
    let pagination: Paginations
}

struct FAQCategory: Decodable, Identifiable {
    let id: Int
    let type: String
    let heading: String
    let content: [FAQContent]
}

struct FAQContent: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct Paginations: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
    
}

//Guide TAB
struct GuideResponse: Decodable {
    let message: String
    let data: GuideData
}

struct GuideData: Decodable {
    let guide: Guide
    let pagination: GuidePagination
}

struct Guide: Decodable {
    let heading: String
    let description: String
    let content: [GuideContent]
}

struct GuideContent: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
}

struct GuidePagination: Decodable {
    let page: Int
    let limit: Int
    let total: Int
    let totalPages: Int
}


