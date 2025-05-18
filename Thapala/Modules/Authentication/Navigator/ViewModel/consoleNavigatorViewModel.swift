//
//  consoleViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 11/04/25.
//

import Foundation

class consoleviewModel:ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    @Published var GetUserSettings: [UserSetting] = []
    @Published var GetTotalStorage: [StorageData] = []
    @Published var savesetting: [UserSettings] = []
    @Published var SecurityQuestions: [securityQuestion] = []
    @Published var contactNumber: String = ""
    @Published var currentPassword: String = ""
    @Published var NewPassword: String = ""
    @Published var isContactsDialogVisible = false
    @Published var countryCodes: [Countrycode] = []
    @Published var selectedCountryCode: CountryCode? = nil
    @Published var isShowCountryDropdown = false
    @Published var successMessage: String = ""
    @Published var GetAllNotificationAlerts: [AlertData] = []
    @Published var updateNotificationAlerts: [AlertSettingsData] = []
    @Published var theme: String?
//    @Published var selectedTheme: String = "light"
//
//    var currentTheme: Theme {
//        ThemeManager.getTheme(AppTheme(rawValue: selectedTheme) ?? .dark)
//    }
    
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
                    self.GetUserSettings = response.settings
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

    func getTotalStorage() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getTotalStorage)"
        NetworkManager.shared.request(type: StorageResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.GetTotalStorage = response.data
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
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    default:
                        self.error = "An unexpected error occurred."
                    }
                }
            }
        }
    }
    
    // Security Account Console module
    
    func getUserSecurityQuestions() {
        self.isLoading = true
        let endUrl = "\(EndPoint.ConsolesecurityQuestions)"
        NetworkManager.shared.request(type: SecurityQuestionsResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.SecurityQuestions = response.data
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
            print("Request JSON: \(jsonString)")
        }
    
        
        // Perform API request
        NetworkManager.shared.request(type: PinResponse.self,endPoint: endPoint,httpMethod: .post,parameters: params,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    print("Comment added successfully: \(response.message)")
                    self.successMessage = response.message
                case .failure(let error):
                    // Handle the error scenarios
                    switch error {
                    case .error(let message):
                        self.error = message
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    default:
                        self.error = "An unexpected error occurred."
                    }
                }
            }
        }
    }
    
        // Notification module
    
    // Get All Notifications
    
    func getAllAlertNotifications() {
        self.isLoading = true
        let endUrl = "\(EndPoint.GetAllAlerts)"
        NetworkManager.shared.request(type: AlertResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.GetAllNotificationAlerts = response.data
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
                        self.updateNotificationAlerts = [response.data]
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let error):
                        self.error = error
                    case .sessionExpired(error: _):
                        self.error = "Please try again later"
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
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    default:
                        self.error = "An unexpected error occurred."
                    }
                }
            }
        }
    }

}
