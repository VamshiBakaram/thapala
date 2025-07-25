//
//  MoreSheet.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import SwiftUI

struct MoreSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var BottomsheetviewModel = BottomSheetViewModel()
    @StateObject private var homePostboxViewModel = HomePostboxViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
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
    @Binding var isSnoozeSheetvisible: Bool
    @State private var isactive: Bool = false
    @State private var selectednewDiaryTag: [Int] = [0]
    @State private var selectednames: [String] = [""]
    @State private var selectedid: Int = 0
    @State private var isClicked:Bool = false
    @State private var StarEmail: Int = 0
    @Binding var StarreEmail: Int
    @Binding var markedAs : Int
    @State private var isclicked: Bool = false
    @State private var isActive: Bool = false
    @State private var selectedNewDiaryTag: [Int] = []
    @State private var selectedID : Int?
    @Binding var HomeawaitingViewVisible: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var selectedIndices: Set<Int> = []
    @Binding var isMoveSheetvisible: Bool
    @State private var isCheckedLabelID: [Int] = []
    var body: some View {
        ZStack {
            // Main BottomTagSheetView content
            VStack {
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
                            
                            if HomeawaitingViewVisible {
                                HStack {
                                    Button {
                                        if markedAs == 0 {
                                            mailFullViewModel.markEmailAsRead(emailId: [emailId])
                                        }
                                        else {
                                            mailFullViewModel.markEmailAsUnRead(emailId: [emailId])
                                        }
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image(markedAs == 1 ? "emailG" : "queueOutline")
                                            .renderingMode(.template)
                                            .frame(width: 35, height: 35)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        
                                        Text(markedAs == 1 ? "Mark as unread" : "Mark as Read")
                                            .fontWeight(.bold)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.leading, 10)
                                    }
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
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                            if HomeawaitingViewVisible {
                                HStack {
                                    Button {
                                        isMoreSheetVisible = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            isMoveSheetvisible = true
                                        }
                                    } label: {
                                        HStack {
                                            Image(systemName: "folder")
                                                .renderingMode(.template)
                                                .frame(width: 35, height: 35)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            Text("Move to")
                                                .fontWeight(.bold)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.leading, 10)
                                        }
                                    }
                                }
                                
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)  // stretch HStack full-width
                        .padding(.leading, 10)
                        .onAppear{
                            StarEmail = StarreEmail
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
                
            }
            
            if isreplyMailView {
                ZStack {
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isreplyMailView = false
                            }
                        }

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
                    ReplyEmailView(replyEmailViewModel: replyViewModel, isPresented: $isreplyMailView)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isreplyMailView)
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
                        CreateTagLabel(isTagSheetVisible: $isTagsheetvisible, isActive: $isactive, HomeawaitingViewVisible: $HomeawaitingViewVisible, selectedNewBottomTag: $selectednewDiaryTag, selectedNames: $selectednames, selectedID: $homeAwaitingViewModel.selectedThreadIDs, isclicked: $isClicked, isCheckedLabelID: $isCheckedLabelID)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isTagsheetvisible)
                    }
                }
            }
            
            if isSnoozeSheetvisible {
                ZStack {
                    // Tappable background
                    Rectangle()
                        .fill(Color.black.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isSnoozeSheetvisible = false
                            }
                        }
                    VStack {
                        Spacer() // Pushes the sheet to the bottom
                        BottomSnoozeView(isBottomSnoozeViewVisible: $isSnoozeSheetvisible, SnoozeTime: $snoozetime, selectedID: emailId)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isSnoozeSheetvisible)
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
                        MoveTo(isMoveToSheetVisible: $isMoveSheetvisible , selectedThreadID : $homeAwaitingViewModel.selectedThreadIDs, selectedIndices: $selectedIndices)
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
                                        let dismissThreshold: CGFloat = 50 // lower this for more sensitivity

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
        .toast(message: $homeAwaitingViewModel.error)
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




