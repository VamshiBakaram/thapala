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
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
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
    @State private var showingDeleteAlert = false
    @State private var selectedIndices: Set<Int> = []
    @State private var isSelectAll = false
    @State private var markAs : Int = 0
    var body: some View {
            GeometryReader{ reader in
                ZStack(alignment: .bottomTrailing) {
                    themesviewModel.currentTheme.windowBackground
                        .ignoresSafeArea()
                    VStack{
                        if homeConveyedViewModel.beforeLongPress{
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
                                    
                                    Text("Conveyed")
                                        .padding(.leading,5)
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
                                        withAnimation {
                                            isMenuVisible.toggle()
                                        }
                                    }) {
                                        Image("MenuIcon")
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                            .font(Font.title.weight(.medium))
                                    }
                                    .padding([.leading,.trailing],15)
                                    
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
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    VStack(alignment:.leading){
                                                        Text("tSent")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 15, height: 15)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    VStack(alignment:.leading){
                                                        Text("tDispatch")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                        .resizable()
                                                        .renderingMode(.template)
                                                        .frame(width: 15, height: 15)
                                                        .padding(5)
                                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .fill(themesviewModel.currentTheme.tabBackground)
                                                        )
                                                    VStack(alignment:.leading){
                                                        Text("Acknowledgement")
                                                            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .lineLimit(1)
                                                    }
                                                }
                                            }
                                            
                                        )
                                }
                                .padding([.leading,.trailing,],5)
                                .padding(.bottom , 10)
                                
                            }
                            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 30)
