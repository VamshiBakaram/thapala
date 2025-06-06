//
//  MoreSheet.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import SwiftUI
import ClockTimePicker

struct MoreSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var BottomsheetviewModel = BottomSheetViewModel()
    @StateObject private var homePostboxViewModel = HomePostboxViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @StateObject var mailFullViewModel = MailFullViewModel()
    @StateObject var starredEmailViewModel = StarredEmailViewModel()
    @Binding var snoozetime: Int
    @State private var isMoreVisible: Bool = false
    @Binding var isMoreSheetVisible: Bool
    @State private var error: String?
    @State var to:String = ""
    @State var subject:String = ""
    @State var replyToId:Int = 0
    @State var threadId:Int = 0
    @State var emailBody:String = ""
    @State private var emailData: EmailsByIdModel?
    @State private var attachmentsData: [Attachment] = []
    @State private var emailBodies: [String] = [] 
    let emailId: Int
    let passwordHash: String
    @State var id:Int = 0
    @State private var isreplyMailView = false
    @Binding var isTagsheetvisible: Bool
    @State private var isSnoozeSheetvisible = false
    @State private var isactive: Bool = false
    @State private var selectednewDiaryTag: [Int] = [0]
    @State private var selectednames: [String] = [""]
    @State private var selectedid: Int = 0
    @State private var isClicked:Bool = false
    @State private var StarEmail: Int = 0
    @Binding var StarreEmail: Int
    @State private var isclicked: Bool = false
    @State private var isActive: Bool = false
    @State private var selectedNewDiaryTag: [Int] = []
    @State private var selectedID : Int?
    
    var body: some View {
        ZStack {
            // Main BottomTagSheetView content
            if !isMoreVisible {
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                         HStack {
                            Button {
                                isreplyMailView = true
                            } label: {
                                Image("Reply")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Text("Reply")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)

                            }
                        }
                        
                        HStack {
                            Button {
                                isreplyMailView = true
                            } label: {
                                Image("Forward")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Text("Forward")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)

                            }
                        }
                        
                        HStack {
                            Button {
                                print("emailId \(emailId)")
                                mailFullViewModel.markEmailAsUnRead(emailId: emailId)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isMoreSheetVisible = false
                                }
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image("emailG")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Text("Mark as unread")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)
                            }
                        }
                        
                        HStack {
                            Button {
                                isMoreSheetVisible = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isTagsheetvisible = true
                                }

                            } label: {
                                Image("Tags")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Text("Label")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)

                            }
                        }
                        
                        HStack {
                            Button {
                                print("emailId \(emailId)")
                                    starredEmailViewModel.getStarredEmail(selectedID: emailId)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isMoreSheetVisible = false
                                }
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(StarEmail == 1 ? "star" : "emptystar")
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Text(StarEmail == 1 ? "Remove Star" : "Add Star")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 10)

                            }
                        }
                        HStack {
                            Button {
                                print("clicked on snooze")
                                isMoreSheetVisible = false
                                // Delay setting isSnoozeSheetvisible until after the sheet is dismissed
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                                    isSnoozeSheetvisible = true
                                }
                            } label: {
                                HStack {
                                    Image("timer")
                                        .renderingMode(.template)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    Text("Snooze")
                                        .fontWeight(.bold)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading, 10)
                                }
                            }
                        }
                     }
                    .frame(maxWidth: .infinity, alignment: .leading)  // stretch HStack full-width
                    .padding(.leading, 10)
                    .onAppear{
                        print("isMoreSheetVisible more sheet \(isMoreSheetVisible)")
                        StarEmail = StarreEmail
                        print("StarEmail  \(StarEmail)")
                        print("homePostboxViewModel.starEmail \(homePostboxViewModel.starEmail)")
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
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: calculateTotalHeight())
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
             }
            
            if isreplyMailView {
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
                        .animation(.easeInOut, value: isreplyMailView)
                }
            }
            if isSnoozeSheetvisible {
                ZStack {
                    // Tappable background
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
//                        .onTapGesture {
//                            withAnimation {
//                                print("Tapped isTagsheetvisible")
//                                isMoreSheetVisible = false
//                            }
//                        }
                    VStack {
                        Spacer() // Pushes the sheet to the bottom
                        BottomSnoozeView(isBottomSnoozeViewVisible: $isSnoozeSheetvisible, SnoozeTime: $snoozetime, ismoreSheetVisible: $isMoreSheetVisible, selectedID: emailId)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isTagsheetvisible)
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

       }
        .background(
            Color.black.opacity(isMoreVisible ? 0.4 : 0)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isMoreSheetVisible = false // Dismiss the sheet
                    }
                }
        )
        .toast(message: $mailFullViewModel.error)
