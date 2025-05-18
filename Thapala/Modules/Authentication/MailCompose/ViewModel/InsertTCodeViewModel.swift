//
//  InsertTCodeViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/08/24.
//

import Foundation

class InsertTCodeViewModel: ObservableObject{
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    @Published var isToSelected: Bool = true
    @Published var isCcSelected: Bool = false
    @Published var isBccSelected: Bool = false
    @Published var insertTCodeSelectedOption: InsertTcodeOptions? = .to
    
    @Published var contactsData:[ContactData] = []
    @Published var isBackToEmail: Bool = false
    
    @Published var tCodes: [TCode] = []
    @Published var ccTCodes: [TCode] = []
    @Published var bccTCodes: [TCode] = []
    
    init(){
        getContactsData()
    }
    
    func getContactsData() {
        self.isLoading = true
        NetworkManager.shared.request(type: InsertTCodeModel.self, endPoint: EndPoint.insertTCodeContacts, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.error = response.message ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        switch response.data {
                        case .insertTCodeDataModel(let dataModel):
                            self.contactsData = dataModel.contacts ?? []
                        case .emptyArray:
                            self.contactsData = []
                        case .none:
                            self.contactsData = []
                        }
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
    
    func selectOption(_ option: InsertTcodeOptions) {
        self.insertTCodeSelectedOption = option
        switch option {
        case .to:
            isToSelected = true
            isCcSelected = false
            isBccSelected = false
        case .cc:
            isToSelected = false
            isCcSelected = true
            isBccSelected = false
        case .bcc:
            isToSelected = false
            isCcSelected = false
            isBccSelected = true
        }
        getContactsData()
        
        contactsData.forEach { contact in
            if contact.isSelected {
                toggleSelection(for: contact)
            }
        }
    }
    
    func toggleSelection(for contact: ContactData) {
        if let index = contactsData.firstIndex(where: { $0.uniqueId == contact.uniqueId }) {
            contactsData[index].isSelected.toggle()
            let tCode = TCode(code: contactsData[index].tCode ?? "")
            
            switch insertTCodeSelectedOption {
            case .to:
                if contactsData[index].isSelected {
                    tCodes.append(tCode)
                } else {
                    tCodes.removeAll { $0.id == tCode.id }
                }
            case .cc:
                if contactsData[index].isSelected {
                    ccTCodes.append(tCode)
                } else {
                    ccTCodes.removeAll { $0.id == tCode.id }
                }
            case .bcc:
                if contactsData[index].isSelected {
                    bccTCodes.append(tCode)
                } else {
                    bccTCodes.removeAll { $0.id == tCode.id }
                }
            case .none:
                break
            }
        }
    }
}

enum InsertTcodeOptions {
    case to
    case cc
    case bcc
}
