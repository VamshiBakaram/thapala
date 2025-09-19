//
//  ConsoleView.swift
//  Thapala
//
//  Created by Ahex-Guest on 08/10/24.
//
import SwiftUI

struct ConsoleView: View {
    @StateObject var consoleViewModel = ConsoleViewModel()
    @StateObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @StateObject var consoleNavigatorViewModel = ConsoleNavigatiorViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var iNotificationAppBarView = false
    @StateObject var themesviewModel = ThemesViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isQuickAccessVisible = false
    @State private var expandedIndex: Int? = nil
    @State private var selectedLanguage = "English"
    @State private var timePeriod = 36
    @State private var isMenuVisible = false
    // Set initial default values
    @State private var awaitingPageSize: Int = 10
    @State private var postBoxPageSize: Int = 10
    @State private var conveyedPageSize: Int = 10
    @State private var isChatEnabled = 0
    @State private var isChatBubbleEnabled = 0
    @State private var selectedTheme: String = "Light"
    @State private var isNavigating = false
    var selectedID: Int
    @State private var consolelistItems: [ConsoleListItem] = [
        ConsoleListItem(title: "Language and Time"),
        ConsoleListItem(title: "Mail"),
        ConsoleListItem(title: "Chat"),
        ConsoleListItem(title: "Appearance")
    ]

