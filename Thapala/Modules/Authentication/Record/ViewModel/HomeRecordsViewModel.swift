//
//  HomeRecordsViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 19/06/24.
//

import Foundation
import UIKit
import Photos

class HomeRecordsViewModel:ObservableObject{
    @Published var isLoading = false
    @Published var error: String?
    
    @Published var isComposeEmail:Bool = false
    @Published var selectedOption: RecordsOptions? = .work
    
    @Published var isWorkSelected:Bool = true
    @Published var isArchiveSelected:Bool = false
    @Published var isLockerSelected:Bool = false
    @Published var isSubMenu:Bool = false
    @Published var isNewFolder:Bool = false
    @Published var isFileUpload:Bool = false
    @Published var isPlusBtn:Bool = false
    @Published var workRecordsResponse: [WorkRecordsResponse] = []
    @Published var defaultRecordsData: [DefaultRecord] = []
    @Published var recordsData: [FolderRecord] = []
    @Published var filesData: [FileRecord] = []
    @Published var emailsData: [EmailRecord] = []
    @Published var ismoresheet: Bool = false
    @Published var downloadedFileURL: URL?
    @Published var attachmentDataIn: [AttachmentDataModel] = []
    @Published var mainRecordsData: [MainRecord] = []
    @Published var folderID: Int = 0
    @Published var fileType: String = ""
    @Published var subfoldertype: String = ""
    @Published var createFolderView: Bool = false
    @Published var isEmailScreen: Bool = false
    @Published var selectedId: Int? = nil
    @Published var setPin: String = ""
    @Published var password: String = ""
    private let sessionExpiredErrorMessage =  "Session expired. Please log in again."
    
