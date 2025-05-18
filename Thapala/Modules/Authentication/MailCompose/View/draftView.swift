//
//  draftView.swift
//  Thapala
//
//  Created by Ahex-Guest on 16/11/24.
//

import SwiftUI

struct draftView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mailComposeViewModel = MailComposeViewModel()
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
    @State private var to: String = "" // Direct state binding
    @State private var subject : String = ""
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
                        print("on click of send: \(mailComposeViewModel.sendEmail())")
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
//                                        .background(themesviewModel.currentTheme.attachmentBGColor)
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
                                                                                
//                                                                                    .foregroundColor(.black)
                                                                                // Ensure text is visible
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
                                        }                             }
                                

                                

                                
//                                .padding()


                                // Helper function to check if the text contains at least 3 numbers
//                                func isThreeNumbers(_ text: String) -> Bool {
//                                    return text.count >= 3
//                                }


//                                VStack {
//                                            // Text showing the currently selected option
////                                            Text(selectedItem)
////                                                .font(.title)
//
//                                            // Picker view (dropdown)
//                                            Picker("", selection: $selectedItem) { // Removed the label text
//                                                ForEach(items, id: \.self) { item in
//                                                    Text(item)
//                                                }
//                                            }
//                                            .pickerStyle(MenuPickerStyle()) // Dropdown style
////                                            .padding()
////                                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
////                                            .padding()
//                                        }
//                                        .padding()
                                      
                                 
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
                        
//                        ZStack(alignment: .leading) {
//                            TextEditor(text: $composeText)
//                                .foregroundColor(themesviewModel.currentTheme.textColor)
//                                .padding(4)
//                                .font(.custom(.poppinsLight, size: 14))
//                            if composeText.isEmpty {
//                                Text("Compose email")
//                                    .font(.custom(.poppinsLight, size: 14))
//                                    .foregroundColor(themesviewModel.currentTheme.textColor)
//                                    .padding(.horizontal, 4)
//                                    .padding(.vertical, 8)
//                            }
//                        }
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
                .padding([.leading,.trailing],5)
                
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
                mailComposeViewModel.saveDraftData()
                mailComposeViewModel.getFullEmail(emailId: id) { result in
                    switch result {
                    case .success(let response):
                        emailByIdData = response
                        let stringValue = response.email?.first?.body ?? ""
                        composeText = (convertHTMLToAttributedString(html: stringValue))?.string ?? ""
                        mailComposeViewModel.composeEmail = composeText
                        subject = response.email?.first?.subject ?? ""
                        attachmentsData = response.email?.first?.attachments ?? []
//                        mailComposeViewModel.to = (response.email?.first?.recipients?.first?.user?.tCode ?? "")
                        if let recipients = response.email?.first?.recipients {
                                        if let toRecipient = recipients.first(where: { $0.type == "to" }) {
                                            to = toRecipient.user?.tCode ?? ""
                                            print("emailByIdData.to \(to))")
                                        }
                                    }
                        
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
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

#Preview {
    draftView()
}
