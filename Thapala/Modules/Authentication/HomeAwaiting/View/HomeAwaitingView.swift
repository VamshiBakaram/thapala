//
//  HomeAwaitingView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import SwiftUI
struct HomeAwaitingView: View {
    @State private var isMenuVisible = false
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @StateObject var themesviewModel = themesViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var isSheetVisible = false
    @State private var isMultiSelectionSheetVisible = false
    @State private var isMoveToFolder = false
    @State private var isCreateLabel = false
    @State private var isStarred: Bool = false // Track starred state
    @State private var isQuickAccessVisible = false
    @State var firstName: String = ""
    @State var Subject: String = ""
    @State var TimeSent: Int = 0
    let imageUrl: String
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @State private var AwaitingView: Bool = false
    @State private var beforeLongPress = true
    @State private var AppBar = true
    @State private var selectedCheck = false
    @State private var iNotificationAppBarView = false
    @State private var showEmptyText = false
    @State private var isFullScreenPresented = false
    @State private var selectedIndices: Set<Int> = []
    @State private var isSelectAll = false
    @State private var showingDeleteAlert = false
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea()
                VStack{
                    if AppBar{
                        VStack {
                            HStack{
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
                                VStack (alignment:.leading) {
                                    Text("Queue")
                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                        .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                                    
                                    if let selectedOption = homeAwaitingViewModel.selectedOption {
                                        switch selectedOption {
                                        case .email:
                                            Text("\(homeAwaitingViewModel.emailFullData?.count?.unreadCount ?? "") unread")
                                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                        case .print:
                                            Text("0 unread")
                                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                        case .outline:
                                            if homeAwaitingViewModel.isDraftsSelected{
                                                Text("\(homeAwaitingViewModel.draftsData.count) count")
                                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                    .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                            }
                                            if homeAwaitingViewModel.istDraftselected{
                                                Text("\(homeAwaitingViewModel.tDraftsData.count) count")
                                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                    .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                            }
                                            if homeAwaitingViewModel.isScheduledSelected{
                                                Text("\(homeAwaitingViewModel.scheduleData.count) count")
                                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                    .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                            }
                                        }
                                    }
                                }
                                .padding(.leading,0)
                                
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
                                .padding(.leading,15)
                                /*
                                 Button(action: {
                                 print("Bagg button pressed")
                                 homeAwaitingViewModel.isComposeEmail = true
                                 }) {
                                 Image("pencil")
                                 .font(Font.title.weight(.medium))
                                 .foregroundColor(Color.white)
                                 }
                                 */
                                Button(action: {
                                    print("bell button pressed")
                                    iNotificationAppBarView = true
                                }) {
                                    Image("bell")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .font(Font.title.weight(.medium))
                                }
                                .padding(.leading,15)
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
                                .padding([.leading,.trailing],15)
                                
                            }
                            .padding(.top, -reader.size.height * 0.01)
                            //   ScrollView(.horizontal,showsIndicators: false){
                            HStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(self.homeAwaitingViewModel.isEmailSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .frame(width: reader.size.width/3 - 10, height: 45)
                                    .onTapGesture {
                                        self.homeAwaitingViewModel.selectedOption = .email
                                        print("Emailed clicked")
                                        print()
                                        print(reader.size.width/3 - 10)
                                        homeAwaitingViewModel.getEmailsData()
                                        self.homeAwaitingViewModel.isEmailSelected = true
                                        self.homeAwaitingViewModel.isPrintSelected = false
                                        self.homeAwaitingViewModel.isOntlineSelected = false
                                       
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
                                                    Text("Obtained")
                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                        .foregroundColor(self.homeAwaitingViewModel.isEmailSelected ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.textColor)
                                                }
                                            }
                                        }
                                    )
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(self.homeAwaitingViewModel.isPrintSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .frame(width: reader.size.width/3 - 10, height: 45)
                                    .onTapGesture {
                                        self.homeAwaitingViewModel.selectedOption = .print
                                        print("print clicked")
                                        self.homeAwaitingViewModel.isEmailSelected = false
                                        self.homeAwaitingViewModel.isPrintSelected = true
                                        self.homeAwaitingViewModel.isOntlineSelected = false
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
                                                        .foregroundColor(self.homeAwaitingViewModel.isPrintSelected ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.textColor)
                                                }
                                            }
                                        }
                                    )
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(self.homeAwaitingViewModel.isOntlineSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .frame(width: reader.size.width/3 - 10, height: 45)
                                    .onTapGesture {
                                        self.homeAwaitingViewModel.selectedOption = .outline
                                        print("outline clicked")
                                        
                                        self.homeAwaitingViewModel.isEmailSelected = false
                                        self.homeAwaitingViewModel.isPrintSelected = false
                                        self.homeAwaitingViewModel.isOntlineSelected = true
                                        self.homeAwaitingViewModel.getDraftsData()
                                    }
                                    .overlay(
                                        Group{
                                            HStack{
                                                Image("chatBox")
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .background(themesviewModel.currentTheme.tabBackground)
                                                VStack{
                                                    Text("Outline")
                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                        .foregroundColor(self.homeAwaitingViewModel.isOntlineSelected ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.textColor)
                                                }
                                            }
                                        }
                                    )
                            }
                            .padding([.leading,.trailing],5)
                            //}
                        }
                        .frame(height: reader.size.height * 0.16)
                        .background(themesviewModel.currentTheme.colorPrimary)
                        
                        HStack{
                            if let selectedOption = homeAwaitingViewModel.selectedOption {
                                switch selectedOption {
                                case .email:
                                    Text("")
                                case .print:
                                    
                                    Text("")
                                case .outline:
                                    Spacer()
                                    
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 12) { // Adjust spacing as needed
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(self.homeAwaitingViewModel.isDraftsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                                    .frame(width: 100, height: 50) // Add fixed width for consistent layout
                                                    .onTapGesture {
                                                        self.homeAwaitingViewModel.outlineSelectedOption = .draft
                                                        self.homeAwaitingViewModel.isDraftsSelected = true
                                                        self.homeAwaitingViewModel.istDraftselected = false
                                                        self.homeAwaitingViewModel.isScheduledSelected = false
                                                        self.homeAwaitingViewModel.istLetersSelected = false
                                                        self.homeAwaitingViewModel.istCardsSelected = false
                                                        self.homeAwaitingViewModel.getDraftsData()
                                                    }
                                                    .overlay(
                                                        Text("Drafts")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(self.homeAwaitingViewModel.isDraftsSelected ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                                    )
                                                
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(self.homeAwaitingViewModel.istDraftselected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                                    .frame(width: 100, height: 50)
                                                    .onTapGesture {
                                                        self.homeAwaitingViewModel.outlineSelectedOption = .tDraft
                                                        self.homeAwaitingViewModel.isDraftsSelected = false
                                                        self.homeAwaitingViewModel.istDraftselected = true
                                                        self.homeAwaitingViewModel.isScheduledSelected = false
                                                        self.homeAwaitingViewModel.istLetersSelected = false
                                                        self.homeAwaitingViewModel.istCardsSelected = false
                                                        self.homeAwaitingViewModel.getTDraftsData()
                                                    }
                                                    .overlay(
                                                        Text("tDrafts")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(self.homeAwaitingViewModel.istDraftselected ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                                    )
                                                
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(self.homeAwaitingViewModel.isScheduledSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                                    .frame(width: 100, height: 50)
                                                    .onTapGesture {
                                                        self.homeAwaitingViewModel.outlineSelectedOption = .schedule
                                                        self.homeAwaitingViewModel.isDraftsSelected = false
                                                        self.homeAwaitingViewModel.istDraftselected = false
                                                        self.homeAwaitingViewModel.isScheduledSelected = true
                                                        self.homeAwaitingViewModel.istLetersSelected = false
                                                        self.homeAwaitingViewModel.istCardsSelected = false
                                                        self.homeAwaitingViewModel.getScheduleEmailsData()
                                                    }
                                                    .overlay(
                                                        Text("Scheduled")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(self.homeAwaitingViewModel.isScheduledSelected ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                                    )
                                                
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(self.homeAwaitingViewModel.istLetersSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                                    .frame(width: 100, height: 50)
                                                    .onTapGesture {
                                                        self.homeAwaitingViewModel.outlineSelectedOption = .schedule
                                                        self.homeAwaitingViewModel.isDraftsSelected = false
                                                        self.homeAwaitingViewModel.istDraftselected = false
                                                        self.homeAwaitingViewModel.isScheduledSelected = false
                                                        self.homeAwaitingViewModel.istLetersSelected = true
                                                        self.homeAwaitingViewModel.istCardsSelected = false
                                                        self.homeAwaitingViewModel.getScheduleEmailsData()
                                                    }
                                                    .overlay(
                                                        Text("tLetters")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                    )
                                                
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(self.homeAwaitingViewModel.istCardsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                                    .frame(width: 100, height: 50)
                                                    .onTapGesture {
                                                        self.homeAwaitingViewModel.outlineSelectedOption = .schedule
                                                        self.homeAwaitingViewModel.isDraftsSelected = false
                                                        self.homeAwaitingViewModel.istDraftselected = false
                                                        self.homeAwaitingViewModel.isScheduledSelected = false
                                                        self.homeAwaitingViewModel.istLetersSelected = false
                                                        self.homeAwaitingViewModel.istCardsSelected = true
                                                        self.homeAwaitingViewModel.getScheduleEmailsData()
                                                    }
                                                    .overlay(
                                                        Text("tCards")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                    )
                                            }
                                            .padding(.horizontal)
                                        }
                                        .background(themesviewModel.currentTheme.tabBackground)
                                        .cornerRadius(25)
                                    
                                }
                            }
                        }
                        .padding(.top , 5)
                        Spacer()
                    }
                    else {
                        VStack{
                            HStack{
                                Spacer()
                                Text("\(selectedIndices.count) Selected")
                                    .font(.custom(.poppinsRegular, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Spacer()
                                
                                Button {
                                    print("cancel works")
                                    beforeLongPress = true
                                    AppBar = true
                                    
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
                                    print("select All clicked")
                                    if homeAwaitingViewModel.isEmailSelected{
                                        print("homeAwaitingViewModel.isEmailSelected")
                                        if selectedIndices.count == homeAwaitingViewModel.emailData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                            //                                        selectedMailID = Array(selectedIndices)
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.emailData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                            //                                        homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                            print("homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs )")
                                        }
                                    }
                                    
                                    else if homeAwaitingViewModel.isDraftsSelected{
                                        if selectedIndices.count == homeAwaitingViewModel.draftsData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                            //                                        selectedMailID = Array(selectedIndices)
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.draftsData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                            //                                        homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                            print("homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs )")
                                        }
                                    }
                                    else if homeAwaitingViewModel.istDraftselected{
                                        if selectedIndices.count == homeAwaitingViewModel.tDraftsData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.tDraftsData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                            print("homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs )")
                                        }
                                    }
                                    
                                    else if homeAwaitingViewModel.isScheduledSelected{
                                        if selectedIndices.count == homeAwaitingViewModel.scheduleData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                            //                                        selectedMailID = Array(selectedIndices)
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.scheduleData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                            //                                        homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                            print("homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs )")
                                        }
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
                        
                        if let selectedOption = homeAwaitingViewModel.selectedOption {
                            switch selectedOption {
                            case .email:
                                if homeAwaitingViewModel.isLoading {
                                    CustomProgressView()
                                }
                                else if homeAwaitingViewModel.emailData.count != 0{
                                    VStack{
                                        if beforeLongPress {
                                            List($homeAwaitingViewModel.emailData) { $data in
                                                HStack{
                                                    
                                                    let image = data.senderProfile ?? "person"
                                                    AsyncImage(url: URL(string: image)) { phase in
                                                        switch phase {
                                                        case .empty:
                                                            ProgressView()
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .frame(width: 34, height: 34)
                                                                .padding([.trailing,.leading],5)
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
                                                    
                                                    
                                                    VStack(alignment: .leading){
                                                        Text(data.firstname ?? "")
                                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        Text(data.subject ?? "")
                                                            .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .lineLimit(1)
                                                    }
                                                    Spacer()
                                                    VStack(alignment: .trailing) {
                                                        if let unixTimestamp = data.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                                            Text(istDateStringFromTimestamp)
                                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                .fontWeight(.bold)
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .padding(.top, 0) // Adds 5 points of padding from the top
                                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                                        }
                                                        Image(data.starred == 1 ? "star" : "emptystar")
                                                            .resizable()
                                                            .frame(width: 14, height: 14)
                                                            .foregroundColor(Color.red)
                                                            .onTapGesture {
                                                                if let threadID = data.threadID,
                                                                   let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == threadID }) {
                                                                    print("thread id:", threadID)
                                                                    // Toggle the 'starred' status between 1 and 0
                                                                    homeAwaitingViewModel.emailData[index].starred = (homeAwaitingViewModel.emailData[index].starred == 1) ? 0 : 1
                                                                    homeAwaitingViewModel.getStarredEmail(selectedEmail: threadID)
                                                                } else {
                                                                    print("threadID is nil")
                                                                }
                                                            }
                                                    }
                                                    .frame(height: 34)
                                                }
                                                .padding(.top , 10)
                                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                .onTapGesture {
                                                    if homeAwaitingViewModel.beforeLongPress {
                                                        homeAwaitingViewModel.selectedID = data.threadID
                                                        homeAwaitingViewModel.passwordHint = data.passwordHint
                                                        homeAwaitingViewModel.isEmailScreen = true
                                                        AwaitingView = true
                                                        beforeLongPress = false
                                                        homeAwaitingViewModel.beforeLongPress = false
                                                        AppBar = false
                                                        print("selectedCheck \(selectedCheck)")
                                                    }
                                                }
                                                .gesture(
                                                    LongPressGesture(minimumDuration: 1.0)
                                                        .onEnded { _ in
                                                            withAnimation {
                                                                beforeLongPress = false
                                                                homeAwaitingViewModel.beforeLongPress = false
                                                                AppBar = false
                                                                print("selectedCheck \(selectedCheck)")
                                                            }
                                                        }
                                                )
                                                .swipeActions(edge: .leading) {
                                                    Button {
                                                        print("Deleting row")
                                                        homeAwaitingViewModel.selectedThreadIDs.append(data.threadID ?? 0)
                                                        homeAwaitingViewModel.deleteEmailFromAwaiting()
                                                    } label: {
                                                        deleteIcon
                                                            .foregroundStyle(.white)
                                                    }
                                                    .tint(Color.themeColor)
                                                }
                                                .swipeActions(edge: .trailing) {
                                                    Button {
                                                        isSheetVisible = true
                                                    } label: {
                                                        moreIcon
                                                            .foregroundStyle(.white)
                                                    }
                                                    .tint(Color(red:255/255, green: 128/255, blue: 128/255))
                                                }
                                            }
                                            .listStyle(PlainListStyle())
                                            .scrollContentBackground(.hidden)
                                        }
                                        
                                        else {
                                            List($homeAwaitingViewModel.emailData) { $data in
                                                HStack{
                                                    Button(action: {
                                                        print("selected check image")
                                                        if let threadId = data.threadID {
                                                            if selectedIndices.contains(threadId) {
                                                                selectedIndices.remove(threadId)
                                                            } else {
                                                                selectedIndices.insert(threadId)
                                                                print("selected threadId \(threadId)")
                                                                homeAwaitingViewModel.selectedThreadIDs = [threadId]
                                                                print("single check homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs)")
                                                            }
                                                            isSelectAll = selectedIndices.count == homeAwaitingViewModel.emailData.count
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
                                                    
                                                    VStack(alignment: .leading){
                                                        Text(data.firstname ?? "")
                                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        Text(data.subject ?? "")
                                                            .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .lineLimit(1)
                                                    }
                                                    Spacer()
                                                    VStack(alignment: .trailing) {
                                                        if let unixTimestamp = data.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                                            Text(istDateStringFromTimestamp)
                                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                .fontWeight(.bold)
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .padding(.top, 0) // Adds 5 points of padding from the top
                                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                                        }
                                                        Image(data.starred == 1 ? "star" : "emptystar")
                                                            .resizable()
                                                            .frame(width: 14, height: 14)
                                                            .foregroundColor(Color.red)
                                                            .onTapGesture {
                                                                if let threadID = data.threadID,
                                                                   let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == threadID }) {
                                                                    print("thread id:", threadID)
                                                                    // Toggle the 'starred' status between 1 and 0
                                                                    homeAwaitingViewModel.emailData[index].starred = (homeAwaitingViewModel.emailData[index].starred == 1) ? 0 : 1
                                                                    homeAwaitingViewModel.getStarredEmail(selectedEmail: threadID)
                                                                } else {
                                                                    print("threadID is nil")
                                                                }
                                                            }
                                                    }
                                                    .frame(height: 34)
                                                }
                                                .padding(.top , 10)
                                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                            }
                                            .listStyle(PlainListStyle())
                                            .scrollContentBackground(.hidden)
                                        }
                                    }
                                    
                                }
                                else {
                                    if showEmptyText {
                                        Text("No Mails Found.")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                    }
                                }
                            case .print:
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
                                }
                            case .outline:
                                if homeAwaitingViewModel.isDraftsSelected{
                                    if homeAwaitingViewModel.isLoading {
                                        CustomProgressView()
                                    }
                                    else if homeAwaitingViewModel.draftsData.count == 0{
                                        VStack {
                                            Text("No Mails Found.")
                                                .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            Spacer()
                                        }
                                    }else {
                                        if beforeLongPress {
                                            VStack{
                                                List($homeAwaitingViewModel.draftsData,id: \.self) { $draftData in
                                                    HStack{
                                                        Button(action: {
                                                            selectedCheck = true
                                                        }) {
                                                            Image("unchecked")
                                                                .renderingMode(.template)
                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                .padding([.trailing, .leading], 5)
                                                                .frame(width: 34, height: 34)
                                                                .clipShape(Circle())
                                                        }
                                                        HStack {
                                                            VStack(alignment: .leading){
                                                                if draftData.status?.rawValue ?? "" == "draft"{
                                                                    if let recipient = draftData.recipients.first(where: { $0.type == "to" }) {
                                                                        Text(recipient.user.firstname ?? "")
                                                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                            .onTapGesture {
                                                                                print("recipient.user.firstname \(recipient.user.firstname ?? "")")
                                                                            }
                                                                    }
                                                                    
                                                                    else {
                                                                        Text("(no recipient)")
                                                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    }
                                                                }
                                                                
                                                                if let subject = draftData.subject {
                                                                    Text(subject)
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .lineLimit(1)
                                                                }
                                                            }
                                                            Text("Draft")
                                                                .foregroundColor(Color.red)
                                                        }
                                                    }
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                    .onTapGesture {
                                                        if homeAwaitingViewModel.beforeLongPress {
                                                            homeAwaitingViewModel.selectedID = draftData.threadID
                                                            homeAwaitingViewModel.passwordHint = draftData.passwordHint
                                                            print("before isdraftemail true  \(homeAwaitingViewModel.isdraftEmail)")
                                                            homeAwaitingViewModel.isdraftEmail = true
                                                            print("before AwaitingView \(AwaitingView)")
                                                            print("After AwaitingView \(AwaitingView)")
                                                            print("After isdraftemail true  \(homeAwaitingViewModel.isdraftEmail)")
                                                        }
                                                    }
                                                    .gesture(
                                                        LongPressGesture(minimumDuration: 1.0)
                                                            .onEnded { _ in
                                                                withAnimation {
                                                                    beforeLongPress = false
                                                                    homeAwaitingViewModel.beforeLongPress = false
                                                                    AppBar = false
                                                                    print("selectedCheck \(selectedCheck)")
                                                                }
                                                            }
                                                    )
                                                }
                                                .refreshable{
                                                    homeAwaitingViewModel.getDraftsData()
                                                }
                                                
                                                .listStyle(PlainListStyle())
                                                .scrollContentBackground(.hidden)
                                            }
                                        }
                                        
                                        else {
                                            VStack{
                                                List($homeAwaitingViewModel.draftsData,id: \.threadID) { $draftData in
                                                    HStack{
                                                        Button(action: {
                                                            print("selected check image")
                                                            if let threadId = draftData.threadID {
                                                                if selectedIndices.contains(threadId) {
                                                                    selectedIndices.remove(threadId)
                                                                } else {
                                                                    selectedIndices.insert(threadId)
                                                                    print("selected threadId \(threadId)")
                                                                    homeAwaitingViewModel.selectedThreadIDs = [threadId]
                                                                    print("single check homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs)")
                                                                }
                                                                isSelectAll = selectedIndices.count == homeAwaitingViewModel.draftsData.count
                                                            }
                                                        }) {
                                                            Image(selectedIndices.contains(draftData.threadID ?? -1) ?  "selected" : "contactW")
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
                                                        
                                                        HStack {
                                                            VStack(alignment: .leading){
                                                                if draftData.status?.rawValue ?? "" == "draft"{
                                                                    if let recipient = draftData.recipients.first(where: { $0.type == "to" }) {
                                                                        Text(recipient.user.firstname ?? "")
                                                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                            .onTapGesture {
                                                                                print("recipient.user.firstname \(recipient.user.firstname ?? "")")
                                                                            }
                                                                    }
                                                                    
                                                                    else {
                                                                        Text("(no recipient)")
                                                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                    }
                                                                }
                                                                
                                                                if let subject = draftData.subject {
                                                                    Text(subject)
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .lineLimit(1)
                                                                }
                                                            }
                                                            Text("Draft")
                                                                .foregroundColor(Color.red)
                                                        }
                                                    }
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                }
                                                
                                                .listStyle(PlainListStyle())
                                                .scrollContentBackground(.hidden)
                                                
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
                                                }
                                                .background(themesviewModel.currentTheme.colorPrimary)
                                            }
                                        }
                                    }
                                }
                                else if homeAwaitingViewModel.istDraftselected{
                                    if homeAwaitingViewModel.isLoading {
                                        CustomProgressView()
                                    }
                                    else if homeAwaitingViewModel.tDraftsData.count == 0{
                                        VStack {
                                            Text("No Mails Found.")
                                                .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                            Spacer()
                                        }
                                    }else{
                                        VStack{
                                            if beforeLongPress {
                                                List($homeAwaitingViewModel.tDraftsData,id: \.self) { $tdraftData in
                                                    HStack{
                                                        Image("unchecked")
                                                            .renderingMode(.template)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            .padding([.trailing,.leading],5)
                                                            .frame(width: 34,height: 34)
                                                            .clipShape(Circle())
                                                        
                                                        VStack(alignment: .leading){
                                                            if tdraftData.status?.rawValue ?? "" == "draft"{
                                                                if let recipient = tdraftData.recipients.first(where: { $0.type == "to" }) {
                                                                    Text(recipient.user.firstname ?? "")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .onTapGesture {
                                                                            print("recipient.user.firstname \(recipient.user.firstname ?? "")")
                                                                        }
                                                                }
                                                                
                                                                else {
                                                                    Text("(no recipient)")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            HStack {
                                                                if let subject = tdraftData.subject, !subject.isEmpty,
                                                                   let body = tdraftData.body, !body.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                    
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let subject = tdraftData.subject, !subject.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let body = tdraftData.body, !body.isEmpty {
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else {
                                                                    Text("No subject")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            
                                                            
                                                        }
                                                        Spacer()
                                                        let unixTimestamp = tdraftData.createdAt ?? ""
                                                        if let istDateStringFromISO = convertToIST(dateInput: unixTimestamp) {
                                                            Text(istDateStringFromISO)
                                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .padding(.top, 0) // Adds 5 points of padding from the top
                                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                                        }
                                                    }
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                    .onTapGesture {
                                                        if homeAwaitingViewModel.beforeLongPress {
                                                            homeAwaitingViewModel.selectedID = tdraftData.threadID
                                                            homeAwaitingViewModel.passwordHint = tdraftData.passwordHint
                                                            homeAwaitingViewModel.isEmailScreen = true
                                                        }
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
                                            
                                            
                                            else {
                                                List($homeAwaitingViewModel.tDraftsData,id: \.self) { $tdraftData in
                                                    HStack{
                                                        Button(action: {
                                                            print("selected check image")
                                                            if let threadId = tdraftData.threadID {
                                                                if selectedIndices.contains(threadId) {
                                                                    selectedIndices.remove(threadId)
                                                                } else {
                                                                    selectedIndices.insert(threadId)
                                                                    print("selected threadId \(threadId)")
                                                                    homeAwaitingViewModel.selectedThreadIDs = [threadId]
                                                                    print("single check homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs)")
                                                                }
                                                                isSelectAll = selectedIndices.count == homeAwaitingViewModel.tDraftsData.count
                                                            }
                                                        }) {
                                                            Image(selectedIndices.contains(tdraftData.threadID ?? -1) ?  "selected" : "contactW")
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

                                                        
                                                        VStack(alignment: .leading){
                                                            if tdraftData.status?.rawValue ?? "" == "draft"{
                                                                if let recipient = tdraftData.recipients.first(where: { $0.type == "to" }) {
                                                                    Text(recipient.user.firstname ?? "")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .onTapGesture {
                                                                            print("recipient.user.firstname \(recipient.user.firstname ?? "")")
                                                                        }
                                                                }
                                                                
                                                                else {
                                                                    Text("(no recipient)")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            HStack {
                                                                if let subject = tdraftData.subject, !subject.isEmpty,
                                                                   let body = tdraftData.body, !body.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                    
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let subject = tdraftData.subject, !subject.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let body = tdraftData.body, !body.isEmpty {
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else {
                                                                    Text("No subject")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            
                                                            
                                                        }
                                                        Spacer()
                                                        let unixTimestamp = tdraftData.createdAt ?? ""
                                                        if let istDateStringFromISO = convertToIST(dateInput: unixTimestamp) {
                                                            Text(istDateStringFromISO)
                                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .padding(.top, 0) // Adds 5 points of padding from the top
                                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                                        }
                                                    }
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                }
                                                .listStyle(PlainListStyle())
                                                .scrollContentBackground(.hidden)
                                                
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
                                                }
                                                .background(themesviewModel.currentTheme.colorPrimary)
                                            }
                                            
                                        }
                                    }
                                }
                                
                                else if homeAwaitingViewModel.isScheduledSelected{
                                    if homeAwaitingViewModel.isLoading {
                                        CustomProgressView()
                                    }
                                    else if homeAwaitingViewModel.scheduleData.count == 0{
                                        VStack {
                                            Text("No Mails Found.")
                                                .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                            Spacer()
                                        }
                                    }else{
                                        VStack{
                                            if beforeLongPress {
                                                List($homeAwaitingViewModel.scheduleData,id: \.self) { $scheduleddata in
                                                    HStack{
                                                        Image("unchecked")
                                                            .renderingMode(.template)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            .padding([.trailing,.leading],5)
                                                            .frame(width: 34,height: 34)
                                                            .clipShape(Circle())
                                                        VStack(alignment: .leading){
                                                            if scheduleddata.status?.rawValue ?? "" == "scheduled"{
                                                                if let recipient = scheduleddata.recipients.first(where: { $0.type == "to" }) {
                                                                    Text(recipient.user.firstname ?? "")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .onTapGesture {
                                                                            print("recipient.user.firstname \(recipient.user.firstname ?? "")")
                                                                        }
                                                                }
                                                                
                                                                else {
                                                                    Text("(no recipient)")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            HStack {
                                                                if let subject = scheduleddata.subject, !subject.isEmpty,
                                                                   let body = scheduleddata.body, !body.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                    
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let subject = scheduleddata.subject, !subject.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let body = scheduleddata.body, !body.isEmpty {
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else {
                                                                    Text("No subject")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            
                                                            
                                                        }
                                                        Spacer()
                                                        if let unixTimestamp = scheduleddata.scheduledTime,
                                                           let istDateStringFromISO = convertToIST(dateInput: unixTimestamp) {
                                                            Text(istDateStringFromISO)
                                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .padding(.top, 0)
                                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                                        }
                                                        
                                                    }
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                    .onTapGesture {
                                                        if homeAwaitingViewModel.beforeLongPress {
                                                            homeAwaitingViewModel.selectedID = scheduleddata.threadID
                                                            homeAwaitingViewModel.passwordHint = scheduleddata.passwordHint
                                                            homeAwaitingViewModel.isScheduleEmail = true
                                                        }
                                                    }
                                                    .gesture(
                                                        LongPressGesture(minimumDuration: 1.0)
                                                            .onEnded { _ in
                                                                withAnimation {
                                                                    beforeLongPress = false
                                                                    homeAwaitingViewModel.beforeLongPress = false
                                                                    AppBar = false
                                                                }
                                                            }
                                                    )
                                                    
                                                }
                                                .listStyle(PlainListStyle())
                                                .scrollContentBackground(.hidden)
                                            }
                                            
                                            else {
                                                List($homeAwaitingViewModel.scheduleData,id: \.self) { $scheduleddata in
                                                    HStack{
                                                        Button(action: {
                                                            
                                                            print("selected check image")
                                                            if let threadId = scheduleddata.threadID {
                                                                if selectedIndices.contains(threadId) {
                                                                    selectedIndices.remove(threadId)
                                                                } else {
                                                                    selectedIndices.insert(threadId)
                                                                    print("selected threadId \(threadId)")
                                                                    homeAwaitingViewModel.selectedThreadIDs = [threadId]
                                                                    print("single check homeAwaitingViewModel.selectedThreadIDs  \(homeAwaitingViewModel.selectedThreadIDs)")
                                                                }
                                                                isSelectAll = selectedIndices.count == homeAwaitingViewModel.draftsData.count
                                                            }
                                                        }) {
                                                            Image(selectedIndices.contains(scheduleddata.threadID ?? -1) ?  "selected" : "contactW")
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
                                                        
                                                        
                                                        VStack(alignment: .leading){
                                                            if scheduleddata.status?.rawValue ?? "" == "scheduled"{
                                                                if let recipient = scheduleddata.recipients.first(where: { $0.type == "to" }) {
                                                                    Text(recipient.user.firstname ?? "")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .onTapGesture {
                                                                            print("recipient.user.firstname \(recipient.user.firstname ?? "")")
                                                                        }
                                                                }
                                                                
                                                                else {
                                                                    Text("(no recipient)")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            HStack {
                                                                if let subject = scheduleddata.subject, !subject.isEmpty,
                                                                   let body = scheduleddata.body, !body.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                    
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let subject = scheduleddata.subject, !subject.isEmpty {
                                                                    Text(subject)
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else if let body = scheduleddata.body, !body.isEmpty {
                                                                    Text("- \(body)")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                        .lineLimit(1)
                                                                } else {
                                                                    Text("No subject")
                                                                        .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                }
                                                            }
                                                            
                                                            
                                                        }
                                                        Spacer()
                                                        if let unixTimestamp = scheduleddata.scheduledTime,
                                                           let istDateStringFromISO = convertToIST(dateInput: unixTimestamp) {
                                                            Text(istDateStringFromISO)
                                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .padding(.top, 0)
                                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                                        }
                                                        
                                                    }
                                                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                    
                                                }
                                                .listStyle(PlainListStyle())
                                                .scrollContentBackground(.hidden)
                                                
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
                                                }
                                                .background(themesviewModel.currentTheme.colorPrimary)
                                            }
                                        }
                                    }
                                }
                                else if homeAwaitingViewModel.istLetersSelected{
                                    if homeAwaitingViewModel.isLoading {
                                        CustomProgressView()
                                    }
                                    else{
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
                                        }
                                    }
                                }
                                
                                else if homeAwaitingViewModel.istCardsSelected{
                                    if homeAwaitingViewModel.isLoading {
                                        CustomProgressView()
                                    }
                                    else{
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
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                        
//                    }
//                    else{
//                        VStack{
//                            HStack{
//                                Spacer()
//                                Text("\(homeAwaitingViewModel.selectedThreadIDs.count) Selected")
//                                    .font(.custom(.poppinsRegular, size: 16))
//                                    .foregroundColor(themesviewModel.currentTheme.textColor)
//                                
//                                Spacer()
//                                
//                                Button {
//                                    homeAwaitingViewModel.beforeLongPress.toggle()
//                                    homeAwaitingViewModel.selectedThreadIDs.removeAll()
//                                } label: {
//                                    Text("Cancel")
//                                        .foregroundColor(themesviewModel.currentTheme.textColor)
//                                }
//                                .padding(.trailing,15)
//                            }
//                            
//                            HStack{
//                                Image(homeAwaitingViewModel.selectedThreadIDs.count != 0 ? "checkbox" : "Check")
//                                    .resizable()
//                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
//                                    .frame(width: 24,height: 24)
//                                    .padding([.trailing,.leading],5)
//                                    .onTapGesture {
//                                        selectAllEmails()
//                                    }
//                                Image("dropdown")
//                                    .renderingMode(.template)
//                                    .foregroundColor(themesviewModel.currentTheme.textColor)
//                                Text("Select All")
//                                    .font(.custom(.poppinsRegular, size: 14))
//                                    .foregroundColor(themesviewModel.currentTheme.textColor)
//                                    .onTapGesture {
//                                        selectAllEmails()
//                                    }
//                                Spacer()
//                            }
//                            .padding(.leading,15)
//                        }
//                    
//                        VStack{
//
//                            
//                            HStack(spacing:50) {
//                                Button(action: {
//                                    homeAwaitingViewModel.deleteEmailFromAwaiting()
//                                }) {
//                                    Image(systemName: "trash")
//                                        .frame(width: 25, height: 25)
//                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
//                                }
//                                
//                                
//                                Button(action: {
//                                    homeAwaitingViewModel.toggleReadStatusForSelectedEmails()
//                                }) {
//                                    Image(systemName: homeAwaitingViewModel.shouldDisplayOpenEnvelope ? "envelope" : "envelope.open")
//                                        .frame(width: 25, height: 25)
//                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
//                                }
//                                
//                                
//                                Button(action: {
//                                    isMoveToFolder = true
//                                }) {
//                                    Image(systemName: "folder")
//                                        .frame(width: 25, height: 25)
//                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
//                                }
//                                
//                                Button(action: {
//                                    isCreateLabel = true
//                                }) {
//                                    Image(systemName: "tag")
//                                        .frame(width: 25, height: 25)
//                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
//                                }
//                                
//                                Button(action: {
//                                    //  isSheetVisible = true
//                                    emailSelectionSheetOptions()
//                                }) {
//                                    Image(systemName: "ellipsis")
//                                        .frame(width: 25, height: 25)
//                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
//                                }
//                                
//                            }
//                            .padding([.leading,.trailing], 20)
//                            
//                        }
//                        
//                    }
                    
                    if homeAwaitingViewModel.beforeLongPress{
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
                        TabViewNavigator()
                            .frame(height: 40)
                            .padding(.bottom, 10)
                    }
                    
//                    Spacer()
                    

                    
                    
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        print("on appears")
                        homeAwaitingViewModel.getEmailsData()
                        print("homeAwaitingViewModel.isLoading  \(homeAwaitingViewModel.isLoading)")
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        showEmptyText = true
                    }
                    

                }
                
                .background(
                                    Color.clear
                                        .blur(radius: isQuickAccessVisible ? 5 : 0) // Apply blur to the background
                                )
                
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

                
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
                if homeAwaitingViewModel.isPlusBtn {
                    QuickAccessView(isQuickAccessVisible: $homeAwaitingViewModel.isPlusBtn)
                        .transition(.opacity)
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
                                beforeLongPress = true
                                AppBar = true
                            }
                        }
                    }
                    .transition(.scale)
                }

            }
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
                    homeAwaitingViewModel.getStarredEmail(selectedEmail: homeAwaitingViewModel.selectedID ?? 0)
                    dismissSheet()
                },
                                  snoozeAction: {
                    if let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == homeAwaitingViewModel.selectedID}) {
                        homeAwaitingViewModel.emailData[index].threadID
                        print("homeAwaitingViewModel.emailData[index].threadID \(homeAwaitingViewModel.emailData[index].threadID)")
                            print("hey its snooze")
                            //                    dismissSheet()
                        }
                },
                                  trashAction: {
                    print("trash acti")
                    dismissSheet()
                }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $isMultiSelectionSheetVisible, content: {
                MultiEmailOptionsView(markAsReadAction: {
                    print("read")
                }, markAsUnReadAction: {
                    print("Unread")
                }, createLabelAction: {
                    print("label")
                }, moveToFolderAction: {
                    print("move")
                }, snoozeAction: {
                    print("snooze")
                }, trashAction: {
                    print("trash")
                })
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $isMoveToFolder, content: {
                //                MoveToFolderView()
                //                    .presentationDetents([.medium])
                //                    .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $isCreateLabel, content: {
                CreateLabelView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            })
            .onChange(of: homeAwaitingViewModel.isEmailScreen) { newValue in
                if newValue == false && homeAwaitingViewModel.isEmailSelected {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        print("queue Api calls")
                        homeAwaitingViewModel.getEmailsData()
                        print("queue Api calls")
                    }
                }
                else if newValue == false && homeAwaitingViewModel.istDraftselected {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        homeAwaitingViewModel.getTDraftsData()
                        print("tDrafts Api calls")
                    }
                }
            }
            .onChange(of: homeAwaitingViewModel.isdraftEmail) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        homeAwaitingViewModel.getDraftsData()
                        print("drafts Api calls")
                    }
                }
            }
            .onChange(of: homeAwaitingViewModel.isScheduleEmail) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        homeAwaitingViewModel.getScheduleEmailsData()
                        print("drafts getScheduleEmailsData calls")
                    }
                }
            }

            .fullScreenCover(isPresented: $homeAwaitingViewModel.isEmailScreen) {
                    MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView,awaitingView: $AwaitingView,  emailId: homeAwaitingViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars ).toolbar(.hidden)
            }
            .fullScreenCover(isPresented: $homeAwaitingViewModel.isComposeEmail) {
                MailComposeView(id:homeAwaitingViewModel.selectedID ?? 0).toolbar(.hidden)
            }
            .fullScreenCover(isPresented: $homeAwaitingViewModel.isdraftEmail) {
                draftView(isdraftViewVisible: $homeAwaitingViewModel.draftView, id:homeAwaitingViewModel.selectedID ?? 0).toolbar(.hidden)
            }
            .fullScreenCover(isPresented: $homeAwaitingViewModel.isScheduleEmail) {
                ScheduleView(id:homeAwaitingViewModel.selectedID ?? 0).toolbar(.hidden)
            }
            .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
                SearchView(appBarElementsViewModel: appBarElementsViewModel)
                    .toolbar(.hidden)
            }
            
//            .toast(message: $homeAwaitingViewModel.error)
            

            
        }
    }
    
    
//    private func selectEmail(data: HomeEmailsDataModel) {
//        if let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == data.threadID }) {
//            homeAwaitingViewModel.emailData[index].isSelected.toggle()
//            if homeAwaitingViewModel.emailData[index].isSelected {
//                homeAwaitingViewModel.selectedThreadIDs.append(data.threadID ?? 0)
//            } else {
//                homeAwaitingViewModel.selectedThreadIDs.removeAll { $0 == data.threadID }
//            }
//        }
//    }
    
    private func selectAllEmails() {
        let allSelected = homeAwaitingViewModel.emailData.allSatisfy { $0.isSelected }
        homeAwaitingViewModel.emailData.indices.forEach { index in
            homeAwaitingViewModel.emailData[index].isSelected = !allSelected
        }
        homeAwaitingViewModel.selectedThreadIDs = allSelected ? [] : homeAwaitingViewModel.emailData.compactMap { $0.threadID }
    }
    private func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func emailSelectionSheetOptions(){
        
        if homeAwaitingViewModel.selectedThreadIDs.count >= 1{
            isMultiSelectionSheetVisible = true
            isSheetVisible = false
        }
        
        if homeAwaitingViewModel.selectedThreadIDs.count == 1{
            isSheetVisible = true
            isMultiSelectionSheetVisible = false
        }
    }
}

#Preview {
    HomeAwaitingView( imageUrl: "")
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
