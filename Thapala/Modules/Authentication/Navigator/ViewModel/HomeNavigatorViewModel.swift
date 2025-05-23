//
//  HomeNavigatorViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import Foundation

class HomeNavigatorViewModel:ObservableObject{
    @Published var isAdobeSelected = false
    @Published var isBioSelected = false
    @Published var isControlSelected = true
    @Published var address1 = ""
    @Published var address2 = ""
    @Published var city = ""
    @Published var state = ""
    @Published var zipcode = ""
    @Published var country = ""
    @Published var selectedOption: NavigatorOptions? = .controlPanel
    @Published var adobeSelectedOption: AdobeOptions? = .primary
    @Published var controlPanelSelectedOption: ControlPanelOptions? = .acDetails
    @Published var isPrimarySelected = true
    @Published var isSecondarySelected = false
    @Published var isOtherSelected = false
    @Published var isAcDetailsSelected = true
    @Published var isSecuritySelected = false
    @Published var isNotificationsSelected = false
    @Published var isThemesSelected = false
    @Published var isNavigateEditScreen = false
    @Published var amount = ""
    @Published var currency = ""
    @Published var timePeriod = ""
    @Published var postBoxTimePeriod = ""
    @Published var controlPanelSetPin = ""
    @Published var isNotificationToggle = true
    @Published var isPaymentsToggle = false
    @Published var isWalletToggle = true
    @Published var isEmailToggle = false
    @Published var isPlannerEmailsToggle = true
    @Published var isEmailCompose = false
    @Published var isPlusbtn = false
    @Published var isComposeEmail:Bool = false
    @Published var isLoading:Bool = false
    @Published var error: String?
    @Published var lastestData: LastestLoginModel?
    @Published var navigatorBioData: NavigatorBioModel?
    @Published var BioData: [Bio] = []
    @Published var UserData: UserDataModel?
    
    
     func getLastestLogin() {
         self.isLoading = true
         NetworkManager.shared.request(type: LastestLoginModel.self, endPoint: EndPoint.latestLogin, httpMethod: .get,isTokenRequired: true) { [weak self]result in
             guard let self = self else { return }
             switch result {
             case .success(let response):
                 DispatchQueue.main.async {
                     self.isLoading = false
                         self.error = response.message ?? ""
                         self.lastestData = response
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
     
    // get Bio by user ID 
    func getNavigatorBio(userId:Int) {
        self.isLoading = true
        let endUrl = "\(EndPoint.navigatorBio)\(userId)"
        NetworkManager.shared.request(type: NavigatorBioModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                        self.error = response.message ?? ""
                    self.navigatorBioData = response
//                    self.UserData = response.user
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


enum NavigatorOptions {
    case adobe
    case bio
    case controlPanel
}

enum AdobeOptions {
    case primary
    case secondary
    case addOther
}

enum ControlPanelOptions {
    case acDetails
    case security
    case notifications
    case themes
}
