////
////  StarredmailView.swift
////  Thapala
////
////  Created by Ahex-Guest on 14/05/25.
////
//
////import SwiftUI
////
////struct StarredmailView: View {
////    var body: some View {
////        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
////    }
////}
////
////#Preview {
////    StarredmailView()
////}
//import SwiftUI
//
//struct StarredmailView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var mailFullViewModel = MailFullViewModel()
//    @ObservedObject var themesviewModel = themesViewModel()
//    @EnvironmentObject private var sessionManager: SessionManager
//    @State private var emailData: EmailsByIdModel?
//    @State private var attachmentsData: [Attachment] = []
//    @State private var emailBodies: [String] = [] // Store bodies for each email
//    @State private var error: String?
//    @State var to:String = ""
//    @State var subject:String = ""
//    @State var replyToId:Int = 0
//    @State var threadId:Int = 0
//    @State var emailBody:String = ""
//    @State private var isTagsheetvisible: Bool = false
//    @State private var isMoveSheetvisible: Bool = false
//    @State private var isMoreSheetvisible: Bool = false
//    @State private var isactive: Bool = false
//    @State private var selectednewDiaryTag: [Int] = [0]
//    @State private var selectednames: [String] = [""]
//    @State private var selectedid: Int = 0
//    @State private var isClicked:Bool = false
//    @Binding var conveyedView: Bool
//    let emailId: Int
//    let passwordHash: String
//    var body: some View {
//        ZStack {
//            VStack {
//                HStack {
//                    Button(action: {
//                        //                    self.mailFullViewModel.backToAwaiting = true
//                        presentationMode.wrappedValue.dismiss()
//                    })
//                    {
//                        Image(systemName: "arrow.backward")
//                            .renderingMode(.template)
//                            .foregroundColor(themesviewModel.currentTheme.iconColor)
//                        //                    Text("Back")
//                        //                        .font(.custom(.poppinsMedium, size: 11, relativeTo: .title))
//                        //                        .foregroundColor(Color.black)
//                    }
//                    Spacer()
//                }
//                .padding()
//                
//                if let emailList = emailData?.email {
//                    ScrollView {
//                        ForEach(emailList.indices, id: \.self) { index in
//                            let email = emailList[index]
//                            
//                            VStack(alignment: .leading, spacing: 20) {
//                                HStack {
//                                    let image = email.recipients?.first?.user?.profile ?? ""
//                                    AsyncImage(url: URL(string: image)) { phase in
//                                        switch phase {
//                                        case .empty:
//                                            ProgressView()
//                                        case .success(let image):
//                                            image
//                                                .resizable()
//                                                .frame(width: 34, height: 34)
//                                                .padding([.trailing,.leading], 2)
//                                                .aspectRatio(contentMode: .fit)
//                                                .clipShape(Circle())
//                                        case .failure:
//                                            Image("person")
//                                                .resizable()
//                                                .frame(width: 34, height: 34)
//                                                .foregroundColor(.blue)
//                                        @unknown default:
//                                            EmptyView()
//                                        }
//                                    }
//                                    //                                email.recipients?.first?.user?.firstname == "to"
//                                    VStack(alignment: .leading) {
//                                        Text("\(email.recipients?.first?.user?.firstname ?? "") \(email.recipients?.first?.user?.lastname ?? "")")
//                                            .foregroundColor(themesviewModel.currentTheme.textColor)
//                                            .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
//                                        Text(email.recipients?.first?.user?.tCode ?? "")
//                                            .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
//                                            .foregroundColor(themesviewModel.currentTheme.textColor)
//                                    }
//                                    Spacer()
//                                    let senderDate: TimeInterval = TimeInterval(email.sentAt ?? 0)
//                                    let finalDate = convertToDateTime(timestamp: senderDate)
//                                    Text(finalDate)
//                                        .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
//                                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                                    
//                                    Button {
//                                        print("dots clicked")
//                                    } label: {
//                                        Image("dots")
//                                            .renderingMode(.template)
//                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
//                                    }
//                                    .padding([.trailing], 12)
//                                }
//                                
//                                // Use the email body for the corresponding row
//                                Text(email.parentSubject ?? "")
//                                    .foregroundColor(themesviewModel.currentTheme.textColor)
//                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
//                                    .padding(.leading , 20)
//                                
//                                TextEditor(text: Binding(
//                                    get: {
//                                        emailBodies.indices.contains(index) ? emailBodies[index] : ""
//                                    },
//                                    set: { newValue in
//                                        if emailBodies.indices.contains(index) {
//                                            emailBodies[index] = newValue
//                                        }
//                                    }
//                                ))
//                                .scrollContentBackground(.hidden)
//                                .background(Color.clear)
//                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                .padding(.leading, 10)
//                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
//                                .padding(.trailing, 10)
//                                .frame(minHeight: 100, maxHeight: .infinity)
//                                .allowsHitTesting(false)
//                                if attachmentsData.count != 0 {
//                                    Rectangle()
//                                        .frame(maxWidth: .infinity)
//                                        .frame(height: 2)
//                                        .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
//                                        .padding([.trailing], 20)
//                                }
//                                // Handle attachments
//                                if let attachmentsData = email.attachments, attachmentsData.count != 0 {
//                                    HStack {
//                                        Text("Attachments")
//                                            .foregroundColor(themesviewModel.currentTheme.textColor)
//                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
//                                        Spacer()
//                                        Button {
//                                            print("Download clicked")
//                                        } label: {
//                                            Text("Download All")
//                                                .underline()
//                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
//                                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                        }
//                                        .padding([.trailing], 20)
//                                    }
//                                    VStack {
//                                        ForEach(attachmentsData, id: \.self) { data in
//                                            HStack {
//                                                Image("File")
//                                                VStack(alignment: .leading) {
//                                                    Text(data.fileName ?? "")
//                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                                                        .font(.custom(.poppinsMedium, size: 11, relativeTo: .title))
//                                                    HStack {
//                                                        let size = formatFileSize(bytes: Int(data.fileSize ?? "") ?? 0)
//                                                        Text(size)
//                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
//                                                            .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
//                                                        Button {
//                                                            mailFullViewModel.downloadEmailFile(fileId: data.id, type: "email", emailId: email.threadID ?? 0)
//                                                        } label: {
//                                                            Text("Download")
//                                                                .font(.custom(.poppinsLight, size: 11, relativeTo: .title))
//                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                            .padding([.trailing], 50)
//                                            .padding([.leading, .top, .bottom], 15)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 10)
//                                                    .stroke(themesviewModel.currentTheme.attachmentBGColor, lineWidth: 1)
//                                            )
//                                        }
//                                    }
//                                }
//                                if index == emailList.indices.last {
//                                    HStack {
//                                        Button {
//                                            let to = to
//                                            let cc = ""
//                                            let bcc = ""
//                                            let subject = subject
//                                            let emailBody = ""
//                                            let replyToId = replyToId
//                                            let threadId = threadId
//                                            let replyViewModel = ReplyEmailViewModel(to: to, cc: cc, bcc: bcc, subject: subject,body:emailBody, replyToId: "\(replyToId)", threadId: "\(threadId)", subSubject: "Re")
//                                            mailFullViewModel.isReply = true
//                                            mailFullViewModel.replyViewModel = replyViewModel
//                                        } label: {
//                                            Text("Reply")
//                                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                                .font(.custom(.poppinsLight, size: 16, relativeTo: .title))
//                                            Image("Reply")
//                                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                                .padding(.trailing, 15)
//                                        }
//                                        .padding([.leading, .top, .bottom], 10)
//                                        .background(themesviewModel.currentTheme.colorPrimary)
//                                        .cornerRadius(10)
//                                        
////                                        Button {
////                                            let to = to
////                                            let cc = ""
////                                            let bcc = ""
////                                            let subject = subject
////                                            let emailBody = ""
////                                            let replyToId = replyToId
////                                            let threadId = threadId
////
////                                            let replyViewModel = ReplyEmailViewModel(to: to, cc: cc, bcc: bcc, subject: subject,body:emailBody, replyToId: "\(replyToId)", threadId: "\(threadId)", subSubject: "Re")
////                                            mailFullViewModel.isReplyAll = true
////                                            mailFullViewModel.replyViewModel = replyViewModel
////                                        } label: {
////                                            Text("Reply all")
////                                                .foregroundColor(themesviewModel.currentTheme.textColor)
////                                                .font(.custom(.poppinsLight, size: 16, relativeTo: .title))
////                                            Image("replyAll")
////                                                .renderingMode(.template)
////                                                .foregroundColor(themesviewModel.currentTheme.textColor)
////                                                .padding(.trailing, 15)
////                                        }
////                                        .padding([.leading, .top, .bottom], 10)
////                                        .background(themesviewModel.currentTheme.windowBackground)
////                                        .cornerRadius(10)
//                                        
//                                        Button {
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
//                                        } label: {
//                                            Text("Forward")
//                                                .font(.custom(.poppinsLight, size: 16, relativeTo: .title))
//                                                .foregroundColor(themesviewModel.currentTheme.windowBackground)
//                                            Image("Forward")
//                                                .renderingMode(.template)
//                                                .foregroundColor(themesviewModel.currentTheme.windowBackground)
//                                                .padding(.trailing, 15)
//                                        }
//                                        .padding([.leading, .top, .bottom], 10)
//                                        .background(themesviewModel.currentTheme.colorControlNormal)
//                                        .cornerRadius(10)
//                                    }
//                                }
//                            }
//                            .padding([.top, .bottom], 15)
//                            .padding(.leading, 20)
//                            
//                            Divider()
//                                .padding([.leading, .trailing], 20)
//                        }
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 15)
//                                .stroke(themesviewModel.currentTheme.attachmentBGColor, lineWidth: 1)
//                        )
//                        .padding()
//                    }
//                } else {
//                    Text("")
//                }
//                Spacer()
//                if conveyedView{
//                    HStack(spacing: 50){
//                        Button(action: {
//                            print("click on conveyed delete icon")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                print("click on delete icon")
//                                mailFullViewModel.deleteEmailFromAwaiting(emailId: [emailId])
//                            }
//                        }) {
//                            Image(systemName: "trash")
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                        }
//                        .padding(.leading , 20)
//                        
//                        
//                        Button(action: {
//                            isMoreSheetvisible.toggle()
//                            print("ellipsis clicked")
//                        }) {
//                            Image("threeDots")
//                                .renderingMode(.template)
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                        }
//                        .padding(.leading , 20)
//                    }
//                }
//                else {
//                    HStack(spacing: 50){
//                        Button(action: {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                print("click on delete icon")
//                                mailFullViewModel.deleteEmailFromAwaiting(emailId: [emailId])
//                            }
//                        }) {
//                            Image(systemName: "trash")
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                        }
//                        .padding(.leading , 20)
//                        
//                        
//                        Button(action: {
//                            isTagsheetvisible.toggle()
//                        }) {
//                            Image("Tags")
//                                .renderingMode(.template)
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                        }
//                        .padding(.leading , 20)
//                        
//                        Button(action: {
//                            isMoreSheetvisible.toggle()
//                            print("ellipsis clicked")
//                        }) {
//                            Image("threeDots")
//                                .renderingMode(.template)
//                                .frame(width: 25, height: 25)
//                                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                        }
//                        .padding(.leading , 20)
//                    }
//                }
//
//                
//            }
//            .background(themesviewModel.currentTheme.windowBackground)
//            .navigationBarBackButtonHidden(true)
//            
//            .onAppear {
//                if conveyedView{
//                    print("conveyedView is true")
//                }
//                mailFullViewModel.getFullEmail(emailId: emailId, passwordHash: passwordHash) { result in
//                    switch result {
//                    case .success(let response):
//                        emailData = response
//                        emailBodies = response.email?.compactMap { email in
//                            convertHTMLToAttributedString(html: email.body ?? "")?.string ?? ""
//                        } ?? []
//                        attachmentsData = response.email?.flatMap { $0.attachments ?? [] } ?? []
//                        self.to = response.email?.last?.recipients?.first?.user?.tCode ?? ""
//                        self.subject = response.email?.last?.parentSubject ?? ""
//                        self.replyToId = response.email?.last?.replyToID ?? 0
//                        self.threadId = response.email?.last?.threadID ?? 0
//                        let emailBodyData = response.email?.last?.body ?? ""
//                        self.emailBody = (convertHTMLToAttributedString(html: emailBodyData))?.string ?? ""
//                    case .failure(let error):
//                        self.error = error.localizedDescription
//                    }
//                }
//            }
//            
////            .sheet(isPresented: $mailFullViewModel.isEmailOptions, content: {
////                EmailOptionsView( replyAction: {
////                    //                mailFullViewModel.isReply = true
////                    print("Reply tapped")
////                    //                dismissSheet()
////                },
////                                  replyAllAction: {
////                    print("Reply all tapped")
////                    /*dismissSheet*/()
////                },
////                                  forwardAction: {
////                    print("Forward tapped")
////                    //                dismissSheet()
////                },
////                                  markAsReadAction: {
////                    print("read")
////                    //                dismissSheet()
////                },
////                                  markAsUnReadAction: {
////                    print("unread")
////                    //                dismissSheet()
////                },
////                                  createLabelAction: {
////                    print("label")
////                    //                dismissSheet()
////                },
////                                  moveToFolderAction: {
////                    print("move folder")
////                    //                dismissSheet()
////                },
////                                  starAction: {
////                    print("star")
////                    //                dismissSheet()
////                },
////                                  snoozeAction: {
////                    print("snooze")
////                    //                dismissSheet()
////                },
////                                  trashAction: {
////                    print("trash acti")
////                    //                dismissSheet()
////                }
////                )
////                //            .toolbar(.hidden)
////                .presentationDetents([.medium])
////                .presentationDragIndicator(.hidden)
////            })
//            if isTagsheetvisible {
//                ZStack {
//                    // Tappable background
//                    Rectangle()
//                        .fill(Color.black.opacity(0.3))
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            withAnimation {
//                                print("Tapped isTagsheetvisible")
//                                isTagsheetvisible = false
//                            }
//                        }
//                    VStack {
//                        Spacer() // Pushes the sheet to the bottom
//                        CreateTagLabel(isTagSheetVisible: $isTagsheetvisible, isActive: $isactive, selectedNewBottomTag: $selectednewDiaryTag, selectedNames: $selectednames, selectedID: selectedid, isclicked: $isClicked)
//                            .transition(.move(edge: .bottom))
//                            .animation(.easeInOut, value: isTagsheetvisible)
//                    }
//                }
//            }
//            
//            if isMoreSheetvisible {
//                ZStack {
//                    // Tappable background
//                    Rectangle()
//                        .fill(Color.black.opacity(0.3))
//                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            withAnimation {
//                                print("Tapped isMoreSheetvisible")
//                                isMoreSheetvisible = false
//                            }
//                        }
//                    VStack {
//                        Spacer() // Pushes the sheet to the bottom
//                        postBoxMoreSheet(isMoreSheetVisible: $isMoreSheetvisible, conveyedView: $conveyedView)
//                            .transition(.move(edge: .bottom))
//                            .animation(.easeInOut, value: isMoreSheetvisible)
//                    }
//                }
//            }
//            
//        }
//        .navigationDestination(isPresented: $mailFullViewModel.backToAwaiting) {
//            if mailFullViewModel.backToAwaiting {
//                HomeAwaitingView( imageUrl: "").toolbar(.hidden)
//            }
//        }
//        .navigationDestination(isPresented: $mailFullViewModel.isUploadFromFolder) {
//            MoveToFolderView(emailId: [emailId]).toolbar(.hidden)
//        }
//        .navigationDestination(isPresented: $mailFullViewModel.isCreateLabel) {
//            CreateLabelView().toolbar(.hidden)
//        }
//        .navigationDestination(isPresented: $mailFullViewModel.isReply) {
//            if let replyViewModel = mailFullViewModel.replyViewModel {
//                ReplyEmailView(replyEmailViewModel: replyViewModel).toolbar(.hidden)
//            }
//        }
//        .navigationDestination(isPresented: $mailFullViewModel.isReplyAll) {
//            if let replyViewModel = mailFullViewModel.replyViewModel {
//                ReplyEmailView(replyEmailViewModel: replyViewModel).toolbar(.hidden)
//            }
//        }
//        .navigationDestination(isPresented: $mailFullViewModel.isForward) {
//            if let replyViewModel = mailFullViewModel.replyViewModel {
//                ReplyEmailView(replyEmailViewModel: replyViewModel).toolbar(.hidden)
//            }
//        }
//        .toast(message: $mailFullViewModel.error)
//        
//    }
////    private func dismissSheet() {
////    }
//}
////#Preview {
////    MailFullView(emailId: 0, passwordHash: "")
////}