//        .navigationDestination(isPresented: $mailFullViewModel.isReply) {
//            if let replyViewModel = mailFullViewModel.replyViewModel {
//                ReplyEmailView(replyEmailViewModel: replyViewModel).toolbar(.hidden)
//            }
//        }
                                         
    }
    func calculateTotalHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44 // Estimated height for each row in the list
        let maxHeight: CGFloat = 800 // Maximum height for the entire view
//        let totalHeight = baseHeight + (CGFloat(homePlannerViewModel.TagLabelData.count) * rowHeight)
        let totalHeight: CGFloat = 350
        return min(totalHeight, maxHeight) // Ensure it doesn't exceed the maxHeight
    }
}
//#Preview {
//    MoreSheet()
//}



struct BottomSnoozeView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var mailFullViewModel = MailFullViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var isBottomSnoozeViewVisible: Bool
    @Binding var SnoozeTime: Int
    @Binding var ismoreSheetVisible: Bool
    @State var comment: String = ""
    var selectedID: Int
    @State private var selectedDate = Date() // Holds the current date or time
    @State private var isDatePickerVisible = false // Controls date picker dialog
    @State private var isTimePickerVisible = false
    @ObservedObject private var options = ClockLooks()
    @State var id:Int = 0
    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Reminder")
                        .font(.headline)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .padding(.top, 20)
                        .padding(.leading, 16)
                    
                    Spacer()
                
                    Button(action: {
                        if ismoreSheetVisible {
                            if let selectedDateTime = mailFullViewModel.selectedDateTime {
                                // Convert the Date to an Int (e.g., timestamp)
                                SnoozeTime = Int(selectedDateTime.timeIntervalSince1970)
                                homeAwaitingViewModel.snoozedEmail(selectedEmail: selectedID)
                                print("SnoozeTime  \(SnoozeTime ?? 0)")
                                self.isBottomSnoozeViewVisible = false
                            }
                        }
                        else {
                            if let selectedDateTime = mailFullViewModel.selectedDateTime {
                                let reminderInt = Int(selectedDateTime.timeIntervalSince1970)
                                homeAwaitingViewModel.snoozedEmail(selectedEmail: selectedID)
                                print("reminderInt  \(reminderInt)")
                                self.isBottomSnoozeViewVisible = false
                            }
                        }
                    }, label: {
                        Text("Done")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .font(.headline)
                    .foregroundColor(themesviewModel.currentTheme.colorAccent)
                    .padding(.trailing, 16)
                    .padding(.top, 16)
                }
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .foregroundColor(themesviewModel.currentTheme.strokeColor)
                    .padding(.horizontal, 16)
                
                HStack {
                    Button(action: {
                        print("")
                    }, label: {
                        Text("Tomorrow")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: {
                        print("")
                    }, label: {
                        Text("8:00 AM")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.trailing, 16)
                }
                .padding(.top, 10)
                
                HStack {
                    Button(action: {
                        print("")
                    }, label: {
                        Text("Next Week")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.leading, 16)
                    
                    Spacer()
                    
                    Button(action: {
                        print("")
                    }, label: {
                        Text("8:00 AM")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                    })
                    .padding(.trailing, 16)
                }
                .padding(.top, 10)
                
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .frame(width: 24, height: 24)
                        .padding(.leading, 16)
                        .onTapGesture {
                            print("Timer clicked")
                        }
                    
                    Button(action: {
                         isDatePickerVisible = true
                     }) {
                         Text(mailFullViewModel.selectedDateTime != nil ? selectedDateTimeFormatted : "Select Date and Time")
                             .foregroundColor(themesviewModel.currentTheme.colorAccent)
                             .fontWeight(.bold)
                             .padding()
                     }
                 }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 213) // Adjust height as per design
            .background(themesviewModel.currentTheme.windowBackground)
            .cornerRadius(16)
            .shadow(radius: 10)
        }
        .onAppear {
            options.withHands = true
            print("selectedID   \(selectedID)")
        }
        .overlay(
            Group {
                if isDatePickerVisible {
                    DialogView(
                        title: "Select a Date",
                        content: {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                        },
                        onCancel: {
                            isDatePickerVisible = false
                        },
                        onConfirm: {
                            isDatePickerVisible = false
                            isTimePickerVisible = true
                        }
                    )
                    .offset(y: -120)
                }
            }
        )
        .overlay(
            Group {
                if isTimePickerVisible {
                    DialogView(
                        title: "Select a Time",
                        content: {
                            ClockPickerView(date: $selectedDate)
                                .frame(width: 250, height: 250)
                        },
                        onCancel: {
                            isTimePickerVisible = false
                        },
                        onConfirm: {
                            isTimePickerVisible = false
                            mailFullViewModel.selectedDateTime = selectedDate
                        }
                    )
                    .offset(y: -120)
                }
            }
        )
    }
    
    private var selectedDateTimeFormatted: String {
        guard let dateTime = mailFullViewModel.selectedDateTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
}
