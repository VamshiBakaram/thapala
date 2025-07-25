//
//  BottomSheetViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import Foundation
import SwiftUI

class BottomSheetViewModel: ObservableObject {
    @Published var selectedLabelID: [Int] = []
    @Published var selectedLabelNames: [String] = []
    @Published var isLabelView: Bool = false
    @Published var isMoveToView: Bool = false
    @Published var isLoading: Bool = false
    @Published var toastmessage: String? = ""
    @Published var setPin: String = ""
    @Published var password: String = ""
    @Published var lockerVerifyResponse: verifyLockerResponse? = nil
    
    func getLockerVerify(completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        let endUrl = "\(EndPoint.verifyCredentials)"
        NetworkManager.shared.request(type: verifyLockerResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true, passwordHash: self.password , pin: setPin) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.lockerVerifyResponse = response
                    self.toastmessage = response.message
                    self.isLoading = false
                    completion(true)
                    if response.status == 401 {
                        completion(false)
                        self.toastmessage = response.message
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(false)
                    switch error {
                    case .error(let errorDescription):
                        self.toastmessage = errorDescription
                        completion(false)
                    case .sessionExpired:
                        self.toastmessage = "Please try again later"
                    }
                }
            }
        }
    }
    
    
}