    var body: some View {
        GeometryReader { reader in
            ZStack {
                VStack {
                    VStack {
                        // Back Button & Title
                        HStack{
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
                                
                                
                                    Text("Navigator")
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                                        .padding(.leading,0)
                            
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
                        .padding(.top, -reader.size.height * 0.02)
                        .frame(height: reader.size.height * 0.09)
                        .background(themesviewModel.currentTheme.colorPrimary)
                        HStack {
                            
                            Text("Console")
                                .font(.custom(.poppinsMedium, size: 20))
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.leading, 18)
                            Spacer()
                        }
                        
                        // Go to Console Button
                        Button(action: {
                            self.homeNavigatorViewModel.selectedOption = .controlPanel
                            isNavigating = true
                        }, label: {
                            Text("Go to console")
                                .font(.custom(.poppinsMedium, size: 18))
                                .fontWeight(.bold)
                                .padding(.all, 10)
                                .frame(maxWidth: .infinity)
                                .background(themesviewModel.currentTheme.tabBackground)
                                .cornerRadius(12.0)
                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                .padding([.leading, .trailing], 20)
                            
                            
                        })
                        
                        // List of Console Items (No Spacing)
                        List {
                            ForEach(consolelistItems.indices, id: \.self) { index in
                                VStack(spacing: 0) {  // Remove spacing
                                    HStack {
                                        Text(consolelistItems[index].title)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.system(size: 16, weight: .medium))
                                        Spacer()
                                        Image(systemName: expandedIndex == index ? "chevron.down" : "chevron.right")
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    }
                                    .padding()
                                    .background(themesviewModel.currentTheme.bottomSheetBG)
                                    .onTapGesture {
                                        expandedIndex = (expandedIndex == index) ? nil : index
                                    }
                                    // Expanded View
                                    if expandedIndex == index {
                                        getExpandedContent(for: index)
                                            .padding()
                                            .background(themesviewModel.currentTheme.bottomSheetBG)
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 1)
                                        .stroke(themesviewModel.currentTheme.attachmentBGColor, lineWidth: 1)
                                )
                                .background(themesviewModel.currentTheme.windowBackground)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                        }
                        .padding(.horizontal, 16)
                        .listStyle(PlainListStyle())
                        .background(themesviewModel.currentTheme.windowBackground)
                        
                        
                        TabViewNavigator()
                            .frame(height: 40)
                            .padding(.bottom , 10)
                    }
                }
                .toast(message: $consoleViewModel.error)
                .toast(message: $consoleNavigatorViewModel.error)
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear {
                    // First, fetch settings data
                    if consoleViewModel.userSettings.isEmpty {
                        consoleViewModel.GetUserSettings()
                    }
                }
                .onChange(of: consoleViewModel.userSettings) { newSettings in
                    // When user settings are updated, refresh the page size values
                    if let settings = newSettings.first {
                        awaitingPageSize = settings.awaitingPageSize
                        postBoxPageSize = settings.postboxPageSize
                        conveyedPageSize = settings.conveyedPageSize
                        timePeriod = settings.hrsToMoveEmail
                        isChatEnabled = settings.chat
                        isChatBubbleEnabled = settings.openChatBubbles
                    }
                }

                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
                // Quick Access View
                if isQuickAccessVisible {
                    Color.white.opacity(0.8)
                        .ignoresSafeArea()
                        .blur(radius: 10)
                    
                    QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
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
            .zIndex(0)
            .navigationBarBackButtonHidden(true)
            
            .fullScreenCover(isPresented: $isNavigating) {
                HomeNavigatorView(imageUrl: "")
                .toolbar(.hidden)
            }
            
            .fullScreenCover(isPresented: $consoleViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
            .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
                SearchView(appBarElementsViewModel: appBarElementsViewModel)
                    .toolbar(.hidden)
            }
        }

    }
    
    @ViewBuilder
    private func getExpandedContent(for index: Int) -> some View {
        switch index {
        case 0: // Language and Time
            VStack(alignment: .leading, spacing: 16) {
                Menu {
                    Button("English") { selectedLanguage = "English" }
                } label: {
                    HStack {
                        Text(selectedLanguage)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themesviewModel.currentTheme.allGray, lineWidth: 1)
                    )
                }
            }
            
        case 1: // Mail
            VStack(alignment: .leading, spacing: 16) {
                Text("Time Period (awaiting area to the postbox)")
                    .font(.system(size: 14))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                
                Menu {
                    Button("24 Hours") {
                        timePeriod = 24
                        consoleViewModel.MailTimePeriod(timePeriod: timePeriod)
                    }
                    Button("36 Hours") {
                        timePeriod = 36
                        consoleViewModel.MailTimePeriod(timePeriod: timePeriod)
                    }
                    Button("48 Hours") {
                        timePeriod = 48
                        consoleViewModel.MailTimePeriod(timePeriod: timePeriod)
                    }
                } label: {
                    HStack {
                        Text("\(timePeriod)")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themesviewModel.currentTheme.allGray, lineWidth: 1)
                    )
                }
                
                Text("Maximum Page List Size (Awaiting)")
                    .font(.system(size: 14))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                
                Menu {
                    Button("5") {
                        awaitingPageSize = 5
                        consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
                    }
                    Button("10") {
                        awaitingPageSize = 10
                        consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
                    }
                    Button("15") {
                        awaitingPageSize = 15
                        consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
                    }
                } label: {
                    HStack {
                        Text("\(awaitingPageSize)")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themesviewModel.currentTheme.allGray, lineWidth: 1)
                    )
                }
                
                Text("Maximum Page List Size (Post-box)")
                    .font(.system(size: 14))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                
                Menu {
                    Button("5") {
                        postBoxPageSize = 5
                        consoleViewModel.PostBoxMaximumPageSize(pageSize: postBoxPageSize)
                    }
                    Button("10") {
                        postBoxPageSize = 10
                        consoleViewModel.PostBoxMaximumPageSize(pageSize: postBoxPageSize)
                    }
                    Button("15") {
                        postBoxPageSize = 15
                        consoleViewModel.PostBoxMaximumPageSize(pageSize: postBoxPageSize)
                    }
                } label: {
                    HStack {
                        Text("\(postBoxPageSize)")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themesviewModel.currentTheme.allGray, lineWidth: 1)
                    )
                }
                
                Text("Maximum Page Size (Conveyed)")
                    .font(.system(size: 14))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                
                Menu {
                    Button("5") {
                        conveyedPageSize = 5
                        consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
                    }
                    Button("10") {
                        conveyedPageSize = 10
                        consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
                    }
                    Button("15") {
                        conveyedPageSize = 15
                        consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
                    }
                } label: {
                    HStack {
                        Text("\(conveyedPageSize)")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.windowBackground)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themesviewModel.currentTheme.allGray, lineWidth: 1)
                    )
                }
            }
            
            
        case 2: // Chat
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Chat:")
                        .font(.system(size: 14))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    
                    Spacer()
                    
                    Toggle("", isOn: Binding(
                        get: { isChatEnabled != 0 },
                        set: { newValue in
                            isChatEnabled = newValue ? 1 : 0
                            consoleViewModel.SaveSettingschat(chats: newValue) // `newValue` is already `true/false`
                        }
                    ))
                    .tint(Color.blue)
                }


                
                HStack {
                    Text("Chat Bubble:")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.system(size: 14))
                    Spacer()
                        Toggle("", isOn: Binding(
                            get: { isChatBubbleEnabled != 0 },
                            set: { newValue in
                                isChatBubbleEnabled = newValue ? 1 : 0
                                consoleViewModel.SaveSettingsChatBubble(chatBubble: newValue)
                            }
                        ))
                        .tint(Color.blue)
                    
                }
            }
            
        case 3: // Appearance
            VStack(spacing: 24) {
                // First row of theme options
                HStack(spacing: 16) {
                    // Light theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("light")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "default" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "default" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "default"
                            sessionManager.selectedTheme = "default"
                            consoleNavigatorViewModel.Themchange(themes: "default", accentcolour: "white")
                        }
                        
                        Text("Default")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("warm Inviting")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "light" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "light" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "light"
                            sessionManager.selectedTheme = "light"
                            consoleNavigatorViewModel.Themchange(themes: "light", accentcolour: "white")
                        }
                        
                        Text("Light")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)

                    
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("Tech Savvy")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "dark" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "dark" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "dark"
                            themesviewModel.selectedTheme = "dark"
                            sessionManager.selectedTheme = "dark"
                            consoleNavigatorViewModel.Themchange(themes: "dark", accentcolour: "white")
                        }
                        
                        Text("Dark")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                }
                HStack(spacing: 16) {
                    
                    // Classic Elegance theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("classic Elegance")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "elegance" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "elegance" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "elegance"
                            themesviewModel.selectedTheme = "elegance"
                            sessionManager.selectedTheme = "elegance"
                            consoleNavigatorViewModel.Themchange(themes: "elegance", accentcolour: "white")
                        }
                        
                        Text("Elegance")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Modern Minimalism theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("modern Minimalism")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "minimalism" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "minimalism" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "minimalism"
                            themesviewModel.selectedTheme = "minimalism"
                            sessionManager.selectedTheme = "minimalism"
                            consoleNavigatorViewModel.Themchange(themes: "minimalism", accentcolour: "white")
                        }
                        
                        Text("Modern Minimalism")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("warm Inviting")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "inviting" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "inviting" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "inviting"
                            themesviewModel.selectedTheme = "inviting"
                            sessionManager.selectedTheme = "inviting"
                            consoleNavigatorViewModel.Themchange(themes: "inviting", accentcolour: "white")
                        }
                        
                        Text("Warm Inviting")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Second row of theme options
                HStack(spacing: 16) {
                    // Tech Savvy theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("Tech Savvy")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "tech" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "tech" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "tech"
                            themesviewModel.selectedTheme = "tech"
                            sessionManager.selectedTheme = "tech"
                            consoleNavigatorViewModel.Themchange(themes: "tech", accentcolour: "white")
                        }
                        
                        Text("Tech Savvy")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Elegant Dark Mode theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("Elegant Dark Mode")
                                .resizable()
                                .foregroundStyle(themesviewModel.currentTheme.iconColor)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "elegent" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "elegent" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = "elegent"
                            themesviewModel.selectedTheme = "elegent"
                            sessionManager.selectedTheme = "elegent"
                            consoleNavigatorViewModel.Themchange(themes: "elegent", accentcolour: "white")
                        }
                        
                        Text("Elegant Dark Mode")
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("")
                                .resizable()
                            
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "Mode" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if sessionManager.selectedTheme == "Mode" {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12, weight: .bold))
                                    )
                                    .offset(x: 8, y: -8)
                            }
                        }
                        .onTapGesture {
                            selectedTheme = " Mode"
                        }
                        
                        Text("")
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(themesviewModel.currentTheme.windowBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(themesviewModel.currentTheme.colorControlNormal.opacity(0.3), lineWidth: 0.5)
                    )
            )
            .padding(.horizontal, 10)
            
        default:
            Text("No content available")
        }
    }
}

// Console List Item Struct
struct ConsoleListItem: Identifiable {
    let id = UUID()
    let title: String
    var isExpanded: Bool = false
}
