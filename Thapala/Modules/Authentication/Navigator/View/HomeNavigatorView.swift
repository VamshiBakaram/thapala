//
//  HomeNavigatorView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import SwiftUI

struct HomeNavigatorView: View {
    
    @State private var isMenuVisible = false
    @ObservedObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @ObservedObject var themesviewModel = themesViewModel()
    @State private var isQuickAccessVisible = false
    @ObservedObject var ConsoleviewModel = consoleviewModel()
    let imageUrl: String
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    VStack {
//                    NavigatorHeaderView
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
                            
                        HStack(spacing:20){
                            Text("Navigator")
                                .padding(.leading,20)
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            Spacer()
                            Button(action: {
                                print("search button pressed")
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

                    ScrollView(.horizontal,showsIndicators: false){
                        HStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isAdobeSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: reader.size.width/3 - 10, height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .adobe
                                    print("Adobe clicked")
                                    self.homeNavigatorViewModel.isAdobeSelected = true
                                    self.homeNavigatorViewModel.isBioSelected = false
                                    self.homeNavigatorViewModel.isControlSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("AdobeIcon")
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(themesviewModel.currentTheme.tabBackground)
                                            VStack{
                                                Text("Adobe")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                            }
                                        }
                                    }
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isBioSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: reader.size.width/3 - 10, height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .bio
                                    print("bio clicked")
                                    self.homeNavigatorViewModel.isAdobeSelected = false
                                    self.homeNavigatorViewModel.isBioSelected = true
                                    self.homeNavigatorViewModel.isControlSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("BioIcon")
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(themesviewModel.currentTheme.tabBackground)
                                            VStack{
                                                Text("Bio")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                            }
                                        }
                                    }
                                )
                            
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeNavigatorViewModel.isControlSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .frame(width: reader.size.width/3 - 10, height: 50)
                                .onTapGesture {
                                    self.homeNavigatorViewModel.selectedOption = .controlPanel
                                    print("control clicked")
                                    self.homeNavigatorViewModel.isAdobeSelected = false
                                    self.homeNavigatorViewModel.isBioSelected = false
                                    self.homeNavigatorViewModel.isControlSelected = true
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            Image("consoleNavigator")
                                                .renderingMode(.template)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .background(themesviewModel.currentTheme.tabBackground)
                                            VStack{
                                                Text("Console")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                    
                                            }
                                        }
                                    }
                                    
                                )
                        }
                        .padding([.leading,.trailing])
                        .padding(.bottom , 50)
                    }
                }
                    .frame(height: 120)
                    .background(themesviewModel.currentTheme.tabBackground)
                    if let selectedOption = homeNavigatorViewModel.selectedOption {
                        switch selectedOption {
                        case .adobe:
                           // AdobeView
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
                            
                        case .bio:
                            BioView(imageUrl: "")
                        case .controlPanel:
                            ControlHeaderView()
                        }
                    }
                    
                    Spacer()
//                    HStack{
//                        Spacer()
//                        Button(action: {
//                            homeNavigatorViewModel.isPlusbtn = true
//                        }) {
//                            Image("plus")
//                                .font(Font.title.weight(.medium))
//                                .foregroundColor(Color.white)
//                        }
//                        .padding(.trailing,15)
//                    }
                    
                    VStack {
        //          Spacer().frame(height: 100)
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
                                                 homeNavigatorViewModel.isComposeEmail = true
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
                    if ConsoleviewModel.isContactsDialogVisible == false{
                        TabViewNavigator()
                            .frame(height: 40)
                    }
                    
                }
                .navigationBarBackButtonHidden(true)
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear{
                    print("homeNavigatorViewModel.isControlSelected = true")
                    self.homeNavigatorViewModel.selectedOption = .controlPanel
                    self.homeNavigatorViewModel.isControlSelected = true
                }
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
                if homeNavigatorViewModel.isPlusbtn {
                    QuickAccessView(isQuickAccessVisible: $homeNavigatorViewModel.isPlusbtn)
                        .transition(.opacity)
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
            }
            .zIndex(0)

        }
        .navigationDestination(isPresented: $homeNavigatorViewModel.isComposeEmail) {
            MailComposeView().toolbar(.hidden)
        }
       
    }
    

//    var ControlPanelView:some View{
//        ControlHeaderView()
//    }
    

