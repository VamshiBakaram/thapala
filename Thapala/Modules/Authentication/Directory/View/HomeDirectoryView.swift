


//
//  HomeDirectoryView.swift
//  Thapala
//
//  Created by Ahex-Guest on 23/10/24.
//

import SwiftUI
struct HomeDirectoryView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject var homeDirectoryViewModel = HomeDirectoryViewModel()
    @StateObject var themesviewModel = themesViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @Binding var isHomeDirectoryVisible: Bool
    let imageUrl: String
    @State private var isMenuVisible = false
    @State private var isShowDialogue = false
    @State private var isProfileDialogue = false
    @State private var isVisible = false
    @State var firstname: String = ""
    @State var groupNamesArray: [String] = []
    @State var groupIDArray: [Int] = []
    @State var id: Int = 0
    @State private var isSearchDialogVisible = false
    @State private var isContactsDialogVisible = false
    @State private var isQuickAccessVisible = false
    @State private var iNotificationAppBarView = false
    @State private var directoryView: Bool = true
    @State private var GroupView: Bool = false
    @State private var serachView: Bool = false
    @State private var moveToNewGroup: Bool = false
    @State private var selectedID: Int = 0
    @State private var reportView: Bool = false
    @State private var isblocked: Bool = false
    @State private var showingBlockAlert = false
    @State private var selectedGroupID: Int? = nil
    @State private var threeDotsView: Bool = false
    @State private var isRenameDialogVisible: Bool = false
    @State private var showingDeleteAlert: Bool  = false
    @State private var DetailsView: Bool = false
    
    var body: some View {
        GeometryReader{ reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
            VStack {
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
                        
                            Text("Directory")
                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))

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
                            print("line.3.horizontal button pressed")
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
//                    .padding(.top, 10) // ADD SOME SPACE INSIDE
                    
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        if !homeDirectoryViewModel.groupitems {
                            HStack {
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(directoryView ? themesviewModel.currentTheme.attachmentBGColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                        .onTapGesture {
                                            print("Emailed clicked")
                                            homeDirectoryViewModel.GetDirectoryList()
                                            selectedGroupID = nil
                                            directoryView = true
                                            GroupView = false
                                        }
                                        .overlay(
                                            Group {
                                                HStack {
                                                    Image("emailG")
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                        .padding(.leading , 5)
                                                    VStack {
                                                        Text("TContacts")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .padding(.trailing , 5)
                                                    }
                                                }
                                            }
                                        )
                                        .padding(.leading , 20)
                                    Spacer()
                                        .frame(width: 10)
                                }
                                
                                HStack{
                                    ForEach(homeDirectoryViewModel.groupList, id: \.id) { item in
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(item.id == selectedGroupID ? themesviewModel.currentTheme.attachmentBGColor :
                                                    themesviewModel.currentTheme.customButtonColor
                                            )
                                            .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                            .onTapGesture {
                                                selectedGroupID = item.id
                                                directoryView = false
                                                GroupView = true
                                                homeDirectoryViewModel.GetGroupsList(Groupid: item.id)
                                                homeDirectoryViewModel.groupID = item.id
                                            }
                                            .overlay(
                                                Group {
                                                    HStack {
                                                        Image("NewGroups")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .frame(width: 20, height: 20)
                                                            .padding(5)
                                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .fill(themesviewModel.currentTheme.tabBackground)
                                                            )
                                                            .padding(.leading , 5)
                                                        HStack{
                                                            Text(item.groupName)
                                                                .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .lineLimit(1)
                                                                .padding(.leading , 5)
                                                                .fixedSize()
                                                            
                                                            Button(action: {
                                                                print("clicked on dots")
                                                                threeDotsView = true
                                                                homeDirectoryViewModel.RenameGroupName = item.groupName
                                                                homeDirectoryViewModel.groupID = item.id
                                                            }) {
                                                                Image("dots")
                                                                    .resizable() // if the asset is resizable
                                                                    .frame(width: 20, height: 20, alignment: .trailing)
                                                                    .padding(.trailing, 5)
                                                            }
                                                        }
                                                    }
                                                }
                                            )
                                            .padding(.leading , 20)
                                        Spacer()
                                            .frame(width: 10)
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            .padding([.leading,.trailing,],5)
                            .padding(.bottom , 10)
                            
                        }
                    }
                }
                
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 30)
                .background(themesviewModel.currentTheme.tabBackground)
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                            .frame(width: 24, height: 24)
                            .padding(.leading, 12)

                        Text("Search by tcode or Name")
                            .font(.custom(.poppinsRegular, size: 14))
                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                    .onTapGesture {
                        homeDirectoryViewModel.getStatesAndCities()
                        isSearchDialogVisible = true
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.attachmentBGColor)
                    .cornerRadius(10)
                    
                    Button(action: {
                        isContactsDialogVisible = true
                    }) {
                        Image("createGroup")
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                    }
                    .padding()
                    .background(themesviewModel.currentTheme.attachmentBGColor)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                if directoryView {
                            HStack(alignment: .top) {
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 10) {
                                        ForEach(homeDirectoryViewModel.DirectoryData, id: \.userId) { item in
                                            HStack {
                                                let image = item.profile ?? ""
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
//                                                            .overlay(
//                                                                Circle().stroke(isblocked ? Color.red : Color.clear, lineWidth: 2)
//                                                            )
                                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                            .padding(.leading, 20)
                                                            .contentShape(Rectangle())
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .frame(width: 40, height: 40)
                                                            .scaledToFill()
                                                            .aspectRatio(contentMode: .fit)
                                                            .clipShape(Circle())
//                                                            .overlay(
//                                                                Circle().stroke(isblocked ? Color.red : Color.clear, lineWidth: 2)
//                                                            )
                                                            .padding(.leading, 20)
                                                            .contentShape(Rectangle())
                                                        
                                                    case .failure:
                                                        Image("contactW")
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .scaledToFill()
                                                            .frame(width: 40, height: 40)
                                                            .background(themesviewModel.currentTheme.colorAccent)
                                                            .clipShape(Circle())
//                                                            .overlay(
//                                                                Circle().stroke(isblocked ? Color.red : Color.clear, lineWidth: 2)
//                                                            )
                                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                            .padding(.leading, 20)
                                                            .contentShape(Rectangle())
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }
                                                
                                                
                                                
                                                Text(item.firstname)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom("Poppins-SemiBold", size: 14)) // Update font name and size
                                                    .padding(.leading, 8)
                                                Text(item.lastname)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom("Poppins-SemiBold", size: 14)) // Update font name and size
                                                Spacer()
                                            }
                                            .onTapGesture{
                                                homeDirectoryViewModel.GetProfileByID(selectId: item.id)
                                                isProfileDialogue.toggle()
                                                id = item.id
                                                print("let check the id     \(id)")
                                                
                                                isProfileDialogue = true
                                            }
                                            .padding(.vertical, 5)
                                            
                                            Divider()
                                                .frame(maxWidth: .infinity)
                                                .frame(height: 2)
                                                .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                                .padding(.horizontal, 12)
                                            
                                        }
                                    }

                                    .padding(.vertical, 10)
                                    //                                }
                                }
                                .refreshable {
                                    homeDirectoryViewModel.GetDirectoryList()
                                    homeDirectoryViewModel.GetGroupList()
                                    homeDirectoryViewModel.GetGroupsList(Groupid: homeDirectoryViewModel.groupID)
                                }
                            }
                }
                
                if GroupView {
                    HStack(alignment: .top) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(homeDirectoryViewModel.memberData, id: \.userId) { item in
                                    HStack {
                                        let image = item.userBio?.profile ?? ""
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
                                                    .overlay(
                                                        Circle().stroke(isblocked ? Color.red : Color.clear, lineWidth: 2)
                                                    )
                                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                    .padding(.leading, 20)
                                                    .contentShape(Rectangle())
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .scaledToFill()
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                                    .overlay(
                                                        Circle().stroke(isblocked ? Color.red : Color.clear, lineWidth: 2)
                                                    )
                                                    .padding(.leading, 20)
                                                    .contentShape(Rectangle())
                                                
                                            case .failure:
                                                Image("contactW")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .scaledToFill()
                                                    .frame(width: 40, height: 40)
                                                    .background(themesviewModel.currentTheme.colorAccent)
                                                    .clipShape(Circle())
                                                    .overlay(
                                                        Circle().stroke(isblocked ? Color.red : Color.clear, lineWidth: 2)
                                                    )
                                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                    .padding(.leading, 20)
                                                    .contentShape(Rectangle())
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        
                                        
                                        Text(item.user?.firstName ?? "")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom("Poppins-SemiBold", size: 14))
                                            .padding(.leading, 8)
                                        
                                        Text(item.user?.lastName ?? "")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom("Poppins-SemiBold", size: 14))
                                        
                                        Spacer()
                                    }
                                    .onTapGesture{
                                        homeDirectoryViewModel.GetProfileByID(selectId: item.id)
                                        isProfileDialogue.toggle()
                                        id = item.id
                                        print("let check the id     \(id)")
                                        
                                        isProfileDialogue = true
                                    }
                                    .padding(.vertical, 5)
                                    
                                    Divider()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 2)
                                        .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                        .padding(.horizontal, 12)
                                    
                                }
                            }
                            

                            .padding(.vertical, 10)
                            //                                }
                        }
                        .refreshable {
                            homeDirectoryViewModel.GetDirectoryList()
                            homeDirectoryViewModel.GetGroupList()
                            homeDirectoryViewModel.GetGroupsList(Groupid: homeDirectoryViewModel.groupID)
                        }
                    }
                }
                if serachView {
                    HStack(alignment: .top) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(homeDirectoryViewModel.searchData, id: \.userId) { item in
                                    HStack {
                                        let image = item.profile ?? ""
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
                                                    .padding(.leading, 20)
                                                    .contentShape(Rectangle())
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .scaledToFill()
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                                    .padding(.leading, 20)
                                                    .contentShape(Rectangle())
                                                
                                            case .failure:
                                                Image("contactW")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .scaledToFill()
                                                    .frame(width: 40, height: 40)
                                                    .background(themesviewModel.currentTheme.colorAccent)
                                                    .clipShape(Circle())
                                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                    .padding(.leading, 20)
                                                    .contentShape(Rectangle())
                                            @unknown default:
                                                EmptyView()
                                            }
                                        }
                                        
                                        
                                        
                                        Text(item.firstname)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom("Poppins-SemiBold", size: 14)) // Update font name and size
                                            .padding(.leading, 8)
                                        Text(item.lastname)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom("Poppins-SemiBold", size: 14)) // Update font name and size
                                        Spacer()
                                    }
                                    
                                    .onTapGesture{
                                        homeDirectoryViewModel.GetProfileByID(selectId: item.id)
                                        isProfileDialogue.toggle()
                                        id = item.id
                                        print("let check the id     \(id)")
                                        
                                        isProfileDialogue = true
                                    }
                                    .padding(.vertical, 5)
                                    
                                    Divider()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 2)
                                        .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                        .padding(.horizontal, 12)
                                    
                                }
                            }
                            .padding(.vertical, 10)
                            //                                }
                        }
                        .refreshable {
                            homeDirectoryViewModel.GetDirectoryList()
                        }
                    }
                }

            
                
                
                TabViewNavigator()
                    .frame(height: 40)
                    .padding(.bottom, 10)
            }
            .toast(message: $homeDirectoryViewModel.error)
                
                
            .edgesIgnoringSafeArea(.top)
            .onAppear {
                    print("View appeared")
                    homeDirectoryViewModel.getStatesAndCities()
                if homeDirectoryViewModel.DirectoryData.isEmpty {
                    homeDirectoryViewModel.GetDirectoryList()
                    if homeDirectoryViewModel.groupList.isEmpty {
                        print("GetGroupList Data")
                        homeDirectoryViewModel.GetGroupList()
                    }
                }

                // Delay execution to ensure data is loaded before processing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // 500ms delay
                    if !homeDirectoryViewModel.DirectoryData.isEmpty {
                        // Map all titles into an array
                        let allTitles = homeDirectoryViewModel.DirectoryData.map { $0.firstname }
                        firstname = allTitles.joined(separator: ", ")
//                        print("firstname \(firstname)")
                        
                        let profiles = homeDirectoryViewModel.DirectoryData.map { $0.profile }
                        print("firstname \(firstname) , profiles \(profiles)")
                    }
                    
                    if !homeDirectoryViewModel.groupList.isEmpty {
                        groupNamesArray = homeDirectoryViewModel.groupList
                            .compactMap { $0.groupName }
                            .flatMap { $0.components(separatedBy: ",") }
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                        print("groupNamesArray: \(groupNamesArray)")

                        for (index, group) in groupNamesArray.enumerated() {
                            print("Group \(index + 1): \(group)")
                        }
                    }

                    else {
                        print("DirectoryData is empty or invalid")
                    }
                }
            }
                
            .onChange(of: homeDirectoryViewModel.groupitems) { newValue in
                if newValue == false {
                        print("DirectoryViewModel.groups \(homeDirectoryViewModel.groupitems)")
                        homeDirectoryViewModel.GetGroupList()
                        print("onchange of  homeDirectoryViewModel.groups")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        if !homeDirectoryViewModel.groupList.isEmpty {
                            groupNamesArray = homeDirectoryViewModel.groupList
                                .compactMap { $0.groupName }
                                .flatMap { $0.components(separatedBy: ",") }
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                            print("groupNamesArray: \(groupNamesArray)")

                            for (index, group) in groupNamesArray.enumerated() {
                                print("Group \(index + 1): \(group)")
                            }

                        }
                        
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
                
                if isProfileDialogue {
                    ZStack {
                        Color.black.opacity(0.5)
                              .edgesIgnoringSafeArea(.all)
                              .onTapGesture {
                                  withAnimation {
                                      isProfileDialogue = false
                                  }
                              }
                        VStack {
                            if let diary = homeDirectoryViewModel.DirectoryData.first(where: { $0.id == id }) {
                                HStack{
                                    let image = diary.profile ?? ""
                                    AsyncImage(url: URL(string: image)) { phase in
                                        switch phase {
                                        case .empty:
                                            Image("contactW")
                                                .resizable()
                                                .renderingMode(.template)
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .background(themesviewModel.currentTheme.colorAccent)
                                                .clipShape(Circle())
                                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                .padding(.leading, 10)
                                                .padding([.top , .bottom], 10)
                                                .contentShape(Rectangle())
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .aspectRatio(contentMode: .fit)
                                                .clipShape(Circle())
                                                .padding([.top , .bottom], 10)
                                                .padding([.trailing,.leading],5)
                                        case .failure:
                                            Image("contactW")
                                                .resizable()
                                                .renderingMode(.template)
                                                .scaledToFill()
                                                .frame(width: 50, height: 50)
                                                .background(themesviewModel.currentTheme.colorAccent)
                                                .clipShape(Circle())
                                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                .padding(.leading, 10)
//                                                .padding([.top , .bottom], 10)
                                                .contentShape(Rectangle())
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                    
                                    .padding(.leading , 150)
                                    Spacer() // Push profile image & name to the right
                                    Image("cross")
                                        .resizable()
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                        .padding([.top , .bottom], 10)
                                        .padding(.trailing, 10)
                                        .onTapGesture {
                                            print("diary.profile \(diary.profile ?? "")")
                                            withAnimation {
                                                isProfileDialogue = false // Close dialog on tap
                                            }
                                        }
                                }
                                
                                .background(themesviewModel.currentTheme.attachmentBGColor)
                                
                                VStack {
                                
                                Text("\(diary.firstname) \(diary.lastname)")
                                    .font(.custom("Poppins-SemiBold", size: 14))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 8)
                                
                                // tCode and Email
                                HStack {
                                    Text("tCode: \(diary.tCode.prefix(4))******")
                                        .font(.body)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    Image("profilemail")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                    
                                }
                                
                                // Location and Languages
                                HStack {
                                    Image("profileLocation")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                    
                                    Text(diary.place ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    
                                    
                                    Text("|")
                                    
                                    Image("profileLanguage")
                                        .resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                    
                                    if let data = homeDirectoryViewModel.profileIdData.first(where: { $0.userId == diary.id }) {
                                        Text(data.languages ?? "")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                    }
                                    else {
                                        Text("N/A")
                                    }
                                }
                                
                                Divider()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 2)
                                    .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                    .padding(.horizontal, 12)
                                
                                HStack {
                                    
                                    Button(action: {
                                        homeDirectoryViewModel.AddContact(contacts: diary.userId)
                                        print("diary.userId  \(diary.userId)")
                                        isProfileDialogue = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            homeDirectoryViewModel.GetGroupList()
                                        }
                                    }) {
                                        Image("profileContact")
                                    }
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    
                                    
                                    Button(action: {
                                        isProfileDialogue = false
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            moveToNewGroup = true
                                        }
                                    }) {
                                        Image("profileMove")
                                    }
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    
                                    
                                    Button(action: {
                                        isProfileDialogue = false
                                        reportView = true
                                    }) {
                                        Image("profileReport")
                                    }
                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                    
                                    
                                    Button(action: {
                                        isProfileDialogue = false
                                        let blockedUserIDs = homeDirectoryViewModel.blockedUsers.compactMap { $0.currentUserBlockedUsers }.flatMap { $0 }
                                        print("Currently blocked user IDs: \(blockedUserIDs)")

                                        let isBlocked = homeDirectoryViewModel.blockedUsers.contains { $0.currentUserBlockedUsers?.contains(diary.userId) ?? false }
                                        print("Checking if user ID \(diary.userId) is blocked: \(isBlocked)")

                                        if isBlocked {
                                            print("Unblock works")
                                            showingBlockAlert = true
                                        } else {
                                            print("Block works")
                                            showingBlockAlert = true
//                                            homeDirectoryViewModel.blockContact(id: diary.userId, type: "block")
                                        }
                                        isblocked.toggle()
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            homeDirectoryViewModel.GetDirectoryList()
                                        }
                                    }) {
                                        Image(isblocked ? "unblock" : "profileBlocked")
                                    }

                                    .frame(width: 30, height: 30)
                                    .padding(5)
                                }
                             }
                                .padding(20)
                            } else {
                                Text("else case")
                            }
                        }
                        .onAppear{
                            let blockedUserIDs = homeDirectoryViewModel.blockedUsers
                                .compactMap { $0.currentUserBlockedUsers }
                                .flatMap { $0 }
                            isblocked = blockedUserIDs.contains(id)

                            homeDirectoryViewModel.GetDirectoryList()
                        }
                        
                        .background(themesviewModel.currentTheme.windowBackground) // Dialog background
                        .cornerRadius(12) // Rounded corners
                        .shadow(radius: 10) // Shadow for the dialog
                        .padding(.horizontal, 16) // Padding from the screen edges
                        .onTapGesture {
                            withAnimation {
                                isProfileDialogue = false // Dismiss the dialog
                            }
                        }
                    }
                }
                

                if isSearchDialogVisible {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isSearchDialogVisible = false
                                }
                            }
                        
                        VStack {
                            
                            Menu {
                                ForEach(homeDirectoryViewModel.countryCodes.indices, id: \.self) { index in
                                    Button {
                                        homeDirectoryViewModel.selectCountry(at: index)
                                        homeDirectoryViewModel.country = homeDirectoryViewModel.countryCodes[index].countryName
                                        print("country name  \(homeDirectoryViewModel.country)")
                                    } label: {
                                        Text(homeDirectoryViewModel.countryCodes[index].countryName)
                                    }
                                }
                            } label: {
                                    Text(homeDirectoryViewModel.selectedCountryIndex != nil ?
                                         homeDirectoryViewModel.countryCodes[homeDirectoryViewModel.selectedCountryIndex!].countryName :
                                         "Select Country")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)

                                    Spacer()

                                    Image("arrowDown")
                                        .foregroundColor(themesviewModel.currentTheme.colorControlNormal)
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing , 16)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                            
                            
                            
                            // State menu
                            Menu {
                                ForEach(homeDirectoryViewModel.allStates.indices, id: \.self) { index in
                                    Button {
                                        homeDirectoryViewModel.selectState(at: index)
                                        homeDirectoryViewModel.state = homeDirectoryViewModel.allStates[index].stateName
                                        print("state name  \(homeDirectoryViewModel.state)")
                                    } label: {
                                        Text(homeDirectoryViewModel.allStates[index].stateName)
                                    }
                                }
                            } label: {
                                
                                    Text(homeDirectoryViewModel.selectedStateIndex != nil ?
                                         homeDirectoryViewModel.allStates[homeDirectoryViewModel.selectedStateIndex!].stateName :
                                         "Select State")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)

                                    Spacer()

                                    Image("arrowDown")
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing , 16)

                            }
                            
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                            
                            
                            
                            // City menu
                            Menu {
                                ForEach(homeDirectoryViewModel.citiesInSelectedState.indices, id: \.self) { index in
                                    Button {
                                        homeDirectoryViewModel.selectCity(at: index)
                                        homeDirectoryViewModel.city = homeDirectoryViewModel.citiesInSelectedState[index]
                                        print("city name  \(homeDirectoryViewModel.city)")
                                    } label: {
                                        Text(homeDirectoryViewModel.citiesInSelectedState[index])
                                    }
                                }
                            } label: {
                                    Text(homeDirectoryViewModel.selectedCityIndex != nil ?
                                         homeDirectoryViewModel.citiesInSelectedState[homeDirectoryViewModel.selectedCityIndex!] :
                                         "Select City")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)

                                    Spacer()

                                    Image("arrowDown")
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing , 16)
                                

                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                            
                            

                            HStack {
                                Spacer()
                                Button(action: {
                                    print("Button clicked!")
                                    homeDirectoryViewModel.selectedCountryIndex = nil
                                    homeDirectoryViewModel.selectedStateIndex = nil
                                    homeDirectoryViewModel.selectedCityIndex = nil
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                        isSearchDialogVisible = false
                                        serachView = false
                                        homeDirectoryViewModel.country = ""
                                        homeDirectoryViewModel.state = ""
                                        homeDirectoryViewModel.city = ""
                                        directoryView = true
                                    }
                                }) {
                                    Text("Reset")
                                        .font(.headline)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .cornerRadius(10)
                                        .padding([.top , .bottom] , 5)
                                        .padding([.leading , .trailing] , 10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                }
                                .padding(.trailing, 16) // Align "Create" button to trailing
                                
                                Button(action: {
                                    if homeDirectoryViewModel.country.isEmpty {
                                        homeDirectoryViewModel.error = "Please Enter The Country"
                                    }
                                    else if homeDirectoryViewModel.state.isEmpty {
                                        homeDirectoryViewModel.error = "Please Enter The State"
                                    }
                                    else if homeDirectoryViewModel.city.isEmpty {
                                        homeDirectoryViewModel.error = "Please Enter The City"
                                    }
                                    else {
                                        print("click on search")
                                        isSearchDialogVisible = false
                                        directoryView = false
                                        serachView = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            homeDirectoryViewModel.GetsearchData(country: homeDirectoryViewModel.country , state: homeDirectoryViewModel.state, city: homeDirectoryViewModel.city)
                                        }
//                                    homeDirectoryViewModel.selectedCountryIndex = nil
//                                    homeDirectoryViewModel.selectedStateIndex = nil
//                                    homeDirectoryViewModel.selectedCityIndex = nil
                                    }
                                }) {
                                    Text("Search")
                                        .font(.headline)
                                        .padding([.top , .bottom] , 5)
                                        .padding([.leading , .trailing] , 10)
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16)
                            }
                            .padding(.top , 10)
                            .padding(.bottom , 15)

                        }
                        .padding(20)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                    .zIndex(1) // Ensure this is on top of other views
                    .onTapGesture {
                        print("zstack prints")
                        homeDirectoryViewModel.getStatesAndCities()
                        
                    }
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
                
                if moveToNewGroup {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()

                        VStack {
                            Spacer() // Push modal to bottom

                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(groupNamesArray, id: \.self) { groupName in
                                    HStack {
                                        Button(action: {
                                            print("Clicked on group: \(groupName)")
                                            if let data = homeDirectoryViewModel.groupList.first(where: {$0.groupName == groupName}) {
                                                homeDirectoryViewModel.movetoGroups(GroupdID: data.id, userIDs: [id])
                                                print("data.id  \(data.id)   , user id \(id)")
                                                moveToNewGroup = false
                                            }
                                           
                                        }) {
                                            Text(groupName)
                                                .foregroundColor(.black)
                                        }
                                        .buttonStyle(.plain)
                                        .padding(.leading, 16)
                                        Spacer()
                                    }
                                }
                            }
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .background(themesviewModel.currentTheme.windowBackground)
                            .cornerRadius(20)
                            .padding(.horizontal, 10)
                            .transition(.move(edge: .bottom)) // Slide up from bottom
                            .animation(.easeInOut, value: moveToNewGroup) // Animate ZStack change
                        }
                        .onAppear {
                            print("id \(id)")
                            homeDirectoryViewModel.GetGroupList()
                            print("groupNamesArray  \(groupNamesArray)")
                        }
                    }
                    
                }
                
                if reportView{
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                            .onTapGesture {
                                reportView = false
                            }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            if let diary = homeDirectoryViewModel.DirectoryData.first(where: { $0.id == id }) {
                                HStack {
                                    Text("Report Your Guidance")
                                        .font(.custom(.poppinsSemiBold, size: 18))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading , 16)
                                        .padding(.top , 16)
                                    
                                    Spacer()
                                    
                                    Image("wrongmark")
                                        .padding(.trailing , 16)
                                        .onTapGesture {
                                            reportView = false
                                        }
                                    
                                }
                                
                                Text("tContact")
                                    .font(.custom(.poppinsSemiBold, size: 14))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                
                                HStack {
                                    Text("\(diary.firstname) \(diary.lastname) < tCode:\(diary.tCode) >")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading, 16)   // text’s left inside padding
                                        .padding(.vertical, 10)  // top & bottom inside padding
                                    Spacer() // push text to leading
                                }
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                                .padding(.horizontal, 16) // OUTSIDE border margin


                                
                                Text("Reported By")
                                    .font(.custom(.poppinsSemiBold, size: 14))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                
                                HStack {
                                    Text("\(sessionManager.userName) \(sessionManager.LastName)")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.leading, 16)   // text’s left inside padding
                                        .padding(.vertical, 10)  // top & bottom inside padding
                                    Spacer() // push text to leading
                                }
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                )
                                .padding(.horizontal, 16) // OUTSIDE border margin

                                Text("What happened?*")
                                    .font(.custom(.poppinsSemiBold, size: 14))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading , 16)
                                
                                
                                ZStack(alignment: .leading) {
                                    TextEditor(text: $homeDirectoryViewModel.reportissue)
                                        .scrollContentBackground(.hidden)
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(4)
                                        .font(.custom(.poppinsLight, size: 14))
                                        .background(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black.opacity(0.1), lineWidth: 1)
                                        )
                                        .frame(height: 150, alignment: .leading)
                                        .padding(.horizontal, 16) // OUTSIDE border margin
                                    
                                    if homeDirectoryViewModel.reportissue.isEmpty {
                                        Text("Please describe the problem and include any error messages")
                                            .font(.custom(.poppinsLight, size: 14))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.leading, 20)
                                    }
                                }
                                .padding(.bottom , 10)
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        print("click on submit")
                                        print("homeDirectoryViewModel.reportissue \(homeDirectoryViewModel.reportissue)")
                                        print("diary.tCode  \(diary.tCode)")
                                        homeDirectoryViewModel.reportContact(descriptions: homeDirectoryViewModel.reportissue, tcode: diary.tCode)
                                        reportView = false
                                    }) {
                                        Text("Submit")
                                            .font(.custom(.poppinsSemiBold, size: 14))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding()
                                            .background(
                                                Color.blue
                                                    .cornerRadius(10) // 👈 Put the corner radius *inside* the background
                                            )
                                    }
                                    .padding([.trailing, .bottom], 10)
                                }

                            }
                        }
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                        
                    }
                  
                }

                if threeDotsView {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    threeDotsView = false
                                }
                            }

                        VStack {
                            Spacer() // Push modal to bottom

                            VStack(alignment: .leading, spacing: 20) {
                                Button(action: {
                                    threeDotsView = false
                                    isRenameDialogVisible = true
                                }) {
                                    HStack {
                                        Text("Rename")
                                            .font(.custom(.poppinsRegular, size: 14))
                                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                        Spacer()
                                    }
                                    .padding(.leading, 16)
                                }

                                Button(action: {
                                    print("clicked on delete icon")
                                    threeDotsView = false
                                    showingDeleteAlert = true
                                }) {
                                    HStack {
                                        Text("Delete")
                                            .font(.custom(.poppinsRegular, size: 14))
                                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                        Spacer()
                                    }
                                    .padding(.leading, 16)
                                }

                                Button(action: {
                                    threeDotsView = false
                                    DetailsView = true
                                }) {
                                    HStack {
                                        Text("Details")
                                            .font(.custom(.poppinsRegular, size: 14))
                                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                        Spacer()
                                    }
                                    .padding(.leading, 16)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .background(themesviewModel.currentTheme.windowBackground)
                            .cornerRadius(20)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: threeDotsView)

                        }
                    }
                }

                if isRenameDialogVisible {
                    ZStack {
                        // Blur background
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isRenameDialogVisible = false
                                }
                            }
                        
                        VStack{
                                HStack {
                                    Text("Rename group name")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsSemiBold, size: 16))
                                        .padding(.leading, 16)
                                    Spacer()
                                    Image("cross")
                                        .resizable()
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                        .onTapGesture {
                                            withAnimation {
                                                isRenameDialogVisible = false
                                            }
                                        }
                                    
                                }

                            floatingTextField(placeHolder : "Group name*", text:  $homeDirectoryViewModel.RenameGroupName)
                                .padding(.top , 15)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    isRenameDialogVisible = false
                                    homeDirectoryViewModel.RenameGroup(id: homeDirectoryViewModel.groupID, groupname: homeDirectoryViewModel.RenameGroupName)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        homeDirectoryViewModel.GetGroupList()
                                    }
                                }) {
                                    Text("Rename")
                                        .padding([.top , .bottom] , 5)
                                        .padding([.leading , .trailing] , 10)
                                        .font(.custom(.poppinsSemiBold, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16) // Align "Create" button to trailing
                                .padding([.top , .bottom], 15)
                            }
                            
                        }
                        .padding(10)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                    .zIndex(1) // Ensure this is on top of other views
                }
                
                if DetailsView {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    DetailsView = false
                                }
                            }

                        VStack {
                            Spacer() // Push modal to bottom

                            VStack(alignment: .leading, spacing: 20) {
                                if let data = homeDirectoryViewModel.groupList.first(where: {$0.id == homeDirectoryViewModel.groupID}) {
                                    HStack {
                                        Text("Created At:")
                                            .font(.custom(.poppinsRegular, size: 12))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            
                                        
                                        Spacer()
                                        
                                        let unixTimestamp = data.createdAt ?? ""
                                        if let istDateStringFromISO = convertToIST(dateInput: unixTimestamp) {
                                            Text(istDateStringFromISO)
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.top, 0) // Adds 5 points of padding from the top
                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                        }
                                        
 
                                        
                                    }
                                    .padding(.horizontal , 16)

                                    HStack {
                                        Text("Updated At:")
                                            .font(.custom(.poppinsRegular, size: 12))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        
                                        Spacer()
                                        
                                        let unixTimestamp = data.updatedAt ?? ""
                                        if let istDateStringFromISO = convertToIST(dateInput: unixTimestamp) {
                                            Text(istDateStringFromISO)
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.top, 0) // Adds 5 points of padding from the top
                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                        }

                                        
                                    }
                                    .padding(.horizontal , 16)

                                    HStack {
                                        Text("Total members:")
                                            .font(.custom(.poppinsRegular, size: 12))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        
                                        Spacer()
                                        
                                        Text("\(data.totalMembers ?? 0)")
                                            .font(.custom(.poppinsRegular, size: 12))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        
                                    }
                                    .padding(.horizontal , 16)
//
                                }
