//
//  ConsoleView.swift
//  Thapala
//
//  Created by Ahex-Guest on 08/10/24.
//
import SwiftUI

struct ConsoleView: View {
    @ObservedObject var consoleViewModel = ConsoleViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
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
                        HStack {
                            Button {
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            .foregroundColor(.black)
                            .padding(.leading, 20)
                            
                            Text("Console")
                                .font(.custom(.poppinsMedium, size: 16))
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.leading, 16)
                            Spacer()
                        }
                        
                        // Go to Console Button
                        Button(action: {
                            print("before cosole click")
                            isNavigating = true
                            print("after cosole click")
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
                                .padding(.horizontal, 16)
                                .background(themesviewModel.currentTheme.windowBackground)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                //                            .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(themesviewModel.currentTheme.windowBackground)
                        
                        // New Email Button
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
                                                    consoleViewModel.isComposeEmail = true
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
                    }
                }
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear {
                    // First, fetch settings data
                    if consoleViewModel.UserSettings.isEmpty {
                        consoleViewModel.GetUserSettings()
                        print("Fetching user settings...")
                    }
                }
                .onChange(of: consoleViewModel.UserSettings) { newSettings in
                    // When user settings are updated, refresh the page size values
                    if let settings = newSettings.first {
                        awaitingPageSize = settings.awaitingPageSize
                        postBoxPageSize = settings.postboxPageSize
                        conveyedPageSize = settings.conveyedPageSize
                        timePeriod = settings.hrsToMoveEmail
                        isChatEnabled = settings.chat
                        isChatBubbleEnabled = settings.openChatBubbles
                        print("Settings updated - awaiting: \(awaitingPageSize), postBox: \(postBoxPageSize), conveyed: \(conveyedPageSize)")
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
            }
            .zIndex(0)
            .navigationDestination(isPresented: $consoleViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
            NavigationLink(destination: HomeNavigatorView(imageUrl: ""), isActive: $isNavigating) {
                EmptyView()
            }
            .hidden()
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
                            .stroke(themesviewModel.currentTheme.AllGray, lineWidth: 1)
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
                            .stroke(themesviewModel.currentTheme.AllGray, lineWidth: 1)
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
                            .stroke(themesviewModel.currentTheme.AllGray, lineWidth: 1)
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
                            .stroke(themesviewModel.currentTheme.AllGray, lineWidth: 1)
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
                            .stroke(themesviewModel.currentTheme.AllGray, lineWidth: 1)
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
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "Light" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if selectedTheme == "Light" {
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
                            selectedTheme = "Light"
                            consoleViewModel.Themchange(themes: "light", accentcolour: "white")
                        }
                        
                        Text("Light")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Classic Elegance theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("classic Elegance")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "Classic Elegance" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if selectedTheme == "Classic Elegance" {
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
                            selectedTheme = "Classic Elegance"
                            consoleViewModel.Themchange(themes: "elegance", accentcolour: "white")
                        }
                        
                        Text("Classic Elegance")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Modern Minimalism theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("modern Minimalism")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "Modern Minimalism" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if selectedTheme == "Modern Minimalism" {
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
                            selectedTheme = "Modern Minimalism"
                            consoleViewModel.Themchange(themes: "minimalism", accentcolour: "white")
                        }
                        
                        Text("Modern Minimalism")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Second row of theme options
                HStack(spacing: 16) {
                    // Warm Inviting theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("warm Inviting")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "Warm Inviting" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if selectedTheme == "Warm Inviting" {
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
                            selectedTheme = "Warm Inviting"
                            consoleViewModel.Themchange(themes: "inviting", accentcolour: "white")
                        }
                        
                        Text("Warm Inviting")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Tech Savvy theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("Tech Savvy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "Tech Savvy" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if selectedTheme == "Tech Savvy" {
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
                            selectedTheme = "Tech Savvy"
                            consoleViewModel.Themchange(themes: "tech", accentcolour: "white")
                        }
                        
                        Text("Tech Savvy")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Elegant Dark Mode theme
                    VStack(spacing: 8) {
                        ZStack(alignment: .bottomLeading) {
                            Image("Elegant Dark Mode")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 110)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedTheme == "Elegant Dark Mode" ? Color.blue : Color.clear, lineWidth: 2)
                                )
                            
                            // Only show checkmark if this theme is selected
                            if selectedTheme == "Elegant Dark Mode" {
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
                            selectedTheme = "Elegant Dark Mode"
                            consoleViewModel.Themchange(themes: "dark", accentcolour: "white")
                        }
                        
                        Text("Elegant Dark Mode")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.system(size: 12))
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 16)
            
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
