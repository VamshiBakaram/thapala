//
//  HomeDirectoryViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/10/24.
//

import SwiftUI

class HomeDirectoryViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    @Published var isTcontactsSelected: Bool = true
    @Published var isTestSelected: Bool = false
    @Published var isTest2Selected: Bool = false
    @Published var selectedOption: DirectoryOption? = .tContacts
    @Published var country: String = ""
    @Published var state:String = ""
    @Published var city:String = ""
    
    @Published var groupName: String = ""
    
    @Published var searchText = ""
    @Published var DirectoryData: [Users] = []
//    @Published var profileResponse: [ProfileResponse] = []
    @Published var profileIdData: [BioData] = []
    @Published var userdata: [user] = []
    @Published var groupdata: [GroupData] = []
    @Published var groupList: [GroupList] = []
    @Published var DirectoryUpdate : Bool = false
    @Published var beforeLongPress: Bool = true
    @Published var isComposeEmail: Bool = false
    @Published var countryCodes: [CountryData] = []
    @Published var selectedCountryCode: CountryData?
    @Published var allStates: [States] = []
    @Published var selectedState: States?
    @Published var citiesInSelectedState: [String] = []

    func GetDirectoryList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.GetDirectoryList)"
        
        NetworkManager.shared.request(type: DirectoryResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.DirectoryData = response.data.results // Use `response.data` to access `DiaryData`
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
    
    func GetProfileByID(selectId: Int) {
        self.isLoading = true
        let endUrl = "\(EndPoint.GetProfileByID)\(selectId)"
        
        NetworkManager.shared.request(type: ProfileResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.profileIdData = [response.bio]
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
    
    func createGRoup(groupname: String) {
        isLoading = true
        let params = CreateGroupRequest(
            groupName: groupname)
        let endPoint = "\(EndPoint.createGroup)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: CreateGroupResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.groupdata = [response.data]
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
    
    func GetGroupList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.GetGroupList)"
        
        NetworkManager.shared.request(type: GroupResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.groupList = response.data
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

    func getStatesAndCities() {
        guard let fileURL = Bundle.main.url(forResource: "countriesToCities", withExtension: "json") else {
            print("❌ countriesToCities.json not found")
            return
        }

        do {
            let jsonData = try Data(contentsOf: fileURL)
            print("✅ JSON loaded, size: \(jsonData.count) bytes")

            let decoded = try JSONDecoder().decode(CountryData.self, from: jsonData)

            DispatchQueue.main.async {
                guard let firstCountry = decoded.countries.first else {
                    print("⚠️ No countries found in JSON")
                    return
                }

                self.allStates = firstCountry.states
                print("📍 States loaded: \(self.allStates.map { $0.stateName })")

                if let firstState = self.allStates.first {
                    self.selectedState = firstState
                    self.citiesInSelectedState = firstState.cities
                    print("✅ Selected state: \(firstState.stateName)")
                    print("🏙️ Cities: \(firstState.cities)")
                }
            }
        } catch {
            print("❌ Failed to decode JSON: \(error.localizedDescription)")
        }
    }

    func selectState(_ state: States) {
        DispatchQueue.main.async {
            self.selectedState = state
            self.citiesInSelectedState = state.cities
            print("🔁 State changed to: \(state.stateName)")
            print("🏙️ Cities: \(state.cities)")
        }
    }




    
}
