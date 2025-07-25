//
//  InfoViewViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//

import SwiftUI

class InfoViewViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var selectedID: Int = 0
    @Published var content: [ContentItem] = []
    @Published var faqcontent: [FAQCategory] = []
    @Published var faqContentItems: [FAQContent] = []
    @Published var guideitems: [Guide] = []
    @Published var guidecontentItems: [GuideContent] = []
    @Published var isComposeEmail: Bool = false
    
    func getInfoData(selectedOption: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.info)contentType=\(selectedOption)&page=1&limit=10"
        
        NetworkManager.shared.request(type: APIResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.content = response.data.content
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    
    func getFaqData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.faq)"
        
        NetworkManager.shared.request(type: FAQResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.faqcontent = response.data.faq
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func getGuideData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.guide)"
        
        NetworkManager.shared.request(type: GuideResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.guideitems = [response.data.guide]
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    
}

