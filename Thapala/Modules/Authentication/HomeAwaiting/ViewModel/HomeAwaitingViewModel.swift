//
//  HomeAwaitingViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import Foundation
import SwiftUI

class HomeAwaitingViewModel: ObservableObject {
    @Published var isEmailSelected: Bool = true
    @Published var isPrintSelected: Bool = false
    @Published var isOntlineSelected: Bool = false
    @Published var selectedOption: Option? = .email
    @Published var isDraftsSelected: Bool = true
    @Published var istDraftselected: Bool = false
    @Published var isScheduledSelected: Bool = false
    @Published var istLetersSelected: Bool = false
    @Published var istCardsSelected: Bool = false
    @Published var outlineSelectedOption: OutlineOption? = .draft
    @Published var emailData: [HomeEmailsDataModel] = []
    @Published var emailFullData: HomeEmailsModel?
    @Published var starredemail: [StarredModel] = []
    @Published var selectedThreadIDs: [Int] = []
    @Published var draftsData: [HomeDraftsDataModel] = []
    @Published var draftsFullData: HomeDraftsModel?
    @Published var tDraftsData: [HomeDraftsDataModel] = []
    @Published var scheduleData: [HomeDraftsDataModel] = []
//    @Published var snoozedmail: [SnoozeResponse] = []
    @Published var createLabelData: [Labeldata] = []
    @Published var isLoading: Bool = false
    @Published var threadID: [Int] = []
    @Published var error: String?
    @Published var selectedID: Int?
    @Published var passwordHint: String? = ""
    @Published var isEmailScreen: Bool = false
    @Published var isComposeEmail: Bool = false
    @Published var isdraftEmail: Bool = false
    @Published var isScheduleEmail: Bool = false
    @Published var isPlusBtn: Bool = false
    @Published var beforeLongPress: Bool = true
    @Published var draftBeforeLongPress: Bool = true
  //  @Published var isSheet: Bool = false
    @Published var replyViewModel: ReplyEmailViewModel? = nil
    @Published var isReply:Bool = false
    @Published var to = ""
    @Published var cc = ""
    @Published var bcc = ""
    @Published var subject = ""
    @Published var body = ""
    @Published var draftView: Bool = false
    

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
                    self.emailData = response.data ?? []
                    self.emailFullData = response
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

