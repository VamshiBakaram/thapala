//
//  ScheduleView.swift
//  Thapala
//
//  Created by Ahex-Guest on 18/11/24.
//

import SwiftUI
struct ScheduleView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mailComposeViewModel = MailComposeViewModel()
    @ObservedObject var BottomsheetviewModel = BottomSheetViewModel()
    @ObservedObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @State var id:Int = 0
    @State var emailByIdData:EmailsByIdModel?
    @State var composeText:String = ""
    @State var attachmentsData:[Attachment] = []
    @State var errorMessage:String = ""
    @State private var isFilePickerPresented:Bool = false
    @State var isInsertTcode: Bool = false
    @State private var text = ""
    @State private var tCodeText: String = ""
    @State private var to: String = "" // Direct state binding
    @State private var receipienttcode: String = "" // Direct state binding
    @State private var receipientfirstname: String = ""
    @State private var receipientlastname: String = ""
    @State private var from: String = "" // Direct state binding
    @State private var subject : String = ""
    @State private var image : String = ""
    @State private var scheduledtime : String = ""
    @State private var firstname : String = ""
    @State private var lastname : String = ""
    @State private var usertcode : String = ""
    @State private var emailData: EmailsByIdModel?
    @State private var showEditProfileDialog: Bool = false
    @State private var isTagsheetvisible: Bool = false
    @State private var isMoveSheetvisible: Bool = false
    @State private var isMoreSheetvisible: Bool = false
    @State private var isactive: Bool = false
    @State private var selectednewDiaryTag: [Int] = [0]
    @State private var selectednames: [String] = [""]
    @State private var selectedid: Int = 0
    @State private var isClicked:Bool = false
    
    var maskedUsertcode: String {
            let usertcodeString = String(usertcode)
            guard usertcodeString.count == 10 else { return "Invalid Code" }
            let prefix = usertcodeString.prefix(4)
            let maskedPart = String(repeating: "*", count: 6)
            return "\(prefix)\(maskedPart)"
        }
    var body: some View {
        ZStack {
            VStack {
                HStack {
                            Button(action: {
                                mailComposeViewModel.saveDraftData()
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrow.backward")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .font(.system(size: 18))
                                Text("Back")
                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                            }
                            .padding(.leading, 16) // Padding from the left
                            Spacer() // Pushes the button to the left
                        }
                        .padding(.top, 20) // Padding from the top
                Spacer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 2) {
                            HStack{
                                AsyncImage(url: URL(string: image)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .frame(width: 34, height: 34)
                                            .padding([.trailing, .leading], 2)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image("person")
                                            .resizable()
                                            .frame(width: 34, height: 34)
                                            .foregroundColor(.blue)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                .padding(.leading , 10)
                                
                                    VStack(alignment: .leading) {
                                        Text("\(firstname) \(lastname)")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        HStack{
                                            Text(maskedUsertcode)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                                        
                                                HStack {
                                                    Image(systemName: "chevron.down")
                                                        .resizable()
                                                        .frame(width: 12, height: 8)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .onTapGesture {
                                                            showEditProfileDialog.toggle()
                                                            }
                                                    Spacer()
                                                }
                                                .padding([.leading, .top], 10)

                                            Spacer()
                                                

                                        }
                                        
                                            if showEditProfileDialog {
                                                ZStack(alignment: .topTrailing) {
                                                    let senderDate: TimeInterval = TimeInterval(scheduledtime) ?? 0
                                                    let finalDate = convertToTime(timestamp: senderDate)
                                                    Color.white
                                                        .edgesIgnoringSafeArea(.all)
                                                    
                                                        .overlay {
                                                            EditProfileDialog(
                                                                              userfirstname : firstname,
                                                                              userlastname : lastname,
                                                                              usercode : usertcode,
                                                                              senderfirstname : receipientfirstname,
                                                                              senderlastname : receipientlastname,
                                                                              sendercode : receipienttcode,
                                                                              scheduletimer : finalDate,
                                                                              bodycontent : composeText,
                                                                              isVisible: $showEditProfileDialog
                                                            )
                                                                .padding(.top, 150) // Adjust this value to position the dialog
                                                                .padding(.leading, 150)
                                                            }
                                                        .onTapGesture {
                                                                showEditProfileDialog = false
                                                        }
                                                }
                                            }
                                    }
                                    
                                
                                Spacer()
                                VStack {
                                    let senderDate: TimeInterval = TimeInterval(scheduledtime) ?? 0
                                    let finalDate = convertToTime(timestamp: senderDate)
                                    Text(finalDate)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsLight, size: 11, relativeTo: .title))
                                    
                                    HStack {
                                        Spacer() // Pushes the button to the trailing edge
                                        Button {
                                            // Add action here
                                        } label: {
                                            Image("dots")
                                                .renderingMode(.template)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 2) // Apply corner radius to make it rounded
                                                        .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1) // Border color and width
                                                )
                                        }
                                        .padding([.trailing], 12) // Apply 12 padding to the right side of the button container
                                    }
                                }
                                .padding([.trailing], 12) // Apply 12 padding to the right side of the VStack

                                
                                    
                                
                            }
                            Spacer()
                                .frame(height: 3)
                            
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                    .padding(.trailing, 16)
                                    .padding(.leading , 16)
                            }
                            
                           
                           
                                HStack{
                                    
                                    TextField("", text: $subject)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                }
                                .padding(.leading , 16)
                                
                                Spacer()
                                    .frame(height: 3)
                                
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                    .padding(.trailing, 16)
                                    .padding(.leading , 16)
                            
                        HStack{
                            Image("sendtimer") // Replace with your desired image
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20) // Adjust size as needed
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            VStack(alignment: .leading, spacing: 8) {
                                let senderDate: TimeInterval = TimeInterval(scheduledtime) ?? 0
                                let finalDate = convertToTime(timestamp: senderDate)
                                
                                Text("Send scheduled for")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.vertical, 5)
                                    .padding(.leading, 16)
                                
                                Text(finalDate)
                                    .font(.footnote)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 16)
                            }
                        }
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading) // Align content to the left
                        .background(themesviewModel.currentTheme.windowBackground) // Light background
                        .cornerRadius(16) // Rounded corners for the background
                        .padding(.horizontal, 16) // Spacing 30 from left and right
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themesviewModel.currentTheme.attachmentBGColor, lineWidth: 1)
                                .padding(.horizontal,16)
                        )
                        
                        Spacer()
                            .frame(height: 3)
                        
                        Rectangle()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .foregroundColor(themesviewModel.currentTheme.strokeColor)
                            .padding(.trailing, 16)
                            .padding(.leading , 16)
                        
                        ZStack(alignment: .leading) {
                            TextEditor(text: $composeText)
                                .scrollContentBackground(.hidden)
                                .background(themesviewModel.currentTheme.windowBackground)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(4)
                                .font(.custom(.poppinsLight, size: 14))
                            if composeText.isEmpty {
                                Text("Compose email")
                                    .font(.custom(.poppinsLight, size: 14))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                            }
                        }
                        
                            Spacer()
                            if mailComposeViewModel.attachmentDataIn.count != 0{
                                Rectangle()
                                    .frame(maxWidth:.infinity)
                                    .frame(height: 2)
                                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                    .padding([.trailing],20)
                                
                                HStack{
                                    if mailComposeViewModel.attachmentDataIn.count != 0{
                                        Text("Attachments")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                        Spacer()
                                    }
                                }
                                VStack(alignment:.leading){
                                    ForEach(mailComposeViewModel.selectedFiles, id: \.self) { file in
                                        HStack {
                                            Image("File")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            VStack(alignment: .leading) {
                                                Text(file.lastPathComponent)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsMedium, size: 11, relativeTo: .title))
                                            }
                                        }
                                        .padding([.trailing], 50)
                                        .padding([.leading, .top, .bottom], 15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1)
                                .padding(.horizontal, 16) // Adds 16 points of space on the left and right
                        )

                    }
                }
            .background(themesviewModel.currentTheme.windowBackground)
            
                .sheet(isPresented: $isInsertTcode, content: {
                    InsertTCodeView(isInsertVisible: $isInsertTcode, onInsert: { tCodes, ccCodes, bccCodes in
                        self.mailComposeViewModel.tCodes = tCodes
                        self.mailComposeViewModel.ccTCodes = ccCodes
                        self.mailComposeViewModel.bccTCodes = bccCodes
                    })
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
                })
