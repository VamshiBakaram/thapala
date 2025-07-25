//
//  ReplyEmailViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/08/24.
//

import Foundation
class ReplyEmailViewModel:ObservableObject{
    @Published var error: String?
    @Published var isLoading = false
    @Published var toAddress = ""
    @Published var ccAddress = ""
    @Published var bccAddress = ""
    @Published var subject = ""
    @Published var messageBody = ""
    @Published var subSubject = ""
    @Published var isArrow = false
    @Published var isSnooze = false
    @Published var tCodes: [TCode] = []
    @Published var ccTCodes: [TCode] = []
    @Published var bccTCodes: [TCode] = []
    @Published var scheduleTime: String = ""
    @Published var attachmentDataIn: [AttachmentDataModel] = []
    @Published var sendEmailResponse:SendEmailsModel?
    @Published var backToscreen = false
    @Published var replyToId: String = ""
    @Published var threadId: String = ""
    @Published var composeEmail: String = ""
    
    init(to: String, cc: String, bcc: String, subject: String, body: String,replyToId:String,threadId:String,subSubject:String) {
           self.toAddress = to
           self.ccAddress = cc
           self.bccAddress = bcc
           self.subject = subject
           self.messageBody = body
        self.replyToId = replyToId
        self.threadId = threadId
        self.subSubject = subSubject
       }
    
    func deleteEmailFromAwaiting(){
        self.isLoading = true
        let params = ["ids": threadId]
        NetworkManager.shared.request(type: DeleteEmailModel.self, endPoint: EndPoint.deleteEmailAwaiting, httpMethod: .delete, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        self.getEmailsData()
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
    
    func getEmailsData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.allEmails)status=awaited"
        NetworkManager.shared.request(type: HomeEmailsModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
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
    
    func sendEmail() {
        isLoading = true
        var emailParams = SendEmailParams(to: [toAddress],subject: subject, body: messageBody)
        if !ccAddress.isEmpty{
            emailParams.cc = [ccAddress]
        }
        if !bccAddress.isEmpty{
            emailParams.bcc = [bccAddress]
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
        if !replyToId.isEmpty{
            emailParams.replyToId = replyToId
        }
        if !threadId.isEmpty{
            emailParams.threadId = threadId
        }
        
        let endPoint = "\(EndPoint.sendEmail)\(ComposeEmailData.shared.isScheduleCreated)&passwordProtected=\(ComposeEmailData.shared.isPasswordProtected)&reply=\(true)"
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
    
    func resetComposeEmailData(){
        ComposeEmailData.shared.isPasswordProtected = false
        ComposeEmailData.shared.isScheduleCreated = false
        ComposeEmailData.shared.passwordHash = ""
        ComposeEmailData.shared.passwordHint = ""
        ComposeEmailData.shared.timeStap = 0.0
    }
    
    func addTCode() {
       if isValidTCode(toAddress) {
           let newTCode = TCode(code: toAddress)
           tCodes.append(newTCode)
           toAddress = ""
       } else {
           error = "tCode must be exactly 10 digits."
       }
   }
   func addCcTCode() {
      if isValidTCode(ccAddress) {
          let newTCode = TCode(code: ccAddress)
          ccTCodes.append(newTCode)
          ccAddress = ""
      } else {
          error = "tCode must be exactly 10 digits."
      }
  }
   func addBccTCode() {
      if isValidTCode(bccAddress) {
          let newTCode = TCode(code: bccAddress)
          bccTCodes.append(newTCode)
          bccAddress = ""
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
    
    func uploadFiles(fileURLs: [URL]) {
        let url = URL(string: "\(EndPoint.attachmentsReplyMail)")!
//        let url = URL(string: "http://128.199.21.237:8080/api/v1/attachments")!
        var request = URLRequest(url: url)
        let sessionManager = SessionManager()
        request.httpMethod = "POST"
        request.setValue("Bearer \(sessionManager.token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let data = createBody(boundary: boundary, fileURLs: fileURLs)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                return
            }
            
            if let response = response as? HTTPURLResponse, let responseData = responseData {
                do {
                    let attachmentResponse = try JSONDecoder().decode(AttachmentModel.self, from: responseData)
                    DispatchQueue.main.async {
                        // Handle the response, e.g., update the view model
                        self.handleAttachmentResponse(attachmentResponse)
                    }
                } catch {
                }
            }
        }
        task.resume()
    }

    func createBody(boundary: String, fileURLs: [URL]) -> Data {
        var body = Data()
        
        for fileURL in fileURLs {
            let filename = fileURL.lastPathComponent
            let mimeType = determineFileType(fileURL: fileURL)
            
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            do {
                       let fileData = try Data(contentsOf: fileURL)
                       body.append(fileData)
                   } catch {
                       continue
                   }
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }

    func handleAttachmentResponse(_ response: AttachmentModel) {
        if let attachments = response.attachments {
          //  self.attachmentDataIn.append(contentsOf: attachments)
        }
        self.error = response.message
    }
    
}
