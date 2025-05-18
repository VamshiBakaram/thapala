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
    @Published var trasheddata: [datas] = []
    @Published var fileData: [TrashItem] = []
    @Published var PlanData: [PlannerTrashItem] = []
    @Published var plannerRestoreMessage: String = ""
    @Published var plannerDeleteMessage: String = ""
    @Published var trashupdateView: Bool = false
    // GetAllTrash
    func GetTrashData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.GetAlltrash)"
        
        NetworkManager.shared.request(type: trashResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.trasheddata = response.data // Use `response.data` to access `DiaryData`
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
    
    func GetFileTrashData(selectedTab: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.GetRecordsFileTrash)\(selectedTab)"
        
        NetworkManager.shared.request(type: FileTrashResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.fileData = response.data // Use `response.data` to access `DiaryData`
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
                    print("PlannerData fetched: \(self.PlanData.count)")
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
        let url = "\(EndPoint.RestorePlanner)"
        
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
        let url = "\(EndPoint.DeletePlanner)"
        
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
}

