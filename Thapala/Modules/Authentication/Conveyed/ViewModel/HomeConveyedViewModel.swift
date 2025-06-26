//
//  HomeConveyedViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 20/06/24.
//

import Foundation
class HomeConveyedViewModel:ObservableObject{
    @Published var error: String?
    @Published var isLoading = false
    @Published var isComposeEmail:Bool = false
    @Published var selectedOption: ConveyedOptions? = .emails
    @Published var isEmailsSelected:Bool = true
    @Published var isPrintSelected:Bool = false
    @Published var isShipmentsSelected:Bool = false
    @Published var beforeLongPress:Bool = true
    @Published var starredemail: [StarredModel] = []
    @Published var selectedID: Int? = 0
    @Published var passwordHint: String? = ""
    @Published var isEmailScreen: Bool = false
    @Published var conveyedEmailData:[ConveyedData] = []
    @Published var conveyedEmailCounaData:Count?
    @Published var selectedThreadIDs: [Int] = []

    
    func getConveyedEmailData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.allEmails)page=1&pageSize=10&status=conveyed"
        NetworkManager.shared.request(type: ConveyedModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                        self.error = response.message ?? ""
                    self.conveyedEmailData = response.data ?? []
                 //   self.conveyedEmailCounaData = response.count
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
    
    func deleteEmailFromConvey() {
        self.isLoading = true
        let params = ["ids": selectedThreadIDs]
        NetworkManager.shared.request(type: DeleteEmailModel.self, endPoint: EndPoint.deleteEmailAwaiting, httpMethod: .delete, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    self.beforeLongPress = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.getConveyedEmailData()
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
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func getStarredEmail(selectedEmail:Int) {
        self.isLoading = true
        let url = "\(EndPoint.starEmail)\(selectedEmail)"
        NetworkManager.shared.request(type: StarredModel.self, endPoint: url, httpMethod: .put, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.starredemail = [response]
                        print("starred email, response")
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
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }

    
}


enum ConveyedOptions {
    case emails
    case print
    case shipments
}
