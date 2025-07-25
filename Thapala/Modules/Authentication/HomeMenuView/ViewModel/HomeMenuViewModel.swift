//
//  HomeMenuViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/06/25.
//

import Foundation
class HomeMenuViewModel:ObservableObject{
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var message: String = ""
    // logout or signout
    
    func logout(userID: Int?) {
        isLoading = true
        let params = LogoutRequest(
            userId: userID
        )
        let endPoint = "\(EndPoint.logout)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: LogoutResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.message = response.message ?? ""
                    self.error = response.message
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired(let message):
                        self.error = message
                    }
                }
            }
        }
    }
}
