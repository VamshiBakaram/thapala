//
//  consoleViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 11/04/25.
//

import Foundation

class ConsoleNavigatiorViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    @Published var userSettings: [UserSetting] = []
    @Published var GetStorageData: [StorageData] = []
    @Published var savesetting: [UserSettings] = []
    @Published var securityQuestions: [securityQuestion] = []
    @Published var contactNumber: String = ""
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var isContactsDialogVisible = false
    @Published var countryCodes: [countryCode] = []
    @Published var selectedCountryCode: countriesCode? = nil
    @Published var isShowCountryDropdown = false
    @Published var successMessage: String = ""
    @Published var getAllNotificationAlerts: [AlertData] = []
    @Published var UpdateNotificationAlerts: [alertSettingsData] = []
    @Published var theme: String?
    private let sessionExpiredErrorMessage =  "Session expired. Please log in again."
    //Get User Settings
    
    func handleDropdown() {
        isShowCountryDropdown.toggle()
    }
    // General Console Module
    func getUserSettings() {
        self.isLoading = true
        let endUrl = "\(EndPoint.userSettings)"
        NetworkManager.shared.request(type: Settingsresponses.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
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

    func getTotalStorage() {
        self.isLoading = true
        let endUrl = "\(EndPoint.TotalStorage)"
        NetworkManager.shared.request(type: StorageResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.GetStorageData = response.data
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
    
//     save settings Post Api
    func saveSettings<T: Encodable>(payload: T) {
        isLoading = true
        let endPoint = "\(EndPoint.saveSettings)"
        if let jsonData = try? JSONEncoder().encode(payload),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: SettingResponse.self,endPoint: endPoint,httpMethod: .post, parameters: payload, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.savesetting = response.data
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
    
    // Security Account Console module
    
    func getUserSecurityQuestions() {
        self.isLoading = true
        let endUrl = "\(EndPoint.consoleSecurityQuestions)"
        NetworkManager.shared.request(type: SecurityQuestionsResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.securityQuestions = response.data
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
    
    func setPin(Newpin: String,confirmationPin: String) {
        isLoading = true
        let params = PinChangeRequest(
            newPin: Newpin,
            confirmNewPin: confirmationPin
        )
        // API Endpoint
        let endPoint = "\(EndPoint.setPin)"

        // Encode the payload to JSON and log it for debugging
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
    
        
        // Perform API request
        NetworkManager.shared.request(type: PinResponse.self,endPoint: endPoint,httpMethod: .post,parameters: params,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.successMessage = response.message
                    self.error = response.message
                case .failure(let error):
                    // Handle the error scenarios
                    switch error {
                    case .error(let message):
                        self.error = message
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
        // Notification module
    
    // Get All Notifications
    
    func getAllAlertNotifications() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getAllAlerts)"
        NetworkManager.shared.request(type: AlertResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.getAllNotificationAlerts = response.data
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
    
    // Update Notifications
    func updateDiaryData(Allnotifications: Bool ,newemails: Bool ,ScheduleSent: Bool ,Newmessage: Bool, AddOrremove: Bool ,chatDetails: Bool , Connectionexpired: Bool , DateBook: Bool , Diary: Bool ,DoIt: Bool , Note: Bool , Reminder: Bool) {
        self.isLoading = true
        let url = "\(EndPoint.updateAlerts)"
        
        // Create the request body using the struct
        let requestBody = NotificationSettings(
            AllNotifications: Allnotifications,
            newEmail: newemails,
            scheduledSent: ScheduleSent,
            newMessage: Newmessage,
            addOrRemove: AddOrremove,
            chatDetails: chatDetails,
            connectionExpired: Connectionexpired,
            datebook: DateBook,
            diary: Diary,
            doIt: DoIt,
            note: Note,
            reminder: Reminder
        )
        
        NetworkManager.shared.request(
            type: AlertSettingsResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.UpdateNotificationAlerts = [response.data]
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let error):
                        self.error = error
                    case .sessionExpired(error: _):
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    // themes
    
    func Themchange(themes: String , accentcolour: String) {
        isLoading = true
        let params = ThemePayload(theme: themes, accentColor: accentcolour)
        let endPoint = "\(EndPoint.themeChange)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: Themeresponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
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
