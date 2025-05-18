//
//  VerifyOTPViewModel.swift
//  Thapala
//
//  Created by ahex on 29/04/24.
//

import Foundation

class VerifyOTPViewModel: ObservableObject {
    @Published var otp: [String] = Array(repeating: "", count: 6)
    @Published var initialOTP = ""
    @Published var phoneNumber = ""
    @Published var isLoading = false
    @Published var error: String?
    @Published var isNavigateToSecurutyQuestions = false
    @Published var isNavigateToPassword = false
    /*
     var resetToken:String = ""
     let tCode:String
     init(tCode:String){
         self.tCode = tCode
     }
     */
    let isfromForgot:Bool
    var resetToken:String = ""
    let tCode:String
    init(dialCode: String, phoneNumber: String,isfromForgot:Bool,tCode:String) {
        self.phoneNumber = "\(dialCode) \(phoneNumber.prefix(2))*** ***\(phoneNumber.suffix(2))"
        self.isfromForgot = isfromForgot
        self.tCode = tCode
    }
    
    func setTCode(code: String) {
        initialOTP = code
    }
    
    func setOTPCodeIndex(index: Int, code: String) {
        otp[index] = code
    }
    
    func validate() {
        if otp.isEmpty {
            self.error = "Please enter otp"
            return
        }
        if otp.joined(separator: "").count < 6 {
            self.error = "Please enter 6 digit otp"
            return
        }
        
        if isfromForgot{
            verifyOTP(navigateTo: .securityPassword)
            return
        }
        verifyOTP(navigateTo: .securityQuestions)
        
    }
    func verifyOTP(navigateTo: NavigationDestination) {
        isLoading = true
        let parameters = VerifyOTP(otpCode: otp.joined(separator: ""))
        NetworkManager.shared.request(type: VerifyOTPModel.self, endPoint: EndPoint.verifyOTP, httpMethod: .post, parameters: parameters, isTokenRequired: false, isSessionIdRequited: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let _ = response.status {
                        self.error = response.message ?? ""
                    }else{
                        self.error = response.message ?? ""
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            switch navigateTo {
                            case .securityQuestions:
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                    self.isNavigateToSecurutyQuestions = true
                                })
                            case .securityPassword:
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                    self.isNavigateToPassword = true
                                })
                            }
//                        })
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
    func resendCode() {
        self.isLoading = true
        let parametes = VerifyOtp(tCode: tCode, tryAnotherWay: 1)
        NetworkManager.shared.getSessionId(endPoint: EndPoint.forgotPasswordOtp, httpMethod: .post, parameters: parametes,isFromForgot: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let _ = response.status {
                        self.error = response.message ?? ""
                    }else{
                        self.error = "OTP sent successfully."
                        UserDataManager.shared.sessionId = response.sessionId ?? ""
                        self.resetToken = response.message ?? ""
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                            self.isOtpTapNextNavigateView = true
//                            self.isPresenter = true
//                        })
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
}

enum NavigationDestination {
    case securityQuestions
    case securityPassword
}
