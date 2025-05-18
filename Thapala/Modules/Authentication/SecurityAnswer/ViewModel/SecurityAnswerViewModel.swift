//
//  SecurityAnswerViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/05/24.
//

import Foundation

class SecurityAnswerViewModel:ObservableObject{
    
    @Published var error: String?
    @Published var isLoading = false
    @Published var securityAnswer = ""
    @Published var isshowPassword = false
    @Published var navigateToResetPass = false
    @Published var isPresenter:Bool = false
    @Published var resetToken = ""
    
    let tCode:String
    init(tCode:String){
        self.tCode = tCode
    }
    
    func validate(){
        if securityAnswer.isEmpty {
            error = "Please enter Security Answer"
            return
        }
        verifyAnswer()
    }
    
    func verifyAnswer() {
        self.isLoading = true
        let parametes = VerifyAnswer(tCode: tCode, tryAnotherWay: 0, securityAnswer: securityAnswer)
        NetworkManager.shared.request(type: SecurityAnswerModel.self, endPoint: EndPoint.forgotPasswordOtp, httpMethod: .post, parameters: parametes, isSessionIdRequited: false) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        self.navigateToResetPass = true
                        self.resetToken = response.resetToken ?? ""
                        self.navigateToResetPass = true
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
//        NetworkManager.shared.getSessionId(endPoint: EndPoint.forgotPasswordOtp, httpMethod: .post, parameters: parametes) { [weak self]result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    if let _ = response.status {
//                        self.error = response.message ?? ""
//                    }else{
//                        self.error = response.message ?? ""
//                        UserDataManager.shared.sessionId = response.sessionId ?? ""
//                        print("Session Is",response.sessionId ?? "")
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                            self.navigateToResetPass = true
//                        })
//                    }
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    switch error {
//                    case .error(error: let message):
//                        self.error = message
//                    case .sessionExpired(error: _ ):
//                        self.error = "Please try again later"
//                    }
//                }
//            }
//        }
    }
    
}
