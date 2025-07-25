//
//  MailComposeView.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import SwiftUI

struct MailComposeView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
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
                        mailComposeViewModel.to = tCodeText
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            mailComposeViewModel.sendEmail()
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image("send")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
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
                                
                                ZStack(alignment: .leading) {
                                    VStack {
                                        if tCodeText.isEmpty {
                                            Text("Enter tcode")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                    mailComposeViewModel.getSerachTcode(searchKey: newValue)
                                                } else {
                                                    mailComposeViewModel.suggest = false
                                                }
                                            }
                                    }
                                    Spacer()
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
                                    }, label: {
                                        Image(mailComposeViewModel.isArrow ? "dropup" : "dropdown")
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .frame(width: 35, height: 35)
                                    })
                                    .padding(.trailing, 20)
                                }
                            )

                            if mailComposeViewModel.suggest,
                               let data = mailComposeViewModel.tcodesuggest?.data {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(data, id: \.self) { tCode in
                                            Button(action: {
                                                if let selectedTCode = tCode.tCode {
                                                    tCodeText = selectedTCode
                                                }
                                                mailComposeViewModel.suggest = false
                                            }) {
                                                Text(tCode.tCode ?? "Unknown")
                                                    .foregroundColor(.black)
                                                    .font(.custom(.poppinsBold, size: 16))
                                                    .padding()
                                                    .frame(alignment: .leading)
                                                    .padding(.leading , 5)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .frame(width: 150)
                                    .background(Color.white)
                                    .cornerRadius(8)
                                    .shadow(radius: 4)

                                    Spacer() // pushes box left within the parent if needed
                                }
                                .padding(.leading, 20)

                            }

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
                                .foregroundColor(themesviewModel.currentTheme.textColor)
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
            .toast(message: $mailComposeViewModel.error)
            
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
