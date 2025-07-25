//
//  MailFullView.swift
//  Thapala
//
//  Created by Ahex-Guest on 06/06/24.
//

import SwiftUI
struct MailFullView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mailFullViewModel = MailFullViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var snoozedMailsViewModel = SnoozedMailsViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @Binding var isMailFullViewVisible: Bool
    @State private var emailData: EmailsByIdModel?
    @State private var attachmentsData: [Attachment] = []
    @State private var emailBodies: [String] = [] // Store bodies for each email
    @State private var error: String?
    @State var to:String = ""
    @State var subject:String = ""
    @State var replyToId:Int = 0
    @State var threadId:Int = 0
    @State var emailBody:String = ""
    @State private var isTagsheetvisible: Bool = false
    @State private var isMoveSheetvisible: Bool = false
    @State private var issnoozesheetvisible: Bool = false
    @State private var isMoreSheetvisible: Bool = false
    @State private var isactive: Bool = false
    @State private var selectednewDiaryTag: [Int] = [0]
    @State private var selectednames: [String] = [""]
    @State private var selectedthreadID: [Int] = []
    @State private var isClicked:Bool = false
    @Binding var conveyedView: Bool
    @Binding var PostBoxView: Bool
    @Binding var SnoozedView: Bool
    @Binding var awaitingView: Bool
    @State private var showingDeleteAlert = false
    @State private var isreplyView = false
    let emailId: Int
    let passwordHash: String
    @State var id:Int = 0
    @State private var fullmailView: Bool = false
    @Binding var StarreEmail: Int
    @State private var EmailStarred : Int = 0
    @State private var snoozeTime : Int = 0
    @State private var snoozeatThread: String = ""
    @Binding var markAs : Int
    @State private var selectedIndices: Set<Int> = []
    @State private var isCheckedLabelID: [Int] = []
    @State private var dragOffset: CGFloat = 0
    var body: some View {
        GeometryReader{ reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.backward")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        Spacer()
                    }
                    .padding()
                    
                    if let emailList = emailData?.email {
                        ScrollView {
                            ForEach(emailList.indices, id: \.self) { index in
                                let email = emailList[index]
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    if SnoozedView {
                                        VStack {
                                            HStack(spacing: 10) {
                                                Image("timer")
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                
                                                Text("Snoozed Until \(snoozeatThread)")
                                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 16)
                                            Rectangle()
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 2)
                                                .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
                                                .padding([.trailing], 20)
                                        }
                                    }
                                    HStack {
                                        let image = email.recipients?.first?.user?.profile ?? ""
                                        AsyncImage(url: URL(string: image)) { phase in
                                            switch phase {
                                            case .empty:
                                                Image("contactW")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
                                                    .background(themesviewModel.currentTheme.colorAccent)
                                                    .clipShape(Circle())
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .padding(.leading, 10)
                                                    .contentShape(Rectangle())
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .frame(width: 34, height: 34)
                                                    .padding([.trailing,.leading],5)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                            case .failure:
                                                Image("contactW")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
                                                    .background(themesviewModel.currentTheme.colorAccent)
                                                    .clipShape(Circle())
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .padding(.leading, 10)
                                                    .contentShape(Rectangle())
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }                                        //email.recipients?.first?.user?.firstname == "to"
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("\(email.recipients?.first?.user?.firstname ?? "") \(email.recipients?.first?.user?.lastname ?? "")")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                    .fontWeight(.bold)
                                                Spacer()
                                                if let timestamp = (email.snoozeThread == 1 ? email.snoozeAtThread : email.sentAt ?? 0),
                                                   let istDateString = convertToIST(dateInput: timestamp) {
                                                    Text(istDateString)
                                                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                        .fontWeight(.bold)
                                                        .foregroundColor(email.snoozeThread == 1 ? .orange : themesviewModel.currentTheme.textColor)
                                                        .padding(.trailing , 20)
                                                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                                                }
                                            }
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(email.recipients?.first?.user?.tCode ?? "")
                                                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)

                                                    if !email.labels.isEmpty {
                                                        HStack {
                                                            ForEach(email.labels) { label in
                                                                Text(label.labelName ?? "")
                                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    .font(.custom(.poppinsRegular, size: 14))
                                                                    .padding(.horizontal, 8)
                                                                    .padding(.vertical, 4)
                                                                    .background(Color.blueAccent)
                                                                    .cornerRadius(8)
                                                            }
                                                        }
                                                    }
                                                }

                                                Spacer()
                                                Button {
                                                    isreplyView = true
                                                } label: {
                                                    Image("mailreply")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                }
                                                
                                                Spacer()
                                                    .frame(width: 10)
                                                
                                                Button {
                                                    isMoreSheetvisible.toggle()
                                                } label: {
                                                    Image("maildots")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                }
                                                .padding([.trailing], 20)
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                    // Use the email body for the corresponding row
                                    Text(email.parentSubject ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                        .padding(.leading , 20)
                                    
                                    TextEditor(text: Binding(
                                        get: {
                                            emailBodies.indices.contains(index) ? emailBodies[index] : ""
                                        },
                                        set: { newValue in
                                            if emailBodies.indices.contains(index) {
                                                emailBodies[index] = newValue
                                            }
                                        }
                                    ))
                                    .scrollContentBackground(.hidden)
                                    .background(themesviewModel.currentTheme.attachmentBGColor)
                                    .cornerRadius(15)
                                    .foregroundColor(themesviewModel.currentTheme.allBlack)
                                    .padding(.leading, 10)
                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                    .padding(.trailing, 10)
                                    .frame(minHeight: 60, maxHeight: .infinity)
                                    .allowsHitTesting(false)
                                    if attachmentsData.count != 0 {
                                        Rectangle()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 2)
                                            .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
                                            .padding([.trailing], 20)
                                    }
                                    // Handle attachments
                                    if let attachmentsData = email.attachments, attachmentsData.count != 0 {
                                        HStack {
                                            Text("Attachments")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                            Spacer()
                                            Button {
                                            } label: {
                                                Text("Download All")
                                                    .underline()
                                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                            }
                                            .padding([.trailing], 20)
                                        }
                                        VStack {
                                            ForEach(attachmentsData, id: \.self) { data in
                                                HStack {
                                                    Image("File")
                                                    VStack(alignment: .leading) {
                                                        Text(data.fileName ?? "")
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .font(.custom(.poppinsMedium, size: 11, relativeTo: .title))
                                                        HStack {
                                                            let size = formatFileSize(bytes: Int(data.fileSize ?? "") ?? 0)
                                                            Text(size)
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                                                            Button {
                                                                mailFullViewModel.downloadEmailFile(fileId: data.id, type: "email", emailId: email.threadID ?? 0)
                                                            } label: {
                                                                Text("Download")
                                                                    .font(.custom(.poppinsLight, size: 11, relativeTo: .title))
                                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            }
                                                        }
                                                    }
                                                }
                                                .padding([.trailing], 50)
                                                .padding([.leading, .top, .bottom], 15)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(themesviewModel.currentTheme.attachmentBGColor, lineWidth: 1)
                                                )
                                            }
                                        }
                                    }
                                    if index == emailList.indices.last {
                                        HStack {
                                            Button {
                                                isreplyView = true
                                                
                                            } label: {
                                                Text("Reply")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsLight, size: 16, relativeTo: .title))
                                                Image("Reply")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .padding(.trailing, 15)
                                            }
                                            .padding([.leading, .top, .bottom], 10)
                                            .background(themesviewModel.currentTheme.colorPrimary)
                                            .cornerRadius(10)
                                            
                                            Button {
                                                isreplyView = true
                                            } label: {
                                                Text("Forward")
                                                    .font(.custom(.poppinsLight, size: 16, relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.windowBackground)
                                                Image("Forward")
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.windowBackground)
                                                    .padding(.trailing, 15)
                                            }
                                            .padding([.leading, .top, .bottom], 10)
                                            .background(themesviewModel.currentTheme.colorControlNormal)
                                            .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding([.top, .bottom], 15)
                                .padding(.leading, 20)
                                
                                Divider()
                                    .padding([.leading, .trailing], 20)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(themesviewModel.currentTheme.attachmentBGColor, lineWidth: 1)
                            )
                            .padding()
                        }
                    } else {
                        Text("")
                    }
                    Spacer()
                    if conveyedView{
                        HStack(spacing: 50){
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                            }
                            .padding(.leading , 20)
                            
                            
                            Button(action: {
                                isMoreSheetvisible.toggle()
                                EmailStarred = StarreEmail
                            }) {
                                Image("threeDots")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            .contentShape(Rectangle())
                            .padding(.leading , 20)
                        }
                        .padding(.bottom, reader.safeAreaInsets.bottom + 10)
                    }
                    
                    else if PostBoxView {
                        HStack(spacing: 50){
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                            }
                            .padding(.leading , 20)
                            
                            
                            Button(action: {
                                isTagsheetvisible.toggle()
                            }) {
                                Image("Tags")
                                    .renderingMode(.template)
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            .padding(.leading , 20)
                            
                            Button(action: {
                                isMoreSheetvisible.toggle()
                                EmailStarred = StarreEmail
                            }) {
                                Image("threeDots")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            .contentShape(Rectangle())
                            .padding(.leading , 20)
                        }
                        .padding(.bottom, reader.safeAreaInsets.bottom + 10)
                    }
                    else {
                        HStack (spacing:0){
                            Button(action: {
                                showingDeleteAlert = true
                            }) {
                                Image(systemName: "trash")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .padding(.leading , 16)
                            }
                            Spacer()
                            
                            Button(action: {
                                isMoveSheetvisible.toggle()
                            }) {
                                Image(systemName: "folder")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            Spacer()
                            
                            Button(action: {
                                isTagsheetvisible.toggle()
                            }) {
                                Image("Tags")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            Spacer()
                            
                            Button(action: {
                                isMoreSheetvisible.toggle()
                                EmailStarred = StarreEmail
                            }) {
                                Image("threeDots")
                                    .renderingMode(.template)
                                    .frame(width: 35 , height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            .contentShape(Rectangle())
                            Spacer()
                        }
                        .padding(.bottom, reader.safeAreaInsets.bottom + 10)
                    }
                    
                    
                }
                .background(themesviewModel.currentTheme.windowBackground)
                .navigationBarBackButtonHidden(true)
                
                .onAppear {
                    selectedthreadID = [emailId]
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        mailFullViewModel.getFullEmail(emailId: emailId, passwordHash: passwordHash) { result in
                            switch result {
                            case .success(let response):
                                emailData = response
                                emailBodies = response.email?.compactMap { email in
                                    convertHTMLToAttributedString(html: email.body ?? "")?.string ?? ""
                                } ?? []
                                attachmentsData = response.email?.flatMap { $0.attachments ?? [] } ?? []
                                self.to = response.email?.last?.recipients?.first?.user?.tCode ?? ""
                                self.subject = response.email?.last?.parentSubject ?? ""
                                self.replyToId = response.email?.last?.replyToID ?? 0
                                self.threadId = response.email?.last?.threadID ?? 0
                                let emailBodyData = response.email?.last?.body ?? ""
                                self.isCheckedLabelID = response.email?.flatMap { $0.labels }.compactMap { $0.labelId } ?? []
                                self.emailBody = (convertHTMLToAttributedString(html: emailBodyData))?.string ?? ""
                                if let snoozeTimestamp = response.email?.first?.snoozeAtThread {
                                    let senderDate: TimeInterval = TimeInterval(snoozeTimestamp) ?? 0
                                    let finalDate = convertToDateTime(timestamp: senderDate)
                                    snoozeatThread = finalDate
                                }
                                
                            case .failure(let error):
                                self.error = error.localizedDescription
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let diary = mailFullViewModel.detailedEmailData.first(where: { $0.threadID == id }) {
                            id = diary.threadID ?? 0
                        }
                    }
                }
                .onChange(of: isTagsheetvisible || isMoreSheetvisible) { newValue in
                    if !newValue { // When sheet is dismissed
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0001) {
                            mailFullViewModel.getFullEmail(emailId: emailId, passwordHash: passwordHash) { result in
                                switch result {
                                case .success(let email):
                                    DispatchQueue.main.async {
                                        // Force update by creating a new instance
                                        self.emailData = nil
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            self.emailData = email
                                            self.emailBodies = email.email?.compactMap { email in
                                                convertHTMLToAttributedString(html: email.body ?? "")?.string ?? ""
                                            } ?? []
                                            self.attachmentsData = email.email?.flatMap { $0.attachments ?? [] } ?? []
                                            self.isCheckedLabelID = email.email?.flatMap { $0.labels }.compactMap { $0.labelId } ?? []
                                        }
                                    }
                                case .failure(let error): break
                                    // Handle the NetworkError
                                }
                            }
                        }
                    }
                }
                
                if isTagsheetvisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isTagsheetvisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            CreateTagLabel(isTagSheetVisible: $isTagsheetvisible, isActive: $isactive, HomeawaitingViewVisible: $awaitingView, selectedNewBottomTag: $selectednewDiaryTag, selectedNames: $selectednames, selectedID: $selectedthreadID, isclicked: $isClicked, isCheckedLabelID: $isCheckedLabelID)
                                .offset(y: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.height > 0 {
                                                dragOffset = value.translation.height
                                            }
                                        }
                                        .onEnded { value in
                                            let dragHeight = value.translation.height
                                            let dismissThreshold: CGFloat = 200 // lower this for more sensitivity

                                            if dragHeight > dismissThreshold {
                                                withAnimation {
                                                    isTagsheetvisible = false
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                                .onAppear {
                                    dragOffset = 0 // ← THIS fixes the “halfway open” issue
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isTagsheetvisible)
                        }
                    }
                }
                
                if isMoreSheetvisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isMoreSheetvisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            MoreSheet(snoozetime: $snoozeTime, isMoreSheetVisible: $isMoreSheetvisible, emailId: emailId, passwordHash: passwordHash, isTagsheetvisible: $isTagsheetvisible, isSnoozeSheetvisible: $issnoozesheetvisible, StarreEmail: $EmailStarred, markedAs: $markAs, HomeawaitingViewVisible: $awaitingView, isMoveSheetvisible: $isMoveSheetvisible)
                                .offset(y: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.height > 0 {
                                                dragOffset = value.translation.height
                                            }
                                        }
                                        .onEnded { value in
                                            let dragHeight = value.translation.height
                                            let dismissThreshold: CGFloat = 200

                                            if dragHeight > dismissThreshold {
                                                withAnimation {
                                                    isMoreSheetvisible = false
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                                .onAppear {
                                    dragOffset = 0 // ← THIS fixes the “halfway open” issue
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isMoreSheetvisible)
                        }
                    }
                }
                
                
                if isMoveSheetvisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isMoveSheetvisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            MoveTo(isMoveToSheetVisible: $isMoveSheetvisible, selectedThreadID: $selectedthreadID, selectedIndices: $selectedIndices)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.height > 0 {
                                                dragOffset = value.translation.height
                                            }
                                        }
                                        .onEnded { value in
                                            let dragHeight = value.translation.height
                                            let dismissThreshold: CGFloat = 50

                                            if dragHeight > dismissThreshold {
                                                withAnimation {
                                                    isMoveSheetvisible = false
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                                .onAppear {
                                    dragOffset = 0 // ← THIS fixes the “halfway open” issue
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isMoveSheetvisible)
                        }
                    }
                }
                
                if showingDeleteAlert {
                    ZStack {
                        Color.gray.opacity(0.5) // Dimmed background
                            .ignoresSafeArea()
                            .transition(.opacity)

                        
                        // Centered DeleteNoteAlert
                        DeleteTrashAlert(isPresented: $showingDeleteAlert) {
                            if PostBoxView || conveyedView || SnoozedView || awaitingView{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    mailFullViewModel.deleteEmailFromAwaiting(emailId: [emailId])
                                    self.isMailFullViewVisible = false
                                }
                            }
                            
                            else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    mailComposeViewModel.Drafttrash(EmailID: emailId)
                                    self.isMailFullViewVisible = false
                                }
                            }
                            
                            // Remove the deleted items from the respective list
                            
                            if SnoozedView && ![emailId].isEmpty {
                                let existingThreadIds = snoozedMailsViewModel.snoozedMailsDataModel.compactMap { $0.emailId }
                                let safeIDsToDelete = [emailId].filter { existingThreadIds.contains($0) }

                                snoozedMailsViewModel.snoozedMailsDataModel.removeAll { item in
                                    if let id = item.emailId {
                                        return safeIDsToDelete.contains(id)
                                    }
                                    return false
                                }
                            }
                            
                            else if awaitingView && ![emailId].isEmpty {
                                let existingThreadIds = homeAwaitingViewModel.emailData.compactMap { $0.threadID }
                                let safeIDsToDelete = [emailId].filter { existingThreadIds.contains($0) }

                                homeAwaitingViewModel.emailData.removeAll { item in
                                    if let id = item.threadID {

                                        return safeIDsToDelete.contains(id)
                                    }
                                    return false
                                }
                            }
                            
                        }
                        .transition(.scale)
                    }
                }
            }
            
            .fullScreenCover(isPresented: $isreplyView) {
                if isreplyView {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                        let to = to
                        let cc = ""
                        let bcc = ""
                        let subject = subject
                        let emailBody = ""
                        let replyToId = replyToId
                        let threadId = threadId
                        let replyViewModel = ReplyEmailViewModel(
                            to: to,
                            cc: cc,
                            bcc: bcc,
                            subject: subject,
                            body: emailBody,
                            replyToId: "\(replyToId)",
                            threadId: "\(threadId)",
                            subSubject: "Re"
                        )
                        ReplyEmailView(replyEmailViewModel: replyViewModel, isPresented: $isreplyView).toolbar(.hidden)
                    }
                }

            }
            
            .navigationDestination(isPresented: $mailFullViewModel.backToAwaiting) {
                if mailFullViewModel.backToAwaiting {
                    HomeAwaitingView( imageUrl: "").toolbar(.hidden)
                }
            }
            .navigationDestination(isPresented: $mailFullViewModel.isUploadFromFolder) {
                MoveToFolderView(emailId: [emailId]).toolbar(.hidden)
            }
            .navigationDestination(isPresented: $mailFullViewModel.isCreateLabel) {
                CreateLabelView().toolbar(.hidden)
            }
            .navigationDestination(isPresented: $mailFullViewModel.isReplyAll) {
                if let replyViewModel = mailFullViewModel.replyViewModel {
                    ReplyEmailView(replyEmailViewModel: replyViewModel, isPresented: $mailFullViewModel.isReplyAll).toolbar(.hidden)
                }
            }

            .toast(message: $mailFullViewModel.error)
        }
    }
}
//#Preview {
//    MailFullView(emailId: 0, passwordHash: "")
//}
