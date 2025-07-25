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
    @Published var DirectoryData: [Users] = []
    @Published var blockedUsers: [DirectoryUserData] = []
    @Published var profileIdData: [BioData] = []
    @Published var userdata: [user] = []
    @Published var groupdata: [GroupData] = []
    @Published var groupList: [GroupList] = []
    @Published var countryCodes: [SingleCountry] = []
    @Published var allStates: [States] = []
    @Published var citiesInSelectedState: [String] = []
    @Published var searchData: [Usersearch] = []
    @Published var blockData: BlockUserData?
    @Published var memberData: [MemberData] = []
//    @Published var selectedOption: DirectoryOption? = .tContacts
    @Published var country: String = ""
    @Published var state:String = ""
    @Published var city:String = ""
    @Published var groupName: String = ""
    @Published var RenameGroupName: String = ""
    @Published var groupID: Int = 0
    @Published var searchText = ""
    @Published var DirectoryUpdate : Bool = false
    @Published var beforeLongPress: Bool = true
    @Published var isComposeEmail: Bool = false
    @Published var selectedCountryIndex: Int? = nil
    @Published var selectedStateIndex: Int? = nil
    @Published var selectedCityIndex: Int? = nil
    @Published var groupitems: Bool = false
    @Published var reportissue: String = ""
    var filteredCountries: [SingleCountry] {
        if country.isEmpty {
            return []
        } else {
            return countryCodes.filter {
                $0.countryName.lowercased().hasPrefix(country.lowercased())
            }
        }
    }


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
                    self.blockedUsers = [response.data]
                    self.error = response.message
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
                    self.error = response.message
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
                    self.error = response.message
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
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
                    self.error = response.message
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
// search by country state and city
    func GetsearchData(country: String , state: String , city: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.searchByAddress)country=\(country)&state=\(state)&city=\(city)&orderby="
        NetworkManager.shared.request(type: searchAPIResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.searchData = response.data.results // Use `response.data` to access `DiaryData`
                    self.error = response.message
                    
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
            return
        }

        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode(CountryData.self, from: jsonData)
            DispatchQueue.main.async {
                self.countryCodes = decoded.countries
                // Select first country and its states by default
                if let _ = self.countryCodes.first {
                    self.selectCountry(at: -1)
                }
            }
        } catch {
//            print("❌ Failed to decode JSON: \(error.localizedDescription)")
        }
    }
    
    func selectCountry(at index: Int) {
        guard index >= 0 && index < countryCodes.count else { return }
        selectedCountryIndex = index
        
        let selectedCountry = countryCodes[index]
        allStates = selectedCountry.states
        
        if let firstState = selectedCountry.states.first,
           let firstStateIndex = selectedCountry.states.firstIndex(where: { $0.id == firstState.id }) {
            selectState(at: -1)
        } else {
            selectedStateIndex = nil
            citiesInSelectedState = []
            selectedCityIndex = nil
        }
    }
    
    func selectState(at index: Int) {
        guard index >= 0 && index < allStates.count else { return }
        selectedStateIndex = index
        
        let selectedState = allStates[index]
        citiesInSelectedState = selectedState.cities
        
        if !citiesInSelectedState.isEmpty {
            selectCity(at: -1)
        } else {
            selectedCityIndex = nil
        }
    }
    
    func selectCity(at index: Int) {
        guard index >= 0 && index < citiesInSelectedState.count else { return }
        selectedCityIndex = index
    }
    
    
    // add contacts post Api
    func AddContact(contacts: Int) {
        isLoading = true
        let params = AddContactRequest(
            contact: contacts,
            type: "direct"
        )
        let endPoint = "\(EndPoint.addContacts)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: Contactresponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.error = response.message
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    }
                }
            }
        }
    }
    
    
    // moveto created groups post Api 49
    func movetoGroups(GroupdID: Int , userIDs: [Int]) {
        isLoading = true
        let params = MoveToRequest(
            userIds: userIDs
        )
        let endPoint = "\(EndPoint.movetoDirectoryGroup)\(GroupdID)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: MoveToresponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.error = response.message
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    }
                }
            }
        }
    }
    
    
    // report contact post Api
    func reportContact(descriptions: String ,tcode: String) {
        isLoading = true

        let reportJSON = ReportJSON(tCode: tcode)
        let params = ReportRequest(
            description: descriptions,
            reportType: "complaint-on-user",
            reportJSON: reportJSON
        )
        
        let endPoint = "\(EndPoint.reportContact)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: reportContactresponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.error = response.message
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                        print("Error: \(message)")
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
                    }
                }
            }
        }
    }
    
    // block contact post Api
    
    func blockContact(id: Int , type: String) {
        self.isLoading = true
        let url = "\(EndPoint.blockContact)\(type)/\(id)"
        
        // Create the request body using the struct
        let requestBody = blockPayloadRequest(
            type: "userBlock"
        )
        
        NetworkManager.shared.request(type: BlockUserResponse.self, endPoint: url,httpMethod: .put,parameters: requestBody,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.error = response.message
                        self.blockData = response.data
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
    
    
    // Get Groups list items
    
    func GetGroupsList(Groupid: Int) {
        self.isLoading = true
        let endUrl = "\(EndPoint.groupListItems)\(Groupid)?orderby="
        
        NetworkManager.shared.request(type: MembersResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.memberData = response.data ?? []
                    self.error = response.message
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
    
    // Rename Group
    
    func RenameGroup(id: Int , groupname: String) {
        self.isLoading = true
        let url = "\(EndPoint.Renamegroup)\(id)"
        
        // Create the request body using the struct
        let requestBody = UpdateGroupRequest(
            groupName: groupname
        )
        
        NetworkManager.shared.request(type: BlockUserResponse.self, endPoint: url,httpMethod: .put,parameters: requestBody,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.error = response.message
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
    
    
    func deleteEmail(id: Int) {
        self.isLoading = true
        // Create parameters for the payload
        let endUrl = "\(EndPoint.deleteGroup)\(id)"
        NetworkManager.shared.request(type: DeleteUserResponse.self, endPoint: endUrl, httpMethod: .delete, isTokenRequired: true) { [weak self] result in
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


//func converttoIST(dateInput: Any) -> String? {
//    var date: Date?
//
//    if let timestamp = dateInput as? Int {
//        date = Date(timeIntervalSince1970: TimeInterval(timestamp))
//    } else if let dateString = dateInput as? String {
//        let isoDateFormatter = ISO8601DateFormatter()
//        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//        date = isoDateFormatter.date(from: dateString)
//        if date == nil {
//            isoDateFormatter.formatOptions = [.withInternetDateTime]
//            date = isoDateFormatter.date(from: dateString)
//        }
//
//        if date == nil {
//            print("⚠️ Could not parse dateString: \(dateString)")
//        }
//    } else {
//        return nil
//    }
//
//    guard let date = date else { return nil }
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.timeZone = TimeZone(identifier: "Asia/Kolkata")
//    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//    dateFormatter.dateFormat = "dd-MMM-yyyy h:mm a"
//
//    return dateFormatter.string(from: date)
//}

