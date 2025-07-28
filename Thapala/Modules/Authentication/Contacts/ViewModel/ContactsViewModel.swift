//
//  ContactsViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//

import SwiftUI

class ContactsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var contactsData:[ContactsDataModel] = []
    private let sessionExpiredErrorMessage =  "Session expired. Please log in again."
    
    init() {
        self.getContactsData()
    }
    
    func getContactsData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.contacts)"
        NetworkManager.shared.request(type: ContactsModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    self.contactsData = response.data ?? []
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
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
}
