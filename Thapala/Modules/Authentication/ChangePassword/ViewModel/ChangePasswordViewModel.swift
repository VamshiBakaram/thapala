//
//  ChangePasswordViewModel.swift
//  Thapala
//
//  Created by ahex on 30/04/24.
//

import Foundation

class ChangePasswordViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var isShowPassword = false
    @Published var isShowConfirmPassword = false
    @Published var isNavigateSuccess = false
    @Published var error: String?
    
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var createpasswordData:CreatePasswordModel?
    
    func validate() {
        if password.isEmpty {
            self.error = "Enter Password"
            return
        }
        if confirmPassword.isEmpty {
            self.error = "Enter Confirm Password"
            return
        }
        if password != confirmPassword {
            self.error = "Paasword and confirm password should be same"
            return
        }
        createPassword()
    }
    func navigate() {
        self.isNavigateSuccess = true
    }
    
    func createPassword() {
        self.isLoading = true
        let parametes = CreatePasswordParams(password: password, timeZone: "Asia/Calcutta")
        NetworkManager.shared.request(type: CreatePasswordModel.self, endPoint: EndPoint.createPassword, httpMethod: .post, parameters: parametes, isSessionIdRequited: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    self.createpasswordData = response
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.navigate()
                    })
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let error):
                        DispatchQueue.main.async {
                            self.error = error
                        }
                    case .sessionExpired(error: _ ):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
}
