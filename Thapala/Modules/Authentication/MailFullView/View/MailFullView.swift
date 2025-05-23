//
//  MailFullView.swift
//  Thapala
//
//  Created by Ahex-Guest on 06/06/24.
//

import SwiftUI

struct MailFullView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var mailFullViewModel = MailFullViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var themesviewModel = themesViewModel()
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
    @State private var isMoreSheetvisible: Bool = false
    @State private var isactive: Bool = false
    @State private var selectednewDiaryTag: [Int] = [0]
    @State private var selectednames: [String] = [""]
    @State private var selectedid: Int = 0
    @State private var isClicked:Bool = false
    @Binding var conveyedView: Bool
    @Binding var PostBoxView: Bool
    @Binding var SnoozedView: Bool
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
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        //                    self.mailFullViewModel.backToAwaiting = true
                        presentationMode.wrappedValue.dismiss()
                    })
                    {
                        Image(systemName: "arrow.backward")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                        //                    Text("Back")
                        //                        .font(.custom(.poppinsMedium, size: 11, relativeTo: .title))
                        //                        .foregroundColor(Color.black)
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
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 34, height: 34)
                                                .padding([.trailing,.leading], 2)
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
                                    //email.recipients?.first?.user?.firstname == "to"
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("\(email.recipients?.first?.user?.firstname ?? "") \(email.recipients?.first?.user?.lastname ?? "")")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                .fontWeight(.bold)
                                            Spacer()
                                            let senderDate: TimeInterval = TimeInterval(email.sentAt ?? 0)
                                            let finalDate = convertToDateTime(timestamp: senderDate)
                                            Text(finalDate)
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.trailing , 20)
                                        }
                                        HStack {
                                            Text(email.recipients?.first?.user?.tCode ?? "")
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            
                                            Spacer()
                                            Button {
                                                print("dots clicked")
                                                isreplyView = true
                                            } label: {
                                                Image("mailreply")
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            }
                                           
                                            Spacer()
                                                .frame(width: 10)
                                            
                                            Button {
                                                print("dots clicked")
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
                                .background(themesviewModel.currentTheme.colorControlNormal)
                                .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                .padding(.leading, 10)
                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                .padding(.trailing, 10)
                                .frame(minHeight: 100, maxHeight: .infinity)
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
                                            print("Download clicked")
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
//                                            mailFullViewModel.isReply = true
//                                            mailFullViewModel.replyViewModel = replyViewModel
                                            
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
                                        
//                                        Button {
//                                            let to = to
//                                            let cc = ""
//                                            let bcc = ""
//                                            let subject = subject
//                                            let emailBody = ""
//                                            let replyToId = replyToId
//                                            let threadId = threadId
//                                            
//                                            let replyViewModel = ReplyEmailViewModel(to: to, cc: cc, bcc: bcc, subject: subject,body:emailBody, replyToId: "\(replyToId)", threadId: "\(threadId)", subSubject: "Re")
//                                            mailFullViewModel.isReplyAll = true
//                                            mailFullViewModel.replyViewModel = replyViewModel
//                                        } label: {
//                                            Text("Reply all")
//                                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                                .font(.custom(.poppinsLight, size: 16, relativeTo: .title))
//                                            Image("replyAll")
//                                                .renderingMode(.template)
//                                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                                .padding(.trailing, 15)
//                                        }
//                                        .padding([.leading, .top, .bottom], 10)
//                                        .background(themesviewModel.currentTheme.windowBackground)
//                                        .cornerRadius(10)
                                        
                                        Button {
//                                            let to = ""
//                                            let cc = ""
//                                            let bcc = ""
//                                            let subject = subject
//                                            let emailBody = emailBody
//                                            let replyToId = replyToId
//                                            let threadId = threadId
//                                            
//                                            let replyViewModel = ReplyEmailViewModel(to: to, cc: cc, bcc: bcc, subject: subject,body:emailBody,replyToId: "\(replyToId)", threadId: "\(threadId)", subSubject: "Frwd")
//                                            mailFullViewModel.isForward = true
//                                            mailFullViewModel.replyViewModel = replyViewModel
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
                            print("click on delete icon")
                        }) {
                            Image(systemName: "trash")
                                .frame(width: 25, height: 25)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                        }
                        .padding(.leading , 20)
                        
                        
                        Button(action: {
                            isMoreSheetvisible.toggle()
                            print("ellipsis clicked")
                        }) {
                            Image("threeDots")
                                .renderingMode(.template)
                                .frame(width: 25, height: 25)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding(.leading , 20)
                    }
                }
                
                else if PostBoxView {
                    HStack(spacing: 50){
                        Button(action: {
                            print("click on delete icon")
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
                            print("ellipsis clicked")
                            EmailStarred = StarreEmail
                            print("post box EmailStarred \(EmailStarred)")
                        }) {
                            Image("threeDots")
                                .renderingMode(.template)
                                .frame(width: 25, height: 25)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding(.leading , 20)
                    }
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
//                            BottomsheetviewModel.isLabelView = true
//                            mailComposeViewModel.isInsertFromRecords = true
                        }) {
                            Image("Tags")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        Spacer()
                        
                        Button(action: {
                            isMoreSheetvisible.toggle()
                        }) {
                            Image("threeDots")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        Spacer()
                    }
                }

                
            }
            .background(themesviewModel.currentTheme.windowBackground)
            .navigationBarBackButtonHidden(true)
            
            .onAppear {
                
                if conveyedView{
                    print("conveyedView is true")
                }
                if PostBoxView{
                    print("PostBoxView is true")
                }
                
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
                        
                        self.emailBody = (convertHTMLToAttributedString(html: emailBodyData))?.string ?? ""
                        if let snoozeTimestamp = response.email?.first?.snoozeAtThread {
                            let senderDate: TimeInterval = TimeInterval(snoozeTimestamp) ?? 0
                            let finalDate = convertToDateTime(timestamp: senderDate)
                            print("finalDate \(finalDate)")
                            snoozeatThread = finalDate
                            print("snoozeatThread \(snoozeatThread)")
                        }

                        
                    case .failure(let error):
                        self.error = error.localizedDescription
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let diary = mailFullViewModel.detailedEmailData.first(where: { $0.threadID == id }) {
                        id = diary.threadID ?? 0
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
                                print("Tapped isTagsheetvisible")
                                isTagsheetvisible = false
                            }
                        }
                    VStack {
                        Spacer() // Pushes the sheet to the bottom
                        CreateTagLabel(isTagSheetVisible: $isTagsheetvisible, isActive: $isactive, selectedNewBottomTag: $selectednewDiaryTag, selectedNames: $selectednames, selectedID: selectedid, isclicked: $isClicked)
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
                                print("Tapped isMoreSheetvisible")
                                isMoreSheetvisible = false
                            }
                        }
                    VStack {
                        Spacer() // Pushes the sheet to the bottom
                        MoreSheet(snoozetime: $snoozeTime, isMoreSheetVisible: $isMoreSheetvisible, emailId: emailId, passwordHash: passwordHash, isTagsheetvisible: $isTagsheetvisible, StarreEmail: $EmailStarred)
//                        postBoxMoreSheet(isMoreSheetVisible: $isMoreSheetvisible, conveyedView: $conveyedView)
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
                                print("Tapped isMoveSheetvisible")
                                isMoveSheetvisible = false
                            }
                        }
                    VStack {
                        Spacer() // Pushes the sheet to the bottom
                        MoveTo(isMoveToSheetVisible: $isMoveSheetvisible)
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
                        mailComposeViewModel.Drafttrash(EmailID: id)
                        self.isMailFullViewVisible = false
                        print("Note deleted")
                    }
                    .transition(.scale)
                }
            }
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
                    ReplyEmailView(replyEmailViewModel: replyViewModel)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isreplyView)
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
//        .navigationDestination(isPresented: $mailFullViewModel.isReply) {
//            if let replyViewModel = mailFullViewModel.replyViewModel {
//                ReplyEmailView(replyEmailViewModel: replyViewModel).toolbar(.hidden)
//            }
//        }
        .navigationDestination(isPresented: $mailFullViewModel.isReplyAll) {
            if let replyViewModel = mailFullViewModel.replyViewModel {
                ReplyEmailView(replyEmailViewModel: replyViewModel).toolbar(.hidden)
            }
        }
//        .navigationDestination(isPresented: $mailFullViewModel.isForward) {
//            if let replyViewModel = mailFullViewModel.replyViewModel {
//                ReplyEmailView(replyEmailViewModel: replyViewModel).toolbar(.hidden)
//            }
//        }
        .toast(message: $mailFullViewModel.error)
        
    }
//    private func dismissSheet() {
//    }
}
//#Preview {
//    MailFullView(emailId: 0, passwordHash: "")
//}
