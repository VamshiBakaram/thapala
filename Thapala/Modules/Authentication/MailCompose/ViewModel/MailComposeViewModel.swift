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
//    @Published var isInsertTcode: Bool = false
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
  //  @Published var isFilePickerPresented = false
    @Published var isInsertFromRecords:Bool = false
    @Published var selectedFiles: [URL] = []
    @Published var attachmentDataIn: [AttachmentDataModel] = []
    @Published var detailedEmailData: [DetailedEmailData] = []
    @Published var trashMessage: String = ""
    // created at 17/11/2024
    @Published var EmailUserdata : EmailUser?
    @Published var mailFullView: Bool = false
    @Published var mailStars: Int = 0
    @State private var markAs : Int = 0
//    @Published var SenderUserData : EmailUser? // for thread id
        

    @Published var tcodeinfo: [TcodeData] = []
        @Published var tcodesuggest: TcodeSuggest?
//    @Published var Tcod = tCode?
    
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
        print("endPoint",endPoint)
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
        print("endPoint",endPoint)
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
        print("Schedule clicked")
    }
    
    func saveDraft() {
        print("Save Draft clicked")
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
    
//    func fileupload(folderID: Int, fileType: String, subfoldertype: String, fileName: String, azureFileName: String, fileLink: String, fileSize: String) {
//        isLoading = true
//
//        let uploadFile = UploadFile(
//            fileName: fileName,
//            azureFileName: azureFileName,
//            fileLink: fileLink,
//            fileSize: fileSize
//        )
//
//        let params = UploadPayload(
//            files: [uploadFile],
//            folderId: folderID,
//            type: fileType,
//            subFolderType: subfoldertype
//        )
//
//        let endPoint = "\(EndPoint.uploadfile)"
//
//        NetworkManager.shared.request(type: UploadResponses.self, endPoint: endPoint, httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.isLoading = false
//                switch result {
//                case .success(let response):
//                    print("Upload successful: \(response.message)")
//                    // You can set a success message or handle response further here.
//                case .failure(let error):
//                    switch error {
//                    case .error(let message):
//                        self.error = message
//                        print("Error: \(message)")
//                    case .sessionExpired:
//                        self.error = "Session expired. Please log in again."
//                    default:
//                        self.error = "An unexpected error occurred."
//                    }
//                }
//            }
//        }
//    }
    
//    func uploadImages(_ images: [UIImage]) {
//        let url = URL(string: "http://128.199.21.237:8080/api/v1/attachments")!
//        var request = URLRequest(url: url)
//        let sessionManager = SessionManager()
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(sessionManager.token)", forHTTPHeaderField: "Authorization")
//
//        let boundary = UUID().uuidString
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        let body = createImageBody(boundary: boundary, images: images)
//        
//        let task = URLSession.shared.uploadTask(with: request, from: body) { responseData, response, error in
//            if let error = error {
//                print("Error uploading images: \(error)")
//                return
//            }
//
//            if let response = response as? HTTPURLResponse, let responseData = responseData {
//                print("Status code: \(response.statusCode)")
//                do {
//                    let attachmentResponse = try JSONDecoder().decode(AttachmentModel.self, from: responseData)
//                    print("Response: \(attachmentResponse)")
//                    DispatchQueue.main.async {
//                        self.handleAttachmentResponse(attachmentResponse)
//                        if let attachments = attachmentResponse.attachments {
//                            for attachment in attachments {
//                                self.fileupload(
//                                    folderID: 1060,
//                                    fileType: "work",
//                                    subfoldertype: "files",
//                                    fileName: attachment.fileName ?? "",
//                                    azureFileName: attachment.fileName ?? "",
//                                    fileLink: attachment.fileLink ?? "",
//                                    fileSize: attachment.fileSize ?? ""
//                                )
//                            }
//                        }
//                        
//                    }
//                } catch {
//                    print("Failed to decode response: \(error)")
//                }
//            }
//        }
//        task.resume()
//    }
//
//    func createImageBody(boundary: String, images: [UIImage]) -> Data {
//        var body = Data()
//
//        for (index, image) in images.enumerated() {
//            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
//
//            let filename = "image\(index).jpg"
//            let mimeType = "image/jpeg"
//
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//            body.append(imageData)
//            body.append("\r\n".data(using: .utf8)!)
//        }
//
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//        return body
//    }
//    func handleAttachmentResponse(_ response: AttachmentModel) {
//        if let attachments = response.attachments {
//            self.attachmentDataIn.append(contentsOf: attachments)
//        }
//        self.error = response.message
//    }
    
//        func getFullEmail(emailId:Int) {
//            print(emailId)
//            self.isLoading = true
//            let endUrl = "\(EndPoint.emailsById)\(emailId)"
//            NetworkManager.shared.request(type: EmailsByIdModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true) { result in
//             //   guard let self = self else { return }
//                switch result {
//                case .success(let response):
//                    DispatchQueue.main.async {
//                        self.isLoading = false
//                        self.error = response.message ?? ""
//                        self.emailByIdData = response
//                        let stringValue = response.email?[0].body ?? ""
//                        self.composeText = (convertHTMLToAttributedString(html: stringValue))?.string ?? ""
//                        self.attachmentsData = response.email?[0].attachments ?? []
//                        print("Data updated: \(self.composeText)")
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        self.isLoading = false
//                        switch error {
//                        case .error(error: let error):
//                            DispatchQueue.main.async {
//                                self.error = error
//                            }
//                        case .sessionExpired(error: _ ):
//                            self.error = "Please try again later"
//                        }
//                    }
//                }
//            }
//        }
    
//    func getFullEmail(emailId: Int, completion: @escaping (Result<EmailsByIdModel, NetworkError>) -> Void) {
//        self.isLoading = true
//        let endUrl = "\(EndPoint.emailsById)\(emailId)"
//        NetworkManager.shared.request(type: EmailsByIdModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { result in
//            DispatchQueue.main.async {
//                self.isLoading = false
//                completion(result)
//            }
//        }
//    }
    
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
//    //on click of draft mail
//
//    func emaildraftdata(threadID : Int) {  // created at 17/11/2024 
//        self.isLoading = true
//        let endUrl = "\(EndPoint.emailsById)\(threadID)"
//        NetworkManager.shared.request(type: EmailUser.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    self.EmailUserdata = response
//                    self.tCode = response.tCode
////                    completion(result)
//                    print("suggested t code response \(response)")
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self.isLoading = false
//                    switch error {
//                    case .error(error: let error):
//                        DispatchQueue.main.async {
//                            self.error = error
//                        }
//                    case .sessionExpired(error: _):
//                        self.error = "Please try again later"
//                    }
//                }
//            }
//        }
//    }

    
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
                    print("suggested t code response \(response)")
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
