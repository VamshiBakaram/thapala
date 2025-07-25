//
//  draftView.swift
//  Thapala
//
//  Created by Ahex-Guest on 16/11/24.
//

import SwiftUI

struct draftView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @ObservedObject var mailFullViewModel = MailFullViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @Binding var isdraftViewVisible: Bool
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
    @State private var subject: String = ""
    @State private var emailID: Int = 0
    @State private var showingDeleteAlert = false
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
                        mailComposeViewModel.sendEmail()
                        presentationMode.wrappedValue.dismiss()// This will pop the current view
                    }) {
                        Image("send")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.colorAccent)
                    }
                    .padding(.trailing,15)
                }
                .padding([.leading, .top], 20)
                Spacer()
                ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(spacing: 10) {
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
                                    .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
                                    .padding(.trailing, 20)
                            }
                            
                            VStack(spacing: 10) {
                                HStack {
                                    Text("To:")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                    /*
                                     TextField("", text: $mailComposeViewModel.to)
                                     .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                     .keyboardType(.numberPad)
                                     */
                                    
                                    ZStack(alignment: .topLeading) {
                                        VStack {
                                            TextField(
                                                "Enter tcode",
                                                text: $to // Bind directly to local state
                                            )
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                        }
                                        // Display suggestions
                                        if mailComposeViewModel.suggest,
                                           let data = mailComposeViewModel.tcodesuggest?.data {
                                            VStack(alignment: .leading, spacing: 0) {
                                                List(data, id: \.self) { tCode in
                                                    Button(action: {
                                                        // When a tcode is tapped, update the tCodeText with the selected tCode
                                                        if let selectedTCode = tCode.tCode {
                                                            tCodeText = selectedTCode
                                                        }
                                                        mailComposeViewModel.suggest = false
                                                    }) {
                                                        Text(tCode.tCode ?? "Unknown")
                                                    }                                                }
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .frame(height: min(CGFloat(data.count * 40), 200)) // Dynamically adjust height
                                                .frame(width: CGFloat(min(10, tCodeText.count)) * 50) // Adjust width based on character count (up to 10)
                                                .listStyle(PlainListStyle()) // Clean style for the list
                                                .background(themesviewModel.currentTheme.attachmentBGColor) // Add background to list
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
                                    .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
                                    .padding(.trailing, 20)
                            }
                            
                            
                            
                            if mailComposeViewModel.isArrow {
                                VStack(spacing: 10) {
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
                                                        .stroke(Color.gray, lineWidth: 1)
                                                )
                                            }
                                            
                                            TextField("", text: $mailComposeViewModel.cc)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                .renderingMode(.template)
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
                                        .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
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
                                                        .padding(.leading, 5)
                                                        .padding(.vertical, 4)
                                                        .cornerRadius(8)
                                                    Button(action: {
                                                        mailComposeViewModel.removeBccTCode(tCode)
                                                    }) {
                                                        Image(systemName: "xmark.circle.fill")
                                                            .renderingMode(.template)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    }
                                                    .padding(.trailing,5)
                                                }
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                                                )
                                            }
                                            
                                            TextField("", text: $mailComposeViewModel.bcc)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .textFieldStyle(PlainTextFieldStyle())
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
                                                .renderingMode(.template)
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
                                        .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
                                        .padding(.trailing, 20)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                HStack {
                                    Text("Subject")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                    TextField("", text: $subject)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                }
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
                                    .padding(.trailing, 20)
                            }
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
                                    .foregroundColor(themesviewModel.currentTheme.attachmentBGColor)
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
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsMedium, size: 11, relativeTo: .title))
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
                        }
                    
                }
                .refreshable {
                    mailComposeViewModel.getFullEmail(emailId: id)
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
                                   showingDeleteAlert = true
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
                                       .foregroundColor(themesviewModel.currentTheme.iconColor)
                               }
                               Spacer()

                               Button(action: {
                                   mailComposeViewModel.isInsertFromRecords = true
                               }) {
                                   Image("files")
                                       .renderingMode(.template)
                                       .foregroundColor(themesviewModel.currentTheme.iconColor)
                               }
                               Spacer()
                               Button(action: {
                                   isFilePickerPresented = true
                               }) {
                                   Image(systemName: "paperclip")
                                       .renderingMode(.template)
                                       .foregroundColor(themesviewModel.currentTheme.iconColor)                               }
                               Spacer()
                           }
                .padding(.leading , 16)
                .padding(.bottom , 10)
                
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
                            if let recipients = diary.recipients {
                                if let toRecipient = recipients.first(where: { $0.type == "to" }) {
                                    to = toRecipient.user?.tCode ?? ""
                                }
                                
                            }
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
                            mailFullViewModel.deleteEmailFromAwaiting(emailId: [id])
                            self.isdraftViewVisible = false
                        }
                        .transition(.scale)
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
        .navigationDestination(isPresented: $mailComposeViewModel.isInsertFromRecords) {
            InsertFileFromRecordsView().toolbar(.hidden)
        }

    }


    private func isThreeNumbers(_ input: String) -> Bool {
            let numbers = input.filter { $0.isNumber }
            return numbers.count == 3
        }
    

}

struct DeleteTrashAlert: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isPresented: Bool
    var onDelete: () -> Void    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Alert card
            VStack(spacing: 24) {
                // Warning icon
                Circle()
                    .fill(Color(UIColor.systemPink).opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.black)
                    )
                
                // Title
                Text("Confirmation")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Message
                Text("Are you sure you want to delete this note ?")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                // Buttons
                HStack(spacing: 20) {
                    // No button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("No")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    
                    // Yes button
                    Button(action: {
                        onDelete()
                        isPresented = false
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Yes")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(24)
            .background(themesviewModel.currentTheme.windowBackground)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
    }
}

//#Preview {
//    draftView()
//}