    func getDraftsData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.allEmails)status=draft&page=1&pageSize=30"
        NetworkManager.shared.request(type: HomeDraftsModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.draftsData = response.data ?? []
                    self.draftsFullData = response
                    if !self.draftsData.isEmpty {
                        self.error = "Draft mails fetched successfully"
                    }
                    else {
                        self.error = response.message ?? ""
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
                    case .sessionExpired(error: _):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func getTDraftsData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.allEmails)status=tdraft&page=1&pageSize=30"
        NetworkManager.shared.request(type: HomeDraftsModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("tDraftData",response)
                    self.tDraftsData = response.data ?? []
                    
                    if !self.tDraftsData.isEmpty {
                        self.error = "TDraft mails fetched successfully"
                    }
                    else {
                        self.error = response.message ?? ""
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
                    case .sessionExpired(error: _):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    func getScheduleEmailsData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.allEmails)status=scheduled&page=1&pageSize=30"
        NetworkManager.shared.request(type: HomeDraftsModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.scheduleData = response.data ?? []
                    
                    if !self.tDraftsData.isEmpty {
                        self.error = "Scheduled mails fetched successfully"
                    }
                    else {
                        self.error = response.message ?? ""
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
                    case .sessionExpired(error: _):
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }

    func deleteEmailFromAwaiting(threadIDS: [Int]) {
        self.isLoading = true
        let params = DeleteEmailPayload (
            ids: threadIDS
        )
        NetworkManager.shared.request(type: DeleteEmailModel.self, endPoint: EndPoint.deleteEmailAwaiting, httpMethod: .delete, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    self.beforeLongPress = true
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
    

    var shouldDisplayOpenEnvelope: Bool {
        guard let emailFullData = emailFullData else { return false }
        let selectedEmails = emailFullData.data?.filter { selectedThreadIDs.contains($0.threadID ?? 0) }
        return ((selectedEmails?.contains { $0.readReceiptStatus == 0 }) != nil)
    }

//    func toggleReadStatusForSelectedEmails() {
//        guard let emailFullData = emailFullData else { return }
//
//        let selectedEmails = emailFullData.data!.filter { selectedThreadIDs.contains($0.threadID!) }
//        for email in selectedEmails {
//            if email.readReceiptStatus == 0 {
//                markEmailAsRead(email: [email])
//            } else {
//                markEmailAsUnRead(email: [email])
//            }
//            self.beforeLongPress = true
//        }
//    }
    
    func getStarredEmail(selectedEmail:Int) {
        self.isLoading = true
        let url = "\(EndPoint.starEmail)\(selectedEmail)"
        NetworkManager.shared.request(type: StarredModel.self, endPoint: url, httpMethod: .put, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
//                    self.isLoading = false
                    self.error = response.message ?? ""
                        self.starredemail = [response]
                        print("starred email, response")
                    
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


    func snoozedEmail(snoozedAt: Int , selectedThreadID : [Int]) {
        self.isLoading = true
        let url = "\(EndPoint.snoozedmail)"
        let params = SnoozeRequest(
            status: true,
            snoozedAt: snoozedAt,
            emailIds: selectedThreadID
        )
        NetworkManager.shared.request(type: SnoozeResponse.self, endPoint: url, httpMethod: .put, parameters: params , isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
    //                    self.isLoading = false
                    self.error = response.message
//                        self.snoozedmail = [response]
                        print("starred email, response")
                    
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
    
    func createLabel(createLabelName: String) {
        isLoading = true
        let params = CreateLabelRequest(
            labelName: createLabelName
        )
        let endPoint = "\(EndPoint.createLabel)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: CreateLabelResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    response.message.self
                    self.createLabelData = [response.data]
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    default:
                        self.error = "An unexpected error occurred."
                    }
                }
            }
        }
    }
    
    func ApplyLabel(LabelId : [Int] , threadId: [Int]) {
        isLoading = true
        let params = ApplyLabelRequest(
            labelIds: LabelId ,
            threadIds: threadId
        )
        let endPoint = "\(EndPoint.ApplyLabel)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: ApplyLabelResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    response.message.self
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    default:
                        self.error = "An unexpected error occurred."
                    }
                }
            }
        }
    }
}


//MARK:convertion data into time format
func convertToIST(dateInput: Any) -> String? {
    let date: Date?
    
    if let timestamp = dateInput as? Int {
        date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    } else if let dateString = dateInput as? String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        date = isoDateFormatter.date(from: dateString)
    } else {
        return nil
    }
    
    guard let date = date else { return nil }
    
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
    dateFormatter.locale = Locale(identifier: "en_US_POSIX") // This ensures AM/PM style
    
    let currentYear = Calendar.current.component(.year, from: Date())
    let dateYear = Calendar.current.component(.year, from: date)
    
    // The formats were the same anyway; you can adjust if you want different ones.
    if dateYear == currentYear {
        dateFormatter.dateFormat = "dd-MMM-yyyy h:mm a"
    } else {
        dateFormatter.dateFormat = "dd-MMM-yyyy h:mm a"
    }
    
    let formattedDateString = dateFormatter.string(from: date)
    return formattedDateString
}


//converting to timestamp
func convertToTimestamp(dateString: String, timeString: String) -> Double? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy h:mm a"
        let dateTimeString = "\(dateString) \(timeString)"
        
        if let date = dateFormatter.date(from: dateTimeString) {
            return date.timeIntervalSince1970
        } else {
            return nil
        }
    }

func convertToTimeDate(dateInput: Any) -> String? {
    let date: Date?

    if let timestamp = dateInput as? Int {
        date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    } else if let dateString = dateInput as? String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        date = isoDateFormatter.date(from: dateString)
    } else {
        return nil
    }

    guard let date = date else { return nil }
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
    dateFormatter.dateFormat = "dd-MMM-yyyy h:mm a"
    return dateFormatter.string(from: date)
}
