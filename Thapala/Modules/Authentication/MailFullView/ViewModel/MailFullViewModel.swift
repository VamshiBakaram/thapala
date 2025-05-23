//
//  MailFullViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 06/06/24.
//

import Foundation
import UIKit

class MailFullViewModel: ObservableObject {
    @Published var error: String?
    @Published var isLoading = false
//    @Published var composeText: String = ""
    @Published var backToAwaiting: Bool = false
    @Published var attachFromFolder: Bool = false
//    @Published var emailByIdData: EmailsByIdModel?
//    @Published var attachmentsData: [Attachment] = []
    @Published var isEmailOptions: Bool = false
    @Published var isUploadFromFolder: Bool = false
    @Published var isCreateLabel: Bool = false
    @Published var isReply: Bool = false
    @Published var isReplyAll: Bool = false
    @Published var isForward: Bool = false
    @Published var replyViewModel: ReplyEmailViewModel? = nil
    @Published var detailedEmailData: [DetailedEmailData] = []
    @Published var  selectedDateTime: Date? = nil
    
    func getFullEmail(emailId: Int, passwordHash: String, completion: @escaping (Result<EmailsByIdModel, NetworkError>) -> Void) {
        self.isLoading = true
        let endUrl = "\(EndPoint.emailsById)\(emailId)"
        NetworkManager.shared.request(type: EmailsByIdModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true, passwordHash: passwordHash) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                completion(result)
            }
        }
    }
    
    func downloadEmailFile(fileId:Int,type:String,emailId:Int) {
        isLoading = true
        let params = DownloadEmailFilesParams(fileId: fileId, type: type, emailId: emailId)
        NetworkManager.shared.request(type: DownloFileModel.self, endPoint: EndPoint.downloadEmailsFile, httpMethod: .post,parameters: params, isTokenRequired: true, isSessionIdRequited: false) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message
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
    
    func deleteEmailFromAwaiting(emailId:Int) {
        self.isLoading = true
        let params = ["ids": emailId]
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
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                        self.emailData = response.data ?? []
//                        self.emailFullData = response
//                    })
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

    func markEmailAsUnRead(emailId: Int) {
        self.isLoading = true
        let params = ["ids": [emailId]]
        NetworkManager.shared.request(type: MarkAsReadEmailModel.self, endPoint: EndPoint.markAsUnReadEmail, httpMethod: .put, parameters: params, isTokenRequired: true) { [weak self] result in
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
    
    func markEmailAsRead(emailId: Int) {
        self.isLoading = true
        let params = ["ids": [emailId]]
        NetworkManager.shared.request(type: MarkAsReadEmailModel.self, endPoint: EndPoint.markAsReadEmail, httpMethod: .put, parameters: params, isTokenRequired: true) { [weak self] result in
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
    
}



//convert to integer to GB
func formatFileSize(bytes: Int) -> String {
    let kb = Double(bytes) / 1024
    let mb = kb / 1024
    let gb = mb / 1024
    
    if gb >= 1 {
        return String(format: "%.2f GB", gb)
    } else if mb >= 1 {
        return String(format: "%.2f MB", mb)
    } else {
        return String(format: "%.2f KB", kb)
    }
}
//convert to date and time format
func convertToDateTime(timestamp: TimeInterval) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    return dateFormatter.string(from: date)
}

//convert to attributed string

func convertHTMLToAttributedString(html: String) -> NSAttributedString? {
    guard let data = html.data(using: .utf8) else { return nil }
    do {
        return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    } catch {
        print("Error converting HTML to NSAttributedString: \(error)")
        return nil
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                
                if let mutableAttributedString = attributedString.mutableCopy() as? NSMutableAttributedString {
                    let font = UIFont(name: "Poppins-Medium", size: 14.0) ?? UIFont.systemFont(ofSize: 16.0)
                    mutableAttributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: mutableAttributedString.length))
                    return mutableAttributedString
                }
            return nil
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