//    struct ControlHeaderView: View {
//        @State private var selectedTab = 0
//        @State private var expandedIndex: Int? = nil
//        let tabs = ["General", "Security", "Notifications", "Appearance"]
//        let icons = ["globe", "calendar", "envelope", "checklist", "bubble.left", "archivebox", "trash", "signature"]
//        let titles = ["Language", "Date and Time", "Mail", "Planner", "Chat", "Storage", "Trash", "Signature"]
//        
//        @State private var selectedLanguage = "English"
//        @State private var DateFormat = "MM-DD-YYYY"
//        @State private var TimeFormat = "12 Hours"
//        @State private var TimeZone = "Pacific/Johnston"
//        @State private var timePeriod = 36
//        
//        @State private var awaitingPageSize: Int = 10
//        @State private var postBoxPageSize: Int = 10
//        @State private var conveyedPageSize: Int = 10
//        @State private var selectedFontFamily: String = "IRANSans"
//        @State private var selectedFontSize: Int = 8
//        @State private var taskType: String = "Upcoming"
//        @State private var doit: Int = 10
//        @State private var dairy: Int = 10
//        @State private var note: Int = 10
//        @State private var isChatEnabled = 0
//        @State private var isChatBubbleEnabled = 0
//        @State private var isChatBackGround = 0
//        @State private var trash: Int = 10
//        @State private var selectedTheme: String = "Light"
//        
//        var body: some View {
//            VStack(spacing: 16) {
//                // Top Tab Bar
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 12) {
//                        ForEach(0..<tabs.count, id: \.self) { index in
//                            Text(tabs[index])
//                                .fontWeight(selectedTab == index ? .bold : .regular)
//                                .foregroundColor(.black)
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 16)
//                                .background(
//                                    selectedTab == index ?
//                                    Color.white.opacity(0.8) :
//                                    Color.clear
//                                )
//                                .cornerRadius(8)
//                                .onTapGesture {
//                                    selectedTab = index
//                                }
//                        }
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 4)
//                    .background(Color(red: 69/255, green: 86/255, blue: 225/255)) // Blue background
//                }
//                .frame(height: 50)
//                .padding(.horizontal , 16)
//                
//                // Settings List
//                VStack(spacing: 0) {
//                    ForEach(titles.indices, id: \.self) { index in
//                        VStack(spacing: 0) {
//                            HStack {
//                                Image(systemName: icons[index])
//                                    .foregroundColor(.black)
//                                    .frame(width: 24, height: 24)
//                                
//                                Text(titles[index])
//                                    .font(.system(size: 18))
//                                    .foregroundColor(.black)
//                                
//                                Spacer()
//                                
//                                Image(systemName: expandedIndex == index ? "chevron.down" : "chevron.right")
//                                    .foregroundColor(.black)
//                                    .onTapGesture {
//                                            expandedIndex = (expandedIndex == index) ? nil : index
//                                        
//                                    }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            
//                            if expandedIndex == index {
//                                getExpandedContent(for: index)
//                                    .padding()
//                                    .background(Color.white)
//                            }
//                            
//                            Divider()
//                                .padding(.leading, 56)
//                        }
//                    }
//                }
//                .background(
//                    RoundedRectangle(cornerRadius: 8)
//                        .fill(Color.black)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 0)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                )
//                .padding(.horizontal, 30)
//            }
//            .edgesIgnoringSafeArea(.top)
//        }
//        
//        @ViewBuilder
//        private func getExpandedContent(for index: Int) -> some View {
//            switch index {
//            case 0:
//                VStack(alignment: .leading, spacing: 16) {
//                    Menu {
//                        Button("English") { selectedLanguage = "English" }
//                    } label: {
//                        HStack {
//                            Text(selectedLanguage)
//                                .foregroundColor(.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    .background(Color.white)
//                }
//                
//            case 1:
//                VStack(alignment: .leading, spacing: 16) {
//                    HStack {
//                        Text("Date Format:")
//                            .font(.system(size: 14))
//                        
////                        Spacer()
//                        VStack(alignment: .leading, spacing: 16) {
//                            Menu {
//                                Button("MM-DD-YYYY") { DateFormat = "MM-DD-YYYY" }
//                                Button("DD-MM-YYYY") { DateFormat = "DD-MM-YYYY" }
//                                Button("YYYY-MM-DD") { DateFormat = "YYYY-MM-DD" }
//                                
//                            } label: {
//                                HStack {
//                                    Text(DateFormat)
//                                        .foregroundColor(.black)
//                                    Spacer()
//                                    Image(systemName: "chevron.down")
//                                        .foregroundColor(.black)
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(8)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .stroke(Color.black, lineWidth: 1)
//                                )
//                            }
//                            .background(Color.white)
//                        }
//                    }
//                    
//                    HStack {
//                        Text("Time Format:")
//                            .font(.system(size: 14))
//                        
////                        Spacer()
//                        VStack(alignment: .leading, spacing: 16) {
//                            Menu {
//                                Button("12 Hours") { TimeFormat = "12 Hours" }
//                                Button("24 Hours") { TimeFormat = "24 Hours" }
//                                
//                            } label: {
//                                HStack {
//                                    Text(TimeFormat)
//                                        .foregroundColor(.black)
//                                    Spacer()
//                                    Image(systemName: "chevron.down")
//                                        .foregroundColor(.black)
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(8)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .stroke(Color.black, lineWidth: 1)
//                                )
//                            }
//                            .background(Color.white)
//                        }
//                    }
//
//                    HStack {
//                        Text("Time Zone:")
//                            .font(.system(size: 14))
//                        
////                        Spacer()
//                        VStack(alignment: .leading, spacing: 16) {
//                            Menu {
//                                Button("Pacific/Johnston") { TimeZone = "Pacific/Johnston" }
//                                Button("Pacific/Rarotonga") { TimeZone = "Pacific/Rarotonga" }
//                                Button("Pacific/Tahiti") { TimeZone = "Pacific/Tahiti" }
//                                
//                            } label: {
//                                HStack {
//                                    Text(TimeZone)
//                                        .foregroundColor(.black)
//                                    Spacer()
//                                    Image(systemName: "chevron.down")
//                                        .foregroundColor(.black)
//                                }
//                                .padding()
//                                .background(Color.white)
//                                .cornerRadius(8)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .stroke(Color.black, lineWidth: 1)
//                                )
//                            }
//                            .background(Color.white)
//                        }
//                        .padding(.leading, 16)
//                    }
//
//                    
//                }
//                
//            case 2: // Mail
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Time Period (awaiting area to the postbox)")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("24 Hours") {
//                            timePeriod = 24
////                            consoleViewModel.MailTimePeriod(timePeriod: timePeriod)
//                        }
//                        Button("36 Hours") {
//                            timePeriod = 36
//                        }
//                        Button("48 Hours") {
//                            timePeriod = 48
//                        }
//                        Button("72 Hours") {
//                            timePeriod = 72
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(timePeriod)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    
//                    
//                    Text("Maximum Page List Size (Awaiting)")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("5") {
//                            awaitingPageSize = 5
////                            consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
//                        }
//                        Button("10") {
//                            awaitingPageSize = 10
//                        }
//                        Button("15") {
//                            awaitingPageSize = 15
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(awaitingPageSize)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    
//                    Text("Maximum Page List Size (Post-box)")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("5") {
//                            postBoxPageSize = 5
////                            consoleViewModel.PostBoxMaximumPageSize(pageSize: postBoxPageSize)
//                        }
//                        Button("10") {
//                            postBoxPageSize = 10
//                        }
//                        Button("15") {
//                            postBoxPageSize = 15
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(postBoxPageSize)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    
//                    Text("Maximum Page Size (Conveyed)")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("5") {
//                            conveyedPageSize = 5
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("10") {
//                            conveyedPageSize = 10
//                        }
//                        Button("15") {
//                            conveyedPageSize = 15
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(conveyedPageSize)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    
//                    Text("Default Font Family")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("IRANSans") {
//                            selectedFontFamily = "IRANSans"
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("cursive") {
//                            selectedFontFamily = "cursive"
//                        }
//                        Button("fantasy") {
//                            selectedFontFamily = "fantasy"
//                        }
//                        Button("monospace") {
//                            selectedFontFamily = "monospace"
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("serif") {
//                            selectedFontFamily = "serif"
//                        }
//                        Button("verdana") {
//                            selectedFontFamily = "verdana"
//                        }
//                        Button("NotoSans-bold") {
//                            selectedFontFamily = "NotoSans-bold"
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("sans-serif") {
//                            selectedFontFamily = "sans-serif"
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(selectedFontFamily)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//
//                    Text("Default Font Size")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("8px") {
//                            selectedFontSize = 8
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("12px") {
//                            selectedFontSize = 12
//                        }
//                        Button("16px") {
//                            selectedFontSize = 16
//                        }
//                        Button("20px") {
//                            selectedFontSize = 20
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("24px") {
//                            selectedFontSize = 24
//                        }
//                        Button("28px") {
//                            selectedFontSize = 15
//                        }
//                        Button("32px") {
//                            selectedFontSize = 32
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("36px") {
//                            selectedFontSize = 36
//                        }
//                        Button("40px") {
//                            selectedFontSize = 40
//                        }
//                        Button("44px") {
//                            selectedFontSize = 44
//                        }
//                        Button("48px") {
//                            selectedFontSize = 48
//                        }
//                        Button("52px") {
//                            selectedFontSize = 52
////                            consoleViewModel.ConveyedMaximumPageSize(pageSize: conveyedPageSize)
//                        }
//                        Button("56px") {
//                            selectedFontSize = 56
//                        }
//                        Button("60px") {
//                            selectedFontSize = 60
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(selectedFontSize)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//
//                }
//                
//            case 3: // Mail
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Task Type")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("Select task type") {
//                            taskType = "Select task type"
////                            consoleViewModel.MailTimePeriod(timePeriod: timePeriod)
//                        }
//                        Button("Upcoming") {
//                            taskType = "Upcoming"
//                        }
//                        Button("older") {
//                            taskType = "older"
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(taskType)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    
//                    
//                    Text("Do it")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("10") {
//                            doit = 10
////                            consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
//                        }
//                        Button("20") {
//                            doit = 20
//                        }
//                        Button("30") {
//                            doit = 30
//                        }
//                        Button("50") {
//                            doit = 50
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(doit)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    
//                    Text("Dairy")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("10") {
//                            dairy = 10
////                            consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
//                        }
//                        Button("20") {
//                            dairy = 20
//                        }
//                        Button("30") {
//                            dairy = 30
//                        }
//                        Button("50") {
//                            dairy = 50
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(dairy)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//                    Text("Note")
//                        .font(.system(size: 14))
//                    
//                    Menu {
//                        Button("10") {
//                            note = 10
////                            consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
//                        }
//                        Button("20") {
//                            note = 20
//                        }
//                        Button("30") {
//                            note = 30
//                        }
//                        Button("50") {
//                            note = 50
//                        }
//                    } label: {
//                        HStack {
//                            Text("\(dairy)")
//                                .foregroundColor(Color.black)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                                .foregroundColor(Color.black)
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.black, lineWidth: 1)
//                        )
//                    }
//
//                }
//                
//            case 4: // Chat
//                VStack(alignment: .leading, spacing: 16) {
//                    HStack {
//                        Text("Chat:")
//                            .font(.system(size: 14))
//                        Image("iIcon")
//                        Spacer()
//                        
//                        Toggle("", isOn: Binding(
//                            get: { isChatEnabled != 0 },
//                            set: { newValue in
//                                isChatEnabled = newValue ? 1 : 0
////                                consoleViewModel.SaveSettingschat(chats: newValue) // `newValue` is already `true/false`
//                            }
//                        ))
//                        .tint(Color.blue)
//                    }
//
//
//                    
//                    HStack {
//                        Text("Open Chat Bubble:")
//                            .font(.system(size: 14))
//                        Image("iIcon")
//                        Spacer()
//                            Toggle("", isOn: Binding(
//                                get: { isChatBubbleEnabled != 0 },
//                                set: { newValue in
//                                    isChatBubbleEnabled = newValue ? 1 : 0
////                                    consoleViewModel.SaveSettingsChatBubble(chatBubble: newValue)
//                                }
//                            ))
//                            .tint(Color.blue)
//                        
//                    }
//                    
//                    HStack {
//                        Text("Chat Background:")
//                            .font(.system(size: 14))
//                        Image("iIcon")
//                        Spacer()
//                            Toggle("", isOn: Binding(
//                                get: { isChatBackGround != 0 },
//                                set: { newValue in
//                                    isChatBackGround = newValue ? 1 : 0
////                                    consoleViewModel.SaveSettingsChatBubble(chatBubble: newValue)
//                                }
//                            ))
//                            .tint(Color.blue)
//                        
//                    }
//                }
//                
////            case 5: // Chat
////                VStack(alignment: .leading, spacing: 16) {
////                }
//                
//            case 6:
//                VStack{
//                    HStack{
//                        Text("Trash")
//                            .font(.system(size: 14))
//                        Image("iIcon")
//                        Menu {
//                            Button("30 days") {
//                                trash = 30
//                                //                            consoleViewModel.AwaitingMaximumPageSize(pageSize: awaitingPageSize)
//                            }
//                            Button("50 days") {
//                                trash = 50
//                            }
//                            Button("60 days") {
//                                trash = 60
//                            }
//                            Button("70 days") {
//                                trash = 70
//                            }
//                        } label: {
//                            HStack {
//                                Text("\(trash)")
//                                    .foregroundColor(Color.black)
//                                Spacer()
//                                Image(systemName: "chevron.down")
//                                    .foregroundColor(Color.black)
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(8)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 5)
//                                    .stroke(Color.black, lineWidth: 1)
//                            )
//                        }
//                    }
//                    
//                }
//                
//            default:
//                Text("No content available")
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//        }
//    }






    struct ControlHeaderView_Previews: PreviewProvider {
        static var previews: some View {
            ControlHeaderView()
        }
    }

}

#Preview {
    HomeNavigatorView(imageUrl: "")
}
