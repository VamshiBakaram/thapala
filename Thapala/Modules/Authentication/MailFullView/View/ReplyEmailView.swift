//
//  ReplyEmailView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/08/24.
//

import SwiftUI

struct ReplyEmailView: View {
    @ObservedObject var replyEmailViewModel:ReplyEmailViewModel
    @ObservedObject var mailComposeViewModel = MailComposeViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var isFilePickerPresented:Bool = false
    @State var isInsertTcode: Bool = false
    @State var isEmailAttachments:Bool = false
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                }
                Spacer()
                Image(systemName: "clock")
                    .font(.title2)
                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                    .onTapGesture {
                        replyEmailViewModel.isSnooze = true
                    }
                    .padding(.trailing,12)
                Image(systemName: "paperplane")
                    .font(.title2)
                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                    .onTapGesture {
                        replyEmailViewModel.sendEmail()
                        presentationMode.wrappedValue.dismiss()
                    }
            }
            .padding()

            HStack {
                Text("From:")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                Text(sessionManager.userTcode)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                Spacer()
            }
            .padding(.horizontal)
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                .padding([.leading,.trailing], 20)
                .padding(.top, -4)
            
            // To address with chips and dropdown
            HStack {
                Text("To:")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                TextField("", text: $replyEmailViewModel.toAddress)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .frame(height: 40)
                    .padding(.trailing, 8)
                
                Image("contacts")
                    .renderingMode(.template)
                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                Button(action: {
                    replyEmailViewModel.isArrow.toggle()
                }) {
                    Image(replyEmailViewModel.isArrow ? "dropup" : "dropdown")
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .frame(width: 35, height: 35)
                }
            }
            .padding(.horizontal)
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 1)
                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                .padding([.leading,.trailing], 20)
                .padding(.top, -7)
            
            if replyEmailViewModel.isArrow {
                VStack(spacing: 2) {
                    HStack {
                        Text("Cc:")
                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        HStack {
                            ForEach(replyEmailViewModel.ccTCodes) { tCode in
                                    HStack {
                                        Text(tCode.code)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.leading, 5)
                                            .padding(.vertical, 4)
                                        .cornerRadius(8)
                                        Button(action: {
                                            replyEmailViewModel.removeCcTCode(tCode)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        }
                                        .padding(.trailing,5)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                                    )
                            }

                            TextField("", text: $replyEmailViewModel.ccAddress)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                .onSubmit {
                                    replyEmailViewModel.addCcTCode()
                                }
                        }
                    }
                    .padding(.top,10)
                    .overlay(
                        HStack {
                            Spacer()
                            Image("contacts")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .padding(.trailing, 40)
                                .onTapGesture {
                                  isInsertTcode = true
                                }
                        }
                    )
                    .padding(.horizontal)
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundColor(themesviewModel.currentTheme.strokeColor)
                        .padding(.trailing, 8)
                        .padding(.horizontal)
                        .padding(.top,5)
                }
                
                VStack(spacing: 2) {
                    HStack {
                        Text("Bcc:")
                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        HStack {
                            ForEach(replyEmailViewModel.bccTCodes) { tCode in
                                    HStack {
                                        Text(tCode.code)
                                            .padding(.leading, 5)
                                            .padding(.vertical, 4)
                                        .cornerRadius(8)
                                        Button(action: {
                                            replyEmailViewModel.removeBccTCode(tCode)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        }
                                        .padding(.trailing,5)
                                    }
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                                    )
                            }

                            TextField("", text: $replyEmailViewModel.bccAddress)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .textFieldStyle(PlainTextFieldStyle())
                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                .onSubmit {
                                    replyEmailViewModel.addBccTCode()
                                }
                        }
                    }
                    .padding(.top,10)
                    .overlay(
                        HStack {
                            Spacer()
                            Image("contacts")
                                .renderingMode(.template)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .padding(.trailing, 40)
                                .onTapGesture {
                                   isInsertTcode = true
                                }
                        }
                    )
                    .padding(.horizontal)
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 1)
                        .foregroundColor(themesviewModel.currentTheme.strokeColor)
                        .padding(.trailing, 8)
                        .padding(.horizontal)
                        .padding(.top, 5)
                }
            }
            
            // Subject
            VStack {
                HStack {
                    Text("\(replyEmailViewModel.subSubject):")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    TextField("", text: $replyEmailViewModel.subject)
                        .font(.custom(.poppinsSemiBold, size: 14))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .frame(height: 40)
                    Spacer()
                }
                .padding(.horizontal)
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                    .padding([.leading,.trailing], 20)
                    .padding(.top, -10)
            }
            
            ZStack(alignment: .topLeading) {
                TextEditor(text: $replyEmailViewModel.messageBody)
                    .scrollContentBackground(.hidden)
                    .background(themesviewModel.currentTheme.windowBackground)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .padding(4)
                    .font(.custom(.poppinsLight, size: 14))
                if replyEmailViewModel.messageBody.isEmpty {
                    Text("Compose email")
                        .font(.custom(.poppinsLight, size: 14))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
            }
            
            Spacer()

            HStack(spacing:10) {
                Button(action: {
                    replyEmailViewModel.deleteEmailFromAwaiting()
                }) {
                    Image(systemName: "trash")
                        .frame(width: 25, height: 25)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                }
                
                Button(action: {
                    mailComposeViewModel.isInsertFromRecords = true
                }) {
                    Image("files")
                        .renderingMode(.template)
                        .frame(width: 25, height: 25)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                }
                .padding(.leading,12)
                Button(action: {
                    isFilePickerPresented = true
                }) {
                    Image(systemName: "paperclip")
                        .frame(width: 25, height: 25)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                }
                .padding(.leading,12)
                Spacer()
            }
            .padding()
        }
        .padding([.leading, .top, .bottom], 20)
        .background(themesviewModel.currentTheme.windowBackground)
        .sheet(isPresented: $isInsertTcode, content: {
            InsertTCodeView(isInsertVisible: $isInsertTcode, onInsert: { tCodes, ccCodes, bccCodes in
                self.replyEmailViewModel.tCodes = tCodes
                self.replyEmailViewModel.ccTCodes = ccCodes
                self.replyEmailViewModel.bccTCodes = bccCodes
            })
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
        })
        
        .navigationDestination(isPresented: $mailComposeViewModel.isInsertFromRecords) {
            InsertFileFromRecordsView().toolbar(.hidden)
        }
        .navigationDestination(isPresented: $replyEmailViewModel.isSnooze) {
            ScheduleEmailView(isScheduleVisible: $replyEmailViewModel.isSnooze).toolbar(.hidden)
        }
        .navigationDestination(isPresented: $replyEmailViewModel.backToscreen) {
            HomeAwaitingView(imageUrl: "").toolbar(.hidden)
        }
    }
}

//#Preview {
//    ReplyEmailView()
//}