//
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .background(themesviewModel.currentTheme.windowBackground)
                            .cornerRadius(20)
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: DetailsView)

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
                                }
                            }
                        
                        VStack{
                                HStack {
                                    Text("Create new group")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsSemiBold, size: 16))
                                        .padding(.leading, 16)
                                    Spacer()
                                    Image("cross")
                                        .resizable()
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .frame(width: 20, height: 20)
                                        .onTapGesture {
                                            withAnimation {
                                                isContactsDialogVisible = false
                                            }
                                        }
                                    
                                }

                            
                            
//                            floatingtextfield(text: $homeDirectoryViewModel.groupName, placeHolder: "Group name*", allowedCharacter: .defaultType)
//                                .padding(.horizontal, 10)
//                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            
                            floatingTextField(placeHolder : "Group name*", text:  $homeDirectoryViewModel.groupName)
                                .padding(.top , 15)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    print("$homeDirectoryViewModel.groupName \(homeDirectoryViewModel.groupName)")
                                    homeDirectoryViewModel.createGRoup(groupname: homeDirectoryViewModel.groupName)
                                    isContactsDialogVisible = false
                                    homeDirectoryViewModel.groupitems = true
                                    print("before homeDirectoryViewModel.groupitems \(homeDirectoryViewModel.groupitems)")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        homeDirectoryViewModel.GetGroupList()
                                        homeDirectoryViewModel.groupitems = false
                                        print("After Dispatch homeDirectoryViewModel.groupitems \(homeDirectoryViewModel.groupitems)")
                                    }
                                }) {
                                    Text("Create")
                                        .padding([.top , .bottom] , 5)
                                        .padding([.leading , .trailing] , 10)
                                        .font(.custom(.poppinsSemiBold, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing, 16) // Align "Create" button to trailing
                                .padding([.top , .bottom], 15)
                            }
                            
                        }
                        .padding(10)
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                        .padding(.horizontal, 16)
                    }
                    .zIndex(1) // Ensure this is on top of other views
                }
                
                if showingBlockAlert {
                    ZStack {
                        Color.gray.opacity(0.5) // Dimmed background
                            .ignoresSafeArea()
                            .transition(.opacity)

                        
                        // Centered DeleteNoteAlert
                        if isblocked {
                            blockAlert(isPresented: $showingBlockAlert , AlertText: "Are you sure that you want to Block this user?") {
                                    print("delete alert")
                                    homeDirectoryViewModel.blockContact(id: id, type: "block")
                                    self.showingBlockAlert = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        homeDirectoryViewModel.GetDirectoryList()
                                    }
                            }
                            .transition(.scale)
                        }
                        else {
                            blockAlert(isPresented: $showingBlockAlert , AlertText: "Are you sure that you want to UnBlock this user?") {
                                    print("delete alert")
                                    homeDirectoryViewModel.blockContact(id: id, type: "unblock")
                                    self.showingBlockAlert = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        homeDirectoryViewModel.GetDirectoryList()
                                    }
                            }
                            .transition(.scale)
                        }
                        
                    }
                }
                
                if showingDeleteAlert {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showingDeleteAlert = false
                        }
                    
                    DeleteAlert(isPresented: $showingDeleteAlert) {
                        homeDirectoryViewModel.deleteEmail(id: homeDirectoryViewModel.groupID)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            homeDirectoryViewModel.GetGroupList()
                            threeDotsView = false
                            GroupView = false
                            directoryView = true
                        }
                    }
                    .transition(.scale)
                    .animation(.easeInOut, value: showingDeleteAlert)
                }

                
        }
            
            .zIndex(0)
            .onTapGesture {
                print("main view zstack clicked")
                isSearchDialogVisible = false
                homeDirectoryViewModel.getStatesAndCities()
            }

        }
        .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
            SearchView(appBarElementsViewModel: appBarElementsViewModel)
                .toolbar(.hidden)
        }
        .navigationDestination(isPresented: $homeDirectoryViewModel.isComposeEmail) {
            MailComposeView().toolbar(.hidden)
        }
//        .navigationDestination(isPresented: $appBarElementsViewModel.isSearch) {
//            SearchView(appBarElementsViewModel: appBarElementsViewModel)
//                .toolbar(.hidden)
//        }

    }
}


struct DirectoryView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a binding with a default value for isHomeDirectoryVisible
        let isHomeDirectoryVisible = Binding.constant(true)
        return HomeDirectoryView(isHomeDirectoryVisible: isHomeDirectoryVisible, imageUrl: "")
    }
}



struct blockAlert: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var themesviewModel = themesViewModel()
    @Binding var isPresented: Bool
    var AlertText: String
    var onDelete: () -> Void
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Alert card
            VStack(spacing: 24) {
                // Warning icon
                Circle()
                    .fill(Color(UIColor.systemPink).opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.black)
                    )
                
                // Title
                Text("Confirmation")
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Message
//                Are you sure that you want to Block this user?
                Text(AlertText)
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                // Buttons
                HStack(spacing: 20) {
                    // No button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("No")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    
                    // Yes button
                    Button(action: {
                        onDelete()
                        isPresented = false
                    }) {
                        Text("Yes")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(24)
            .background(themesviewModel.currentTheme.windowBackground)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
    }
}
