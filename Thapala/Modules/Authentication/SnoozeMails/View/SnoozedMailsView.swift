//
//  SnoozedMailsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/10/24.
//
import SwiftUI

struct SnoozedMailsView:View{
    @StateObject var snoozedMailsViewModel = SnoozedMailsViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var moveToFolderViewModel = MoveToFolderViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var selectedTab = "Queue"
    @State private var beforeLongPress = true
    @State private var isMultiSelectionSheetVisible: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isMenuVisible = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    @State private var markAs : Int = 0
    @State private var selectedIndices: Set<Int> = []
    @State private var emailId: Int = 0
    @State private var isSelectAll = false
    @State private var selectView: Bool = false
    @State private var showingDeleteAlert = false
    @State private var isMoveSheetvisible: Bool = false
    @State private var isTagsheetvisible: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var isactive: Bool = false
    @State private var HomeawaitingViewVisible: Bool = false
    @State private var selectednewDiaryTag: [Int] = [0]
    @State private var selectednames: [String] = [""]
    @State private var isClicked:Bool = false
    @State private var isCheckedLabelID: [Int] = []
    @State private var isMoreSheetvisible: Bool = false
    @State private var passwordHash: String = ""
    @State private var issnoozesheetvisible: Bool = false
    @State private var EmailStarred : Int = 0
    @State private var snoozeTime : Int = 0
    
