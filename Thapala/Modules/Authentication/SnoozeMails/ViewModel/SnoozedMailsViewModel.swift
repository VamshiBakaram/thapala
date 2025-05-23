//
//  SnoozedMailsViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/10/24.
//
import SwiftUI
class SnoozedMailsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var isEmailScreen: Bool = false
    @Published var passwordHint: String? = ""
    @Published var selectedID: Int? = nil
    @Published var snoozedMailsDataModel:[SnoozedMailsDataModel] = []
    init() {
        self.getSnoozedEmailData(selectedTabItem : "awaited")
    }
    
    func getSnoozedEmailData(selectedTabItem : String) {
        self.isLoading = true
        
        let endUrl = "\(EndPoint.snoozedEmails)\(selectedTabItem)"
        NetworkManager.shared.request(type: SnoozedMailsModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                        self.error = response.message ?? ""
                    self.snoozedMailsDataModel = response.data ?? []
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
