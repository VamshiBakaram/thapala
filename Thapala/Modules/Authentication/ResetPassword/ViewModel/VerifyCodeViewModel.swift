//
//  VerifyCodeViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/05/24.
//

import Foundation

class VerifyCodeViewModel: ObservableObject {
    
    @Published var error: String?
    @Published var isLoading = false
    @Published var forgotPasswordOtpData:ResetpasswordModel?
    @Published var otpTapBorderColor: Bool = false
    @Published var otherWayTapBorderColor: Bool = false
    @Published var isOtpTapNextNavigateView:Bool = false
    @Published var isPresenter:Bool = false
    var resetToken:String = ""
    let tCode:String
    init(tCode:String){
        self.tCode = tCode
    }
    
    func borderAlert() {
        if !otpTapBorderColor && !otherWayTapBorderColor {
            self.error = "Please select any of the above options"
        }
    }

    
    func verifyCode() {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            self.isOtpTapNextNavigateView = true
                            self.isPresenter = true
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
}