//                            .frame(height: reader.size.height * 0.16)
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
                                        Spacer()
                                        Text("\(selectedIndices.count) Selected")
                                            .font(.custom(.poppinsRegular, size: 16))
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        
                                        Spacer()
                                        
                                        Button {
                                            homeConveyedViewModel.beforeLongPress = true
                                            homeConveyedViewModel.selectedThreadIDs = []
                                            selectedIndices = []
                                            
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
                                                if selectedIndices.count == homeConveyedViewModel.conveyedEmailData.count {
                                                    selectedIndices.removeAll()
                                                    homeConveyedViewModel.selectedThreadIDs = []
                                                    isSelectAll = false
                                                } else {
                                                    selectedIndices = Set(homeConveyedViewModel.conveyedEmailData.compactMap { $0.threadID })
                                                    isSelectAll = true
                                                    homeConveyedViewModel.selectedThreadIDs = Array(selectedIndices)
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
                                    .padding(.leading,15)
                                    
                                }
                            
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
                                            if homeConveyedViewModel.beforeLongPress {
                                                List(homeConveyedViewModel.conveyedEmailData) { data in
                                                    VStack(spacing: 0) {
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
                                                                    Text("\(data.firstname ?? "")")
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsMedium, size: 16))
                                                                    
                                                                    if data.hasDraft == 1 {
                                                                        Text("Draft")
                                                                            .foregroundColor(Color.red)
                                                                            .font(.custom(.poppinsMedium, size: 14))
                                                                            .padding(.leading , 5)
                                                                    }
                                                                }
                                                                Text(data.subject ?? "No Subject")
                                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    .font(.custom(.poppinsMedium, size: 14))
                                                                    .lineLimit(1)
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            VStack(alignment: .trailing) {
                                                                if let unixTimestamp = data.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                                                    Text(istDateStringFromTimestamp)
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                        .padding(.trailing , 10)
                                                                }
                                                                
                                                                Image(data.starred == 1 ? "star" : "emptystar")
                                                                    .resizable()
                                                                    .renderingMode(.template)
                                                                    .frame(width: 20, height: 20)
                                                                    .padding(.trailing , 10)
                                                                    .foregroundColor(data.starred == 1 ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                                    .onTapGesture {
                                                                        if let threadID = data.threadID,
                                                                           let index = homeConveyedViewModel.conveyedEmailData.firstIndex(where: { $0.threadID == threadID }) {
                                                                            homeConveyedViewModel.conveyedEmailData[index].starred = (homeConveyedViewModel.conveyedEmailData[index].starred == 1) ? 0 : 1
                                                                            homeConveyedViewModel.getStarredEmail(selectedEmail: threadID)
                                                                            homeConveyedViewModel.selectedID = data.threadID
                                                                            homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
                                                                        }
                                                                    }
                                                            }
                                                        }
                                                        .padding(.vertical, 8)
                                                        .onTapGesture {
                                                            conveyedView = true
                                                            homeConveyedViewModel.beforeLongPress = false
                                                            homeConveyedViewModel.selectedID = data.threadID
                                                            homeConveyedViewModel.passwordHint = data.passwordHint
                                                            homeConveyedViewModel.isEmailScreen = true
                                                            homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
                                                        }
                                                        .gesture(
                                                            LongPressGesture(minimumDuration: 1.0)
                                                                .onEnded { _ in
                                                                    withAnimation {
                                                                        homeConveyedViewModel.beforeLongPress = false
                                                                        selectedIndices.insert(data.threadID ?? 0)
                                                                        homeConveyedViewModel.selectedID = data.threadID
                                                                        homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
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
                                                        
                                                        Divider()
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 1)
                                                            .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                                        //                                                            .padding(.leading, 60) // Optional: Indent divider
                                                    }
                                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                }
                                                .listStyle(PlainListStyle())
                                                .scrollContentBackground(.hidden)
                                            }
                                            
                                            else {
                                                ZStack(alignment: .bottomTrailing) {
                                                List(homeConveyedViewModel.conveyedEmailData) { data in
                                                    VStack {
                                                        HStack {
                                                            Button(action: {
                                                                if let threadId = data.threadID {
                                                                    if selectedIndices.contains(threadId) {
                                                                        selectedIndices.remove(threadId)
                                                                        homeConveyedViewModel.selectedThreadIDs.removeAll { $0 == threadId }
                                                                    } else {
                                                                        selectedIndices.insert(threadId)
                                                                        homeConveyedViewModel.selectedThreadIDs.append(threadId)
                                                                    }
                                                                    isSelectAll = selectedIndices.count == homeConveyedViewModel.conveyedEmailData.count
                                                                }
                                                            }) {
                                                                Image(selectedIndices.contains(data.threadID ?? -1) ?  "selected" : "contactW")
                                                                    .resizable()
                                                                    .renderingMode(.template)
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
                                                                    Text("\(data.firstname ?? "")")
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsMedium, size: 16))
                                                                    
                                                                    if data.hasDraft == 1 {
                                                                        Text("Draft")
                                                                            .foregroundColor(Color.red)
                                                                            .font(.custom(.poppinsMedium, size: 14))
                                                                            .padding(.leading , 5)
                                                                    }
                                                                }
                                                                Text(data.subject ?? "No Subject")
                                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    .font(.custom(.poppinsMedium, size: 14))
                                                                    .lineLimit(1)
                                                            }
                                                            
                                                            Spacer()
                                                            
                                                            VStack(alignment: .trailing) {
                                                                if let unixTimestamp = data.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                                                    Text(istDateStringFromTimestamp)
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                        .padding(.trailing , 10)
                                                                }
                                                                
                                                                Image(data.starred == 1 ? "star" : "emptystar")
                                                                    .resizable()
                                                                    .renderingMode(.template)
                                                                    .frame(width: 20, height: 20)
                                                                    .foregroundColor(data.starred == 1 ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                                    .padding(.trailing , 10)
                                                                    .onTapGesture {
                                                                        if let threadID = data.threadID,
                                                                           let index = homeConveyedViewModel.conveyedEmailData.firstIndex(where: { $0.threadID == threadID }) {
                                                                            homeConveyedViewModel.conveyedEmailData[index].starred = (homeConveyedViewModel.conveyedEmailData[index].starred == 1) ? 0 : 1
                                                                            homeConveyedViewModel.getStarredEmail(selectedEmail: threadID)
                                                                        }
                                                                    }
                                                            }
                                                        }
                                                        Divider()
                                                            .frame(maxWidth: .infinity)
                                                            .frame(height: 1)
                                                            .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                                            .padding(.top,2)
                                                            .padding(.bottom,2)
                                                        //                                                            .padding(.leading, 60) // Optional: Indent divider
                                                    }
                                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                }
                                                .listStyle(PlainListStyle())
                                                .scrollContentBackground(.hidden)
                                                
                                                
                                                HStack {
//                                                    Spacer()
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
                                                .padding(.bottom , 30)
                                                
                                                
                                                
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
                                                }
                                                .background(themesviewModel.currentTheme.colorPrimary)
                                            }
                                          }
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
                        if homeConveyedViewModel.beforeLongPress{
//                                HStack {
//                                    RoundedRectangle(cornerRadius: 30)
//                                        .fill(themesviewModel.currentTheme.colorPrimary)
//                                        .frame(width: 150, height: 48)
//                                        .overlay(
//                                            HStack {
//                                                Text("New Email")
//                                                    .font(.custom(.poppinsBold, size: 14))
//                                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
//                                                    .padding(.trailing, 8)
//                                                    .onTapGesture {
//                                                        homeConveyedViewModel.isComposeEmail = true
//                                                    }
//                                                Spacer()
//                                                    .frame(width: 1, height: 24)
//                                                    .background(themesviewModel.currentTheme.inverseIconColor)
//                                                Image("dropdown 1")
//                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
//                                                    .onTapGesture {
//                                                        isQuickAccessVisible = true
//                                                        
//                                                    }
//                                            }
//                                        )
//                                        .padding(.trailing, 20)
//                                        .padding(.bottom, 20)
//                                }
                            
                            TabViewNavigator()
                                .frame(height: 40)
                                .padding(.bottom , 10)
                            
                        }

                        
                        
                    }
                    .toast(message: $homeConveyedViewModel.error)
                    .background(themesviewModel.currentTheme.windowBackground)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            homeConveyedViewModel.getConveyedEmailData()
                        }
                    }
                    
                    if homeConveyedViewModel.beforeLongPress{
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
                            // Centered DeleteNoteAlert
                            DeleteAlert(isPresented: $showingDeleteAlert) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                    homeAwaitingViewModel.deleteEmailFromAwaiting(threadIDS: homeConveyedViewModel.selectedThreadIDs)
                                    showingDeleteAlert = false
                                    homeConveyedViewModel.beforeLongPress = true
                                }
                                
                                homeConveyedViewModel.conveyedEmailData.removeAll { item in
                                    homeConveyedViewModel.selectedThreadIDs.contains(item.id)
                                }
                                
                                selectedIndices.removeAll()
                            }
                        }
                        .transition(.scale)
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
                }


                .navigationDestination(isPresented: $homeConveyedViewModel.isEmailScreen) {
                    MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: homeConveyedViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs).toolbar(.hidden)
                }
                //
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
