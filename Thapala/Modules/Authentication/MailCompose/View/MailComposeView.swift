//
//  MailComposeView.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import SwiftUI

struct MailComposeView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var mailComposeViewModel = MailComposeViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
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
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
//                        self.mailComposeViewModel.resetComposeEmailData()
                        mailComposeViewModel.saveDraftData()
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    .padding(.leading)
                    Spacer()
                    Button(action: {
                        mailComposeViewModel.scheduleSend()
                    }) {
                        Image(systemName: "clock")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    .padding(.trailing,10)
                    
                    Button(action: {
//                        mailComposeViewModel.sendEmail()
                        print("on click of send: \(mailComposeViewModel.sendEmail())")
                    }) {
                        Image("send")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .onTapGesture {
                                mailComposeViewModel.sendEmail()
                                presentationMode.wrappedValue.dismiss()// This will pop the current view
                                    
                                            }
                    }
                    .padding(.trailing,15)
                }
                .padding([.leading, .top], 20)
                Spacer()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(spacing: 2) {
                            HStack {
                                Text("From:")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                TextField("", text: $sessionManager.userTcode)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                    .disabled(true)
                            }
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                .padding(.trailing, 20)
                        }
                        
                        VStack(spacing: 2) {
                            HStack {
                                Text("To:")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))

                                ZStack(alignment: .topLeading) {
                                    ZStack(alignment: .leading) {
                                        if tCodeText.isEmpty {
                                            Text("Enter tcode")
                                                .foregroundColor(themesviewModel.currentTheme.AllGray)
                                        }

                                        TextField("", text: $tCodeText)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .onChange(of: tCodeText) { newValue in
                                                if let intValue = Int(newValue) {
                                                    if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                        mailComposeViewModel.tcodeinfo[0].tCode = String(intValue)
                                                    }
                                                } else {
                                                    if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                        mailComposeViewModel.tcodeinfo[0].tCode = nil
                                                    }
                                                }
                                                if isThreeNumbers(newValue) {
                                                    mailComposeViewModel.suggest = true
                                                    print("Calling getSearchTcode")
                                                    mailComposeViewModel.getSerachTcode(searchKey: newValue)
                                                    print("API call completed")
                                                } else {
                                                    mailComposeViewModel.suggest = false
                                                }
                                            }
                                    }

                                    
                                    // Display suggestions
                                    if mailComposeViewModel.suggest,
                                           let data = mailComposeViewModel.tcodesuggest?.data {
                                            VStack(alignment: .leading, spacing: 0) {
                                                List(data, id: \.self) { tCode in
                                                    Button(action: {
                                                        if let selectedTCode = tCode.tCode {
                                                            tCodeText = selectedTCode
                                                        }
                                                        mailComposeViewModel.suggest = false
                                                    }) {
                                                        Text(tCode.tCode ?? "Unknown")
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                                .frame(height: min(CGFloat(data.count * 40), 200)) // Dynamically adjust height
                                                .frame(width: CGFloat(min(10, tCodeText.count)) * 50) // Adjust width based on character count (up to 10)
                                                .listStyle(PlainListStyle()) // Clean style for the list
                                                .scrollContentBackground(.hidden)
                                                .background(Color.green)
                                                .cornerRadius(8) // Rounded corners for suggestions
                                                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                                                .offset(y: 25) // Adjust this for spacing between the TextField and list
                                            }
                                            .zIndex(1) // Ensure this appears above other elements in the ZStack
                                        }
                                }
                            }
                            .overlay(
                                HStack {
                                    Spacer()
                                    Image("contacts")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .onTapGesture {
                                            isInsertTcode = true
                                        }
                                    Button(action: {
                                        mailComposeViewModel.isArrow.toggle()
                                        print("arrow clicked")
                                    }, label: {
                                        Image(mailComposeViewModel.isArrow ? "dropup" : "dropdown")
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .frame(width: 35, height: 35)
                                    })
                                    .padding(.trailing, 20)
                                }
                            )
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                .padding(.trailing, 20)
                        }
                        
                        
                        
                        if mailComposeViewModel.isArrow {
                            VStack(spacing: 2) {
                                HStack {
                                    Text("Cc:")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                    /*
                                    TextField("", text: $mailComposeViewModel.cc)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                     */
                                    HStack {
                                        ForEach(mailComposeViewModel.ccTCodes) { tCode in
                                                HStack {
                                                    Text(tCode.code)
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .padding(.leading, 5)
                                                        .padding(.vertical, 4)
                                                    .cornerRadius(8)
                                                    Button(action: {
                                                        mailComposeViewModel.removeCcTCode(tCode)
                                                    }) {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    }
                                                    .padding(.trailing,5)
                                                }
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1)
                                                )
                                        }

                                        TextField("", text: $mailComposeViewModel.cc)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                            .onSubmit {
                                                mailComposeViewModel.addCcTCode()
                                            }
                                    }
                                }
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Image("contacts")
                                            .padding(.trailing, 60)
                                            .onTapGesture {
                                              isInsertTcode = true
                                            }
                                    }
                                )
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                    .padding(.trailing, 20)
                            }
                            
                            VStack(spacing: 2) {
                                HStack {
                                    Text("Bcc:")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                    /*
                                    TextField("", text: $mailComposeViewModel.bcc)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                     */
                                    HStack {
                                        ForEach(mailComposeViewModel.bccTCodes) { tCode in
                                                HStack {
                                                    Text(tCode.code)
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .padding(.leading, 5)
                                                        .padding(.vertical, 4)
                                                    .cornerRadius(8)
                                                    Button(action: {
                                                        mailComposeViewModel.removeBccTCode(tCode)
                                                    }) {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    }
                                                    .padding(.trailing,5)
                                                }
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1)
                                                )
                                        }

                                        TextField("", text: $mailComposeViewModel.bcc)
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                            .onSubmit {
                                                mailComposeViewModel.addBccTCode()
                                            }
                                    }
                                }
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Image("contacts")
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .padding(.trailing, 60)
                                            .onTapGesture {
                                               isInsertTcode = true
                                            }
                                    }
                                )
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                    .padding(.trailing, 20)
                            }
                        }
                        
                        VStack(spacing: 2) {
                            HStack {
                                Text("Subject")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                TextField("", text: $mailComposeViewModel.subject)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                            }
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                .padding(.trailing, 20)
                        }
                        
                        ZStack(alignment: .leading) {
                            TextEditor(text: $mailComposeViewModel.composeEmail)
                                .scrollContentBackground(.hidden)
                                .background(themesviewModel.currentTheme.windowBackground)
                                .foregroundColor(Color.blue)
                                .padding(4)
                                .font(.custom(.poppinsLight, size: 14))
                            if mailComposeViewModel.composeEmail.isEmpty {
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
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        VStack(alignment: .leading) {
                                            Text(file.lastPathComponent)
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
                }
                .padding([.leading, .top, .bottom], 20)
                /*
                 .overlay(
                     RoundedRectangle(cornerRadius: 20)
                         .stroke(Color.gray, lineWidth: 1)
                 )
                 .padding()
                 */
                
                HStack (spacing:0){
                               Button(action: {
                                   self.presentationMode.wrappedValue.dismiss()
                               }) {
                                   Image(systemName: "trash")
                                       .renderingMode(.template)
                                       .foregroundColor(themesviewModel.currentTheme.iconColor)
                               }
                               Spacer()

                               Button(action: {
                                   mailComposeViewModel.isPasswordProtected = true
                               }) {
                                   Image(systemName: "lock")
                                       .renderingMode(.template)
                                       .foregroundColor(themesviewModel.currentTheme.textColor)
                               }
                               Spacer()

                               Button(action: {
                                   mailComposeViewModel.isInsertFromRecords = true
                               }) {
                                   Image("files")
                                       .renderingMode(.template)
                                       .foregroundColor(themesviewModel.currentTheme.textColor)
                               }
                               Spacer()

                               Button(action: {
                                   isFilePickerPresented = true
                               }) {
                                   Image(systemName: "paperclip")
                                       .renderingMode(.template)
                                       .foregroundColor(themesviewModel.currentTheme.textColor)
                               }
                               Spacer()
                           }
                .padding([.leading,.trailing],20)
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
            .fileImporter(isPresented: $isFilePickerPresented, allowedContentTypes: [.image, .pdf, .plainText], allowsMultipleSelection: true) { result in
                switch result {
                case .success(let urls):
                    mailComposeViewModel.selectedFiles.append(contentsOf: urls)
                    mailComposeViewModel.uploadFiles(fileURLs: urls)
                case .failure(let error):
                    print("Failed to select files: \(error.localizedDescription)")
                }
            }
            .toast(message: $mailComposeViewModel.error)
            .onAppear {
//                if mailComposeViewModel.detailedEmailData.isEmpty {
//                    print("getFullEmail(emailId: id)")
//                    mailComposeViewModel.getFullEmail(emailId: id)
//                }
//                
//                // Safely handle any logic without mutating `selectedID`
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                    if let diary = mailComposeViewModel.detailedEmailData.first(where: { $0.threadID == id }) {
//                        let stringValue = diary.body
//                        composeText = (convertHTMLToAttributedString(html: stringValue ?? ""))?.string ?? ""
//                        mailComposeViewModel.composeEmail = composeText
//                        mailComposeViewModel.subject = diary.subject ?? ""
//                        attachmentsData = diary.attachments ?? []
//                        print("composeText \(composeText)")
//                        print("subject \(mailComposeViewModel.subject)")
//                        print("attachmentsData \(attachmentsData)")
//                        //                    selectedIconIndex = diary.theme
//                        if let recipients = diary.recipients {
//                            if let toRecipient = recipients.first(where: { $0.type == "to" }) {
//                                mailComposeViewModel.to = toRecipient.user?.tCode ?? ""
//                                print("emailByIdData.to \(mailComposeViewModel.to))")
//                            }
//                            
//                        }
//                    }
//                }
            }
//            .onAppear {
//                mailComposeViewModel.getFullEmail(emailId: id) { result in
//                    switch result {
//                    case .success(let response):
//                        emailByIdData = response
//                        let stringValue = response.email?.first?.body ?? ""
//                        composeText = (convertHTMLToAttributedString(html: stringValue))?.string ?? ""
//                        mailComposeViewModel.composeEmail = composeText
//                        mailComposeViewModel.subject = response.email?.first?.parentSubject ?? ""
//                        attachmentsData = response.email?.first?.attachments ?? []
////                        mailComposeViewModel.to = (response.email?.first?.recipients?.first?.user?.tCode ?? "")
//                        if let recipients = response.email?.first?.recipients {
//                                        if let toRecipient = recipients.first(where: { $0.type == "to" }) {
//                                            mailComposeViewModel.to = toRecipient.user?.tCode ?? ""
//                                            print("emailByIdData.to \(mailComposeViewModel.to))")
//                                        }
//                                    }
////
//                        
//                    case .failure(let error):
//                        self.errorMessage = error.localizedDescription
//                    }
//                }
//            }
            
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
        .navigationDestination(isPresented: $mailComposeViewModel.isInsertFromRecords) {
            InsertFileFromRecordsView().toolbar(.hidden)
        }
    }
    private func isThreeNumbers(_ input: String) -> Bool {
            let numbers = input.filter { $0.isNumber }
            return numbers.count == 3
        }
}

struct TCode: Identifiable {
    let id = UUID()
    let code: String
}
