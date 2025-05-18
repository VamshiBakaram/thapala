//
//  CreateAccountViewModel.swift
//  Thapala
//
//  Created by ahex on 23/04/24.
//

import Foundation

class CreateAccountViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var phoneNumber = ""
    @Published var error: String?
    @Published var isLoading = false
    
    @Published var isNavigateToOtpView = false
    @Published var countryCodes: [CountryCode] = []
    @Published var selectedCountryCode: CountryCode? = nil
    @Published var selectedCountryName:CountryCode? = nil
    @Published var isShowCountryDropdown = false
    
    private var sessionManager: SessionManager
    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
        getCountryCodes()
    }
    
    func handleDropdown() {
        isShowCountryDropdown.toggle()
    }
    
    func validate() {
        if firstName.isEmpty {
            self.error = "Please enter first name"
            return
        }
        if firstName.count <= 2{
            self.error = "First Name must be at least 3 characters long"
            return
        }
        if !isValidStartWithAlphabet(text: firstName) {
            self.error = "First name should start with Alphabets only"
                   return
               }
        if lastName.isEmpty {
            self.error = "Please enter last name"
            return
        }
        if lastName.count <= 2{
            self.error = "First Name must be at least 3 characters long"
            return
        }
        if !isValidStartWithAlphabet(text: lastName) {
            self.error = "Last name should start with Alphabets only"
                   return
               }
        if phoneNumber.isEmpty {
            self.error = "Please phone number"
            return
        }
        if phoneNumber.count < 10{
            self.error = "Mobile Number must contain 10 digits"
            return
        }
        createAccount()
    }
    
    func createAccount() {
        isLoading = true
        let parameters = CreateAccount(firstname: firstName, lastname: lastName, countryCode: selectedCountryCode?.dial_code ?? "",country: selectedCountryCode?.name ?? "", phoneNumber: phoneNumber)
        NetworkManager.shared.getSessionId(endPoint: EndPoint.createAccount, httpMethod: .post, parameters: parameters) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let _ = response.status {
                        self.error = response.message ?? ""
                    }else{
                        self.error = response.message ?? ""
//                        self.sessionManager.sessionId = response.sessionId ?? ""
                        UserDataManager.shared.sessionId = response.sessionId ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.isNavigateToOtpView = true
                        })
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let message):
                        self.error = message
                    case .sessionExpired(error: _ ):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func getCountryCodes() {
        guard let fileURL = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") else {
            return
        }
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let countryCodes = try JSONDecoder().decode([CountryCode].self, from: jsonData)
            DispatchQueue.main.async {
                self.countryCodes = countryCodes
                let defaultCode = self.countryCodes.filter({ $0.code == (Locale.current.region?.identifier ?? "") })
                self.selectedCountryCode = defaultCode.first
            }
        }catch{
            
        }
    }
    
    func isValidStartWithAlphabet(text: String) -> Bool {
            guard let firstCharacter = text.first else { return true }
            return firstCharacter.isLetter
        }
}
