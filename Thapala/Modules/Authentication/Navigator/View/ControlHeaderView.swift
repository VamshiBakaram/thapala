//
//  ConsoleView.swift
//  Thapala
//
//  Created by Ahex-Guest on 04/04/25.
//

import SwiftUI

struct ControlHeaderView: View {
    @ObservedObject var ConsoleviewModel = consoleviewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var selectedTab = 0
    @State private var expandedIndex: Int? = nil
    let tabs = ["General", "Security", "Notifications", "Appearance"]
    let icons = ["globe", "calendar", "envelope", "checklist", "bubble.left", "archivebox", "trash", "signature"]
    let titles = ["Language", "Date and Time", "Mail", "Planner", "Chat", "Storage", "Trash", "Signature"]
    // Settings states
    @State private var selectedLanguage = "English"
    @State private var DateFormat = "MMM-dd-yyyy"
    @State private var TimeFormat = "12 Hours"
    @State private var TimeZone = "Pacific/Johnston"
    @State private var timePeriod = 36
    @State private var awaitingPageSize: Int = 10
    @State private var postBoxPageSize: Int = 10
    @State private var conveyedPageSize: Int = 10
    @State private var selectedFontFamily: String = "IRANSans"
    @State private var selectedFontSize: Int = 8
    @State private var taskType: String = "Upcoming"
    @State private var doit: Int = 10
    @State private var dairy: Int = 10
    @State private var note: Int = 10
    @State private var isChatEnabled = 0
    @State private var isChatBubbleEnabled = 0
    @State private var isChatBackGround = 0
    @State private var trash: Int = 10
    @State private var selectedTheme: String = ""
    @State private var selectToggles: [Bool] = [true, true, true] // one for each toggle
    @State private var isContactsDialogVisible = false
    @State private var isPasswordDialogVisible = false
    @State private var isPinDialogVisible = false
    @State private var isSelect = false
    @State private var issecurityQuestions: String = ""
    @State private var isnewPasswordVisible = false
    @State private var isconfirmPasswordVisible = false
    @State private var AllNotifications = false
    @State private var mail = false
    @State private var chatBox = false
    @State private var planner = false
    @State private var NewEmail = false
    @State private var Scheduledsent = false
    @State private var NewMessage = false
    @State private var AddOrRemove = false
    @State private var ChatDetails = false
    @State private var ConnectionExpired = false
    @State private var Datebook = false
    @State private var Diary = false
    @State private var DoIt = false
    @State private var Note = false
    @State private var Reminder = false
    var body: some View {
        GeometryReader{ reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
//                    .ignoresSafeArea() // Makes sure it fills the entire screen
                ScrollView(.vertical) {
                    VStack(spacing: 16) {
                        // Top Tab Bar
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<tabs.count, id: \.self) { index in
                                    Text(tabs[index])
                                        .fontWeight(selectedTab == index ? .bold : .regular)
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 16)
                                        .background(
                                            selectedTab == index ?
                                            Color.white.opacity(0.8) :
                                                Color.clear
                                        )
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            selectedTab = index
                                            // Reset expanded index when changing tabs
                                            expandedIndex = nil
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            .background(themesviewModel.currentTheme.tabBackground) // Blue background
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 16)

                        // Settings List - Show different items based on selected tab
                        if (selectedTab == 0) || (selectedTab == 1) || (selectedTab == 2) {
                            VStack(spacing: 0) {
                                ForEach(getTabItems().indices, id: \.self) { index in
                                    let itemTitle = getTabItems()[index]
                                    let itemIcon = getTabIcons()[index]
                                    VStack(spacing: 0) {
                                        HStack {
                                            
                                            if selectedTab == 1{
                                                Image(itemIcon)
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .frame(width: 24, height: 24)
                                            }
                                            
                                            else if selectedTab == 2 {
                                                Image(systemName: expandedIndex == index ? "chevron.down" : "chevron.right")
                                                    .foregroundColor(themesviewModel.currentTheme.colorControlNormal)
                                                    .onTapGesture {
                                                        expandedIndex = (expandedIndex == index) ? nil : index
                                                    }
                                            }
                                            
                                            else {
                                                Image(systemName: itemIcon)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .frame(width: 24, height: 24)
                                            }
                                            
                                            Text(itemTitle)
                                                .font(.system(size: 18))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            
                                            Spacer()
                                            if selectedTab == 2 {
                                                if index == 0 {
                                                    Toggle("", isOn: $mail)
                                                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                                                        .padding(8)
                                                        .cornerRadius(8)
                                                        .onChange(of: mail) { newValue in
                                                            if newValue {
                                                                ConsoleviewModel.updateDiaryData(Allnotifications: newValue, newemails: newValue, ScheduleSent: newValue, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                                                mail = true
                                                                NewEmail = true
                                                                Scheduledsent = true
                                                            }
                                                            else{
                                                                ConsoleviewModel.updateDiaryData(Allnotifications: false, newemails: false, ScheduleSent: false, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                                                mail = false
                                                                NewEmail = false
                                                                Scheduledsent = false
                                                            }
                                                        }
                                                }
                                                if index == 1 {
                                                    Toggle("", isOn: $chatBox)
                                                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                                                        .padding(8)
                                                        .cornerRadius(8)
                                                        .onChange(of: chatBox) { newValue in
                                                            if newValue {
                                                                ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: newValue, AddOrremove: newValue, chatDetails: newValue, Connectionexpired: newValue, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                                                chatBox = true
                                                                NewMessage = true
                                                                AddOrRemove = true
                                                                ChatDetails = true
                                                                ConnectionExpired = true
                                                            }
                                                            else{
                                                                ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: false, AddOrremove: false, chatDetails: false, Connectionexpired: false, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                                                chatBox = false
                                                                NewMessage = false
                                                                AddOrRemove = false
                                                                ChatDetails = false
                                                                ConnectionExpired = false
                                                            }
                                                        }
                                                }
                                                if index == 2 {
                                                    Toggle("", isOn: $planner)
                                                        .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                                                        .padding(8)
                                                        .cornerRadius(8)
                                                        .onChange(of: planner) { newValue in
                                                            if newValue {
                                                                ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: newValue, Diary: newValue, DoIt: newValue, Note: newValue, Reminder: newValue)
                                                                planner = true
                                                                Datebook = true
                                                                Diary = true
                                                                DoIt = true
                                                                Note = true
                                                                Reminder = true
                                                            }
                                                            else{
                                                                ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: false, Diary: false, DoIt: false, Note: false, Reminder: false)
                                                                planner = false
                                                                Datebook = false
                                                                Diary = false
                                                                DoIt = false
                                                                Note = false
                                                                Reminder = false
                                                            }
                                                        }
                                                }
                                            }
                                            
                                            else {
                                                Image(systemName: expandedIndex == index ? "chevron.down" : "chevron.right")
                                                    .foregroundColor(themesviewModel.currentTheme.colorControlNormal)
                                                    .onTapGesture {
                                                        expandedIndex = (expandedIndex == index) ? nil : index
                                                    }
                                            }
                                        }
                                        .padding()
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        
                                        if expandedIndex == index {
                                            getExpandedContent(for: index)
                                                .padding()
                                                .background(themesviewModel.currentTheme.windowBackground)
                                        }
                                        
                                        Divider()
                                            .padding(.leading, 56)
                                    }
                                }
                            }
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(themesviewModel.currentTheme.colorControlNormal)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)
                                            .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 30)
                        }
                        else {
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
                                            if selectedTheme == "default" {
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
                                            sessionManager.SelectedTheme = "default"
                                            ConsoleviewModel.Themchange(themes: "default", accentcolour: "white")
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
                                            if selectedTheme == "light" {
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
                                            themesviewModel.selectedTheme = "light"
                                            sessionManager.SelectedTheme = "light"
                                            ConsoleviewModel.Themchange(themes: "light", accentcolour: "white")
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
                                            if selectedTheme == "dark" {
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
                                            sessionManager.SelectedTheme = "dark"
                                            ConsoleviewModel.Themchange(themes: "dark", accentcolour: "white")
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
                                            if selectedTheme == "elegance" {
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
                                            sessionManager.SelectedTheme = "elegance"
                                            ConsoleviewModel.Themchange(themes: "elegance", accentcolour: "white")
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
                                            if selectedTheme == "minimalism" {
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
                                            sessionManager.SelectedTheme = "minimalism"
                                            ConsoleviewModel.Themchange(themes: "minimalism", accentcolour: "white")
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
                                            if selectedTheme == "inviting" {
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
                                            sessionManager.SelectedTheme = "inviting"
                                            ConsoleviewModel.Themchange(themes: "inviting", accentcolour: "white")
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
                                            if selectedTheme == "tech" {
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
                                            sessionManager.SelectedTheme = "tech"
                                            ConsoleviewModel.Themchange(themes: "tech", accentcolour: "white")
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
                                            if selectedTheme == "elegent" {
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
                                            sessionManager.SelectedTheme = "elegent"
                                            ConsoleviewModel.Themchange(themes: "elegent", accentcolour: "white")
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
                                            if selectedTheme == "Mode" {
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
                                            //                                        ConsoleviewModel.Themchange(themes: "dark", accentcolour: "white")
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
                                            .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 30)
                        }
                        
                    }
                    Spacer()
                        .edgesIgnoringSafeArea(.top)
                        .navigationBarBackButtonHidden(true)
                        .onAppear {
                            // First, fetch settings data
                            if ConsoleviewModel.GetUserSettings.isEmpty {
                                ConsoleviewModel.getUserSettings()
                                ConsoleviewModel.getUserSecurityQuestions()
                                ConsoleviewModel.getAllAlertNotifications()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                if let settings = ConsoleviewModel.GetUserSettings.first {
                                    selectedLanguage = settings.defaultLanguage
                                    DateFormat = settings.dateFormat
                                    TimeFormat = settings.timeFormat
                                    TimeZone = settings.timeZone
                                    selectedFontFamily = settings.mailFontFamily
                                    selectedFontSize = Int(settings.mailFontSize) ?? 0
                                    taskType = settings.taskList
                                    doit = settings.doitPageSize
                                    dairy = settings.dairyPageSize
                                    note = settings.notePageSize
                                    awaitingPageSize = settings.awaitingPageSize
                                    postBoxPageSize = settings.postboxPageSize
                                    conveyedPageSize = settings.conveyedPageSize
                                    timePeriod = settings.hrsToMoveEmail
                                    isChatEnabled = settings.chat
                                    isChatBubbleEnabled = settings.openChatBubbles
                                    isChatBackGround = settings.chatBackGround
                                    trash = settings.trashRecovery
                                }
                            }
                        }
                }
                .onChange(of: selectedTab) { newValue in
                    if newValue == 1 {
                        ConsoleviewModel.getUserSecurityQuestions()

                    }
                }
                .onChange(of: selectedTab) { newValue in
                    if newValue == 2 {
                        ConsoleviewModel.getAllAlertNotifications()
                        ConsoleviewModel.GetAllNotificationAlerts.forEach { alert in
                            AllNotifications = alert.allNotifications
                            NewEmail = alert.newEmail
                            Scheduledsent = alert.scheduledSent
                            NewMessage = alert.newMessage
                            AddOrRemove = alert.addOrRemove
                            ChatDetails = alert.chatDetails
                            ConnectionExpired = alert.connectionExpired
                            Datebook = alert.datebook
                            Diary = alert.diary
                            DoIt = alert.doIt
                            Note = alert.note
                            Reminder = alert.reminder
                            if NewEmail || Scheduledsent == true {
                                if NewEmail || Scheduledsent == true {
                                    mail = true
                                }
                                else {
                                    mail = false
                                }
                            }
                            if NewMessage || AddOrRemove || ChatDetails || ConnectionExpired == true {
                                if NewMessage || AddOrRemove || ChatDetails || ConnectionExpired == true {
                                    chatBox = true
                                }
                                else {
                                    chatBox = false
                                }
                            }
                            if Datebook || Diary || DoIt || Note || Reminder == true {
                                if Datebook || Diary || DoIt || Note || Reminder == true {
                                    planner = true
                                }
                                else {
                                    planner = false
                                }
                            }
                        }
                    }
                }




                
                if isContactsDialogVisible {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isContactsDialogVisible = false
                                    ConsoleviewModel.isContactsDialogVisible = false
                                }
                            }
                        
                        VStack(spacing: 16) {
                            // Title and Close Button
                            HStack {
                                Text("Reset Your Phone Number")
                                    .font(.headline)
                                    .padding(.leading, 16)
                                Spacer()
                                Image("cross")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(8)
                                    .onTapGesture {
                                        withAnimation {
                                            isContactsDialogVisible = false
                                            ConsoleviewModel.isContactsDialogVisible = false
                                        }
                                    }
                            }
                            
                            HStack {
                                Image("bell")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .background(Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                    .padding(.leading, 10)
                                FloatingTextField(text: $ConsoleviewModel.contactNumber, placeHolder: "Phone Number*", allowedCharacter: .defaultType)
                                    .padding(.horizontal, 10)
                            }
                            
                            // Create Button
                            HStack {
                                Spacer()
                                Button(action: {
                                }) {
                                    Text("Submit")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                }
                if isPasswordDialogVisible {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isPasswordDialogVisible = false
                                }
                            }
                        
                        VStack(spacing: 16) {
                            // Title and Close Button
                            HStack {
                                Text("Change Your Password")
                                    .font(.headline)
                                    .padding(.leading, 16)
                                Spacer()
                                Image("cross")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(8)
                                    .onTapGesture {
                                        withAnimation {
                                            isPasswordDialogVisible = false
                                        }
                                    }
                            }
                            
                            FloatingTextField(text: $ConsoleviewModel.currentPassword, placeHolder: "Enter Current Password", allowedCharacter: .defaultType)
                                .padding(.horizontal, 10)
                            FloatingTextField(text: $ConsoleviewModel.NewPassword, placeHolder: "Enter New Password", allowedCharacter: .defaultType)
                                .padding(.horizontal, 10)
                            
                            // Create Button
                            HStack {
                                Spacer()
                                Button(action: {
                                }) {
                                    Text("Submit")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                }
                if isSelect {
                    VStack(alignment: .leading, spacing: 16) {
                        Menu {
                            ForEach(ConsoleviewModel.SecurityQuestions, id: \.question) { question in
                                Button(question.question) {
                                    issecurityQuestions = question.question
                                    ConsoleviewModel.getUserSecurityQuestions()
                                    isSelect = false
                                }
                            }
                        } label: {
                            HStack {
                                Text(issecurityQuestions.isEmpty ? "Select Security Question" : issecurityQuestions)
                                    .foregroundColor(Color.black)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(Color.black)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .frame(minWidth: 0, maxWidth: 200)
                            .padding(.top , 10)
                        }
                    }
                }
                
                if isPinDialogVisible {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isPinDialogVisible = false
                                }
                            }
                        
                        VStack(spacing: 16) {
                            // Title and Close Button
                            HStack {
                                Text("Set PIN")
                                    .font(.headline)
                                    .padding(.leading, 16)
                                Spacer()
                                Image("cross")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding(8)
                                    .onTapGesture {
                                        withAnimation {
                                            isPinDialogVisible = false
                                        }
                                    }
                            }
                            HStack {
                                ZStack(alignment: .trailing) {
                                    Floatingtextfield(
                                        text: $ConsoleviewModel.currentPassword,
                                        placeHolder: "Enter new PIN",
                                        allowedCharacter: .defaultType,
                                        isSecure: !isnewPasswordVisible // <- Add support in your custom FloatingTextField
                                    )
//                                    .padding(.horizontal, 10)
                                    
                                    Button(action: {
                                        isnewPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isnewPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.black)
                                            .padding(.trailing, 20)
                                    }
                                }
                            }
                            HStack {
                                ZStack(alignment: .trailing) {
                                    Floatingtextfield(
                                        text: $ConsoleviewModel.NewPassword,
                                        placeHolder: "Enter new confirm PIN",
                                        allowedCharacter: .defaultType,
                                        isSecure: !isconfirmPasswordVisible // <- Add support in your custom FloatingTextField
                                    )
//                                    .padding(.horizontal, 10)
                                    
                                    Button(action: {
                                        isconfirmPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isconfirmPasswordVisible ? "eye" : "eye.slash")
                                            .foregroundColor(.black)
                                            .padding(.trailing, 20)
                                    }
                                }
                            }
                            HStack {
                                Text("Note:")
                                    .foregroundColor(.red)
                                Text("PIN must be exactly 4 digits long")
                            }
                            
                            // Create Button
                            HStack {
                                Spacer()
                                Button(action: {
                                    ConsoleviewModel.setPin(Newpin: ConsoleviewModel.currentPassword, confirmationPin: ConsoleviewModel.NewPassword)
                                    isPinDialogVisible = false
                                }) {
                                    Text("Submit")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16)
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                }
            }
            .zIndex(0)
        }
    }
    
    // Helper function to get the appropriate items for the selected tab
    private func getTabItems() -> [String] {
        switch selectedTab {
        case 0: // General
            return ["Language", "Date and Time", "Mail", "Planner", "Chat", "Storage", "Trash", "Signature"]
        case 1: // Security
            return ["Account Security", "Locker"]
        case 2: // Notifications
            return ["Mail", "Chat-Box","Planner"]
        default:
            return []
        }
    }
    
    // Helper function to get the appropriate icons for the selected tab
    private func getTabIcons() -> [String] {
        switch selectedTab {
        case 0: // General
            return ["globe", "calendar", "envelope", "checklist", "bubble.left", "archivebox", "trash", "signature"]
        case 1: // Security
            return ["AccountSecurity","lockerSecurity"]
        case 2: // Notifications
            return ["chevronRight", "chevronRight", "chevronRight"]
        default:
            return []
        }
    }
    
    @ViewBuilder
    private func getExpandedContent(for index: Int) -> some View {
        switch selectedTab {
        case 0: // General Tab
            switch index {
            case 0: // Language
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
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    
                }
                
            case 1: // Date and Time
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Date Format:")
                            .font(.system(size: 14))
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Menu {
                                Button("MMM-dd-yyyy") {
                                    DateFormat = "MMM-dd-yyyy"
                                    let payload = DateFormatPayload(dateFormat: DateFormat)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                                Button("dd-MMM-yyyy") {
                                    DateFormat = "dd-MMM-yyyy"
                                    let payload = DateFormatPayload(dateFormat: DateFormat)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                                Button("yyyy-MMM-dd") {
                                    DateFormat = "yyyy-MMM-dd"
                                    let payload = DateFormatPayload(dateFormat: DateFormat)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                            } label: {
                                HStack {
                                    Text("\(DateFormat)")
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
                                        .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                                )
                            }                            .background(themesviewModel.currentTheme.windowBackground)
                        }
                    }

                    

                    
                    HStack {
                        Text("Time Format:")
                            .font(.system(size: 14))
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Menu {
                                Button("12 Hours") {
                                    TimeFormat = "12 Hours"
                                    let payload = TimeFormatPayload(timeFormat: TimeFormat)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                                Button("24 Hours") {
                                    TimeFormat = "24 Hours"
                                    let payload = TimeFormatPayload(timeFormat: TimeFormat)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                            } label: {
                                HStack {
                                    Text("\(TimeFormat)")
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
                                        .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                                )
                            }                            .background(themesviewModel.currentTheme.windowBackground)
                        }
                    }
                    
                    HStack {
                        Text("Time Zone:")
                            .font(.system(size: 14))
                            .foregroundStyle(themesviewModel.currentTheme.textColor)
                        VStack(alignment: .leading, spacing: 16) {
                            Menu {
                                Button("Pacific/Johnston") {
                                    TimeZone = "Pacific/Johnston"
                                    let payload = TimeZonePayload(timeZone: TimeZone)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                                Button("Pacific/Rarotonga") {
                                    TimeZone = "Pacific/Rarotonga"
                                    let payload = TimeZonePayload(timeZone: TimeZone)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                                Button("Pacific/Tahiti") {
                                    TimeZone = "Pacific/Tahiti"
                                    let payload = TimeZonePayload(timeZone: TimeZone)
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                            } label: {
                                HStack {
                                    Text("\(TimeZone)")
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
                                        .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                                )
                            }
                            .background(themesviewModel.currentTheme.windowBackground)
                        }
                        .padding(.leading, 16)
                    }
                }
                
            case 2: // Mail
                VStack(alignment: .leading, spacing: 16) {
                    Text("Time Period (awaiting area to the postbox)")
                        .font(.system(size: 14))
                        .foregroundStyle(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("24 Hours") {
                            timePeriod = 24
                            let payload = TimeZonePayload(timeZone: TimeZone)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("36 Hours") {
                            timePeriod = 36
                        }
                        Button("48 Hours") {
                            timePeriod = 48
                        }
                        Button("72 Hours") {
                            timePeriod = 72
                        }
                    } label: {
                        HStack {
                            Text("\(timePeriod)")
                                .foregroundStyle(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    
                    
                    Text("Maximum Page List Size (Awaiting)")
                        .font(.system(size: 14))
                        .foregroundStyle(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("5") {
                            awaitingPageSize = 5
                            let payload = AwaitingPayload(awaitingPageSize: awaitingPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
    //                            consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
                        }
                        Button("10") {
                            awaitingPageSize = 10
                            let payload = AwaitingPayload(awaitingPageSize: awaitingPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("15") {
                            awaitingPageSize = 15
                            let payload = AwaitingPayload(awaitingPageSize: awaitingPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
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
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    
                    Text("Maximum Page List Size (Post-box)")
                        .font(.system(size: 14))
                        .foregroundStyle(themesviewModel.currentTheme.textColor)
                    Menu {
                        Button("5") {
                            postBoxPageSize = 5
                            let payload = postBoxsizePayload(postboxPageSize: postBoxPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("10") {
                            postBoxPageSize = 10
                            let payload = postBoxsizePayload(postboxPageSize: postBoxPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("15") {
                            postBoxPageSize = 15
                            let payload = postBoxsizePayload(postboxPageSize: postBoxPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
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
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    
                    Text("Maximum Page Size (Conveyed)")
                        .font(.system(size: 14))
                        .foregroundStyle(themesviewModel.currentTheme.textColor)
                    Menu {
                        Button("5") {
                            conveyedPageSize = 5
                            let payload = conveyedsizePayload(ConveyedPageSize: conveyedPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("10") {
                            conveyedPageSize = 10
                            let payload = conveyedsizePayload(ConveyedPageSize: conveyedPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("15") {
                            conveyedPageSize = 15
                            let payload = conveyedsizePayload(ConveyedPageSize: conveyedPageSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                    } label: {
                        HStack {
                            Text("\(conveyedPageSize)")
                                .foregroundStyle(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    
                    Text("Default Font Family")
                        .font(.system(size: 14))
                        .foregroundStyle(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("IRANSans") {
                            selectedFontFamily = "IRANSans"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("cursive") {
                            selectedFontFamily = "cursive"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("fantasy") {
                            selectedFontFamily = "fantasy"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("monospace") {
                            selectedFontFamily = "monospace"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)                        }
                        Button("serif") {
                            selectedFontFamily = "serif"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("verdana") {
                            selectedFontFamily = "verdana"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("NotoSans-bold") {
                            selectedFontFamily = "NotoSans-bold"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("sans-serif") {
                            selectedFontFamily = "sans-serif"
                            let payload = defalutfont(mailFontFamily: selectedFontFamily)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                    } label: {
                        HStack {
                            Text("\(selectedFontFamily)")
                                .foregroundStyle(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }

                    Text("Default Font Size")
                        .font(.system(size: 14))
                        .foregroundStyle(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("8px") {
                            selectedFontSize = 8
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("12px") {
                            selectedFontSize = 12
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)

                        }
                        Button("16px") {
                            selectedFontSize = 16
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)

                        }
                        Button("20px") {
                            selectedFontSize = 20
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("24px") {
                            selectedFontSize = 24
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)

                        }
                        Button("28px") {
                            selectedFontSize = 15
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("32px") {
                            selectedFontSize = 32
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("36px") {
                            selectedFontSize = 36
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("40px") {
                            selectedFontSize = 40
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("44px") {
                            selectedFontSize = 44
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("48px") {
                            selectedFontSize = 48
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("52px") {
                            selectedFontSize = 52
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("56px") {
                            selectedFontSize = 56
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("60px") {
                            selectedFontSize = 60
                            let payload = FontSize(mailFontSize: selectedFontSize)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                    } label: {
                        HStack {
                            Text("\(selectedFontSize)")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }

                }
                
            case 3: // Mail
                VStack(alignment: .leading, spacing: 16) {
                    Text("Task Type")
                        .font(.system(size: 14))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("Upcoming") {
                            taskType = "Upcoming"
                            let payload = tasktype(taskList: taskType)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("older") {
                            taskType = "older"
                            let payload = tasktype(taskList: taskType)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                    } label: {
                        HStack {
                            Text("\(taskType)")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    
                    
                    Text("Do it")
                        .font(.system(size: 14))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("10") {
                            doit = 10
                            let payload = tDo(doitPageSize: doit)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("20") {
                            doit = 20
                            let payload = tDo(doitPageSize: doit)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("30") {
                            doit = 30
                            let payload = tDo(doitPageSize: doit)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("50") {
                            doit = 50
                            let payload = tDo(doitPageSize: doit)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                    } label: {
                        HStack {
                            Text("\(doit)")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    
                    Text("Dairy")
                        .font(.system(size: 14))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("10") {
                            dairy = 10
                            let payload = tDiary(dairyPageSize: dairy)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("20") {
                            dairy = 20
                            let payload = tDiary(dairyPageSize: dairy)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("30") {
                            dairy = 30
                            let payload = tDiary(dairyPageSize: dairy)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("50") {
                            dairy = 50
                            let payload = tDiary(dairyPageSize: dairy)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                    } label: {
                        HStack {
                            Text("\(dairy)")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }
                    Text("Note")
                        .font(.system(size: 14))
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                    
                    Menu {
                        Button("10") {
                            note = 10
                            let payload = tNote(notePageSize: note)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("20") {
                            note = 20
                            let payload = tNote(notePageSize: note)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("30") {
                            note = 30
                            let payload = tNote(notePageSize: note)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                        Button("50") {
                            note = 50
                            let payload = tNote(notePageSize: note)
                            ConsoleviewModel.saveSettings(payload: payload)
                        }
                    } label: {
                        HStack {
                            Text("\(dairy)")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                        )
                    }

                }
//                HStack {
//                    Text("Chat:")
//                        .font(.system(size: 14))
//                    
//                    Spacer()
//                    
//                    Toggle("", isOn: Binding(
//                        get: { isChatEnabled != 0 },
//                        set: { newValue in
//                            isChatEnabled = newValue ? 1 : 0
//                                let payload = tNote(notePageSize: note)
//                                ConsoleviewModel.saveSettings(payload: payload)
//                            consoleViewModel.SaveSettingschat(chats: newValue) // `newValue` is already `true/false`
//                        }
//                    ))
//                    .tint(Color.blue)
//                }
                
            case 4: // Chat
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Chat:")
                            .font(.system(size: 14))
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Image("iIcon")
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { isChatEnabled != 0 },
                            set: { newValue in
                                isChatEnabled = newValue ? 1 : 0
                                let payload = chat(chat: (isChatEnabled != 0))
                                ConsoleviewModel.saveSettings(payload: payload)
                            }
                        ))
                        .tint(Color.blue)
                    }


                    
                    HStack {
                        Text("Open Chat Bubble:")
                            .font(.system(size: 14))
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Image("iIcon")
                        Spacer()
                            Toggle("", isOn: Binding(
                                get: { isChatBubbleEnabled != 0 },
                                set: { newValue in
                                    isChatBubbleEnabled = newValue ? 1 : 0
                                    let payload = chatBubble(openChatBubbles: (isChatBubbleEnabled != 0))
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                            ))
                            .tint(Color.blue)
                        
                    }
                    
                    HStack {
                        Text("Chat Background:")
                            .font(.system(size: 14))
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Image("iIcon")
                        Spacer()
                            Toggle("", isOn: Binding(
                                get: { isChatBackGround != 0 },
                                set: { newValue in
                                    isChatBackGround = newValue ? 1 : 0
                                    let payload = chatBackground(ChatBackGround: (isChatBackGround != 0))
                                    ConsoleviewModel.saveSettings(payload: payload)
                                }
                            ))
                            .tint(Color.blue)
                        
                    }
                }
                
    //            case 5: // Chat
    //                VStack(alignment: .leading, spacing: 16) {
    //                }
                
            case 6:
                VStack{
                    HStack{
                        Text("Trash")
                            .font(.system(size: 14))
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Image("iIcon")
                        Menu {
                            Button("30 days") {
                                trash = 30
                                let payload = Trash(TrashRecovery: trash)
                                ConsoleviewModel.saveSettings(payload: payload)
                            }
                            Button("50 days") {
                                trash = 50
                                let payload = Trash(TrashRecovery: trash)
                                ConsoleviewModel.saveSettings(payload: payload)
                            }
                            Button("60 days") {
                                trash = 60
                                let payload = Trash(TrashRecovery: trash)
                                ConsoleviewModel.saveSettings(payload: payload)
                            }
                            Button("70 days") {
                                trash = 70
                                let payload = Trash(TrashRecovery: trash)
                                ConsoleviewModel.saveSettings(payload: payload)
                            }
                        } label: {
                            HStack {
                                Text("\(trash)")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                            }
                            .padding()
                            .background(themesviewModel.currentTheme.windowBackground)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(themesviewModel.currentTheme.colorControlNormal, lineWidth: 1)
                            )
                        }
                    }
                    
                }
                
            default:
                Text("No content available")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            
        case 1: // Security Tab
            switch index {
            case 0: // Password
                VStack(alignment: .leading, spacing: 16) {
                    
                        HStack {
                            Text("Recovery Phone Number")
                                .font(.headline)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            Spacer()
                            Button(action: {
                                isContactsDialogVisible = true
                                ConsoleviewModel.isContactsDialogVisible = true
                            }) {
                                Text("Change")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .frame(height: 40)
                                    .frame(width: 100)
                            }
                            .background(themesviewModel.currentTheme.colorPrimary)
                            .cornerRadius(10) // This will now affect the background too
                            .padding(.trailing, 16)

                        }
                        Text("Reset Your Phone number")
                        .font(.system(size: 12))
                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                    
                    Divider()
                        .padding(.horizontal)
                    
                    HStack {
                        Text("Change Password")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Spacer()
                        Button(action: {
                            isPasswordDialogVisible = true
                        }) {
                            Text("Change")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .frame(height: 40)
                                .frame(width: 100)
                        }
                        .background(themesviewModel.currentTheme.colorPrimary)
                        .cornerRadius(10) // This will now affect the background too
                        .padding(.trailing, 16)
                    }
                    Text("Reset Your Password")
                    .font(.system(size: 12))
                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)

                Divider()
                    .padding(.horizontal)
                    
                    HStack {
                        Text(issecurityQuestions.isEmpty
                            ? "What is the name of your favorite childhood"
                            : issecurityQuestions)

                            .font(.headline)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                        Spacer()
                        Button(action: {
                            isSelect = true
                        }) {
                            Text("Add")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .frame(height: 40)
                                .frame(width: 100)
                        }
                        .background(themesviewModel.currentTheme.colorPrimary)
                        .cornerRadius(10)
                        .padding(.trailing, 16)
                    }
                    Text("**********")
                    .font(.system(size: 12))
                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                }
                
            case 1: // Authentication
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Set Pin")
                            .font(.headline)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .padding(.leading,16)
                        Spacer()
                        Button(action: {
                            isPinDialogVisible = true
                        }) {
                            Text("Add")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .frame(height: 40)
                                .frame(width: 100)
                        }
                        .background(themesviewModel.currentTheme.colorPrimary)
                        .cornerRadius(10) // This will now affect the background too
                        .padding(.trailing, 16)

                    }
                }
                
            default:
                Text("No content available")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
            }
//            @State private var isToggleAllNotificationsOn = false
//            @State private var isToggleNewEmailOn = false
//            @State private var isToggleScheduledsentOn = false
//            @State private var isToggleNewMessageOn = false
//            @State private var isToggleAddOrRemoveOn = false
//            @State private var isToggleChatDetailsOn = false
//            @State private var isToggleConnectionExpiredOn = false
//            @State private var isToggleDatebookOn = false
//            @State private var isToggleDiaryOn = false
//            @State private var isToggleDoItOn = false
//            @State private var isToggleNoteOn = false
//            @State private var isToggleReminderOn = false
        case 2: // Notifications Tab
            switch index {
            case 0: // Push Notifications
                VStack(alignment: .leading, spacing: 16) {
                    
                    // New Mail Toggle
                    HStack {
                        Text("New mail")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading, 20)
                        Spacer()
                        Toggle("", isOn: $NewEmail)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: NewEmail) { newValue in
                                ConsoleviewModel.updateDiaryData(
                                    Allnotifications: AllNotifications,
                                    newemails: newValue,
                                    ScheduleSent: Scheduledsent,
                                    Newmessage: NewMessage,
                                    AddOrremove: AddOrRemove,
                                    chatDetails: ChatDetails,
                                    Connectionexpired: ConnectionExpired,
                                    DateBook: Datebook,
                                    Diary: Diary,
                                    DoIt: DoIt,
                                    Note: Note,
                                    Reminder: Reminder
                                )
                            }
                    }

                    // Scheduled Sent Toggle
                    HStack {
                        Text("Scheduled sent")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading, 20)
                        Spacer()
                        Toggle("", isOn: $Scheduledsent)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: Scheduledsent) { newValue in
                                
                                ConsoleviewModel.updateDiaryData(
                                    Allnotifications: AllNotifications,
                                    newemails: NewEmail,
                                    ScheduleSent: newValue,
                                    Newmessage: NewMessage,
                                    AddOrremove: AddOrRemove,
                                    chatDetails: ChatDetails,
                                    Connectionexpired: ConnectionExpired,
                                    DateBook: Datebook,
                                    Diary: Diary,
                                    DoIt: DoIt,
                                    Note: Note,
                                    Reminder: Reminder
                                )

                            }
                    }
                }

                
            case 1: // Push Notifications
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("New message")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $NewMessage)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: NewMessage) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: newValue, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: false, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                            }
                    }
                    HStack {
                        Text("Add/remove")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $AddOrRemove)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: AddOrRemove) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: newValue, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: false, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                            }

                    }
                    HStack {
                        Text("chat details")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $ChatDetails)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: ChatDetails) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: newValue, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: false, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                            }

                    }
                    HStack {
                        Text("Connection expiring")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $ConnectionExpired)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: ConnectionExpired) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: newValue, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: false, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                            }

                    }
                    
                }
                
            case 2: // Push Notifications
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Do it")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $DoIt)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: DoIt) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: newValue, Note: Note, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: false, Note: Note, Reminder: Reminder)
                                }
                            }

                    }
                    HStack {
                        Text("Remainder")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $Reminder)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: Reminder) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: newValue)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: false)
                                }
                            }

                    }
                    HStack {
                        Text("Note")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $Note)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: Note) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: newValue, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: Diary, DoIt: DoIt, Note: false, Reminder: Reminder)
                                }
                            }

                    }
                    HStack {
                        Text("Diary")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $Diary)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: Diary) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: newValue, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: Datebook, Diary: false, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                            }

                    }
                    HStack {
                        Text("Datebook")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.subheadline)
                            .padding(.leading , 20)
                        Spacer()
                        Toggle("", isOn: $Datebook)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .padding(8)
                            .cornerRadius(8)
                            .onChange(of: Datebook) { newValue in
                                if newValue {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: newValue, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                                else {
                                    ConsoleviewModel.updateDiaryData(Allnotifications: AllNotifications, newemails: NewEmail, ScheduleSent: Scheduledsent, Newmessage: NewMessage, AddOrremove: AddOrRemove, chatDetails: ChatDetails, Connectionexpired: ConnectionExpired, DateBook: false, Diary: Diary, DoIt: DoIt, Note: Note, Reminder: Reminder)
                                }
                            }

                    }
                    
                }
                
            default:
                Text("No content available")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            


            
        default:
            Text("No content available")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // Helper function to get color from string
    private func getColor(for name: String) -> Color {
        switch name {
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "purple": return .purple
        default: return .gray
        }
    }
}

struct ControlHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ControlHeaderView()
    }
}
