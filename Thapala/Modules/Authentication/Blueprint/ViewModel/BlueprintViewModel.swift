//
//  BlueprintViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 25/06/24.
//

import Foundation
class BlueprintViewModel:ObservableObject{
    @Published var error: String?
    
    @Published var isComposeEmail:Bool = false
    @Published var selectedOption: BlueprintOptions? = .compose
    
    @Published var isComposeSelected = true
    @Published var isLettersSelected = false
    @Published var isCardsSelected = false
    @Published var emailEditor:String = ""
//    @Published var isPlusBtn:Bool = false
    @Published var isSchedule:Bool = false
    @Published var ccTCodes: [tCode] = []
    @Published var bccTCodes: [tCode] = []
    @Published var from: String = ""
    @Published var to: String = ""
    @Published var cc: String = ""
    @Published var bcc: String = ""
    @Published var subject: String = ""
    @Published var composeEmail: String = ""
    @Published var tCodes: [tCode] = []
    @Published var suggest: Bool = false
    @Published var tcodesuggest: TcodeSuggest?
    @Published var isArrow: Bool = false
    @Published var tcodeinfo: [TcodeData] = []
    @Published var beforeLongPress: Bool = true
    @Published var isLoading = false
    @Published var userdatum: [Userdatum] = []
    
    func saveToTdraft(To: [String] ,CC: [String] ,BCC: [String] ,Subject: String ,Body: String) {
        isLoading = true
        let params = EmailPayload(to: To ,
             cc: CC,
             bcc: BCC,
             subject: Subject,
             body: Body
        )
        let endPoint = "\(EndPoint.saveToDraft)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: SaveDraftResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.userdatum = response.userData
                    self.error = response.message
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = "Add atleast One Tcode"
                    case .sessionExpired:
                        self.error = "Session expired. Please log in again."
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
    }
    

    
     func addTCode() {
        if isValidTCode(to) {
            let newTCode = tCode(code: to)
            tCodes.append(newTCode)
            to = ""
        } else {
            error = "tCode must be exactly 10 digits."
        }
    }
    func addCcTCode() {
       if isValidTCode(cc) {
           let newTCode = tCode(code: cc)
           ccTCodes.append(newTCode)
           cc = ""
       } else {
           error = "tCode must be exactly 10 digits."
       }
   }
    func addBccTCode() {
       if isValidTCode(bcc) {
           let newTCode = tCode(code: bcc)
           bccTCodes.append(newTCode)
           bcc = ""
       } else {
           error = "tCode must be exactly 10 digits."
       }
   }

    func removeTCode(_ tCode: tCode) {
        tCodes.removeAll { $0.id == tCode.id }
    }
    
    func removeCcTCode(_ tCode: tCode) {
        ccTCodes.removeAll { $0.id == tCode.id }
    }

    func removeBccTCode(_ tCode: tCode) {
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
}


enum BlueprintOptions {
    case compose
    case letters
    case cards
}
