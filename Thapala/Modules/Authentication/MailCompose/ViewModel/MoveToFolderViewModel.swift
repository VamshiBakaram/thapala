//
//  MoveToFolderViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/08/24.
//

import Foundation
class MoveToFolderViewModel:ObservableObject{
    @Published var isLoading: Bool = false
    @Published var error: String?
    @Published var folderData: [FolderModel] = []
    
    func getFoldersData() {
        self.isLoading = true
        NetworkManager.shared.request(type: GetFolderModel.self, endPoint: EndPoint.getAllFolders, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    DispatchQueue.main.async {
                        self.folderData = response.folders ?? []
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
    
    func moveToFolder(folderId:Int,recordName:String,selectedThreadIDs:[Int]) {
        isLoading = true
        let params = MoveToFolderParams(folderId: folderId, recordName: recordName, makeACopy: true, emailIds: selectedThreadIDs)
        NetworkManager.shared.request(type: MoveEmailToFolderModel.self, endPoint: EndPoint.moveToFolder, httpMethod: .post,parameters: params, isTokenRequired: true, isSessionIdRequited: false) { [weak self]result in
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
    
    func moveToLockerFolder(folderId:Int,recordName:String,selectedThreadIDs:[Int] , password: String , pin: String) {
        isLoading = true
        let params = MoveToFolderParams(folderId: folderId, recordName: recordName, makeACopy: true, emailIds: selectedThreadIDs)
        NetworkManager.shared.request(type: MoveEmailToFolderModel.self, endPoint: EndPoint.moveToFolder, httpMethod: .post,parameters: params, isTokenRequired: true, passwordHash: password, pin: pin, isSessionIdRequited: false) { [weak self]result in
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

    
    
}
