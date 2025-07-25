//
//  HomePlannerViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import Foundation
class HomePlannerViewModel:ObservableObject{
    @Published var error: String?
    
    @Published var isComposeEmail:Bool = false
    @Published var selectedOption: PlannerOptions? = .doit
    
    @Published var isDoItSelected = true
    @Published var isDairySelected = false
    @Published var isNoteSelected = false
    @Published var isDateSelected = false
    @Published var addtask = false
    @Published var doItTapped = false
    @Published var addNote = false
    @Published var image: String = ""
    @Published var isLoading = false
    @Published var note: String = ""
    @Published var title: String = ""
    @Published var Diarytask = false
    @Published var Notetask = false
    @Published var Diaryviewupdate = false
    @Published var Diaryupdate: Bool = false
    @Published var Noteupdate: Bool = false
    @Published var tDate: Bool = false
    @Published var selectedtodo:Bool = false // do it
    @Published var createLabel: Bool = false
    @Published var titlediary: Bool = false
    @Published var notediary: Bool = false
    @Published var tNotetitle: Bool = false
    @Published var tNotenote: Bool = false
    @Published var selectedID: Int = 0
    @Published var labelcomments: [Comment] = []
    @Published var diaryData: PlannerItem?
    @Published var NoteData: PlannerItems?
    @Published var sessionManager = SessionManager()
    @Published var listData: [Diary] = []
    @Published var NotelistData: [Note] = []
    @Published var successMessage: String?
    @Published var type: [String] = []
    @Published var commentdelete:[DeleteCommentRequest] = []
    @Published var Datalabel : [LabelData] = []
    @Published var TagLabelData: [Labels] = []
    @Published var TagLabelNoteData: [Labell] = []
    @Published var TagLabelDoitData: [LabelTags] = []
    @Published var selectedLabelID: [Int] = []
    @Published var selectedLabelNoteID: [Int] = []
    @Published var selectedLabelDoitID: [Int] = []
    @Published var labelMessage: String = ""
    @Published var  selectedDateTime: Date? = nil
    @Published var reminder: String?
    @Published var  task: [String] = []
    @Published var comment: String = ""
    @Published var DiaryUpdateRespons: [DiaryUpdateResponse]?
    @Published var LabelID: [Int] = []
    @Published var HistoryscheduleData: [PlannerHistory] = []
    @Published var isPlusBtn:Bool = false
    @Published var doitlistData: [Doit] = []
    @Published var selectedItem: Int?
    @Published var selectedDoItId: Int?
    @Published var doitHistoryData: [PlannerDoitHistory] = []
    @Published var Addtasks : [DoitAddItems] = [] // Add task
    @Published var NewNotetask : [Notelist] = [] // create new Note
    @Published var updateDoitData: updateItem? // notification doit
    @Published var NotificationNotetime: Int?
    @Published var DiaryNotificationNotetime: Int?
    @Published var isTagActive: Bool = false
    @Published var NewDiarytask : [NewDiary] = [] // crete new Diary
    @Published var isDiaryTagActive: Bool = false
    @Published var selectedLabelNames: [String] = []
    @Published var DateBookListData: [DatebookItem] = [] // DateBook GetList
    @Published var AddEventData : [DatebookItems] = [] // Add Event DateBook post
    
    
    // Diary get method
    func GetDiaryDataList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.diaryList)"
        
        NetworkManager.shared.request(type: DiaryResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.listData = response.data.diaries // Use `response.data` to access `DiaryData`
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

    //Diary put method
    func updateDiaryData(selectedID: Int, notediary: String, titlediary: String) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = DiaryUpdateRequest(note: notediary, title: titlediary)
        
        NetworkManager.shared.request(
            type: UpdatedPlannerResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        self.diaryData = response.updatedPlannerItem // Update local data with response
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
    
    // put method  click done on notification bottom sheet
    func onclickDone(selectedID: Int, reminder: Int?) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = PlannerPayload(
            reminder: reminder,
            type: "diary"
        )
        
        NetworkManager.shared.request(
            type: UpdatedPlannerResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        self.diaryData = response.updatedPlannerItem // Update local data with response
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
    
    func updateCommentData(selectedId: Int , commentide : Int , comment : String) {
        self.isLoading = true
        let url = "\(EndPoint.updateComment)"
        
        // Create the request body using the struct
        let requestBody = editUpdateRequest(
            parentId: selectedId,
            commentId: commentide,
            comment: comment,
            type: "diary",
            status: "todo"
        )
        NetworkManager.shared.request(
            type: DiaryUpdateResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
    // remove the tag in diaryupdateview xdelete method
    func removeTag(selectedID: Int , Tagid : Int) {
        self.isLoading = true
        let url = "\(EndPoint.removeTagLabel)plannerId=\(selectedID)&labelId=\(Tagid)"
        
        // Create the request body using the struct
        let requestBody = RemoveLabelRequest(
            plannerId: selectedID,
            labelId: Tagid
        )
        
        NetworkManager.shared.request(
            type: RemoveLabelResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
 
    
    // Diary Delete comments method
    func deletecomments(selectedIDs: Int, commentIDs: Int) {
        self.isLoading = true
        // Create parameters for the payload
        let params = DeleteCommentRequest(
            parentId: selectedIDs,
            commentId: commentIDs,
            type: "diary"
        )
        let endUrl = "\(EndPoint.delcomment)parentId=\(selectedIDs))&commentId=\(commentIDs))&type=diary"
        NetworkManager.shared.request(type: DeleteCommentResponse.self, endPoint: endUrl, httpMethod: .delete, parameters: params, isTokenRequired: true) { [weak self] result in
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
    

    
    // add comment Diary
    func addComment(comment: String,selectedID: Int) {
        isLoading = true

        // Create parameters for the payload
        let params = CommentPayload(
            parentId: selectedID,
            comment: comment,
            type: "diary"
        )
        // API Endpoint
        let endPoint = "\(EndPoint.addComment)"

        // Encode the payload to JSON and log it for debugging
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
    
        
        // Perform API request
        NetworkManager.shared.request(type: AddCommentResponse.self,endPoint: endPoint,httpMethod: .post,parameters: params,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.successMessage = response.message

                case .failure(let error):
                    // Handle the error scenarios
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
    
    // create post label
    func CreateLabelDiary(title: String) {
        isLoading = true
        let params = LabelPayload(labelName: title)
        let endPoint = "\(EndPoint.createLabels)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(type: ApiResponse.self,endPoint: endPoint,httpMethod: .post, parameters: params, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.Datalabel = response.data
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
    
    //  Dairy bottom tag label list Get method
    func GetTagLabelList() {
        
        self.isLoading = true
        let endUrl = "\(EndPoint.getTagLabels)"
        
        NetworkManager.shared.request(type: ApiResponses.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.TagLabelData = response.data
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
    // add tag in diary
    func ApplyTag(listId: Int, tagIds: [Int]) {
        isLoading = true
        let params = AddLabelPayload(
            plannerId: listId,
            labelIds: tagIds // Pass the array of IDs here
        )
        
        let endPoint = "\(EndPoint.applyTagLabel)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        
        NetworkManager.shared.request(
            type: AddLabelResponse.self,
            endPoint: endPoint,
            httpMethod: .post,
            parameters: params,
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.labelMessage = response.message
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
    
    // remove schedule notification
    
    func removescheduleDiary(selectedID: Int ,reminder:String) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = DiaryItemPayload(
            reminder: reminder,
            type: "diary"
        )
        
        NetworkManager.shared.request(
            type: PlannerItem.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
    func AddNewDiary(title: String ,  notes: String , reminder: Int?) {
        isLoading = true
        let params = DiaryPayload(
            title: title,
            note: notes,
            reminder : reminder
        )
        let endPoint = "\(EndPoint.createNewDiary)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(
            type: CreateDiaryResponse.self,
            endPoint: endPoint,
            httpMethod: .post,
            parameters: params,
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.NewDiarytask = response.data.data
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
    
    func AddTheme(theme: String , selectedID: Int) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = UpdatePlannerPayload(theme: theme,task: [] )
        
        NetworkManager.shared.request(type: UpdatedPlannerResponse.self,endPoint: url,httpMethod: .put,parameters: requestBody,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
    //////////////////////////////////////Note ////////////////////////////////////////////////
    
    //Note Get
    func GetNoteDataList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.noteList)"
        
        NetworkManager.shared.request(type: NotesResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.NotelistData = response.data.data // Use `response.data` to access `DiaryData`
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

//    
//    
    //Note put method
    func NoteDiaryData(selectedID: Int, notediary: String, titlediary: String) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = DiaryUpdateRequest(note: notediary, title: titlediary)
        
        NetworkManager.shared.request(
            type: UpdatedPlannerResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        self.diaryData = response.updatedPlannerItem // Update local data with response
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
    
    
    //Note post method
    
    func AddNewNote(title: String ,  notes: String , reminder: Int?) {
        isLoading = true
        let params = NotePayload(
            title: title,
            task: [],
            note: notes,
            reminder : reminder
        )
        let endPoint = "\(EndPoint.plannerNoteSave)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(
            type: AddNoteResponse.self,
            endPoint: endPoint,
            httpMethod: .post,
            parameters: params,
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.NewNotetask = response.data.data
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
    
// Get tag
    func GetTagNoteLabelList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getTagLabels)"
        
        NetworkManager.shared.request(type: ApiRespons.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.TagLabelNoteData = response.data
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
    
    // on click on done in noftification view
    func ScheduledonclickDone(selectedID: Int, reminder: Int?) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = PlannerPayload(reminder: reminder,type: "Note")
        
        NetworkManager.shared.request(type: UpdatedPlannerResponses.self, endPoint: url,httpMethod: .put,parameters: requestBody,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.NoteData = response.updatedPlannerItem // Update local data with response
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
    
    
    func GetScheduleHistoryList(selectedID: Int) {
        self.isLoading = true
        let endUrl = "\(EndPoint.historySchedule)\(selectedID)"
        
        NetworkManager.shared.request(type: PlannerDiaryResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.HistoryscheduleData = response.data.history
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
    
    // delete the note - move to Trash
    func deleteNote(selectedID: Int) {
        self.isLoading = true
        let url = "\(EndPoint.deletenote)"
        
        // Create the request body using the struct
        let requestBody = DeletePayload(
            ids: [selectedID]
        )
        
        NetworkManager.shared.request(
            type: MoveToTrashResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
    func removescheduleNote(selectedID: Int) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = DiaryItemsPayload(
            reminder: nil,
            type: "Note"
        )
        
        NetworkManager.shared.request(
            type: PlannerItems.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
    
    
    
  /////////////////////////////////////  //Do it ///////////////////////////
    // Get doit List
    func GetDoitList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getDoIt)"
        
        NetworkManager.shared.request(type: DoitResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.doitlistData = response.data.data// Use `response.data` to access `DiaryData`
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
    
    //update the comment
    
    func updateComment(selectedId: Int , commenttid : Int ,comment : String ,selectedStatus: String) {
        self.isLoading = true
        let url = "\(EndPoint.updateDoitcomment)"
        let requestBody = DoitPayload(
            parentId: selectedId,
            commentId: commenttid,
            comment: comment,
            type: "doit",
            status: selectedStatus
        )
        NetworkManager.shared.request(
            type: commentResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody,
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
    
    func GetDoitHistory(selectedID: Int) {
        self.isLoading = true
        let endUrl = "\(EndPoint.doItHistory)\(selectedID)"
        
        NetworkManager.shared.request(type: PlannerDoitResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.doitHistoryData = response.data.history
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
    
    // Add doit task  - post
    
    func AddTask(title: String , tasks: [String], notes: String ) {
        isLoading = true
        let params = AddTaskPayload(
            title: title,
            task: tasks,
            note: notes
        )
        let endPoint = "\(EndPoint.addTask)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(
            type: PlannerResponse.self,
            endPoint: endPoint,
            httpMethod: .post,
            parameters: params,
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.Addtasks = response.data.data
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
    func RemoveTask(selectedIDs: Int, commentIDs: Int) {
        self.isLoading = true
        // Create parameters for the payload
        let params = DeleteCommentRequest(
            parentId: selectedIDs,
            commentId: commentIDs,
            type: "doit"
        )
        let endUrl = "\(EndPoint.delcomment)parentId=\(selectedIDs)&commentId=\(commentIDs)&type=doit"
        NetworkManager.shared.request(type: DeleteCommentResponse.self, endPoint: endUrl, httpMethod: .delete, parameters: params, isTokenRequired: true) { [weak self] result in
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

    // Add Task to existing Doit screen - post method
    func taskAdding(comment: String,selectedID: Int) {
        isLoading = true

        // Create parameters for the payload
        let params = AddingTaskPayload(
            parentId: selectedID,
            type: "doit",
            status : "todo",
            comment: comment
        )
        // API Endpoint
        let endUrl = "\(EndPoint.addingTask)"

        // Encode the payload to JSON and log it for debugging
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        // Perform API request
        NetworkManager.shared.request(type: AddResponse.self,endPoint: endUrl,httpMethod: .post,parameters: params,isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.successMessage = response.message
                case .failure(let error):
                    // Handle the error scenarios
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
    
    // change task status on doit screen - put method
    func changeStatus(selectedID: Int, status: String) {
        self.isLoading = true
        let url = "\(EndPoint.changeStatus)"
        
        // Create the request body using the struct
        let requestBody = ChangeStatusPayload(
            ids: [selectedID],
            status: status
        )
        
        NetworkManager.shared.request(
            type: ChangeStatusResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
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
    
    func TapOnDone(selectedID: Int, reminder: Int?) {
        self.isLoading = true
        let url = "\(EndPoint.plannerDiarySave)\(selectedID)"
        
        // Create the request body using the struct
        let requestBody = UpdateDoitPayload(
            reminder: reminder,
            task: [] 
        )
        
        NetworkManager.shared.request(
            type: UpdateDoitResponse.self,
            endPoint: url,
            httpMethod: .put,
            parameters: requestBody, // Pass the Encodable struct
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        
                        self.updateDoitData = response.updatedPlannerItem // Update local data with response
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
    
    // Get Tags
    func GetTagDoitLabelList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getTagLabels)"
        
        NetworkManager.shared.request(type: TagApiRespons.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.TagLabelDoitData = response.data
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
    
    // Date Book
    
    //Get DateBook Data
    func GetDateBookList() {
        self.isLoading = true
        let endUrl = "\(EndPoint.getDateBook)"
        
        NetworkManager.shared.request(type: DatebookResponse.self, endPoint: endUrl, httpMethod: .get, isTokenRequired: true) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.DateBookListData = response.data.data // Use `response.data` to access `DiaryData`
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
    
    
    func AddEvent(endDateTime:Int ,note: String ,  `repeat`: String ,startDateTime: Int , title: String) {
        isLoading = true
        let params = DatebookPayload(
            endDateTime: endDateTime,
            note: note,
            `repeat` : `repeat`,
            startDateTime: startDateTime,
            title: title
            
        )
        let endPoint = "\(EndPoint.addEventDateBook)"
        if let jsonData = try? JSONEncoder().encode(params),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        NetworkManager.shared.request(
            type: DatebookResponses.self,
            endPoint: endPoint,
            httpMethod: .post,
            parameters: params,
            isTokenRequired: true
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.AddEventData = response.data.data
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
    

}
extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}



enum PlannerOptions {
    case doit
    case diary
    case Note
    case Date
}