    func getMainRecordsData() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getRecords)"
        
        NetworkManager.shared.request(type: RecordsResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.mainRecordsData = response.mainRecords
                    self.error = response.message
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }

    func getRecordsData(selectedTabID: Int , Type:String , SubFoldersType: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.records)/\(selectedTabID)?type=\(Type)&subfoldertype=\(SubFoldersType)&page=1&pageSize=10"
        
        NetworkManager.shared.request(type: WorkRecordsResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.defaultRecordsData = response.defaultRecords
                    self.recordsData = response.records
                    self.filesData = response.files
                    self.emailsData = response.emails
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    func getSubRecordsData(selectedTabID: Int , Type:String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.subrecords)/\(selectedTabID)?type=\(Type)&page=1&pageSize=10"
        
        NetworkManager.shared.request(type: WorkRecordsResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.defaultRecordsData = response.defaultRecords
                    self.recordsData = response.records.filter { $0.parentId == selectedTabID }
                    self.filesData = response.files
                    self.emailsData = response.emails

                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    func getLockerData(selectedTabID: Int , Type:String , SubFoldersType: String) {
        self.isLoading = true
        let endUrl = "\(EndPoint.records)/\(selectedTabID)?type=\(Type)&subfoldertype=\(SubFoldersType)&page=1&pageSize=10"
        
        NetworkManager.shared.request(type: WorkRecordsResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true, passwordHash: self.password , pin: setPin) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.defaultRecordsData = response.defaultRecords
                    self.recordsData = response.records
                    self.filesData = response.files
                    self.emailsData = response.emails
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(let errorDescription):
                        self.error = errorDescription
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    // bottom delete
    
    func deleteBottom(selectedTabType: String , RecordIds: [Int] , FieldIDs: [FieldID] , EmailIDs: [Int]) {
        isLoading = true
        let params = DeleteFolderRequest(
            recordIds: RecordIds,
            fileIds: FieldIDs,  // Pass array of structs directly
            emailIds: EmailIDs
        )
        let endPoint = "\(EndPoint.bottomDelete)status=\(selectedTabType)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: DeleteFolderResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
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
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    func fileDownloads(selectedfieldID: Int) {
        isLoading = true
        let params = FilePayload(
            fileId: selectedfieldID,
            type: "record"
        )
        let endPoint = "\(EndPoint.downloadFiles)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: DownloadResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
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
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }


    func downloadFile(selectedfieldID: Int, fileLink: String) {
        isLoading = true
        guard let url = URL(string: fileLink) else {
            self.error = "Invalid file URL"
            isLoading = false
            return
        }

        let session = URLSession.shared
        let task = session.downloadTask(with: url) { localURL, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.error = "Download error: \(error.localizedDescription)"
                }
                return
            }

            guard let localURL = localURL else {
                DispatchQueue.main.async {
                    self.error = "Downloaded file URL is nil"
                }
                return
            }

            // Extract the file extension
            let fileExtension = url.pathExtension.lowercased()
            let fileName = "Record_\(selectedfieldID).\(fileExtension)"
            let fileManager = FileManager.default
            let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let destinationURL = docsURL.appendingPathComponent(fileName)
            do {
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                try fileManager.copyItem(at: localURL, to: destinationURL)
                DispatchQueue.main.async {
                    if ["jpg", "jpeg", "png"].contains(fileExtension) {
                        self.saveImageToPhotoLibrary(fileURL: destinationURL)
                    }
                    
                    else if ["mp4", "mov", "m4v", "3gp"].contains(fileExtension) {
                        self.saveVideoToPhotoLibrary(fileURL: destinationURL)
                    }
                    else if ["pdf", "doc", "docx", "odt", "rtf", "txt", "xls", "xlsx", "ods", "ppt", "pptx", "odp", "mp3", "wav", "zip", "rar"].contains(fileExtension) {
                        self.presentShareSheet(for: destinationURL)
                        }
                    
                    else {
                        self.showUnsupportedFormatAlert(for: destinationURL)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Failed to save file: \(error.localizedDescription)"
                }
            }
        }

        task.resume()
    }

    
    func showUnsupportedFormatAlert(for fileURL: URL) {
        let alert = UIAlertController(
            title: "Unsupported Format",
            message: "This file type isn't supported by iOS. Try opening it with another app (like VLC) using the Share button.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Share", style: .default, handler: { _ in
            self.presentShareSheet(for: fileURL)
        }))
        
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            DispatchQueue.main.async {
                rootVC.present(alert, animated: true)
            }
        }
    }

    func presentShareSheet(for fileURL: URL) {
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

        // Present from the top-most view controller
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            DispatchQueue.main.async {
                rootVC.present(activityVC, animated: true, completion: nil)
            }
        }
    }


    func saveImageToPhotoLibrary(fileURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self.error = "Photo Library access denied."
                }
                return
            }

            guard let data = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.error = "Could not load image from file."
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.error = "Image saved to Photos library"
                    } else {
                        self.error = error?.localizedDescription ?? "Failed to save to Photos."
                    }
                }
            }
        }
    }

    func saveVideoToPhotoLibrary(fileURL: URL) {
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self.error = "Photo Library access denied."
                }
                return
            }

            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: fileURL)
            }) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.error = "Video saved to Photos library"
                    } else {
                        self.error = error?.localizedDescription ?? "Failed to save video to Photos."
                    }
                }
            }
        }
    }
    
    // rename three dots sheet
    func rename(fileRecordName: String , subfoldertype: String, selectedfieldID: Int , fileType: String) {
        self.isLoading = true
        let url = "\(EndPoint.renamefile)\(selectedfieldID)?type=\(fileType)"
        
        // Create the request body using the struct
        let requestBody = renamePayload(
            recordName: fileRecordName,
            subFolderType: subfoldertype
        )
        
        NetworkManager.shared.request(type: RenameFileResponse.self, endPoint: url, httpMethod: .put, parameters: requestBody, isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                error = "rename successfully "
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        response.message.self
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch error {
                    case .error(error: let error):
                        self.error = error
                    case .sessionExpired(error: _):
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    
    // create new folder
    
    func createNewFolder(folderName: String , parentID: Int , Type: String ,subFolderType: String) {
        isLoading = true
        let params = CreateFolderRequest(
            folderName: folderName,
                parentId: parentID,
                type: Type,
                subFolderType: subFolderType
        )
        let endPoint = "\(EndPoint.createFolder)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: CreateFolderResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
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
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }
    
    func fileupload(folderID: Int, fileType: String, subfoldertype: String, fileName: String, azureFileName: String, fileLink: String, fileSize: String) {
        isLoading = true

        let uploadFile = UploadFile(
            fileName: fileName,
            azureFileName: azureFileName,
            fileLink: fileLink,
            fileSize: fileSize
        )

        let params = UploadPayload(
            files: [uploadFile],
            folderId: folderID,
            type: fileType,
            subFolderType: subfoldertype
        )

        let endPoint = "\(EndPoint.uploadfile)"

        NetworkManager.shared.request(type: UploadResponses.self, endPoint: endPoint, httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response): break
                    // You can set a success message or handle response further here.
                case .failure(let error):
                    switch error {
                    case .error(let message):
                        self.error = message
                    case .sessionExpired:
                        self.error = self.sessionExpiredErrorMessage
                    }
                }
            }
        }
    }

    func uploadImages(_ images: [UIImage]) {
        let url = URL(string: "\(EndPoint.attachmentsReplyMail)")!
//        let url = URL(string: "http://128.199.21.237:8080/api/v1/attachments")!
        var request = URLRequest(url: url)
        let sessionManager = SessionManager()
        request.httpMethod = "POST"
        request.setValue("Bearer \(sessionManager.token)", forHTTPHeaderField: "Authorization")

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let body = createImageBody(boundary: boundary, images: images)
        
        let task = URLSession.shared.uploadTask(with: request, from: body) { responseData, response, error in
            if let error = error {
                return
            }

            if let response = response as? HTTPURLResponse, let responseData = responseData {
                do {
                    let attachmentResponse = try JSONDecoder().decode(AttachmentModel.self, from: responseData)
                    DispatchQueue.main.async {
                        self.handleAttachmentResponse(attachmentResponse)
                        if let attachments = attachmentResponse.attachments {
                            for attachment in attachments {
                                self.fileupload(
                                    folderID: self.folderID,
                                    fileType: self.fileType,
                                    subfoldertype: self.subfoldertype,
                                    fileName: attachment.fileName ?? "",
                                    azureFileName: attachment.fileName ?? "",
                                    fileLink: attachment.fileLink ?? "",
                                    fileSize: attachment.fileSize ?? ""
                                )
                            }
                        }
                        
                    }
                } catch {
                }
            }
        }
        task.resume()
    }

    func createImageBody(boundary: String, images: [UIImage]) -> Data {
        var body = Data()

        for (index, image) in images.enumerated() {
            guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }

            let filename = "image\(index).jpg"
            let mimeType = "image/jpeg"

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"attachment\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    func handleAttachmentResponse(_ response: AttachmentModel) {
        if let attachments = response.attachments {
            self.attachmentDataIn.append(contentsOf: attachments)
        }
        self.error = response.message
    }

}





enum RecordsOptions {
    case work
    case archive
    case locker
}
