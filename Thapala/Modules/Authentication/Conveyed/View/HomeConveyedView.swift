//
//  HomeConveyedView.swift
//  Thapala
//
//  Created by Ahex-Guest on 20/06/24.
//

import SwiftUI

struct HomeConveyedView: View {
    @State private var isMenuVisible = false
    @StateObject var homeConveyedViewModel = HomeConveyedViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var themesviewModel = themesViewModel()
    @State private var isSheetVisible = false
    @State private var isStarred: Bool = false // Track starred state
    @State private var isQuickAccessVisible = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    let imageUrl: String
    @Environment(\.presentationMode) var presentationMode
    @State private var iNotificationAppBarView = false
    
    var body: some View {
            GeometryReader{ reader in
                ZStack{
                    themesviewModel.currentTheme.windowBackground
                        .ignoresSafeArea()
                    VStack{
                        if homeConveyedViewModel.beforeLongPress{
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
                                    Text("Conveyed")
                                        .padding(.leading,20)
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                    Spacer()
                                    Button(action: {
                                        print("Before isSearchView \(appBarElementsViewModel.isSearch)")
                                        appBarElementsViewModel.isSearch = true
                                        print("After isSearchView \(appBarElementsViewModel.isSearch)")
                                    }) {
                                        Image("magnifyingglass")
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                            .font(Font.title.weight(.medium))
                                            .padding(.trailing , 16)
                                    }
                                    
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
                                .padding(.top , -reader.size.height * 0.01)
                                
                                
                                
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeConveyedViewModel.isEmailsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            homeConveyedViewModel.getConveyedEmailData()
                                            self.homeConveyedViewModel.selectedOption = .emails
                                            self.homeConveyedViewModel.isEmailsSelected = true
                                            self.homeConveyedViewModel.isPrintSelected = false
                                            self.homeConveyedViewModel.isShipmentsSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("emailG")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack(alignment:.leading){
                                                        Text("Emails")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        //   Text("Obtained")
                                                        //  .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                                                    }
                                                }
                                            }
                                        )
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeConveyedViewModel.isPrintSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homeConveyedViewModel.selectedOption = .print
                                            self.homeConveyedViewModel.isEmailsSelected = false
                                            self.homeConveyedViewModel.isPrintSelected = true
                                            self.homeConveyedViewModel.isShipmentsSelected = false
                                            
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("printIcon")
                                                        .frame(width: 20, height: 20)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    VStack(alignment:.leading){
                                                        Text("Letters")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        //   Text("Letters")
                                                        //   .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeConveyedViewModel.isShipmentsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homeConveyedViewModel.selectedOption = .shipments
                                            self.homeConveyedViewModel.isEmailsSelected = false
                                            self.homeConveyedViewModel.isPrintSelected = false
                                            self.homeConveyedViewModel.isShipmentsSelected = true
                                            
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("chatBox")
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack(alignment:.leading){
                                                        Text("Shipments")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        // Text("Letters")
                                                        // .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
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
                            
                            //                            if let selectedOption = homeConveyedViewModel.selectedOption {
                            //                                switch selectedOption {
                            //                                case .emails:
                            //                                    emailsView
                            //                                case .print:
                            //                                    printView
                            //                                case .shipments:
                            //                                    shipmentsView
                            //                                }
                            //                            }
                            
                        }else{
                            VStack{
                                HStack{
                                    Button {
                                        homeConveyedViewModel.beforeLongPress.toggle()
                                    } label: {
                                        Image(systemName: "arrow.backward")
                                            .foregroundColor(Color.black)
                                    }
                                    
                                    Text("1 Selected")
                                        .font(.custom(.poppinsRegular, size: 16))
                                        .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                                    Spacer()
                                }
                                .padding(.leading,15)
                                
                                HStack{
                                    Image("unchecked")
                                    Image("dropdown")
                                    Text("Select All")
                                        .font(.custom(.poppinsRegular, size: 14))
                                        .foregroundColor(Color(red: 112/255, green: 112/255, blue: 112/255))
                                    Spacer()
                                }
                                .padding(.leading,15)
                                HStack(spacing: 40) {
                                    Image(systemName: "square.and.arrow.down")
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                    Image(systemName: "trash")
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                    Image(systemName: "envelope")
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                    Image(systemName: "clock")
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                    Image(systemName: "folder")
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                    Spacer()
                                }
                                .padding([.leading,.top],15)
                            }
                            .padding(.top,15)
                        }
                        
                        
                        
                        if let selectedOption = homeConveyedViewModel.selectedOption {
                            switch selectedOption {
                            case .emails:
                                VStack{
                                    if homeConveyedViewModel.isLoading {
                                        CustomProgressView()
                                        
                                    }
                                    else if homeConveyedViewModel.conveyedEmailData.isEmpty{
                                        VStack {
                                            Text("No mails found")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 16))
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                        .background(themesviewModel.currentTheme.windowBackground)
                                    }else{
                                        VStack{
                                            List(homeConveyedViewModel.conveyedEmailData) { data in
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
                                                        Text("\(data.firstname ?? "") \(data.lastname ?? "")")
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .font(.custom("Poppins-Medium", size: 16))
                                                        Text(data.subject ?? "No Subject")
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .font(.custom("Poppins-Regular", size: 14))
                                                            .lineLimit(1)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    VStack(alignment: .trailing) {
                                                        if let unixTimestamp = data.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                                            Text(istDateStringFromTimestamp)
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                        }
                                                        
                                                        Image(data.starred == 1 ? "star" : "emptystar")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .frame(width: 14, height: 14)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            .onTapGesture {
                                                                if let threadID = data.threadID,
                                                                   let index = homeConveyedViewModel.conveyedEmailData.firstIndex(where: { $0.threadID == threadID }) {
                                                                    homeConveyedViewModel.conveyedEmailData[index].starred = (homeConveyedViewModel.conveyedEmailData[index].starred == 1) ? 0 : 1
                                                                    homeConveyedViewModel.getStarredEmail(selectedEmail: threadID)
                                                                }
                                                            }
                                                    }
                                                }
                                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                .onTapGesture {
                                                    conveyedView = true
                                                    homeConveyedViewModel.selectedID = data.threadID
                                                    homeConveyedViewModel.passwordHint = data.passwordHint
                                                    print("Before setting isEmailScreen: \(homeConveyedViewModel.isEmailScreen)")
                                                    homeConveyedViewModel.isEmailScreen = true
                                                    print("After setting isEmailScreen: \(homeConveyedViewModel.isEmailScreen)")
                                                    print("conveyedView  \(conveyedView)")
                                                    print("homeConveyedViewModel.selectedID  \(homeConveyedViewModel.selectedID)")
                                                    print("homeConveyedViewModel.passwordHint  \(homeConveyedViewModel.passwordHint)")
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                                        print("Delayed check isEmailScreen: \(homeConveyedViewModel.isEmailScreen)")
                                                    }
                                                }
                                                .gesture(
                                                    LongPressGesture(minimumDuration: 1.0)
                                                        .onEnded { _ in
                                                            withAnimation {
                                                                homeConveyedViewModel.beforeLongPress = false
                                                            }
                                                        }
                                                )
                                                .swipeActions(edge: .leading) {
                                                    Button {
                                                        homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
                                                        homeConveyedViewModel.deleteEmailFromConvey()
                                                    } label: {
                                                        deleteIcon
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    }
                                                    .tint(Color.themeColor)
                                                }
                                                .swipeActions(edge: .trailing) {
                                                    Button {
                                                        isSheetVisible = true
                                                    } label: {
                                                        moreIcon
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    }
                                                    .tint(Color(red: 255/255, green: 128/255, blue: 128/255))
                                                }
                                                
                                            }
                                            .listStyle(PlainListStyle())
                                            .scrollContentBackground(.hidden)
                                        }
                                    }
                                }
                            case .print:
                                ZStack {
                                    Color.clear // Background to help center the image
                                    Image("coming soon") // Replace with the actual image name
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .padding(.bottom , 10)
                                        .scaledToFit()
                                        .frame(width: 160, height: 111.02)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(Color.clear)
                            case .shipments:
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
                        //                    HStack{
                        //                        Spacer()
                        //                        Button(action: {
                        //                            homeConveyedViewModel.isPlusBtn = true
                        //                        }) {
                        //                            Image("plus")
                        //                                .font(Font.title.weight(.medium))
                        //                                .foregroundColor(Color.white)
                        //                        }
                        //                        .padding(.trailing,15)
                        //                    }
                        VStack {
                            //                        Spacer().frame(height: 100)
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
                                                    homeConveyedViewModel.isComposeEmail = true
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
                            .padding(.bottom , 10)
                        
                    }
                    .toast(message: $homeConveyedViewModel.error)
                    .background(themesviewModel.currentTheme.windowBackground)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            print("conveyed view appears")
                            homeConveyedViewModel.getConveyedEmailData()
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
                    
                    
                }
//                    .fullScreenCover(isPresented: $isSearchView) {
//                        SearchView()
//                            .onAppear {
//                                print("Search screen appeared: \(isSearchView)")
//                            }
//                            .toolbar(.hidden) // Optional: Only if you still want to hide the toolbar
//                    }
//                .fullScreenCover(isPresented: $homeConveyedViewModel.isComposeEmail) {
//                    MailComposeView()
//                        .onAppear {
//                            print("MailComposeView appeared with emailId: \(homeConveyedViewModel.selectedID)")
//                        }
//                        .toolbar(.hidden) // Optional: Only if you still want to hide the toolbar
//                }
//                .fullScreenCover(isPresented: $homeConveyedViewModel.isEmailScreen) {
//                    MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, emailId: homeConveyedViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars)
//                        .onAppear {
//                            print("MailFullView appeared with emailId: \(homeConveyedViewModel.selectedID)")
//                        }
//                        .toolbar(.hidden) // Optional: Only if you still want to hide the toolbar
//                }
                .navigationDestination(isPresented: $appBarElementsViewModel.isSearch) {
                    SearchView(appBarElementsViewModel: appBarElementsViewModel)
                        .toolbar(.hidden)
                }
                .navigationDestination(isPresented: $homeConveyedViewModel.isComposeEmail) {
                    MailComposeView().toolbar(.hidden)
                        .onAppear {
                            print("MailFullView appeared with emailId: \(homeConveyedViewModel.selectedID)")
                        }
                }


                .navigationDestination(isPresented: $homeConveyedViewModel.isEmailScreen) {
                    MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: homeConveyedViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
                }
                //
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
                
                
                
            }
        

        
    }
    
//    var emailsView: some View {
//        VStack{
//            if homeConveyedViewModel.isLoading {
//                CustomProgressView()
//                
//            }
//            else if homeConveyedViewModel.conveyedEmailData.isEmpty{
//                VStack {
//                    Text("No mails found")
//                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                        .font(.custom(.poppinsRegular, size: 16))
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//                .background(themesviewModel.currentTheme.windowBackground)
//            }else{
//                VStack{
//                    List(homeConveyedViewModel.conveyedEmailData) { data in
//                        HStack {
//                            let image = data.senderProfile ?? "person"
//                            AsyncImage(url: URL(string: image)) { phase in
//                                switch phase {
//                                case .empty:
//                                    ProgressView()
//                                        .foregroundColor(.white)
//                                case .success(let image):
//                                    image
//                                        .resizable()
//                                        .frame(width: 34, height: 34)
//                                        .padding([.trailing, .leading], 5)
//                                        .aspectRatio(contentMode: .fit)
//                                        .clipShape(Circle())
//                                case .failure:
//                                    Image("person")
//                                        .resizable()
//                                        .frame(width: 34, height: 34)
//                                        .foregroundColor(.blue)
//                                @unknown default:
//                                    EmptyView()
//                                }
//                            }
//                            
//                            VStack(alignment: .leading) {
//                                Text("\(data.firstname ?? "") \(data.lastname ?? "")")
//                                    .foregroundColor(themesviewModel.currentTheme.textColor)
//                                    .font(.custom("Poppins-Medium", size: 16))
//                                Text(data.subject ?? "No Subject")
//                                    .foregroundColor(themesviewModel.currentTheme.textColor)
//                                    .font(.custom("Poppins-Regular", size: 14))
//                                    .lineLimit(1)
//                            }
//                            
//                            Spacer()
//                            
//                            VStack(alignment: .trailing) {
//                                if let unixTimestamp = data.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
//                                    Text(istDateStringFromTimestamp)
//                                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
//                                }
//                                
//                                Image(data.starred == 1 ? "star" : "emptystar")
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .frame(width: 14, height: 14)
//                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
//                                    .onTapGesture {
//                                        if let threadID = data.threadID,
//                                           let index = homeConveyedViewModel.conveyedEmailData.firstIndex(where: { $0.threadID == threadID }) {
//                                            homeConveyedViewModel.conveyedEmailData[index].starred = (homeConveyedViewModel.conveyedEmailData[index].starred == 1) ? 0 : 1
//                                            homeConveyedViewModel.getStarredEmail(selectedEmail: threadID)
//                                        }
//                                    }
//                            }
//                        }
//                        .listRowBackground(themesviewModel.currentTheme.windowBackground)
//                        .onTapGesture {
//                            conveyedView = true
//                            homeConveyedViewModel.selectedID = data.threadID
//                            homeConveyedViewModel.passwordHint = data.passwordHint
//                            print("Before setting isEmailScreen: \(homeConveyedViewModel.isEmailScreen)")
//                            homeConveyedViewModel.isEmailScreen = true
//                            print("After setting isEmailScreen: \(homeConveyedViewModel.isEmailScreen)")
//                            print("conveyedView  \(conveyedView)")
//                            print("homeConveyedViewModel.selectedID  \(homeConveyedViewModel.selectedID)")
//                            print("homeConveyedViewModel.passwordHint  \(homeConveyedViewModel.passwordHint)")
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                print("Delayed check isEmailScreen: \(homeConveyedViewModel.isEmailScreen)")
//                            }
//                        }
//                        .gesture(
//                            LongPressGesture(minimumDuration: 1.0)
//                                .onEnded { _ in
//                                    withAnimation {
//                                        homeConveyedViewModel.beforeLongPress = false
//                                    }
//                                }
//                        )
//                        .swipeActions(edge: .leading) {
//                            Button {
//                                homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
//                                homeConveyedViewModel.deleteEmailFromConvey()
//                            } label: {
//                                deleteIcon
//                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
//                            }
//                            .tint(Color.themeColor)
//                        }
//                        .swipeActions(edge: .trailing) {
//                            Button {
//                                isSheetVisible = true
//                            } label: {
//                                moreIcon
//                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
//                            }
//                            .tint(Color(red: 255/255, green: 128/255, blue: 128/255))
//                        }
//                        
//                    }
//                    .listStyle(PlainListStyle())
//                    .scrollContentBackground(.hidden)
//                }
//            }
//        }
//    }

//    var printView:some View{
////                List(homeConveyedViewModel.postBoxPrintRead){ data in
////                    HStack{
////                        Image(data.image)
////                            .padding([.trailing,.leading],5)
////                            .frame(width: 34,height: 34)
////                            .clipShape(Circle())
////                        VStack(alignment: .leading){
////                            Text(data.title)
////                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
////                            Text(data.subTitle)
////                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
////                        }
////                        Spacer()
////                        Text(data.time)
////                            .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
////                    }
////                    .gesture(
////                        LongPressGesture(minimumDuration: 1.0)
////                            .onEnded { _ in
////                                withAnimation {
////                                    homeConveyedViewModel.beforeLongPress = false
////                                  //  selectEmail(data: data)
////                                }
////                            }
////                    )
////                    .swipeActions(edge: .leading) {
////                        Button {
////                            print("Deleting row")
////                         //   homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
////                            homeConveyedViewModel.deleteEmailFromConvey()
////                        } label: {
////                            deleteIcon
////                                .foregroundStyle(.white)
////                        }
////                        .tint(Color.themeColor)
////                    }
////                    .swipeActions(edge: .trailing) {
////                        Button {
////                            isSheetVisible = true
////                        } label: {
////                            moreIcon
////                                .foregroundStyle(.white)
////                        }
////                        .tint(Color(red:255/255, green: 128/255, blue: 128/255))
////                    }
////                    .onTapGesture {
////                        homeConveyedViewModel.selectedID = homeConveyedViewModel.conveyedEmailData.first?.threadID ?? 0
////                        homeConveyedViewModel.passwordHint = homeConveyedViewModel.conveyedEmailData.first?.passwordHint
////                        homeConveyedViewModel.isEmailScreen = true
////                    }
////
////                }
////                .listStyle(PlainListStyle())
////                .scrollContentBackground(.hidden)
//
//        ZStack {
//            Color.clear // Background to help center the image
//            Image("coming soon") // Replace with the actual image name
//                .renderingMode(.template)
//                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                .padding(.bottom , 10)
//                .scaledToFit()
//                .frame(width: 160, height: 111.02)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.clear)
//        
//    }
    
//    var shipmentsView:some View{
//        ZStack {
//            Color.clear // Background to help center the image
//            Image("coming soon") // Replace with the actual image name
//                .resizable()
//                .renderingMode(.template)
//                .foregroundColor(themesviewModel.currentTheme.iconColor)
//                .scaledToFit()
//                .frame(width: 160, height: 111.02)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.clear)
//    }
    private func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
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