//                .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.image, .pdf, .plainText], allowsMultipleSelection: true) { result in
//                    switch result {
//                    case .success(let urls):
//                        mailComposeViewModel.selectedFiles.append(contentsOf: urls)
//                        mailComposeViewModel.uploadFiles(fileURLs: urls)
//                    case .failure(let error):
//                        print("Failed to select files: \(error.localizedDescription)")
//                    }
//                }
                .toast(message: $mailComposeViewModel.error)
                .onAppear {
                    if mailComposeViewModel.detailedEmailData.isEmpty {
                        mailComposeViewModel.getFullEmail(emailId: id)
                    }
                    
                    // Safely handle any logic without mutating `selectedID`
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let diary = mailComposeViewModel.detailedEmailData.first(where: { $0.threadID == id }) {
                            let stringValue = diary.body
                            composeText = (convertHTMLToAttributedString(html: stringValue ?? ""))?.string ?? ""
                            mailComposeViewModel.composeEmail = composeText
                            subject = diary.subject ?? ""
                            attachmentsData = diary.attachments ?? []
                            scheduledtime = String(diary.scheduledTime ?? 0)
                            image = homeNavigatorViewModel.BioData.first?.profile ?? "person"
                            if let recipients = diary.recipients {
                                if let toRecipient = recipients.first(where: { $0.type == "from" }) {
                                    firstname = toRecipient.user?.firstname ?? ""
                                }
                            }
                            if let recipients = diary.recipients {
                                if let toRecipient = recipients.first(where: { $0.type == "from" }) {
                                    lastname = toRecipient.user?.lastname ?? ""
                                }
                            }
                            if let recipients = diary.recipients {
                                if let toRecipient = recipients.first(where: { $0.type == "from" }) {
                                    usertcode = toRecipient.user?.tCode ?? ""
                                }
                            }
                            if let recipients = diary.recipients {
                                if let toRecipient = recipients.first(where: { $0.type == "to" }) {
                                    receipienttcode = toRecipient.user?.tCode ?? ""
                                }
                            }
                            if let recipients = diary.recipients {
                                if let toRecipient = recipients.first(where: { $0.type == "to" }) {
                                    receipientfirstname = toRecipient.user?.firstname ?? ""
                                }
                            }
                            if let recipients = diary.recipients {
                                if let toRecipient = recipients.first(where: { $0.type == "to" }) {
                                    receipientlastname = toRecipient.user?.lastname ?? ""
                                }
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        mailComposeViewModel.saveDraftData()
                    }
                }
        
            
                if mailComposeViewModel.isSchedule {
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ScheduleEmailView(isScheduleVisible: $mailComposeViewModel.isSchedule)
                        .transition(.opacity)
                }
                
                if mailComposeViewModel.isPasswordProtected {
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    ComposeEmailEncripted(isEmailEncript: $mailComposeViewModel.isPasswordProtected)
                        .transition(.opacity)
                }
            }
        
            .navigationDestination(isPresented: $mailComposeViewModel.backToscreen) {
                HomeAwaitingView(imageUrl: "").toolbar(.hidden)
            }
            
        }
        
        
        private func isThreeNumbers(_ input: String) -> Bool {
            let numbers = input.filter { $0.isNumber }
            return numbers.count == 3
        }
    func convertToTime(timestamp: TimeInterval) -> String {
            let dateFormatter = DateFormatter()
            
            // Set the desired date format
            dateFormatter.dateFormat = "EEE, dd-MMM-yyyy, hh:mm a"
            
            // Set the time zone for the desired region (e.g., India Standard Time - IST)
            dateFormatter.timeZone = TimeZone(abbreviation: "IST")
            
            // Get the current date (you can replace this with any date)
            let currentDate = Date()
            
            // Format the date
            let formattedDate = dateFormatter.string(from: currentDate)
            
            // Get the time zone offset
            let timeZoneOffset = getTimeZoneOffset()
            
            return "\(formattedDate) (\(timeZoneOffset))"
        }

        func getTimeZoneOffset() -> String {
            let timeZone = TimeZone.current
            let seconds = timeZone.secondsFromGMT()
            let hours = seconds / 3600
            let minutes = (seconds % 3600) / 60
            
            // Format offset like +05:30
            return String(format: "%+02d:%02d", hours, minutes)
        }
    
    struct EditProfileDialog: View {
        let userfirstname: String
        let userlastname: String
        let usercode: String
        let senderfirstname: String
        let senderlastname: String
        let sendercode: String
        let scheduletimer : String
        let bodycontent : String
        
        @Binding var isVisible: Bool
        
        var body: some View {
            ZStack{
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("From :")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        VStack {
                            Text("\(userfirstname) \(userlastname)")
                                .font(.body)
                            Text("\(usercode)")
                        }
                       
                    }
                    HStack {
                        Text("To :")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        VStack{
                            Text("\(senderfirstname) \(senderlastname)")
                                .font(.body)
                            Text("\(sendercode)")
                        }
                        
                    }
                    HStack {
                        Text("Date :")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(scheduletimer)")
                            .font(.subheadline)
                    }
                    HStack {
                        Text("Title :")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(bodycontent)
                            .font(.body)
                    }
                }
            }
            
            .padding()
            .frame(width: 300)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .onTapGesture {
                            isVisible = false // Close dialog on tap
                        }
        }
    }
}

#Preview {
    ScheduleView()
}
