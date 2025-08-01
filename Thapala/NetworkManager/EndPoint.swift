//
//  EndPoint.swift
//  Thapala
//
//  Created by ahex on 24/04/24.
//

import Foundation

struct EndPoint {
    private init() {}
    static let login = "user/login"
    static let createAccount = "user/user-info"
    static let securityQuestions = "questions/security-questions"
    static let generateTCode = "user/generate-tCode"
    static let verifyOTP = "verify-otp"
    static let createTCode = "user/create-tCode"
    static let addQuestionAnswer = "questions/user-security-question"
    static let verifytCode = "user/verify-tCode"
    static let forgotPassword = "user/forgot-user-details"
    static let forgotPasswordOtp = "user/forgot-password"
    static let createPassword = "user/create-password"
    static let userResetPassword = "user/reset-password"
    static let allEmails = "emails/get-all?"
    static let emailsById = "emails/get-by-id/"
    static let sendEmail = "emails/send?scheduledStatus="
    static let saveEmailtoDrafts = "emails/save-to-draft?"
    static let markAsReadEmail = "emails/mark-as-read"
    static let markAsUnReadEmail = "emails/mark-as-unread"
    static let downloadEmailsFile = "download"
    static let getAllFolders = "get-all-folders"
    static let moveToFolder = "emails/move-emails-to-records"
    static let insertTCodeContacts = "chat/added-contacts"
    static let latestLogin = "navigator/get-last-login-details"
    static let starEmail = "emails/star-by-id/"
    static let logout = "user/logout"
    static let starredEmails = "emails/get-all?page=1&pageSize=30&status=starred&starredin="
    static let labelledEmails = "emails/get-all-labels"
    static let snoozedEmails = "emails/get-all?status=snoozed&searchIn="
    static  let searchTcode = "emails/suggestions"
    static let createNewDiary = "planner?type=diary"
    static let plannerDiarySave = "planner/update/"
    static let diaryList = "planner?type=diary&page=1&pageSize=10"
    static let noteList = "planner?type=note&page=1&pageSize=10"
    static let plannerNoteSave = "planner?type=note"
    static let addComment = "planner/add-comment"
    static let delcomment = "planner/delete-comment?"
    static let updateComment = "planner/update-comment" // edit comment
    static let createLabels = "planner/create-label"
    static let getTagLabels = "/get-labels" // Diary Tag
    static let applyTagLabel = "planner/add-label" // Diary Tag
    static let removeTagLabel = "planner/remove-label?" // remove Tag
    static let verifyCredentials = "/record/verify-credentials"
    
    static let attachmentsReplyMail = "attachments"
    // postBox
    static let deleteEmailAwaiting = "emails/delete"
    
    
    
    // Home awaiting
    
    static let snoozedMail = "emails/snooze-by-id"
    static let trash = "emails/clear-draft" // draft trash
    static let createLabel = "emails/create-label"
    static let ApplyLabel = "emails/add-emails-to-labels"
    
    //Note
    static let historySchedule = "planner/get-planner-history/" // history bottom sheet
    static let deletenote = "planner/move-to-trash"
    static let getDoIt = "planner?type=doit&page=1&pageSize=10"
    static let updateDoitcomment = "planner/update-comment"
    static let doItHistory = "planner/get-planner-history/"
    static let addDoItTask = "planner?type=doit"
    static let removeTask = "planner/add-comment" // delete Task
    static let addingTask = "planner/add-comment" // task add to existing doit
    static let changeStatus = "planner/change-status"
    
    // Date Book
    static let getDateBook = "planner-datebook"
    static let addEventDateBook = "planner?type=datebook"
    
    // Directory
    
    static let getDirectoryList = "user/get-all-users?page=1&pageSize=50&orderby="
    static let getProfileByID = "navigator/get-bio-by-id/"
    static let createGroup = "groups/create"
    static let getGroupList = "groups/get-all"
    static let searchByAddress = "user/get-all-users?"
    static let addContacts = "chat/add-contact"
    static let movetoDirectoryGroup = "groups/add-member/"
    static let reportContact = "user/report-issue"
    static let blockContact = "user/"
    static let groupListItems = "groups/get-all-members/"
    static let renameGroup = "groups/update/"
    static let deleteGroup = "groups/delete/"
    
    // trash module
    
    static let getAlltrash = "emails/get-all?page=1&pageSize=30&status=trash"
    static let getRecordsFileTrash = "record/get-trash?type=files"
    static let getRecordsFoldersTrash = "record/get-trash?type=folders"
    static let plannerTrash = "trash"
    static let restorePlanner = "planner/restore-planner"
    static let deletePlanner = "planner/delete-planner-items"
    static let deleteFiles = "record/delete-from-trash"
    static let restoreFiles = "record/restore"
    static let emailRestore = "emails/restore"
    static let emailDelete = "emails/delete-from-trash"
    
    // info module
    static let info = "user/content/get-all?"
    static let faq = "user/content/get-all?contentType=faq&page=1&limit=10"
    static let guide = "user/content/get-all?contentType=guide&page=1&limit=10"
    
    
    // console module
    
    static let mailTimePeriod = "user/move-emails-time"
    static let maximumListPageSize = "user/save-user-settings"
    static let UserSettings = "user/user-settings"
    static let themeChange = "user/change-theme"
    
    // Records Module
    static let getRecords = "get-main-records"
    static let records = "subfolders"
    static let subrecords = "records"
    static let bottomDelete = "record/delete?pin=undefined&password=undefined&"
    static let downloadFiles = "download"
    static let renamefile = "record/"
    static let createFolder = "record"
    static let attachments = "attachments?"
    static let uploadfile = "upload-file"
    
    // Navigator
    
    static let userSettings = "user/user-settings"
    static let TotalStorage = "get-total-storage" // Get Api
    static let saveSettings = "user/save-user-settings"
    static let consoleSecurityQuestions = "questions/user-security-questions"
    static let navigatorBio = "navigator/get-bio-by-id/"
    
    // Navigator -> Console > Security Accont
    static let setPin = "set-pin"
    static let getAllAlerts = "navigator/get-all-alerts"
    static let updateAlerts = "navigator/update-alerts"
    
    //postBox
    
    static let contacts = "chat/contacts" // chatBox
    static let getChatMessages = "chat/get-chat?"
    
    // Blue print
    
    static let saveToDraft = "emails/save-to-draft?type=template"
    
    
    // App Bar Search and notification
    
    static let getSearchData = "emails/search?"
    static let getNotifications = "notification/get-all-notification"
}

//senderId=48&receiverId=14&page=1&pageSize=500
