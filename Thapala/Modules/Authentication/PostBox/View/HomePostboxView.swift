//
//  HomePostboxView.swift
//  Thapala
//
//  Created by Ahex-Guest on 20/06/24.
//

import SwiftUI

struct HomePostboxView: View {
    @State private var isMenuVisible = false
    @StateObject var homePostboxViewModel = HomePostboxViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var isSheetVisible = false
    @State private var isStarred: Bool = false // Track starred state
    @State private var isQuickAccessVisible = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    let imageUrl: String
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var iNotificationAppBarView = false
    @State private var longpress: Bool = false
    @State private var selectedIndices: Set<Int> = []
    @State private var isSelectAll = false
    @State private var showingDeleteAlert = false
    @State private var isMoreSheetvisible: Bool = false
    @State private var isTagsheetvisible: Bool = false
    @State private var issnoozesheetvisible: Bool = false
    @State private var isSnoozeSheetvisible: Bool = false
    @State private var isViewActive: Bool = false
    @State private var notificationTime: Int = 0
    var selectedID: Int
    let emailId: Int
    let passwordHash: String
    @State private var EmailStarred : Int = 0
    @State private var snoozeTime : Int = 0
    @State private var isPostBoxMailViewActive:Bool = false
    @State private var markAs : Int = 0
    @State private var HomeawaitingViewVisible: Bool = false
    @State private var isMoveSheetvisible: Bool = false
    var body: some View {
        GeometryReader{ reader in
            ZStack(alignment: .bottomTrailing){
                VStack{
                    if homePostboxViewModel.beforeLongPress{
                        VStack {
                        HStack(spacing:20){
                            Image("contactW")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 35, height: 35)
                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                .background(
                                    Circle()
                                        .fill(themesviewModel.currentTheme.colorPrimary) // Inner background
                                )
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2) // Border
                                )
                                .clipShape(Circle())
                                .padding(.leading, 16)
                            
                            Text("Postbox")
                                .padding(.leading,5)
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsBold, size: 16, relativeTo: .title))
                            
                            Spacer()
                            
                            Button(action: {
                                appBarElementsViewModel.isSearch = true
                            }) {
                                Image("magnifyingglass")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            .padding(.leading,15)
                            
                            Button(action: {
                                iNotificationAppBarView = true
                            }) {
                                Image("notification")
                            }
                            .padding(.leading,15)
                            
                            Button(action: {
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image("MenuIcon")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            .padding(.leading,15)
                            .padding(.trailing , 30)
                            
                            
                        }
                        .padding(.top, -reader.size.height * 0.01)
                            
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homePostboxViewModel.isEmailsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .onTapGesture {
                                            homePostboxViewModel.getPostEmailData()
                                            self.homePostboxViewModel.selectedOption = .emails
                                            self.homePostboxViewModel.isEmailsSelected = true
                                            self.homePostboxViewModel.isPrintSelected = false
                                            self.homePostboxViewModel.isChatboxSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("stacked_email")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    
                                                        
                                                    VStack{
                                                        Text("tEmails")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homePostboxViewModel.isPrintSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .onTapGesture {
                                            self.homePostboxViewModel.selectedOption = .print
                                            self.homePostboxViewModel.isEmailsSelected = false
                                            self.homePostboxViewModel.isPrintSelected = true
                                            self.homePostboxViewModel.isChatboxSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                     Image("tpersued")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    VStack{
                                                        Text("tPerused")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homePostboxViewModel.isChatboxSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .onTapGesture {
                                            homePostboxViewModel.getContactsList()
                                            self.homePostboxViewModel.selectedOption = .chatbox
                                            self.homePostboxViewModel.isEmailsSelected = false
                                            self.homePostboxViewModel.isPrintSelected = false
                                            self.homePostboxViewModel.isChatboxSelected = true
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("tChat")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    VStack{
                                                        Text("tChat")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                }
                                .padding([.leading,.trailing,],5)
                                .padding(.bottom , 10)
                            
                    }
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 30)
//                        .frame(height: reader.size.height * 0.16)
                        .background(themesviewModel.currentTheme.tabBackground)
                        



                          
                        if let selectedOption = homePostboxViewModel.selectedOption {
                            switch selectedOption {
                            case .emails:
                                emailsView
                            case .print:
                                printView
                            case .chatbox:
                                chatView
                            }
                        }

                        Spacer()
                        
                        TabViewNavigator()
                            .frame(height: 40)
                            .padding(.bottom, 10)
                    }
                    
                    else {
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(selectedIndices.count) selected")
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                
                                Spacer()
                                
                                Button {
                                    selectedIndices = []
                                    homePostboxViewModel.selectedThreadIDs = []
                                    homePostboxViewModel.beforeLongPress.toggle()
                                    selectedIndices.removeAll()
                                    isSelectAll = false
                                    isPostBoxMailViewActive = false // for snooze view bool the view
                                } label: {
                                    Text("Cancel")
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                }
                                .padding(.trailing, 15)
                            }
                            
                            HStack {
                                Text("Select All")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)
                                
                                Button(action: {
                                    if selectedIndices.count == homePostboxViewModel.postBoxEmailData.count {
                                        selectedIndices.removeAll()
                                        isSelectAll = false
                                        homePostboxViewModel.selectedThreadIDs = []
                                    } else {
                                        selectedIndices = Set(homePostboxViewModel.postBoxEmailData.compactMap { $0.threadId })
                                        isSelectAll = true
                                        homePostboxViewModel.selectedThreadIDs = Array(selectedIndices)
                                        
                                    }
                                }) {
                                    Image(systemName: isSelectAll ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.top, 1)
                                        .padding(.trailing, 5)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                }
                                
                                Spacer()
                            }
                            .padding(.leading, 15)
                            .padding(.top, 10)
                            ZStack(alignment: .bottomTrailing) {
                                List($homePostboxViewModel.postBoxEmailData) { $data in
                                    VStack {
                                        HStack {
                                            Button(action: {
                                                if let threadId = data.threadId {
                                                    if selectedIndices.contains(threadId) {
                                                        selectedIndices.remove(threadId)
                                                        homePostboxViewModel.selectedThreadIDs.removeAll { $0 == threadId }
                                                    } else {
                                                        selectedIndices.insert(threadId)
                                                        homePostboxViewModel.selectedThreadIDs.append(threadId)
                                                        homePostboxViewModel.selectedID = threadId
                                                        markAs = data.readReceiptStatus ?? 0
                                                        EmailStarred = data.starred
                                                    }
                                                    isSelectAll = selectedIndices.count == homePostboxViewModel.postBoxEmailData.count
                                                    
                                                }
                                            }) {
                                                Image(selectedIndices.contains(data.threadId ?? -1) ? "selected" : "contactW")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
                                                    .background(themesviewModel.currentTheme.colorAccent)
                                                    .clipShape(Circle())
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .padding(.leading, 10)
                                                    .contentShape(Rectangle())
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                HStack {
                                                    Text(data.firstname ?? "")
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                    if data.hasDraft == 1 {
                                                        Text("Draft")
                                                            .foregroundColor(Color.red)
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                    }
                                                }
                                                
                                                Text(data.subject)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                    .lineLimit(1)
                                                
                                                if let labels = data.labels, !labels.isEmpty {
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
                                            }
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                HStack {
                                                    if let timestamp = (data.snooze == 1 ? data.snoozeAt : data.sentAt ?? 0),
                                                       let istDateString = convertToIST(dateInput: timestamp) {
                                                        HStack(spacing: 5) {
                                                            if (data.snooze == 1) {
                                                                Image("snooze")
                                                                    .renderingMode(.template)
                                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            }
                                                            Text(istDateString)
                                                                .font(.custom(.poppinsMedium, size: 14))
                                                                .foregroundColor(data.snooze == 1 ? .orange : themesviewModel.currentTheme.iconColor)
                                                            
                                                            
                                                        }
                                                        .padding(.top, 0)
                                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                                    }
                                                }
                                                .padding(.trailing , 10)
                                                
                                                
                                                
                                                Image(data.starred == 1 ? "star" : "emptystar")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(data.starred == 1 ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                    .padding(.trailing , 10)
                                                    .onTapGesture {
                                                        // Safely toggle starred state
                                                        data.starred = data.starred == 1 ? 0 : 1
                                                        homePostboxViewModel.getStarredEmail(selectedEmail: data.threadId ?? 0)
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                                            homePostboxViewModel.isLoading = false
                                                        }
                                                    }
                                            }
                                            .frame(height: 34)
                                        }
                                        .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                        .swipeActions(edge: .leading) {
                                            Button {
                                                showingDeleteAlert = true
                                            } label: {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.white)
                                            }
                                            .tint(Color.themeColor)
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button {
                                                isSheetVisible = true
                                            } label: {
                                                Image(systemName: "ellipsis")
                                                    .foregroundColor(.white)
                                            }
                                            .tint(Color(red: 1.0, green: 0.5, blue: 0.5))
                                        }
                                        //                                }
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
                                
                                Spacer()
                                HStack{
                                    RoundedRectangle(cornerRadius: 30)
                                        .fill(themesviewModel.currentTheme.colorPrimary)
                                        .frame(width: 150,height: 48)
                                        .overlay(alignment: .center) {
                                            HStack {
                                                Text("New Email")
                                                    .font(.custom(.poppinsBold, size: 14))
                                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                    .padding(.trailing, 8)
                                                    .onTapGesture {
                                                        homePostboxViewModel.isComposeEmail = true
                                                    }
                                                Spacer()
                                                    .frame(width: 1, height: 24)
                                                    .background(themesviewModel.currentTheme.inverseIconColor)
                                                Image("dropdown 1")
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .onTapGesture {
                                                        isQuickAccessVisible = true
                                                    }
                                            }
                                        }
                                        .padding(.trailing)
                                        .padding(.bottom)
                                }
                                .padding(.bottom, 50)
                            }
                        }
                        .onAppear {
                            isPostBoxMailViewActive = true
                        }
                        HStack{
                            Button(action: {
                                showingDeleteAlert = true
                            }){
                                Image("delete")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 30 , height: 30)
                                    .padding(.leading ,20 )
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                isSnoozeSheetvisible = true
                            }){
                                Image("snooze")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 30 , height: 30)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                isMoreSheetvisible = true
                            }){
                                Image("threeDots")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 30 , height: 30)
                                    .padding(.trailing ,20 )
                            }
                        }
                        .background(themesviewModel.currentTheme.windowBackground)
                        
                        
                    }
                                        

                }
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        homePostboxViewModel.getPostEmailData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            homePostboxViewModel.getContactsList()
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let settings = homePostboxViewModel.contactsList.first {
                            firstName = settings.firstname
                            lastName = settings.lastname
                        }
                    }
                }
                
                .onChange(of: isSnoozeSheetvisible || isMoreSheetvisible) { newValue in
                    if newValue == false {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            homePostboxViewModel.getPostEmailData()
                            selectedIndices = []
                            homePostboxViewModel.selectedThreadIDs = []
                        }
                    }
                }

                if homePostboxViewModel.beforeLongPress {
                     HStack {
                         Spacer()
                         RoundedRectangle(cornerRadius: 30)
                             .fill(themesviewModel.currentTheme.colorPrimary)
                             .frame(width: 150, height: 48)
                             .overlay(
                                 HStack {
                                     Text("New Email")
                                         .font(.custom(.poppinsBold, size: 14))
                                         .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                         .padding(.trailing, 8)
                                         .onTapGesture {
                                             homePostboxViewModel.isComposeEmail = true
                                         }
                                     Spacer()
                                         .frame(width: 1, height: 24)
                                         .background(themesviewModel.currentTheme.inverseIconColor)
                                         Image("dropdown 1")
                                         .foregroundColor(themesviewModel.currentTheme.iconColor)
                                             .onTapGesture {
                                                 isQuickAccessVisible = true
                                                 
                                             }
                                 }
                             )
                             .padding(.trailing, 20)
                             .padding(.bottom, 20)
                     }
                     .padding(.bottom, 50)
                 }
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
                if isQuickAccessVisible {
                    ZStack {
                        Color.gray.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isQuickAccessVisible = false
                            }
                        QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                            .background(Color.white) // Background color for the Quick Access View
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Align at the bottom right
                            .padding([.bottom, .trailing], 20)
                    }
                }
                
                if iNotificationAppBarView {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    iNotificationAppBarView = false
                                }
                            }
                        NotificationAppBarView()
                        .frame(height: .infinity)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(20)
                        .padding(.horizontal,20)
                        .padding(.bottom,50)
                        .padding(.top,80)
                        .transition(.scale)
                        .animation(.easeInOut, value: iNotificationAppBarView)
                    }
                }
                if showingDeleteAlert {
                    ZStack {
                        Color.gray.opacity(0.5) // Dimmed background
                            .ignoresSafeArea()
                            .transition(.opacity)                        
                        // Centered DeleteNoteAler
                        DeleteAlert(isPresented: $showingDeleteAlert) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                homeAwaitingViewModel.deleteEmailFromAwaiting(threadIDS: homePostboxViewModel.selectedThreadIDs)
                                showingDeleteAlert = false
                                homePostboxViewModel.beforeLongPress.toggle()
                            }
                            
                           
                            homePostboxViewModel.postBoxEmailData.removeAll { item in
                                homePostboxViewModel.selectedThreadIDs.contains(item.threadId ?? 0)
                            }
                            
                            selectedIndices.removeAll()
                            
                        }
                    }
                    .transition(.scale)
                }
                
                if isMoreSheetvisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isMoreSheetvisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            MoreSheet(snoozetime: $snoozeTime, isMoreSheetVisible: $isMoreSheetvisible, emailId: homePostboxViewModel.selectedID ?? 0, passwordHash: passwordHash, isTagsheetvisible: $isTagsheetvisible, isSnoozeSheetvisible: $issnoozesheetvisible, StarreEmail: $EmailStarred, markedAs: $markAs, HomeawaitingViewVisible: $HomeawaitingViewVisible, isMoveSheetvisible: $isMoveSheetvisible)
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isMoreSheetvisible)
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
                            BottomSnoozeView(isBottomSnoozeViewVisible: $isSnoozeSheetvisible, SnoozeTime: $notificationTime, selectedID: homePostboxViewModel.selectedID ?? 0)
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isSnoozeSheetvisible)
                        }
                    }
                }
                
            }

            .sheet(isPresented: $isSheetVisible, content: {
                EmailOptionsView( replyAction: {
                    // Perform reply action
                    dismissSheet()
                },
                                  replyAllAction: {
                    // Perform reply all action
                    dismissSheet()
                },
                                  forwardAction: {
                    // Perform forward action
                    dismissSheet()
                },
                                  markAsReadAction: {
                    dismissSheet()
                },
                                  markAsUnReadAction: {
                    dismissSheet()
                },
                                  createLabelAction: {
                    dismissSheet()
                },
                                  moveToFolderAction: {
                    dismissSheet()
                },
                                  starAction: {
                    dismissSheet()
                },
                                  snoozeAction: {
                    dismissSheet()
                },
                                  trashAction: {
                    dismissSheet()
                }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
            })
            .navigationDestination(isPresented: $homePostboxViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
            .navigationDestination(isPresented: $appBarElementsViewModel.isSearch) {
                SearchView(appBarElementsViewModel: appBarElementsViewModel)
                    .toolbar(.hidden)
            }
            .navigationDestination(isPresented: $homePostboxViewModel.isEmailScreen) {
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: homePostboxViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $EmailStarred,markAs: $markAs).toolbar(.hidden)
            }
            .toast(message: $homePostboxViewModel.error)
        }
    }
    
    var emailsView:some View{
        VStack{
            if homePostboxViewModel.isLoading {
                CustomProgressView()
                    
            }
            else if homePostboxViewModel.postBoxEmailData.isEmpty{
                Text("No Mails Found.")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
            }else{
                    VStack{
                        if homePostboxViewModel.beforeLongPress{
                            List($homePostboxViewModel.postBoxEmailData) { $data in
                                VStack {
                                    HStack {
                                        let image = data.senderProfile ?? "person"
                                        AsyncImage(url: URL(string: image)) { phase in
                                            switch phase {
                                            case .empty:
                                                Image("contactW")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
                                                    .background(themesviewModel.currentTheme.colorAccent)
                                                    .clipShape(Circle())
                                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                    .padding(.leading, 10)
                                                    .contentShape(Rectangle())
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .frame(width: 34, height: 34)
                                                    .padding([.trailing,.leading],5)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                            case .failure:
                                                Image("contactW")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .scaledToFill()
                                                    .frame(width: 30, height: 30)
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
                                                Text(data.firstname ?? "")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                if data.hasDraft == 1 {
                                                    Text("Draft")
                                                        .foregroundColor(Color.red)
                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                }
                                            }
                                            
                                            Text(data.subject)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                .lineLimit(1)
                                            
                                            if let labels = data.labels, !labels.isEmpty {
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
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            HStack {
                                                if let timestamp = (data.snooze == 1 ? data.snoozeAt : data.sentAt ?? 0),
                                                   let istDateString = convertToIST(dateInput: timestamp) {
                                                    HStack(spacing: 5) {
                                                        if (data.snooze == 1) {
                                                        Image("snooze")
                                                            .renderingMode(.template)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        }
                                                            Text(istDateString)
                                                                .font(.custom(.poppinsMedium, size: 14))
                                                                .foregroundColor(data.snooze == 1 ? .orange : themesviewModel.currentTheme.iconColor)
                                                                
                                                        
                                                    }
                                                    .padding(.top, 0)
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                }
                                            }
                                            .padding(.trailing , 10)


                                            
                                            Image(data.starred == 1 ? "star" : "emptystar")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(data.starred == 1 ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                .padding(.trailing , 10)
                                                .onTapGesture {
                                                    // Safely toggle starred state
                                                    data.starred = data.starred == 1 ? 0 : 1
                                                    homePostboxViewModel.getStarredEmail(selectedEmail: data.threadId ?? 0)
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                                        homePostboxViewModel.isLoading = false
                                                    }
                                                }
                                        }
                                        .frame(height: 34)
                                    }
                                    .padding(.top , 10)
                                    .onTapGesture {
                                        PostBoxView = true
                                        homePostboxViewModel.starEmail = EmailStarred
                                        EmailStarred = data.starred
                                        homePostboxViewModel.selectedID = data.threadId
                                        homePostboxViewModel.passwordHint = data.passwordHint
                                        homePostboxViewModel.isEmailScreen = true
                                    }
                                    .gesture(
                                        LongPressGesture(minimumDuration: 1.0)
                                            .onEnded { _ in
                                                withAnimation {
                                                    selectedIndices.insert(data.threadId ?? 0)
                                                    homePostboxViewModel.selectedID = data.threadId
                                                    homePostboxViewModel.selectedThreadIDs.append(data.threadId ?? 0)
                                                    homePostboxViewModel.beforeLongPress = false
                                                    markAs = data.readReceiptStatus
                                                    EmailStarred = data.starred
                                                }
                                            }
                                    )
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            // deletion logic here
                                        } label: {
                                            deleteIcon.foregroundStyle(.white)
                                        }
                                        .tint(Color.themeColor)
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button {
                                            isSheetVisible = true
                                        } label: {
                                            moreIcon.foregroundStyle(.white)
                                        }
                                        .tint(Color(red: 1.0, green: 0.5, blue: 0.5))

                                    }
//                                }
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
    }
    
    var printView:some View{
            VStack{
                ZStack {
                    Color.clear // Background to help center the image
                    Image("coming soon") // Replace with the actual image name
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .scaledToFit()
                        .frame(width: 160, height: 111.02)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
        }
    }
    
    var chatView:some View{

            VStack{
                if homePostboxViewModel.contactsList.count == 0{
                    Text("No Mails Found.")
                        .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                }else{
                    VStack{
                        List($homePostboxViewModel.contactsList, id: \.id) { $contact in
                            HStack{
                                AsyncImage(url: URL(string: contact.profile ?? "")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView() // Or any placeholder
                                }
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                VStack(alignment: .leading){
                                    Text(contact.firstname)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                    Text(contact.lastname)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                        .lineLimit(1)
                                }
                                Spacer()
                            }
                            .listRowBackground(themesviewModel.currentTheme.windowBackground)
                            .onTapGesture {
                                homePostboxViewModel.isChatBoxScreen = true
                                homePostboxViewModel.selectID = contact.id
                                homePostboxViewModel.roomid = contact.roomId
                                
                            }
                            .gesture(
                                LongPressGesture(minimumDuration: 1.0)
                                    .onEnded { _ in
                                        withAnimation {
                                            homePostboxViewModel.beforeLongPress = false
                                        }
                                    }
                            )
                        }
                        .listStyle(PlainListStyle())
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationDestination(isPresented: $homePostboxViewModel.isChatBoxScreen) {
                ChatBoxView(selectID: homePostboxViewModel.selectID, roomid: homePostboxViewModel.roomid)
            }
        
    }
    private func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
    }
}

//#Preview {
//    HomePostboxView( starredEmail: $starredEmail, imageUrl: "")
//}

struct ChatBubble: View {
    var message: Message

    var body: some View {
        VStack(alignment: message.isSentByUser ? .trailing : .leading) {
            HStack {
                if message.isSentByUser {
                    Spacer()
                }
                Text(message.text)
                    .padding()
                    .background(message.isSentByUser ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                if !message.isSentByUser {
                    Spacer()
                }
            }
            Text(message.timestamp, style: .time)
                .font(.footnote)
                .foregroundColor(.gray)
        }
    }
}


private var deleteIcon: Image {
    Image(
        size: CGSize(width: 60, height: 40),
        label: Text("Delete").font(.custom(.poppinsLight, size: 10, relativeTo: .title))
    ) { ctx in
        ctx.draw(
            Image(systemName: "trash"),
            at: CGPoint(x: 30, y: 0),
            anchor: .top
        )
        ctx.draw(
            Text("Delete"),
            at: CGPoint(x: 30, y: 20),
            anchor: .top
        )
    }
}

private var moreIcon: Image {
    Image(
        size: CGSize(width: 60, height: 40),
        label: Text("More").font(.custom(.poppinsLight, size: 10, relativeTo: .title))
    ) { ctx in
        ctx.draw(
            Image("more 1"),
            at: CGPoint(x: 30, y: 0),
            anchor: .top
        )
        ctx.draw(
            Text("More"),
            at: CGPoint(x: 30, y: 20),
            anchor: .top
        )
    }
}
