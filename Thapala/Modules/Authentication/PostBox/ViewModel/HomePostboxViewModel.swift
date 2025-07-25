//
//  HomePostboxViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 20/06/24.
//

import Foundation
class HomePostboxViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    @Published var isComposeEmail:Bool = false
    @Published var selectedOption: PostBoxOptions? = .emails
    @Published var isEmailsSelected:Bool = true
    @Published var isPrintSelected:Bool = false
    @Published var isChatboxSelected:Bool = false
    @Published var postBoxEmailData:[PostboxDataModel] = []
    @Published var starredemail: [StarredModel] = []
    @Published var ContactsList: [contact] = []
    @Published var ChatContacts: [chatContacts] = []
    @Published var GetChatMessage: [ChatMessage] = []
    @Published var selectedThreadIDs: [Int] = []
    @Published var beforeLongPress: Bool = true
    @Published var selectedID: Int? = nil
    @Published var passwordHint: String? = ""
    @Published var isEmailScreen: Bool = false
    @Published var isChatBoxScreen: Bool = false
    @Published var selectID: Int = 0
    @Published var roomid: String = ""
    @Published var starEmail: Int = 0
    
    func getPostEmailData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.allEmails)page=1&pageSize=30&status=postbox"
        NetworkManager.shared.request(type: PostboxModel.self, endPoint: endUrl, httpMethod: .get,isTokenRequired: true) { [weak self]result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                        self.error = response.message ?? ""
                        self.postBoxEmailData = response.data ?? []
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
    
    func getContactsList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.insertTCodeContacts)"
        NetworkManager.shared.request(type: ContactResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.ContactsList = response.data.contacts
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    // get chat contacts
    func getChatContacts() {
        self.isLoading = true
        let endUrl = "\(EndPoint.contacts)"
        NetworkManager.shared.request(type: ChatContactresponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.ChatContacts = response.data
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
    
    // Get All chat history
    func getAllChats(senderID: Int , recieverId: Int) {
        self.isLoading = true
        let endUrl = "\(EndPoint.getChatMessages)senderId=\(senderID)&receiverId=\(recieverId)&page=1&pageSize=500"
        NetworkManager.shared.request(type: ChatAPIResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.GetChatMessage = response.data.messages
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = "Please try again later"
                    }
                }
            }
        }
    }
}

