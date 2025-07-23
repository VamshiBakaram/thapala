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
                    print("success case")
                    self.lockerVerifyResponse = response
                    self.toastmessage = response.message
                    print("response.message  \(response.message)")
                    self.isLoading = false
                    completion(true)
                    if response.status == 401 {
                        print("Api 401 case")
                        completion(false)
                        self.toastmessage = response.message
                        print("response.message  \(response.message)")
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("failure case")
                    self.isLoading = false
                    completion(false)
                    switch error {
                    case .error(let errorDescription):
                        self.toastmessage = errorDescription
                        print("error case \(self.toastmessage)")
                        completion(false)
                    case .sessionExpired:
                        self.toastmessage = "Please try again later"
                    }
                }
            }
        }
    }
    
    
}
