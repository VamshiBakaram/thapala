//
//  AppBarElementsViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 16/06/25.
//

import Foundation
import SwiftUI
class AppBarElementsViewModel: ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    @Published var emailData: [EmailItem] = []
    @Published var notificationsData : [NotificationItem] = []
    @Published var filterLabelTF = ""
    @Published var selectedOption: searchOptions? = .allMails
    @Published var isAllMailsSelected: Bool = true
    @Published var isQueueSelected: Bool = false
    @Published var ispostBoxSelected: Bool = false
    @Published var isConveyedSelected: Bool = false
    @Published var beforeLongPress: Bool = true
    @Published var isEmailView: Bool = false
    @Published var selectedemailID: Int?
    @Published var isSearch: Bool = false
    
    
    func getMailsData(keyWord: String , searchfor: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.getSearchData)advanced=true&keyword=\(keyWord)&searchIn=\(searchfor)&page=1&pageSize=10"
        
        NetworkManager.shared.request(type: SuggestionResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.emailData = response.data
                    self.error = response.message
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
    
    func getAppBarNotifications() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getNotifications)"
        
        NetworkManager.shared.request(type: NotificationResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.notificationsData = response.data
                    self.error = response.message
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
