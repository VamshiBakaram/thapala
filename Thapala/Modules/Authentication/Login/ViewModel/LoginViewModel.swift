//
//  LoginViewModel.swift
//  Thapala
//
//  Created by ahex on 23/04/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var password = ""
    @Published var tCode: [String] = Array(repeating: "", count: 10)
    @Published var initialTCode = ""
    
    @Published var isShowCreateAccount = false
    @Published var isLoading = false
    @Published var error: String?
    
    @Published var forgotPassword = false
    @Published var forgotPasswordData:UserData?
    
    @Published var isPresenter:Bool = false
    
    @Published var userData: LoginResponse?
        
    func navigate() {
        isShowCreateAccount = true
        forgotPassword = false
        isPresenter = true
    }
    
    func setTCode(code: String) {
        initialTCode = code
    }
    
    func setTCodeIndex(index: Int, code: String) {
        tCode[index] = code
    }
    
    func validate(completion: @escaping() -> Void) {
        if tCode.joined(separator: "").isEmpty {
            error = "Please enter tCode"
            return
        }
        if tCode.joined(separator: "").count < 10 {
            error = "Please enter complete tCode"
            return
        }
        if password.isEmpty {
            error = "Please enter password"
            return
        }
        self.isLoading = true
        let parametes = Login(tCode: tCode.joined(separator: ""), password: password)
        
        NetworkManager.shared.requestToken(type: LoginResponse.self, endPoint: EndPoint.login, httpMethod: .post, parameters: parametes, isTokenRequired: false) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        let sessionManager = SessionManager()
                        sessionManager.token = response.token ?? "hlo"
                        sessionManager.userName = response.model?.user?.firstname ?? ""
                        sessionManager.lastName = response.model?.user?.lastname ?? ""
                        sessionManager.userTcode = response.model?.user?.tCode ?? ""
                        sessionManager.userId = response.model?.user?.id ?? 0
                        sessionManager.pin = response.model?.user?.pin ?? ""
                        sessionManager.password = self.password
                        self.error = response.model?.message ?? ""
                        
                        if response.model?.message == "User logged in successfully." {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                completion()
                            }
                        }
                        if response.model?.message == "Server error with status code: 401"{
                            self.error = "Incorrect or invalid password."
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.isLoading = false
                        switch error {
                        case .error(let error):
                            self.error = "Incorrect or invalid password."
                            if error == "Server error with status code: 401"{
                                self.error = "Incorrect or invalid password."
                            }
                            
                        case .sessionExpired(_):
                            self.error = "Invalid tCode."
                        }
                    }
                }
            }
    }
    
    func navigateToForgotPassword() {
        forgotPassword = true
        isShowCreateAccount = false
        }
    
    func forgotUserData() {
        if tCode.joined(separator: "").isEmpty {
            error = "Please enter tCode"
            return
        }
        if tCode.joined(separator: "").count < 10 {
            error = "Please enter complete tCode"
            return
        }
        self.isLoading = true
        let parametes = PasswordForgot(tCode: tCode.joined(separator: ""))
        NetworkManager.shared.request(type: forgotUserDetailsModel.self, endPoint: EndPoint.forgotPassword, httpMethod: .post, parameters: parametes, isTokenRequired: false) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    self.forgotPasswordData = response.result
                    if response.message != "User not found with this tcode."{
                        self.isPresenter = true
                    }
                    self.navigateToForgotPassword()
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
