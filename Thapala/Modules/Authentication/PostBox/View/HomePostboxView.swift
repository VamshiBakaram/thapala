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
    @StateObject var themesviewModel = themesViewModel()
    @State private var emailStarred: Int = 0
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
    @State private var isNotificationVisible: Bool = false
    @State private var isViewActive: Bool = false
    @Binding var notificationTime: Int?
    var selectedID: Int
    let emailId: Int
    let passwordHash: String
    @State private var EmailStarred : Int = 0
    @State private var snoozeTime : Int = 0
    @State private var selectedMailID: [Int] = []
    @State private var isPostBoxMailViewActive:Bool = false
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    if homePostboxViewModel.beforeLongPress{
                        VStack {
                        HStack(spacing:20){
                            AsyncImage(url: URL(string: imageUrl)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .padding(.leading,20)
                                case .failure:
                                    Image("person")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .padding(.leading,20)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text("Postbox")
                                .padding(.leading,5)
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsBold, size: 16, relativeTo: .title))
                            Spacer()
                            Button(action: {
                                print("search button pressed")
                                appBarElementsViewModel.isSearch = true
                            }) {
                                Image("magnifyingglass")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
//                            Button(action: {
//                                print("Pencil button pressed")
//                                homePostboxViewModel.isComposeEmail = true
//                            }) {
//                                Image("pencil")
//                                    .font(Font.title.weight(.medium))
//                                    .foregroundColor(Color.white)
//                            }
                            
                            Button(action: {
                                print("bell button pressed")
                                iNotificationAppBarView = true
                            }) {
                                Image("notification")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            
                            Button(action: {
                                print("line.3.horizontal button pressed")
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .font(Font.title.weight(.medium))
                            }
                            .padding(.trailing,15)
                            
                        }
                        .padding(.top, -reader.size.height * 0.01)
                            
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homePostboxViewModel.isEmailsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
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
                                                    Image("emailG")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    
                                                        
                                                    VStack{
                                                        Text("Emails")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homePostboxViewModel.isPrintSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homePostboxViewModel.selectedOption = .print
                                            self.homePostboxViewModel.isEmailsSelected = false
                                            self.homePostboxViewModel.isPrintSelected = true
                                            self.homePostboxViewModel.isChatboxSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                     Image("printIcon")
                                                        .frame(width: 20, height: 20)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    VStack{
                                                        Text("Print")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homePostboxViewModel.isChatboxSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
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
                                                    Image("chatBox")
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack{
                                                        Text("ChatBox")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    }
                                                }
                                            }
                                        )
                                }
                                .padding([.leading,.trailing,],5)
                                .padding(.bottom , 10)
                            
                    }
                        .frame(height: reader.size.height * 0.16)
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

                        VStack {
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
                         }
                        
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
                                        selectedMailID = Array(selectedIndices)
                                    } else {
                                        selectedIndices = Set(homePostboxViewModel.postBoxEmailData.compactMap { $0.threadId })
                                        isSelectAll = true
                                        homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                        print("Select All selectedMailID \(selectedMailID)")
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

                            List {
                                ForEach($homePostboxViewModel.postBoxEmailData, id: \.threadId) { $data in
                                    HStack {
                                        Button(action: {
                                            if let threadId = data.threadId {
                                                if selectedIndices.contains(threadId) {
                                                    selectedIndices.remove(threadId)
                                                } else {
                                                    selectedIndices.insert(threadId)
                                                    homeAwaitingViewModel.selectedThreadIDs = [threadId]
                                                    print("single check \(homeAwaitingViewModel.selectedThreadIDs)")
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
                                                    .font(.custom("Poppins-Medium", size: 16))
                                                if data.hasDraft == 1 {
                                                    Text("Draft")
                                                        .foregroundColor(Color.red)
                                                        .font(.custom("Poppins-Regular", size: 14))
                                                }
                                            }

                                            Text(data.subject)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom("Poppins-Regular", size: 14))
                                                .lineLimit(1)
                                        }

                                        Spacer()

                                        VStack(alignment: .trailing) {
                                            if let date = data.sentAt,
                                               let istDateString = convertToIST(dateInput: date) {
                                                Text(istDateString)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom("Poppins-Light", size: 14))
                                            }

                                            Image(data.starred == 1 ? "star" : "emptystar")
                                                .resizable()
                                                .frame(width: 14, height: 14)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .onTapGesture {
                                                    data.starred = data.starred == 1 ? 0 : 1
                                                    if let id = data.threadId {
                                                        homePostboxViewModel.getStarredEmail(selectedEmail: id)
                                                    }
                                                }
                                        }
                                    }
                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            print("Deleting row")
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
                                }
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
                            
                            Spacer()
                            HStack{
                                Spacer()
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
                                                    homeAwaitingViewModel.isComposeEmail = true
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
                        }
                        .onAppear {
                            isPostBoxMailViewActive = true
                            print("isPostBoxMailViewActive  \(isPostBoxMailViewActive)")
                        }
                        HStack{
                            Button(action: {
                                print("delete clicked")
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
                                print("snooze clicked")
                                isNotificationVisible = true
                            }){
                                Image("snooze")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 30 , height: 30)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                print("threeDots clicked")
                                isMoreSheetvisible = true
                            }){
                                Image("threeDots")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 30 , height: 30)
                                    .padding(.trailing ,20 )
                            }
                        }
                        .background(themesviewModel.currentTheme.windowBackground.opacity(0.1))
                        
                        
                    }
                                        

                }
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        print("postBox view appears")
                        
                        homePostboxViewModel.getPostEmailData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            homePostboxViewModel.getContactsList()
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        if let settings = homePostboxViewModel.ContactsList.first {
                            firstName = settings.firstname
                            lastName = settings.lastname
                        }
                    }
                }

                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                if isQuickAccessVisible {
                        Color.white.opacity(0.8) // Optional: semi-transparent background
                            .ignoresSafeArea()
                            .blur(radius: 10) // Blur effect for the background
                        QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                            .background(Color.white) // Background color for the Quick Access View
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Align at the bottom right
                            .padding([.bottom, .trailing], 20)
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
                        // Centered DeleteNoteAlert
                        DeleteAlert(isPresented: $showingDeleteAlert) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                print("delete alert")
                                homeAwaitingViewModel.deleteEmailFromAwaiting()
                                showingDeleteAlert = false
                                homePostboxViewModel.beforeLongPress.toggle()
                            }
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
                                    print("Tapped isMoreSheetvisible")
                                    isMoreSheetvisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            MoreSheet(snoozetime: $snoozeTime, isMoreSheetVisible: $isMoreSheetvisible, emailId: emailId, passwordHash: passwordHash, isTagsheetvisible: $isTagsheetvisible, StarreEmail: $EmailStarred)
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isMoreSheetvisible)
                        }
                    }
                }
                
                if isNotificationVisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    print("Tapped isNotificationVisible")
                                    isNotificationVisible = false
                                }
                            }

                        VStack {
                            Spacer()
                            BottomNotificationView(isNotificationVisible: $isNotificationVisible, notificationTime: $notificationTime, isViewActive: $isViewActive, ispostBoxMailViewActive: $isPostBoxMailViewActive, selectedID: selectedID)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isNotificationVisible)
                        }
                    }
                }
                
            }
