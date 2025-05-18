//
//  ResetForgotPasswordViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/05/24.
//

import Foundation
class ResetForgotPasswordViewModel:ObservableObject{
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isLoading = false
    @Published var isShowPassword = false
    @Published var error: String?
    @Published var isShowConfirmPassword = false
    @Published var isNavigateSuccess = false
        
    func validate(resetToken:String) {
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
        createUserResetPassword(resetToken:resetToken)
    }
    
    func createUserResetPassword(resetToken:String) {
        self.isLoading = true
        print(resetToken)
        let parametes = UserResetPasswordData(newPassword: password, confirmPassword: confirmPassword)
        NetworkManager.shared.request(type: UserResetPasswordModel.self, endPoint: "\(EndPoint.userResetPassword)/\(resetToken)", httpMethod: .put, parameters: parametes, isSessionIdRequited: false) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let _ = response.status {
                        self.isLoading = false
                        self.error = response.message ?? ""
                    }else{
                        self.isLoading = false
                        self.error = response.message ?? ""
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            self.isNavigateSuccess = true
                        })
                    }
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

