//
//  trashViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 26/03/25.
//

import Foundation


class TrashViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    @Published var trashData: [Emaildata] = []
    @Published var fileData: [TrashItem] = []
    @Published var folderData: [TrashFolder] = []
    @Published var PlanData: [PlannerTrashItem] = []
    @Published var plannerRestoreMessage: String = ""
    @Published var plannerDeleteMessage: String = ""
    @Published var trashupdateView: Bool = false
    @Published var selectedID: Int?
    @Published var passwordHint: String? = ""
    @Published var isEmailScreen: Bool = false
    @Published var beforeLongPress: Bool = true
    // GetAllTrash
    func GetTrashData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getAlltrash)"
        
        NetworkManager.shared.request(type: trashResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.trashData = response.data // Use `response.data` to access `DiaryData`
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
    
    // Get Files Trash DATA
    
    func GetFileTrashData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getRecordsFileTrash)"
        
        NetworkManager.shared.request(type: FileTrashResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                        self.fileData = response.data
                    self.error = response.message.self
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
    
    // Get folder Trash Data
    func GetFolderTrashData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getRecordsFoldersTrash)"
        
        NetworkManager.shared.request(type: TrashResponseModel.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.folderData = response.data // Use `response.data` to access `DiaryData`
                    self.error = response.message.self
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
    
    func GetPlannerTrashData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.plannerTrash)"
        
        NetworkManager.shared.request(type: PlannerTrashResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.PlanData = response.data.plannerTrash // Use `response.data` to access `DiaryData`
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
    
    // restore planner
    

    func restorePlanner(selectedID: [Int]) {
        self.isLoading = true
        let url = "\(EndPoint.restorePlanner)"
        
        // Create the request body using the struct
        let requestBody = UpdateRequest(
            ids: selectedID
        )
        
        NetworkManager.shared.request(type: PlannerRestoreResponse.self, endPoint: url, httpMethod: .put, parameters: requestBody, isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.plannerRestoreMessage = response.message
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

    
    func deleteplanner(selectedID: [Int]) {
        self.isLoading = true
        let url = "\(EndPoint.deletePlanner)"
        
        // Create the request body using the struct
        let requestBody = RequestBody(
            ids: selectedID
        )
        
        NetworkManager.shared.request(type: DeleteCommentResponse.self, endPoint: url, httpMethod: .put, parameters: requestBody, isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.plannerDeleteMessage = response.message
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
    
    func restoreFiles(RecordIds: [Int] , FieldIDs: [Int]) {
        isLoading = true
        let params = RestoreRequest(
            recordIds: RecordIds,
            fileIds: FieldIDs
        )
        let endPoint = "\(EndPoint.restoreFiles)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: RestoreResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    response.message.self
                    self.error = response.message.self
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    }
                }
            }
        }
    }
    
    func deleteFiles(RecordIds: [Int] , selectedFieldID: Int , AzureFileName: String , FileSize: String) {
        isLoading = true
        
        let field = FileID(
                id: selectedFieldID,
                azureFileName: AzureFileName,
                type: "work" ,
                fileSize: FileSize
        )
        
        let params = DeleteFileRequests(
            recordIds: RecordIds,
            fileIds: [field]
        )
        
        let endPoint = "\(EndPoint.deleteFiles)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: DeletefolderResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    response.message.self
                    self.error = response.message.self
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    }
                }
            }
        }
    }

    
    func deleteFolders(RecordIds: [Int] , FileIds: [Int]) {
        isLoading = true
        
        let params = DeleteFolderRequests(
            recordIds: RecordIds,
            fileIds: FileIds
        )
        
        let endPoint = "\(EndPoint.deleteFiles)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: DeletefolderResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    response.message.self
                    self.error = response.message.self
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    }
                }
            }
        }
    }
    
    
    func restoreMails(threadID: [Int]) {
        self.isLoading = true
        let url = "\(EndPoint.emailRestore)"
        
        // Create the request body using the struct
        let requestBody = RestoreMailsPayload(
            threadId: threadID
        )
        
        NetworkManager.shared.request(type: RestoreMailsResponse.self, endPoint: url, httpMethod: .put, parameters: requestBody, isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.plannerRestoreMessage = response.message
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
    
    func deleteEmail(selectedEmailIDs: [Int]) {
        self.isLoading = true
        // Create parameters for the payload
        let params = DeleteEmailRequest(
            emailIds: selectedEmailIDs
        )
        let endUrl = "\(EndPoint.emailDelete)"
        NetworkManager.shared.request(type: DeleteEmailResponse.self, endPoint: endUrl, httpMethod: .delete, parameters: params, isTokenRequired: true) { [weak self] result in
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