//            .navigationDestination(isPresented: $homePostboxViewModel.isComposeEmail) {
//                MailComposeView().toolbar(.hidden)
//            }
            .sheet(isPresented: $isSheetVisible, content: {
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
                 //   homeAwaitingViewModel.getStarredEmail(selectedEmail: homeAwaitingViewModel.selectedID ?? 0)
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
            .navigationDestination(isPresented: $homePostboxViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
            .navigationDestination(isPresented: $appBarElementsViewModel.isSearch) {
                SearchView(appBarElementsViewModel: appBarElementsViewModel)
                    .toolbar(.hidden)
            }
            .navigationDestination(isPresented: $homePostboxViewModel.isEmailScreen) {
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: homePostboxViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $emailStarred).toolbar(.hidden)
            }
           //
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
                            List {
                                ForEach($homePostboxViewModel.postBoxEmailData, id: \.threadId) { $data in
                                    HStack {
                                        let image = data.senderProfile ?? "person"
                                        AsyncImage(url: URL(string: image)) { phase in
                                            switch phase {
                                            case .empty:
                                                ProgressView()
                                                    .foregroundColor(.white)
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .frame(width: 34, height: 34)
                                                    .padding([.trailing, .leading], 5)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                            case .failure:
                                                Image("person")
                                                    .resizable()
                                                    .frame(width: 34, height: 34)
                                                    .foregroundColor(.blue)
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
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing) {
                                            if let istDateStringFromTimestamp = convertToIST(dateInput: data.sentAt) {
                                                Text(istDateStringFromTimestamp)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                    .alignmentGuide(.top) { $0[.top] }
                                            }
                                            
                                            Image(data.starred == 1 ? "star" : "emptystar")
                                                .resizable()
                                                .frame(width: 14, height: 14)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .onTapGesture {
                                                    // Safely toggle starred state
                                                    data.starred = data.starred == 1 ? 0 : 1
                                                    homePostboxViewModel.getStarredEmail(selectedEmail: data.threadId ?? 0)
                                                }
                                        }
                                    }
                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                    .onTapGesture {
                                        PostBoxView = true
                                        homePostboxViewModel.starEmail = emailStarred
                                        emailStarred = data.starred
                                        homePostboxViewModel.selectedID = data.threadId
                                        homePostboxViewModel.passwordHint = data.passwordHint
                                        homePostboxViewModel.isEmailScreen = true
                                    }
                                    .gesture(
                                        LongPressGesture(minimumDuration: 1.0)
                                            .onEnded { _ in
                                                withAnimation {
                                                    print("before clicked homePostboxViewModel.beforeLongPress \(homePostboxViewModel.beforeLongPress)")
                                                    homePostboxViewModel.beforeLongPress = false
                                                    print("after clicked homePostboxViewModel.beforeLongPress \(homePostboxViewModel.beforeLongPress)")
                                                }
                                            }
                                    )
                                    .swipeActions(edge: .leading) {
                                        Button {
                                            print("Deleting row")
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
                                        .tint(Color(red: 255/255, green: 128/255, blue: 128/255))
                                    }
                                }
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
//                List(homePostboxViewModel.postBoxPrintRead){ data in
//                    HStack{
//                        Image(data.image)
//                            .padding([.trailing,.leading],5)
//                            .frame(width: 34,height: 34)
//                            .clipShape(Circle())
//                        VStack(alignment: .leading){
//                            Text(data.title)
//                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
//                            Text(data.subTitle)
//                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
//                        }
//                        Spacer()
//                        Text(data.time)
//                            .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
//                    }
//                }
//                .listStyle(PlainListStyle())
//                .scrollContentBackground(.hidden)
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
                if homePostboxViewModel.ContactsList.count == 0{
                    Text("No Mails Found.")
                        .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                }else{
                    VStack{
                        List($homePostboxViewModel.ContactsList, id: \.id) { $contact in
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
                                print("on tap of hstack before screen")
                                homePostboxViewModel.isChatBoxScreen = true
                                print("on tap of hstack after screen")
                                print(homePostboxViewModel.isChatBoxScreen)
                                homePostboxViewModel.selectID = contact.id
                                print("homePostboxViewModel.selectID \(homePostboxViewModel.selectID)")
                                homePostboxViewModel.roomid = contact.roomId
                                print("homePostboxViewModel.roomid \(homePostboxViewModel.roomid)")
                                
                            }
                            .gesture(
                                LongPressGesture(minimumDuration: 1.0)
                                    .onEnded { _ in
                                        withAnimation {
                                            homePostboxViewModel.beforeLongPress = false
                                            //  selectEmail(data: data)
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