    var body: some View {
        GeometryReader{ reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
                VStack {
                    if beforeLongPress {
                        VStack{
                            HStack{
                                Button {
                                    withAnimation {
                                        isMenuVisible.toggle()
                                    }
                                } label: {
                                    Image(systemName: "arrow.backward")
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                }
                                .foregroundColor(Color.black)
                                Spacer()
                                Text("Snoozed Emails")
                                    .font(.custom(.poppinsSemiBold, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                Spacer()
                            }
                            .padding(.leading,20)
                            .padding(.top,12)

                            
                            HStack(spacing: 0) { // Adjust spacing as needed
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(self.snoozedMailsViewModel.isQueueSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                    .frame(width: 120, height: 50) // Add fixed width for consistent layout
                                    .onTapGesture {
                                        selectedTab = "awaited";
                                        snoozedMailsViewModel.isQueueSelected = true
                                        snoozedMailsViewModel.isPostBoxselected = false
                                        snoozedMailsViewModel.isConveyedSelected = false
                                        SnoozedView = false
                                        snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab);
                                    }
                                    .overlay(
                                        Text("Queue")
                                            .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                                            .foregroundColor(self.snoozedMailsViewModel.isQueueSelected ? themesviewModel.currentTheme.allBlack : themesviewModel.currentTheme.inverseTextColor)
                                    )
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(self.snoozedMailsViewModel.isPostBoxselected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                    .frame(width: 120, height: 50)
                                    .onTapGesture {
                                        selectedTab = "postbox";
                                        SnoozedView = false
                                        snoozedMailsViewModel.isQueueSelected = false
                                        snoozedMailsViewModel.isPostBoxselected = true
                                        snoozedMailsViewModel.isConveyedSelected = false
                                        snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab);
                                    }
                                    .overlay(
                                        Text("postbox")
                                            .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                                            .foregroundColor(self.snoozedMailsViewModel.isPostBoxselected ? themesviewModel.currentTheme.allBlack : themesviewModel.currentTheme.inverseTextColor)
                                    )
                                
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(self.snoozedMailsViewModel.isConveyedSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                    .frame(width: 120, height: 50)
                                    .onTapGesture {
                                        selectedTab = "conveyed";
                                        SnoozedView = false
                                        snoozedMailsViewModel.isQueueSelected = false
                                        snoozedMailsViewModel.isPostBoxselected = false
                                        snoozedMailsViewModel.isConveyedSelected = true
                                        snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab);
                                    }
                                    .overlay(
                                        Text("conveyed")
                                            .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                                            .foregroundColor(self.snoozedMailsViewModel.isConveyedSelected ? themesviewModel.currentTheme.allBlack : themesviewModel.currentTheme.inverseTextColor)
                                    )
                            }
                            .background(themesviewModel.currentTheme.tabBackground)
                            .cornerRadius(25)
                            
                            
                            
                            if selectedTab == "awaited" {
                                QueueSnoozedMailsView
                            }
                            else if selectedTab == "postbox" {
                                postboxMailsView
                            }
                            else if selectedTab == "conveyed" {
                                conveyedMailsView
                            }
                            
                            Spacer()
                        }
                        .background(themesviewModel.currentTheme.windowBackground)
                        
                        .onAppear {
                            // Initialize with "awaited" to show QueueSnoozedMailsView on appear
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                selectedTab = "awaited"
                                snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab)
                            }
                        }
                        
                        .sheet(isPresented: $isMultiSelectionSheetVisible, content: {
                            EmailOptionsView( replyAction: {
                                // Perform reply action
                                print("Reply tapped")
                                dismissSheet()
                            },
                                              replyAllAction: {
                                // Perform reply all action
                                print("Reply all tapped")
                                dismissSheet()
                            },
                                              forwardAction: {
                                // Perform forward action
                                print("Forward tapped")
                                dismissSheet()
                            },
                                              markAsReadAction: {
                                print("read")
                                dismissSheet()
                            },
                                              markAsUnReadAction: {
                                print("unread")
                                dismissSheet()
                            },
                                              createLabelAction: {
                                print("label")
                                dismissSheet()
                            },
                                              moveToFolderAction: {
                                print("move folder")
                                dismissSheet()
                            },
                                              starAction: {
                                print("star")
                                dismissSheet()
                            },
                                              snoozeAction: {
                                print("snooze")
                                dismissSheet()
                            },
                                              trashAction: {
                                print("trash acti")
                                dismissSheet()
                            }
                            )
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.hidden)
                        })
                        
                        if isMenuVisible{
                            HomeMenuView(isSidebarVisible: $isMenuVisible)
                        }
                    }
                    
                    else if selectView {
                        VStack{
                            HStack{
                                Spacer()
                                Text("\(selectedIndices.count) Selected")
                                    .font(.custom(.poppinsRegular, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Spacer()
                                
                                Button {
                                    selectedIndices = []
                                    snoozedMailsViewModel.selectedThreadIDs = []
                                    beforeLongPress = true
                                    selectView = false
                                    emailId = 0
                                    print("cancel button select indices \(selectedIndices)")
                                } label: {
                                    Text("Cancel")
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                }
                                .padding(.trailing,15)
                            }
                            
                            HStack {
                                Text("Select All")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)
                                
                                Button(action: {
                                    if selectedIndices.count == snoozedMailsViewModel.snoozedMailsDataModel.count {
                                        selectedIndices.removeAll()
                                        isSelectAll = false
                                        selectedIndices = []
                                        snoozedMailsViewModel.selectedThreadIDs = []
                                        print("if case select indices \(selectedIndices)")
                                        print("if case snoozedMailsViewModel.selectedThreadIDs \(snoozedMailsViewModel.selectedThreadIDs)")
                                    } else {
                                        selectedIndices = Set(snoozedMailsViewModel.snoozedMailsDataModel.compactMap { $0.threadId})
                                        isSelectAll = true
                                        snoozedMailsViewModel.selectedThreadIDs = Array(selectedIndices)
                                        print("else case select indices \(selectedIndices)")
                                        print("else case snoozedMailsViewModel.selectedThreadIDs \(selectedIndices)")
                                    }
                                    
                                    
                                }) {
                                    Image(systemName: isSelectAll ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.top, 1)
                                        .padding(.trailing, 5)
                                        .foregroundColor(isSelectAll ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                }
                                
                                Spacer()
                            }
                            .padding(.leading,15)
                            
                            List($snoozedMailsViewModel.snoozedMailsDataModel) { $email in
                                VStack(alignment: .leading) {
                                    HStack {
                                        Button(action: {
                                            if let threadId = email.threadId {
                                                if selectedIndices.contains(threadId) {
                                                    selectedIndices.remove(threadId)
                                                    snoozedMailsViewModel.selectedThreadIDs.removeAll { $0 == threadId }
                                                    print("selectedIndices  \(selectedIndices)")
                                                    print("snoozedMailsViewModel.selectedThreadIDs  \(snoozedMailsViewModel.selectedThreadIDs)")
                                                } else {
                                                    selectedIndices.insert(threadId)
                                                    snoozedMailsViewModel.selectedThreadIDs.append(threadId)
                                                    markAs = email.readReceiptStatus ?? 0
                                                    emailId = threadId
                                                    snoozedMailsViewModel.selectedID = threadId
                                                    print("insert snoozedMailsViewModel.selectedID \(snoozedMailsViewModel.selectedID)")
                                                    print("emailId  \(emailId)")
                                                    print("markAs  \(markAs)")
                                                    print("insert selectedIndices  \(selectedIndices)")
                                                    if let thread = snoozedMailsViewModel.snoozedMailsDataModel.first(where: { $0.threadId == threadId }) {
                                                        let labelIDs = thread.labels?.compactMap { $0.labelId } ?? []
                                                        isCheckedLabelID = labelIDs
                                                    }
                                                }
                                                isSelectAll = selectedIndices.count == snoozedMailsViewModel.snoozedMailsDataModel.count
                                            }
                                        }) {
                                            Image(selectedIndices.contains(email.threadId ?? -1) ?  "selected" : "contactW")
                                                .resizable()
                                                .renderingMode(.template)
                                                .scaledToFill()
                                                .frame(width: 35, height: 35)
                                                .background(themesviewModel.currentTheme.colorAccent)
                                                .clipShape(Circle())
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .padding(.leading, 10)
                                                .contentShape(Rectangle())
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(email.firstname ?? "")
                                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                Text(email.lastname ?? "")
                                                    .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .lineLimit(1)
                                                Spacer()
                                                let unixTimestamp = email.sentAt ?? 0
                                                if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                                    Text(istDateStringFromTimestamp)
                                                        .padding(.trailing, 20)
                                                        .foregroundColor(Color.blueAccent?.opacity(0.3))
                                                        .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                                }
                                            }
                                            HStack {
                                                Text(email.subject ?? "")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsLight, size: 14))
                                                    .lineLimit(1)
                                                Spacer()
                                            }
                                            
                                            if let labels = email.labels, !labels.isEmpty {
                                                HStack {
                                                    Image("Tags")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    
                                                    Text(labels.first?.labelName ?? "")
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .font(.custom(.poppinsRegular, size: 14))
                                                        .background(Color.blueAccent)
                                                        .cornerRadius(8)
                                                    
                                                    if labels.count > 1 {
                                                        Text("+ \(labels.count - 1)")
                                                            .font(.custom(.poppinsRegular, size: 12))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .frame(width: 24, height: 24) // Make it a circle
                                                            .padding(.all ,1)
                                                            .background(Circle().fill(Color.clear)) // Transparent fill
                                                            .overlay(
                                                                Circle()
                                                                    .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1.5) // White border
                                                            )
                                                    }
                                                    
                                                }
                                            }
                                            
                                            HStack{
                                                let unixTimestamp = email.snoozeAt ?? 0
                                                if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                                    Text("snoozed Until \(istDateStringFromTimestamp)")
                                                        .padding(.trailing, 20)
                                                        .foregroundColor(Color.blue)
                                                        .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                    .padding(.top , 10)
                                    Divider()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 1)
                                        .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                }
                                .onAppear {
                                    print("else if case Active Branch - beforeLongPress: \(beforeLongPress), selectView: \(selectView)")
                                }
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
                            HStack(spacing: 50) {
                                Button(action: {
                                    showingDeleteAlert.toggle()
                                }) {
                                    Image("delete")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 40 , height: 40)
                                }
                                
                                
                                Button(action: {
                                    isMoveSheetvisible.toggle()
                                }) {
                                    Image("move")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 40 , height: 40)
                                }
                                                                
                                Button(action: {
                                    isTagsheetvisible.toggle()
                                }) {
                                    Image("Tags")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 40 , height: 40)
                                }
                                
                                
                                Button(action: {
                                    isMoreSheetvisible.toggle()
                                    issnoozesheetvisible = false
                                }) {
                                    Image("threeDots")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 40 , height: 40)
                                }
                                
                                Spacer()
                                
                            }
                            .padding([.leading, .trailing], 20)
                        }
                        .background(themesviewModel.currentTheme.windowBackground)
                        .onAppear{
                            HomeawaitingViewVisible = true
                            print("select all View appears")
                            if let thread = snoozedMailsViewModel.snoozedMailsDataModel.first(where: { $0.threadId == emailId }) {
                                let labelIDs = thread.labels?.compactMap { $0.labelId } ?? []
                                isCheckedLabelID = labelIDs
                            }
                        }
                        .onChange(of: isMoveSheetvisible || isTagsheetvisible || isMoreSheetvisible) { newValue in
                            if newValue == false {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab)
                                    selectedIndices = []
                                    homeAwaitingViewModel.selectedThreadIDs = []
                                }
                            }
                        }
                    }
                }
                .toast(message: $snoozedMailsViewModel.error)
                .toast(message: $homeAwaitingViewModel.error)
                .toast(message: $moveToFolderViewModel.error)
                
                if showingDeleteAlert {
                    ZStack {
                        Color.gray.opacity(0.5) // Dimmed background
                            .ignoresSafeArea()
                            .transition(.opacity)
                        // Centered DeleteNoteAlert
                        DeleteAlert(isPresented: $showingDeleteAlert) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                homeAwaitingViewModel.deleteEmailFromAwaiting(threadIDS: snoozedMailsViewModel.selectedThreadIDs)
                                selectView = false
                                showingDeleteAlert = false
                                beforeLongPress = true
                            }
                            selectedIndices.removeAll()

                        }
                    }
                    .transition(.scale)
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
                            MoveTo(isMoveToSheetVisible: $isMoveSheetvisible , selectedThreadID : $snoozedMailsViewModel.selectedThreadIDs, selectedIndices: $selectedIndices)
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
                            CreateTagLabel(isTagSheetVisible: $isTagsheetvisible, isActive: $isactive, HomeawaitingViewVisible: $HomeawaitingViewVisible, selectedNewBottomTag: $selectednewDiaryTag, selectedNames: $selectednames, selectedID:  $snoozedMailsViewModel.selectedThreadIDs, isclicked: $isClicked , isCheckedLabelID: $isCheckedLabelID)
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
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isMoreSheetvisible = false
                                }
                            }

                        VStack {
                            Spacer()

                            MoreSheet(snoozetime: $snoozeTime, isMoreSheetVisible: $isMoreSheetvisible, emailId: emailId, passwordHash: passwordHash, isTagsheetvisible: $isTagsheetvisible, isSnoozeSheetvisible: $issnoozesheetvisible ,StarreEmail: $EmailStarred ,markedAs: $markAs , HomeawaitingViewVisible: $HomeawaitingViewVisible, isMoveSheetvisible: $isMoveSheetvisible)
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
                
                
            }
        }

    }
    
    var QueueSnoozedMailsView: some View {
        VStack {
            if beforeLongPress {
                if snoozedMailsViewModel.isLoading {
                    CustomProgressView()
                }
                else if snoozedMailsViewModel.snoozedMailsDataModel.count == 0 {
                    VStack {
                        Text("No mails found")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(themesviewModel.currentTheme.windowBackground)
                }
                else {
                    List($snoozedMailsViewModel.snoozedMailsDataModel) { $email in
                        VStack {
                            HStack {
                                let image = email.senderProfile ?? "person"
                                AsyncImage(url: URL(string: image)) { phase in
                                    switch phase {
                                    case .empty:
                                        Image("contactW")
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .background(themesviewModel.currentTheme.colorAccent)
                                            .clipShape(Circle())
                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                            .padding(.leading, 10)
                                            .contentShape(Rectangle())
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .padding([.trailing,.leading],5)
                                            .aspectRatio(contentMode: .fit)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image("contactW")
                                            .resizable()
                                            .renderingMode(.template)
                                            .scaledToFill()
                                            .frame(width: 40, height: 40)
                                            .background(themesviewModel.currentTheme.colorAccent)
                                            .clipShape(Circle())
                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                            .padding(.leading, 10)
                                            .contentShape(Rectangle())
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(email.firstname ?? "")
                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        Text(email.lastname ?? "")
                                            .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .lineLimit(1)
                                        Spacer()
                                        let unixTimestamp = email.sentAt ?? 0
                                        if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                            Text(istDateStringFromTimestamp)
                                                .padding(.trailing, 20)
                                                .foregroundColor(Color.blueAccent?.opacity(0.3))
                                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                        }
                                    }
                                    HStack {
                                        Text(email.subject ?? "")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsLight, size: 14))
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    
                                    if let labels = email.labels, !labels.isEmpty {
                                        HStack {
                                            Image("Tags")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            
                                            Text(labels.first?.labelName ?? "")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 14))
                                                .background(Color.blueAccent)
                                                .cornerRadius(8)
                                            
                                            if labels.count > 1 {
                                                Text("+ \(labels.count - 1)")
                                                    .font(.custom(.poppinsRegular, size: 12))
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .frame(width: 24, height: 24) // Make it a circle
                                                    .padding(.all ,1)
                                                    .background(Circle().fill(Color.clear)) // Transparent fill
                                                    .overlay(
                                                        Circle()
                                                            .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1.5) // White border
                                                    )
                                            }
                                            
                                        }
                                    }
                                    
                                    HStack{
                                        let unixTimestamp = email.snoozeAt ?? 0
                                        if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                            Text("snoozed Until \(istDateStringFromTimestamp)")
                                                .padding(.trailing, 20)
                                                .foregroundColor(Color.blue)
                                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.top , 10)
                            .onTapGesture {
                                if beforeLongPress {
                                    markAs = email.readReceiptStatus ?? 0
                                    EmailStarred = email.starred ?? 0
                                    SnoozedView = true
                                    snoozedMailsViewModel.selectedID = email.threadId
                                    snoozedMailsViewModel.passwordHint = email.passwordHint
                                    selectView = false
                                    snoozedMailsViewModel.isEmailScreen = true
                                    print("onTap gesture")
                                    
                                }
                            }
                            .gesture(
                                LongPressGesture(minimumDuration: 1.0)
                                    .onEnded { _ in
                                        withAnimation {
                                            selectView = true
                                            beforeLongPress = false
                                            selectedIndices.insert(email.threadId ?? 0)
                                            snoozedMailsViewModel.selectedID = email.threadId
                                            snoozedMailsViewModel.selectedThreadIDs.append(email.threadId ?? 0)
                                            markAs = email.readReceiptStatus ?? 0
                                            EmailStarred = email.starred ?? 0
                                            emailId = email.threadId ?? 0
                                            print("Long press triggered")
                                            print("selectView \(selectView)")
                                            print("beforeLongPress \(beforeLongPress)")
                                        }
                                    }
                            )
                            
                            
                            
                            Divider()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                        }
                        .onAppear {
                            print("before long press appears")
                            print("if case Active Branch - beforeLongPress: \(beforeLongPress), selectView: \(selectView)")
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    
                }
                
            }
        }
        .navigationDestination(isPresented: $snoozedMailsViewModel.isEmailScreen) {
            if $snoozedMailsViewModel.passwordHint != nil{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: snoozedMailsViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs).toolbar(.hidden)
            }else{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: snoozedMailsViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars,markAs: $markAs).toolbar(.hidden)
            }
        }
    }
    
    var postboxMailsView: some View {
        VStack{
            
        if beforeLongPress{
            if snoozedMailsViewModel.isLoading {
                CustomProgressView()
            }
            
            else if snoozedMailsViewModel.snoozedMailsDataModel.count == 0 {
                VStack {
                    Text("No mails found")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsRegular, size: 16))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(themesviewModel.currentTheme.windowBackground)
            }
            else {
                List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
                    VStack {
                    HStack {
                        let image = email.senderProfile ?? "person"
                        AsyncImage(url: URL(string: image)) { phase in
                            switch phase {
                            case .empty:
                                Image("contactW")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .background(themesviewModel.currentTheme.colorAccent)
                                    .clipShape(Circle())
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .padding(.leading, 10)
                                    .contentShape(Rectangle())
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding([.trailing,.leading],5)
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                            case .failure:
                                Image("contactW")
                                    .resizable()
                                    .renderingMode(.template)
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .background(themesviewModel.currentTheme.colorAccent)
                                    .clipShape(Circle())
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .padding(.leading, 10)
                                    .contentShape(Rectangle())
                            @unknown default:
                                EmptyView()
                            }
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text(email.firstname ?? "")
                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                Text(email.lastname ?? "")
                                    .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .lineLimit(1)
                                Spacer()
                                let unixTimestamp = email.sentAt ?? 0
                                if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                    Text(istDateStringFromTimestamp)
                                        .padding(.trailing, 20)
                                        .foregroundColor(Color.blueAccent?.opacity(0.3))
                                        .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                }
                            }
                            HStack {
                                Text(email.subject ?? "")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom(.poppinsLight, size: 14))
                                    .lineLimit(1)
                                Spacer()
                            }
                            
                            if let labels = email.labels, !labels.isEmpty {
                                HStack {
                                    Image("Tags")
                                        .resizable()
                                        .renderingMode(.template)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    
                                    Text(labels.first?.labelName ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14))
                                        .background(Color.blueAccent)
                                        .cornerRadius(8)
                                    
                                    if labels.count > 1 {
                                        Text("+ \(labels.count - 1)")
                                            .font(.custom(.poppinsRegular, size: 12))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .frame(width: 24, height: 24) // Make it a circle
                                            .padding(.all ,1)
                                            .background(Circle().fill(Color.clear)) // Transparent fill
                                            .overlay(
                                                Circle()
                                                    .stroke(themesviewModel.currentTheme.textColor, lineWidth: 1.5) // White border
                                            )
                                    }
                                    
                                }
                            }
                            
                            HStack{
                                let unixTimestamp = email.snoozeAt ?? 0
                                if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                    Text("snoozed Until \(istDateStringFromTimestamp)")
                                        .padding(.trailing, 20)
                                        .foregroundColor(Color.blue)
                                        .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                }
                                Spacer()
                            }
                        }
                    }
                    .padding(.top , 10)
                    .onTapGesture {
                        markAs = email.readReceiptStatus ?? 0
                        EmailStarred = email.starred ?? 0
                        SnoozedView = true
                        snoozedMailsViewModel.selectedID = email.emailId
                        snoozedMailsViewModel.passwordHint = email.passwordHint
                        selectView = false
                        snoozedMailsViewModel.isEmailScreen = true
                    }
                        
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onEnded { _ in
                                withAnimation {
                                    selectView = true
                                    beforeLongPress = false
                                    selectedIndices.insert(email.threadId ?? 0)
                                    snoozedMailsViewModel.selectedID = email.threadId
                                    snoozedMailsViewModel.selectedThreadIDs.append(email.threadId ?? 0)
                                    markAs = email.readReceiptStatus ?? 0
                                    EmailStarred = email.starred ?? 0
                                    emailId = email.threadId ?? 0
                                    print("Long press triggered")
                                    print("selectView \(selectView)")
                                    print("beforeLongPress \(beforeLongPress)")
                                }
                            }
                    )
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                        
                }
                
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)

            }
        
        }
        }
        .navigationDestination(isPresented: $snoozedMailsViewModel.isEmailScreen) {
            MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: snoozedMailsViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars,markAs: $markAs).toolbar(.hidden)
           }
    }
    
    var conveyedMailsView: some View {
        VStack{
        if beforeLongPress{
            if snoozedMailsViewModel.isLoading {
                CustomProgressView()
            }
            
            else if snoozedMailsViewModel.snoozedMailsDataModel.count == 0 {
                VStack {
                    Text("No mails found")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsRegular, size: 16))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .background(themesviewModel.currentTheme.windowBackground)
            }
            else {
                List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
                    VStack {
                        HStack {
                            let image = email.senderProfile ?? "person"
                            AsyncImage(url: URL(string: image)) { phase in
                                switch phase {
                                case .empty:
                                    Image("contactW")
                                        .resizable()
                                        .renderingMode(.template)
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .background(themesviewModel.currentTheme.colorAccent)
                                        .clipShape(Circle())
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .padding(.leading, 10)
                                        .contentShape(Rectangle())
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .padding([.trailing,.leading],5)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                case .failure:
                                    Image("contactW")
                                        .resizable()
                                        .renderingMode(.template)
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .background(themesviewModel.currentTheme.colorAccent)
                                        .clipShape(Circle())
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .padding(.leading, 10)
                                        .contentShape(Rectangle())
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(email.firstname ?? "")
                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    Text(email.lastname ?? "")
                                        .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .lineLimit(1)
                                    Spacer()
                                    let unixTimestamp = email.sentAt ?? 0
                                    if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                        Text(istDateStringFromTimestamp)
                                            .padding(.trailing, 20)
                                            .foregroundColor(Color.blueAccent)
                                            .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                    }
                                }
                                HStack {
                                    Text(email.subject ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsLight, size: 14))
                                        .lineLimit(1)
                                    Spacer()
                                }
                                
                                HStack{
                                    let unixTimestamp = email.snoozeAt ?? 0
                                    if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                        Text("snoozed Until \(istDateStringFromTimestamp)")
                                            .padding(.trailing, 20)
                                            .foregroundColor(Color.blueAccent?.opacity(0.3))
                                            .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .onTapGesture {
                            markAs = email.readReceiptStatus ?? 0
                            EmailStarred = email.starred ?? 0
                            SnoozedView = true
                            snoozedMailsViewModel.selectedID = email.emailId
                            snoozedMailsViewModel.passwordHint = email.passwordHint
                            selectView = false
                            snoozedMailsViewModel.isEmailScreen = true
                        }
                            
                        .gesture(
                            LongPressGesture(minimumDuration: 1.0)
                                .onEnded { _ in
                                    withAnimation {
                                        selectView = true
                                        beforeLongPress = false
                                        selectedIndices.insert(email.threadId ?? 0)
                                        snoozedMailsViewModel.selectedID = email.threadId
                                        snoozedMailsViewModel.selectedThreadIDs.append(email.threadId ?? 0)
                                        markAs = email.readReceiptStatus ?? 0
                                        EmailStarred = email.starred ?? 0
                                        emailId = email.threadId ?? 0
                                        print("Long press triggered")
                                        print("selectView \(selectView)")
                                        print("beforeLongPress \(beforeLongPress)")
                                    }
                                }
                        )
                        Divider()
                            .frame(maxWidth: .infinity)
                            .frame(height: 1)
                            .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                        
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
        }
        }
    }
    private func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
    }
    
}

#Preview {
    SnoozedMailsView()
}
