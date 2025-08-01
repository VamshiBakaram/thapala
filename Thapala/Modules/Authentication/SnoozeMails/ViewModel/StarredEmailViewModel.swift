//
//  StarredEmailViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/10/24.
//
import SwiftUI

class StarredEmailViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var starredEmailData:[StarredEmailDataModel] = []
    @Published var starredemail: String?
    @Published var isEmailScreen: Bool = false
    @Published var passwordHint: String? = ""
    @Published var selectedID: Int? = nil
    private let sessionExpiredErrorMessage =  "Session expired. Please log in again."
//    
//    init() {
//        self.getStarredEmailData(selectedTabItem: "awaited")
//    }

    func  getStarredEmailData(selectedTabItem: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.starredEmails)\(selectedTabItem)"
        NetworkManager.shared.request(type: StarredEmailModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                        self.starredEmailData = response.data ?? []
                    
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let error):
                        DispatchQueue.main.async {
                            self.error = error
                        }
                    case .sessionExpired(error: _):
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    func getStarredEmail(selectedID:Int) {
        self.isLoading = true
        let url = "\(EndPoint.starEmail)\(selectedID)"
        NetworkManager.shared.request(type: StarredModel.self, endPoint: url, httpMethod: .put, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.error = response.message ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.starredemail = response.message ?? ""
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
                    case .sessionExpired(error: _):
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
}
