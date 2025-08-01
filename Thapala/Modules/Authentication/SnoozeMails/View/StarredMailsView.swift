//
//  StarredMailsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/10/24.
//

import SwiftUI

struct StarredMailsView: View {
    @StateObject var themesviewModel = ThemesViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject var starredEmailViewModel = StarredEmailViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = "awaited"
    @State private var beforeLongPress = true
    @State private var isMultiSelectionSheetVisible: Bool = false
    @State private var isMenuVisible = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    @State private var markAs : Int = 0
    
    var body: some View {
        GeometryReader{ reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
                VStack {
                    HStack {
                        Button {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.backward")
                            
                        }
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        
                        Spacer()
                        Text("Starred EMails")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsSemiBold, size: 16))
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 12)
                    HStack {
                        Button(action: { selectedTab = "awaited";
                            starredEmailViewModel.getStarredEmailData(selectedTabItem: selectedTab);
                            }) {
                                Text("Queue")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedTab == "awaited" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(20)
                            }
                        
                        Button(action: { selectedTab = "postbox";
                            starredEmailViewModel.getStarredEmailData(selectedTabItem: selectedTab);
                         
                        }) {
                                Text("Postbox")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedTab == "postbox" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(10)
                            }
                        
                        Button(action: { selectedTab = "conveyed" ;
                            starredEmailViewModel.getStarredEmailData(selectedTabItem: selectedTab);
                       
                        }) {
                                Text("Conveyed")
                                    .fontWeight(.medium)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(selectedTab == "conveyed" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .cornerRadius(10)
                            }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                    )
                    
                    
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .padding(.top)
                    if selectedTab == "awaited" {
                        QueueSnoozedMailsView
                    }
                    
                    if selectedTab == "postbox" {
                        postBoxMailsView
                    }
                    if selectedTab == "conveyed" {
                        converyedMailsView
                    }
                    
                    Spacer()
                }
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear {
                    // Initialize with "awaited" to show QueueSnoozedMailsView on appear
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        selectedTab = "awaited"
                        starredEmailViewModel.getStarredEmailData(selectedTabItem: selectedTab)
                    }
                }
                .sheet(isPresented: $isMultiSelectionSheetVisible, content: {
                    EmailOptionsView(
                        replyAction: { dismissSheet() },
                        replyAllAction: { dismissSheet() },
                        forwardAction: { dismissSheet() },
                        markAsReadAction: { dismissSheet() },
                        markAsUnReadAction: { dismissSheet() },
                        createLabelAction: { dismissSheet() },
                        moveToFolderAction: { dismissSheet() },
                        starAction: { dismissSheet() },
                        snoozeAction: { dismissSheet() },
                        trashAction: { dismissSheet() }
                    )
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
                })
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
            }
        }
    }
    
    var QueueSnoozedMailsView: some View {
        VStack {
            if beforeLongPress {
                if  starredEmailViewModel.starredEmailData.count == 0 {
                    VStack {
                        Text("No mails found")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(themesviewModel.currentTheme.windowBackground)
                }
                else {
                    List($starredEmailViewModel.starredEmailData, id: \.id) { $email in
                        VStack {
                            HStack {
                                VStack {
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
                                    Spacer()
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
                                        Image("star.fill")
                                            .padding(.trailing , 16)
                                            .onTapGesture {
                                                starredEmailViewModel.getStarredEmail(selectedID: email.threadId ?? 0)
                                                
                                            }
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
                                    
                                }
                                .padding(.leading, 16)
                            }
                            .padding(.top , 10)
                            .onTapGesture {
                                PostBoxView = true
                                conveyedView = false
                                starredEmailViewModel.selectedID = email.threadId
                                starredEmailViewModel.passwordHint = email.passwordHint
                                starredEmailViewModel.isEmailScreen = true
                            }
                            .gesture(
                                LongPressGesture(minimumDuration: 1.0)
                                    .onEnded { _ in
                                        withAnimation {
                                            beforeLongPress = false
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
            } else {
                List($starredEmailViewModel.starredEmailData, id: \.id) { $email in
                    HStack {
                        Image("checkbox")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .frame(width: 24,height: 24)
                            .padding([.trailing,.leading],5)
                        VStack(alignment: .leading) {
                            Text(email.firstname ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                            Text(email.subject ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsLight, size: 14))
                                .lineLimit(1)
                        }
                        let unixTimestamp = email.sentAt ?? 0
                        if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                            Text(istDateStringFromTimestamp)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding(.top, -30)
                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                        }
                        Image("emptystar")
                            .renderingMode(.template)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                        Spacer()
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onEnded { _ in
                                withAnimation {
                                    beforeLongPress = false
                                }
                            }
                    )
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                HStack(spacing: 50) {
                    Button(action: { }) {
                        Image(systemName: "trash")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "envelope.open")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "folder")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "tag")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: {
                        isMultiSelectionSheetVisible = true
                    }) {
                        Image(systemName: "ellipsis")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
        
        
        .navigationDestination(isPresented: $starredEmailViewModel.isEmailScreen) {
            if $starredEmailViewModel.passwordHint != nil{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs).toolbar(.hidden)
            }else{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs).toolbar(.hidden)
            }
        }
    }
    
    var postBoxMailsView: some View {
        VStack {
            if beforeLongPress {
                if  starredEmailViewModel.starredEmailData.count == 0 {
                    VStack {
                        Text("No mails found")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(themesviewModel.currentTheme.windowBackground)
                }
                else {
                    List($starredEmailViewModel.starredEmailData, id: \.id) { $email in
                        VStack {
                            HStack {
                                VStack {
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
                                        Image("star.fill")
                                            .padding(.trailing , 16)
                                            .onTapGesture {
                                                starredEmailViewModel.getStarredEmail(selectedID: email.threadId ?? 0)
                                                
                                            }
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
                                }
                            }
                            padding(.top , 10)
                            
                            .onTapGesture {
                                PostBoxView = true
                                conveyedView = false
                                starredEmailViewModel.selectedID = email.threadId
                                starredEmailViewModel.passwordHint = email.passwordHint
                                starredEmailViewModel.isEmailScreen = true
                            }
                            .gesture(
                                LongPressGesture(minimumDuration: 1.0)
                                    .onEnded { _ in
                                        withAnimation {
                                            beforeLongPress = false
                                        }
                                    }
                            )
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            } else {
                List($starredEmailViewModel.starredEmailData, id: \.id) { $email in
                    HStack {
                        Image("checkbox")
                            .resizable()
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .frame(width: 24,height: 24)
                            .padding([.trailing,.leading],5)
                        VStack(alignment: .leading) {
                            Text(email.firstname ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                            Text(email.subject ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsLight, size: 14))
                                .lineLimit(1)
                        }
                        let unixTimestamp = email.sentAt ?? 0
                        if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                            Text(istDateStringFromTimestamp)
                                .padding(.top, -30)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                        }
                        Image(systemName: "star")
                        Spacer()
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onEnded { _ in
                                withAnimation {
                                    beforeLongPress = false
                                }
                            }
                    )
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                HStack(spacing: 50) {
                    Button(action: { }) {
                        Image(systemName: "trash")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "envelope.open")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "folder")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "tag")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: {
                        isMultiSelectionSheetVisible = true
                    }) {
                        Image(systemName: "ellipsis")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
        
        .navigationDestination(isPresented: $starredEmailViewModel.isEmailScreen) {
            MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars , markAs: $markAs).toolbar(.hidden)
        }
    }
    
    var converyedMailsView: some View {
        VStack {
            if beforeLongPress {
                if  starredEmailViewModel.starredEmailData.count == 0 {
                    VStack {
                        Text("No mails found")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .background(themesviewModel.currentTheme.windowBackground)
                }
                else {
                    List($starredEmailViewModel.starredEmailData, id: \.id) { $email in
                        HStack {
                            Image("person")
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(email.firstname ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 16))
                                    Text(email.lastname ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 16))
                                    Spacer()
                                    let unixTimestamp = email.sentAt ?? 0
                                    if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                        Text(istDateStringFromTimestamp)
                                            .padding(.trailing, 20)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                    }
                                }
                                HStack {
                                    Text(email.subject ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsLight, size: 14))
                                        .lineLimit(1)
                                    Spacer()
                                    Image("star.fill")
                                        .onTapGesture {
                                            starredEmailViewModel.getStarredEmail(selectedID: email.threadId ?? 0)
                                        }
                                }
                            }
                        }
                        .listRowBackground(themesviewModel.currentTheme.windowBackground)
                        .onTapGesture {
                            PostBoxView = false
                            conveyedView = true
                            starredEmailViewModel.selectedID = email.threadId
                            starredEmailViewModel.passwordHint = email.passwordHint
                            starredEmailViewModel.isEmailScreen = true
                        }
                        .gesture(
                            LongPressGesture(minimumDuration: 1.0)
                                .onEnded { _ in
                                    withAnimation {
                                        beforeLongPress = false
                                    }
                                }
                        )
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                }
            } else {
                List($starredEmailViewModel.starredEmailData, id: \.id) { $email in
                    HStack {
                        Image("checkbox")
                            .resizable()
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                            .frame(width: 24,height: 24)
                            .padding([.trailing,.leading],5)
                        VStack(alignment: .leading) {
                            Text(email.firstname ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                            Text(email.subject ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsLight, size: 14))
                                .lineLimit(1)
                        }
                        let unixTimestamp = email.sentAt ?? 0
                        if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                            Text(istDateStringFromTimestamp)
                                .padding(.top, -30)
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                        }
                        Image(systemName: "star")
                        Spacer()
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .gesture(
                        LongPressGesture(minimumDuration: 1.0)
                            .onEnded { _ in
                                withAnimation {
                                    beforeLongPress = false
                                }
                            }
                    )
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                HStack(spacing: 50) {
                    Button(action: { }) {
                        Image(systemName: "trash")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "envelope.open")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "folder")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "tag")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                    
                    Button(action: {
                        isMultiSelectionSheetVisible = true
                    }) {
                        Image(systemName: "ellipsis")
                            .frame(width: 25, height: 25)
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
        .navigationDestination(isPresented: $starredEmailViewModel.isEmailScreen) {
            if $starredEmailViewModel.passwordHint != nil{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView, conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars, markAs: $markAs).toolbar(.hidden)
            }else{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $AwaitingView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars , markAs: $markAs).toolbar(.hidden)
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
