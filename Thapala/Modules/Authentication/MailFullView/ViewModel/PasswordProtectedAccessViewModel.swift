//
//  PasswordProtectedAccessViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 05/07/24.
//

import Foundation
class PasswordProtectedAccessViewModel:ObservableObject{
    @Published var error:String?
    @Published var isLoading:Bool = false
    @Published var password = ""
    @Published var hint = ""
    
    @Published var isPasswordProtected:Bool = false
    @Published var emailByIdData:EmailsByIdModel?
    @Published var composeText:String = ""
    @Published var attachmentsData:[Attachment] = []
    
    func validate(idEmail:Int){
        if password.isEmpty {
            error = "Please enter Password"
            return
        }
        self.isPasswordProtected = true
    }
    
    func getFullEmail(emailId:Int,passwordHash:String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.emailsById)\(emailId)"
        NetworkManager.shared.request(type: EmailsByIdModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true,passwordHash: passwordHash) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    self.emailByIdData = response
                    let stringValue = response.email?[0].body ?? ""
                    self.composeText = (convertHTMLToAttributedString(html: stringValue))?.string ?? ""
                    self.attachmentsData = response.email?[0].attachments ?? []
                    
                    if self.error == "Email retrieved successfully."{
                        self.isPasswordProtected = true
                    }
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
