//
//  LabelledMailsViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/10/24.
//

import SwiftUI
class LabelledMailsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var selectedLabelID: [Int] = [] // bottom tag
    @Published var selectedLabelNames: [String] = []
    @Published var labelledMailsDataModel:[LabelledMailsDataModel] = []
    
//    init() {
//        self.getLabelledEmailData()
//    }
    
    func getLabelledEmailData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.labelledEmails)"
        NetworkManager.shared.request(type: LabelledMailsModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                        self.error = response.message ?? ""
                    self.labelledMailsDataModel = response.data ?? []
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
