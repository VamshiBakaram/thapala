//
//  MailComposeViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import Foundation
import SwiftUI

class MailComposeViewModel:ObservableObject{
    @Published var error: String?
    @Published var isLoading = false
    @Published var from: String = ""
    @Published var to: String = ""
    @Published var cc: String = ""
    @Published var bcc: String = ""
    @Published var tCodes: [TCode] = []
    @Published var ccTCodes: [TCode] = []
    @Published var bccTCodes: [TCode] = []
    @Published var subject: String = ""
    @Published var image: String = ""
    @Published var scheduledtime: String = ""
    @Published var firstname: String = ""
    @Published var lastname: String = ""
    @Published var usertcode: String = ""
    @Published var receipienttcode: String = ""
    @Published var receipientfirstname: String = ""
    @Published var receipientlastname: String = ""
    @Published var composeEmail: String = ""
    @Published var scheduleTime: String = ""
    @Published var passwordHint: String = ""
    @Published var threadId: Int = 0
    @Published var draftMailId: Int = 0
    @Published var replyTo: Int = 0
    @Published var attachments: String = ""
    @Published var isArrow: Bool = false
    @Published var suggest: Bool = false
    @Published var CCsuggest: Bool = false
    @Published var BCCsuggest: Bool = false
    @Published var isEmailSend: Bool = false
    @Published var isPasswordProtected:Bool = false
    @Published var isSubMenu:Bool = false
    @Published var isSchedule:Bool = false
    @Published var sendEmailResponse:SendEmailsModel?
    @Published var backToscreen:Bool = false
    @Published var isInsertFromRecords:Bool = false
    @Published var selectedFiles: [URL] = []
    @Published var attachmentDataIn: [AttachmentDataModel] = []
    @Published var detailedEmailData: [DetailedEmailData] = []
    @Published var trashMessage: String = ""
    @Published var EmailUserdata : EmailUser?
    @Published var mailFullView: Bool = false
    @Published var mailStars: Int = 0
    @Published private var markAs : Int = 0
    @Published var tcodeinfo: [TcodeData] = []
        @Published var tcodesuggest: TcodeSuggest?
    
