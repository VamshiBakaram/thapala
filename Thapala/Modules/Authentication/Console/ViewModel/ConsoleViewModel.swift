//
//  ConsoleViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 08/10/24.
//
import SwiftUI

class ConsoleViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var isComposeEmail: Bool = false
    @Published var timePeriodMessage: String?
    @Published var settingdata: [SettingsData] = []
    @Published var userSettings: [Setting] = []
    @Published var selectedID: Int = 0
    @Published var theme: String?
    private let sessionExpiredErrorMessage =  "Session expired. Please log in again."
    func MailTimePeriod(timePeriod: Int) {
        isLoading = true
        let params = TimeChangeRequest(timeInHours: timePeriod)
        let endPoint = "\(EndPoint.mailTimePeriod)"
        if let jsonData = try? JSONEncoder().encode(params),
           let _ = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: TimeChangeResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.timePeriodMessage = response.message
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }

    // mail Awaiting
    
    func AwaitingMaximumPageSize(pageSize: Int) {
        isLoading = true
        let params = SettingsPayload(awaitingPageSize: pageSize)
        let endPoint = "\(EndPoint.maximumListPageSize)"
        if let jsonData = try? JSONEncoder().encode(params),
           let _ = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: SettingsResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.settingdata = response.data
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    // mail postBox
    
    func PostBoxMaximumPageSize(pageSize: Int) {
        isLoading = true
        let params = PostboxRequestModel(postboxPageSize: pageSize)
        let endPoint = "\(EndPoint.maximumListPageSize)"
        if let jsonData = try? JSONEncoder().encode(params),
           let _ = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: SettingsResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.settingdata = response.data
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    // mail Conveyed
    func ConveyedMaximumPageSize(pageSize: Int) {
        isLoading = true
        let params = ConveyedPageSizeModel(conveyedPageSize: pageSize)
        let endPoint = "\(EndPoint.maximumListPageSize)"
        if let jsonData = try? JSONEncoder().encode(params),
           let _ = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: SettingsResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.settingdata = response.data
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    // chat
    
    func SaveSettingschat(chats: Bool) {
        isLoading = true
        let params = chatRequestModel(chat: chats)
        let endPoint = "\(EndPoint.maximumListPageSize)"
        if let jsonData = try? JSONEncoder().encode(params),
           let _ = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: SettingsResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.settingdata = response.data
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    // chat Bubble
    
    func SaveSettingsChatBubble(chatBubble: Bool) {
        isLoading = true
        let params = chatBubbleRequestModel(openChatBubbles: chatBubble)
        let endPoint = "\(EndPoint.maximumListPageSize)"
        if let jsonData = try? JSONEncoder().encode(params),
           let _ = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: SettingsResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.settingdata = response.data
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    // Get User Settings
    
    func GetUserSettings() {
        self.isLoading = true
        let endUrl = "\(EndPoint.UserSettings)"
        
        NetworkManager.shared.request(type: UserSettingsResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.userSettings = response.settings
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    // Appearance theme change
    
    func Themchange(themes: String , accentcolour: String) {
        isLoading = true
        let params = Themepayload(theme: themes, accentColor: accentcolour)
        let endPoint = "\(EndPoint.themeChange)"
        if let jsonData = try? JSONEncoder().encode(params),
           let _ = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: ThemeResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.theme = response.theme
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
}