    func sendEmail() {
        isLoading = true
        var emailParams = SendEmailParams(to: [to],subject: subject, body: composeEmail)
        if !cc.isEmpty{
            emailParams.cc = [cc]
        }
        if !bcc.isEmpty{
            emailParams.bcc = [bcc]
        }
        if !ComposeEmailData.shared.passwordHint.isEmpty{
            emailParams.passwordHint = ComposeEmailData.shared.passwordHint
        }
        scheduleTime = String(ComposeEmailData.shared.timeStap)
        if !scheduleTime.isEmpty{
            emailParams.scheduledTime = scheduleTime
        }
        if !attachmentDataIn.isEmpty{
            emailParams.attachments = attachmentDataIn
        }
        
        let endPoint = "\(EndPoint.sendEmail)\(ComposeEmailData.shared.isScheduleCreated)&passwordProtected=\(ComposeEmailData.shared.isPasswordProtected)&reply=\(false)"
        NetworkManager.shared.request(type: SendEmailsModel.self, endPoint: endPoint, httpMethod: .post, parameters: emailParams, isTokenRequired: true,passwordHash: ComposeEmailData.shared.passwordHash, isSessionIdRequited: false) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message
                    self.sendEmailResponse = response
                }
                if response.message == "Email sent securely with password protection." || response.message == "Email sent successfully!." || response.message == "Email scheduled successfully." || response.message == "Email sent successfully."{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.resetComposeEmailData()
                        self.backToscreen = true
                    })
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let message):
                        self.error = message
                    case .sessionExpired(error: _ ):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func saveDraftData() {
        isLoading = true
        var emailParams = SendEmailParams(to: [to],subject: subject, body: composeEmail)
        if !cc.isEmpty{
            emailParams.cc = [cc]
        }
        if !bcc.isEmpty{
            emailParams.bcc = [bcc]
        }
        if !ComposeEmailData.shared.passwordHint.isEmpty{
            emailParams.passwordHint = ComposeEmailData.shared.passwordHint
        }
        let endPoint = "\(EndPoint.saveEmailtoDrafts)passwordProtected=\(ComposeEmailData.shared.isPasswordProtected)"
        NetworkManager.shared.request(type: SaveEmailToDraftsModel.self, endPoint: endPoint, httpMethod: .post, parameters: emailParams, isTokenRequired: true,passwordHash: ComposeEmailData.shared.passwordHash, isSessionIdRequited: false) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message
                }
                if response.message == "Email saved successfully as draft."{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.resetComposeEmailData()
                        self.backToscreen = true
                    })
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let message):
                        self.error = message
                    case .sessionExpired(error: _ ):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func resetComposeEmailData(){
        ComposeEmailData.shared.isPasswordProtected = false
        ComposeEmailData.shared.isScheduleCreated = false
        ComposeEmailData.shared.passwordHash = ""
        ComposeEmailData.shared.passwordHint = ""
        ComposeEmailData.shared.timeStap = 0.0
    }
    
    func scheduleSend() {
        self.isSchedule = true
    }
    
    func saveDraft() {
        saveDraftData()
    }
    
     func addTCode() {
        if isValidTCode(to) {
            let newTCode = TCode(code: to)
            tCodes.append(newTCode)
            to = ""
        } else {
            error = "tCode must be exactly 10 digits."
        }
    }
    func addCcTCode() {
       if isValidTCode(cc) {
           let newTCode = TCode(code: cc)
           ccTCodes.append(newTCode)
           cc = ""
       } else {
           error = "tCode must be exactly 10 digits."
       }
   }
    func addBccTCode() {
       if isValidTCode(bcc) {
           let newTCode = TCode(code: bcc)
           bccTCodes.append(newTCode)
           bcc = ""
       } else {
           error = "tCode must be exactly 10 digits."
       }
   }

    func removeTCode(_ tCode: TCode) {
        tCodes.removeAll { $0.id == tCode.id }
    }
    
    func removeCcTCode(_ tCode: TCode) {
        ccTCodes.removeAll { $0.id == tCode.id }
    }

    func removeBccTCode(_ tCode: TCode) {
        bccTCodes.removeAll { $0.id == tCode.id }
    }

    private func isValidTCode(_ code: String) -> Bool {
        return code.count == 10 && code.allSatisfy({ $0.isNumber })
    }
    
    func determineFileType(fileURL: URL) -> String {
           switch fileURL.pathExtension.lowercased() {
           case "jpg", "jpeg":
               return "image/jpeg"
           case "pdf":
               return "application/pdf"
           case "txt":
               return "text/plain"
           default:
               return "application/octet-stream"
           }
       }
    
    
    func getFullEmail(emailId: Int) {
        self.isLoading = true
        let endUrl = "\(EndPoint.emailsById)\(emailId)"
        NetworkManager.shared.request(type: EmailsByIdModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.detailedEmailData = response.email ?? []
//                    print("suggested t code response \(response)")
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

    
    func getSerachTcode(searchKey: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.searchTcode)?searchKey=\(searchKey)"
        NetworkManager.shared.request(type: TcodeSuggest.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.tcodesuggest = response
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
    
    // bottom Draft Trash
    func Drafttrash(EmailID: Int) {
        self.isLoading = true
        let url = "\(EndPoint.trash)"
        
        // Create the request body using the struct
        let requestBody = ClearDraftRequest(emailId: EmailID)
        
        NetworkManager.shared.request(type: DraftClearResponse.self, endPoint: url,httpMethod: .put,parameters: requestBody,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.trashMessage = response.message
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let error):
                        self.error = error
                    case .sessionExpired(error: _):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
}
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
