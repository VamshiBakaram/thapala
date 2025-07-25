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
    @StateObject var mailFullViewModel = MailFullViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
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
    @State private var beforeLongPress = true
    @State private var AppBar = true
    @State private var selectedCheck = false
    @State private var iNotificationAppBarView = false
    @State private var showEmptyText = false
    @State private var isFullScreenPresented = false
    @State private var selectedIndices: Set<Int> = []
    @State private var isSelectAll = false
    @State private var showingDeleteAlert = false
    @State private var selectView: Bool = false
    @State private var isTagsheetvisible: Bool = false
    @State private var isMoveSheetvisible: Bool = false
    @State private var issnoozesheetvisible: Bool = false
    @State private var isMoreSheetvisible: Bool = false
    @State private var isactive: Bool = false
    @State private var selectednewDiaryTag: [Int] = [0]
    @State private var selectednames: [String] = [""]
    @State private var selectedid: Int = 0
    @State private var isClicked:Bool = false
    @State private var emailId: Int = 0
    @State private var passwordHash: String = ""
    @State private var EmailStarred : Int = 0
    @State private var snoozeTime : Int = 0
    @State private var markAs : Int = 0
    @State private var HomeawaitingViewVisible: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var isCheckedLabelID: [Int] = []
    @State private var emailBodies: [String] = []
    var body: some View {
        GeometryReader{ reader in
            ZStack(alignment: .bottomTrailing) {
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea()
                VStack{
                    if beforeLongPress{
                        VStack {
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
                                                    Text("\(homeAwaitingViewModel.draftsData.count) Drafts")
                                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                        .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                                }
                                                if homeAwaitingViewModel.istDraftselected{
                                                    Text("\(homeAwaitingViewModel.tDraftsData.count) tDrafts")
                                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                        .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                                }
                                                if homeAwaitingViewModel.isScheduledSelected{
                                                    Text("\(homeAwaitingViewModel.scheduleData.count) Scheduled")
                                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                        .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                                }
                                                if homeAwaitingViewModel.istLetersSelected{
                                                    Text("0 count")
                                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                        .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                                }
                                                
                                                if homeAwaitingViewModel.istCardsSelected{
                                                    Text("0 count")
                                                        .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                                        .font(.custom(.poppinsRegular, size: 12, relativeTo: .title))
                                                }
                                                
                                            }
                                        }
                                    }
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
                            .padding(.top, -reader.size.height * 0.01)
                            HStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(self.homeAwaitingViewModel.isEmailSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                    .onTapGesture {
                                        self.homeAwaitingViewModel.selectedOption = .email
                                        homeAwaitingViewModel.getEmailsData()
                                        self.homeAwaitingViewModel.isEmailSelected = true
                                        self.homeAwaitingViewModel.isPrintSelected = false
                                        self.homeAwaitingViewModel.isOntlineSelected = false
                                       
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
                                                    
                                                VStack{
                                                    Text("Recent")
                                                        .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                }
                                            }
                                        }
                                    )
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(self.homeAwaitingViewModel.isPrintSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                    .onTapGesture {
                                        self.homeAwaitingViewModel.selectedOption = .print
                                        self.homeAwaitingViewModel.isEmailSelected = false
                                        self.homeAwaitingViewModel.isPrintSelected = true
                                        self.homeAwaitingViewModel.isOntlineSelected = false
                                    }
                                    .overlay(
                                        Group{
                                            HStack{
                                                Image("intact")
                                                    .renderingMode(.template)
                                                    .frame(width: 20, height: 20)
                                                    .padding(5)
                                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(themesviewModel.currentTheme.tabBackground)
                                                    )
                                                
                                                VStack{
                                                    Text("Intact")
                                                        .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                }
                                            }
                                        }
                                    )
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(self.homeAwaitingViewModel.isOntlineSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                    .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
                                    .onTapGesture {
                                        self.homeAwaitingViewModel.selectedOption = .outline
                                        self.homeAwaitingViewModel.isEmailSelected = false
                                        self.homeAwaitingViewModel.isPrintSelected = false
                                        self.homeAwaitingViewModel.isOntlineSelected = true
                                        self.homeAwaitingViewModel.isDraftsSelected = true
                                        self.homeAwaitingViewModel.istDraftselected = false
                                        self.homeAwaitingViewModel.isScheduledSelected = false
                                        self.homeAwaitingViewModel.istLetersSelected = false
                                        self.homeAwaitingViewModel.istCardsSelected = false
                                        self.homeAwaitingViewModel.getDraftsData()
                                    }
                                    .overlay(
                                        Group{
                                            HStack{
                                                Image("queueOutline")
                                                    .renderingMode(.template)
                                                    .frame(width: 20, height: 20)
                                                    .padding(5)
                                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(themesviewModel.currentTheme.tabBackground)
                                                    )

                                                
                                                VStack{
                                                    Text("Outline")
                                                        .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                }
                                            }
                                        }
                                    )
                            }
                            .padding([.leading,.trailing,],5)
                            .padding(.bottom , 10)
                        }
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 30)
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
                    else if selectView {
                        VStack{
                            HStack{
                                Spacer()
                                Text("\(selectedIndices.count) Selected")
                                    .font(.custom(.poppinsRegular, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                
                                Spacer()
                                
                                Button {
                                    selectedIndices = []
                                    homeAwaitingViewModel.selectedThreadIDs = []
                                    beforeLongPress = true
                                    homeAwaitingViewModel.beforeLongPress = true
                                    homeAwaitingViewModel.isEmailScreen = false
                                    homeAwaitingViewModel.isdraftEmail = false
                                    emailId = 0
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
                                    if homeAwaitingViewModel.isEmailSelected{
                                        if selectedIndices.count == homeAwaitingViewModel.emailData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                            selectedIndices = []
                                            homeAwaitingViewModel.selectedThreadIDs = []
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.emailData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                        }
                                    }
                                    
                                    else if homeAwaitingViewModel.isDraftsSelected{
                                        if selectedIndices.count == homeAwaitingViewModel.draftsData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                            selectedIndices = []
                                            homeAwaitingViewModel.selectedThreadIDs = []
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.draftsData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                        }
                                    }
                                    else if homeAwaitingViewModel.istDraftselected{
                                        if selectedIndices.count == homeAwaitingViewModel.tDraftsData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                            selectedIndices = []
                                            homeAwaitingViewModel.selectedThreadIDs = []
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.tDraftsData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                        }
                                    }
                                    
                                    else if homeAwaitingViewModel.isScheduledSelected{
                                        if selectedIndices.count == homeAwaitingViewModel.scheduleData.count {
                                            selectedIndices.removeAll()
                                            isSelectAll = false
                                            selectedIndices = []
                                            homeAwaitingViewModel.selectedThreadIDs = []
                                        } else {
                                            selectedIndices = Set(homeAwaitingViewModel.scheduleData.compactMap { $0.threadID })
                                            isSelectAll = true
                                            homeAwaitingViewModel.selectedThreadIDs = Array(selectedIndices)
                                        }
                                    }
                                                                        
                                }) {
                                    Image(systemName: isSelectAll ? "checkmark.square.fill" : "square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .padding(.top, 1)
                                        .padding(.trailing, 5)
                                        .foregroundColor(isSelectAll ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
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
                                    VStack(spacing: 10) {
                                        if beforeLongPress {
                                            List($homeAwaitingViewModel.emailData) { $data in
                                                VStack {
                                                    HStack{
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
                                                        
                                                        VStack(alignment: .leading){
                                                            Text(data.firstname ?? "")
                                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            Text(data.subject ?? "")
                                                                .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .lineLimit(1)
                                                            if let labels = data.labels, !labels.isEmpty {
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
                                                        Spacer()
                                                        VStack(alignment: .trailing) {
                                                            HStack {
                                                                if let timestamp = (data.snooze == 1 ? data.snoozeAt : data.sentAt),
                                                                   let istDateString = convertToIST(dateInput: timestamp) {
                                                                    HStack(spacing: 5) {
                                                                        if (data.snooze == 1) {
                                                                            Image("snooze")
                                                                                .renderingMode(.template)
                                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                        }
                                                                        Text(istDateString)
                                                                            .font(.custom(.poppinsMedium, size: 14))
                                                                            .foregroundColor(data.snooze == 1 ? .orange : themesviewModel.currentTheme.iconColor)
                                                                        
                                                                        
                                                                    }
                                                                    .padding(.top, 0)
                                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                                }
                                                            }
                                                            .padding(.trailing , 10)
                                                            
                                                            
                                                            Image(data.starred == 1 ? "star" : "emptystar")
                                                                .resizable()
                                                                .renderingMode(.template)
                                                                .frame(width: 20, height: 20)
                                                                .foregroundColor(data.starred == 1 ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                                .padding(.trailing , 10)
                                                                .onTapGesture {
                                                                    if let threadID = data.threadID,
                                                                       let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == threadID }) {
                                                                        homeAwaitingViewModel.emailData[index].starred = (homeAwaitingViewModel.emailData[index].starred == 1) ? 0 : 1
                                                                        homeAwaitingViewModel.getStarredEmail(selectedEmail: threadID)
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                                                            homeAwaitingViewModel.isLoading = false
                                                                        }
                                                                    } else {
                                                                    }
                                                                }
                                                        }
                                                        .frame(height: 34)
                                                    }
                                                    .padding(.top , 10)
                                                    .onTapGesture {
                                                        if homeAwaitingViewModel.beforeLongPress {
                                                            EmailStarred = data.starred ?? 0
                                                            markAs = data.readReceiptStatus ?? 0
                                                            HomeawaitingViewVisible = true
                                                            homeAwaitingViewModel.selectedID = data.threadID
                                                            homeAwaitingViewModel.passwordHint = data.passwordHint
                                                            homeAwaitingViewModel.isEmailScreen = true
                                                        }
                                                    }
                                                    .gesture(
                                                        LongPressGesture(minimumDuration: 1.0)
                                                            .onEnded { _ in
                                                                withAnimation {
                                                                    beforeLongPress = false
                                                                    homeAwaitingViewModel.beforeLongPress = false
                                                                    selectView = true
                                                                    selectedIndices.insert(data.threadID ?? 0)
                                                                    homeAwaitingViewModel.selectedID = data.threadID
                                                                    homeAwaitingViewModel.selectedThreadIDs.append(data.threadID ?? 0)
                                                                    EmailStarred = data.starred ?? 0
                                                                    markAs = data.readReceiptStatus ?? 0
                                                                    emailId = data.threadID ?? 0
                                                                }
                                                            }
                                                    )
                                                    .swipeActions(edge: .leading) {
                                                        Button {
                                                            homeAwaitingViewModel.selectedThreadIDs.append(data.threadID ?? 0)
                                                            homeAwaitingViewModel.deleteEmailFromAwaiting(threadIDS: homeAwaitingViewModel.selectedThreadIDs)
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
                                                        .tint(Color(red: 1.0, green: 0.5, blue: 0.5))
                                                    }
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
                                        
                                        else if selectView{
                                          ZStack(alignment: .bottomTrailing) {
                                            List($homeAwaitingViewModel.emailData) { $data in
                                                VStack {
                                                    HStack{
                                                        Button(action: {
                                                            if let threadId = data.threadID {
                                                                if selectedIndices.contains(threadId) {
                                                                    selectedIndices.remove(threadId)
                                                                    homeAwaitingViewModel.selectedThreadIDs.removeAll { $0 == threadId }
                                                                } else {
                                                                    selectedIndices.insert(threadId)
                                                                    homeAwaitingViewModel.selectedThreadIDs.append(threadId)
                                                                    markAs = data.readReceiptStatus ?? 0
                                                                    emailId = threadId
                                                                    homeAwaitingViewModel.selectedID = threadId
                                                                    if let thread = homeAwaitingViewModel.emailData.first(where: { $0.threadID == threadId }) {
                                                                        let labelIDs = thread.labels?.compactMap { $0.labelId } ?? []
                                                                        isCheckedLabelID = labelIDs
                                                                    }
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
                                                            if let labels = data.labels, !labels.isEmpty {
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
                                                        Spacer()
                                                        VStack(alignment: .trailing) {
                                                            if let timestamp = (data.snooze == 1 ? data.snoozeAt : data.sentAt),
                                                               let istDateString = convertToIST(dateInput: timestamp) {
                                                                Text(istDateString)
                                                                    .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                                    .fontWeight(.bold)
                                                                    .foregroundColor(data.snooze == 1 ? .orange : themesviewModel.currentTheme.textColor)
                                                                    .padding(.top, 0)
                                                                    .frame(maxWidth: .infinity, alignment: .topTrailing)
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
                                                                       let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == threadID }) {
                                                                        // Toggle the 'starred' status between 1 and 0
                                                                        homeAwaitingViewModel.emailData[index].starred = (homeAwaitingViewModel.emailData[index].starred == 1) ? 0 : 1
                                                                        homeAwaitingViewModel.getStarredEmail(selectedEmail: threadID)
                                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                                                            homeAwaitingViewModel.isLoading = false
                                                                        }
                                                                    } else {
                                                                        print("threadID is nil")
                                                                    }
                                                                }
                                                        }
                                                        .frame(height: 34)
                                                    }
                                                    .padding(.top , 10)
                                                    
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
                                            
                                            
                                            .onAppear{
                                                HomeawaitingViewVisible = true
                                                isCheckedLabelID
                                                if let thread = homeAwaitingViewModel.emailData.first(where: { $0.threadID == emailId }) {
                                                    let labelIDs = thread.labels?.compactMap { $0.labelId } ?? []
                                                    isCheckedLabelID = labelIDs
                                                }
                                            }
                                            
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
                                            .padding(.bottom, 50)
                                            
                                            
                                            HStack{
                                                
                                                Button(action: {
                                                    showingDeleteAlert = true
                                                }) {
                                                    Image(systemName: "trash")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .padding(.leading , 16)
                                                }
                                                Spacer()
                                                
                                                Button {
                                                    if markAs == 0 {
                                                        mailFullViewModel.markEmailAsRead(emailId: homeAwaitingViewModel.selectedThreadIDs)
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                                            homeAwaitingViewModel.getEmailsData()
                                                            selectedIndices = []
                                                            homeAwaitingViewModel.selectedThreadIDs = []
                                                        }
                                                    }
                                                    else {
                                                        mailFullViewModel.markEmailAsUnRead(emailId: homeAwaitingViewModel.selectedThreadIDs)
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                                            homeAwaitingViewModel.getEmailsData()
                                                            selectedIndices = []
                                                            homeAwaitingViewModel.selectedThreadIDs = []
                                                        }
                                                    }
                                                    
                                                    
                                                } label: {
                                                    Image(markAs == 0 ? "emailG" : "queueOutline")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                }
                                                
                                                Spacer()
                                                
                                                Button(action: {
                                                    isMoveSheetvisible.toggle()
                                                }) {
                                                    Image(systemName: "folder")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                }
                                                Spacer()
                                                
                                                Button(action: {
                                                    isTagsheetvisible.toggle()
                                                }) {
                                                    Image("Tags")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                }
                                                Spacer()
                                                
                                                Button(action: {
                                                    isMoreSheetvisible.toggle()
                                                    issnoozesheetvisible = false
                                                }) {
                                                    Image("threeDots")
                                                        .renderingMode(.template)
                                                        .frame(width: 35 , height: 35)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                }
                                                .contentShape(Rectangle())
                                                Spacer()
                                            }
                                            .padding(.leading,20)
                                            .background(themesviewModel.currentTheme.colorPrimary)
                                            
                                        }
                                    }
                                    }
                                }
                                
                                else {
                                    if showEmptyText {
                                        VStack {
                                            Text("No Mails Found.")
                                                .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            Spacer()
                                        }
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
                                                List($homeAwaitingViewModel.draftsData,id: \.self) { $draftData in
                                                    VStack(alignment: .leading) {
                                                        HStack {
                                                            Button(action: {
                                                                selectedCheck = true
                                                                beforeLongPress = false
                                                                homeAwaitingViewModel.beforeLongPress = false
                                                                selectView = true
                                                                selectedIndices.insert(draftData.threadID ?? 0)
                                                                homeAwaitingViewModel.selectedThreadIDs.append(draftData.threadID ?? 0)
                                                            }) {
                                                                Image("unchecked")
                                                                    .renderingMode(.template)
                                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                    .frame(width: 34, height: 34)
                                                                    .clipShape(Circle())
                                                                    .padding(.leading, 20)
                                                            }
                                                            
                                                            VStack(alignment: .leading){
                                                                if draftData.status?.rawValue ?? "" == "draft"{
                                                                    if let recipient = draftData.recipients.first(where: { $0.type == "to" }) {
                                                                        Text(recipient.user.firstname ?? "")
                                                                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                            
                                                            .onTapGesture {
                                                                if homeAwaitingViewModel.beforeLongPress {
                                                                    homeAwaitingViewModel.selectedID = draftData.threadID
                                                                    homeAwaitingViewModel.passwordHint = draftData.passwordHint
                                                                    homeAwaitingViewModel.isdraftEmail = true
                                                                }
                                                            }
                                                            .gesture(
                                                                LongPressGesture(minimumDuration: 1.0)
                                                                    .onEnded { _ in
                                                                        withAnimation {
                                                                            beforeLongPress = false
                                                                            homeAwaitingViewModel.beforeLongPress = false
                                                                            selectView = true
                                                                            selectedIndices.insert(draftData.threadID ?? 0)
                                                                            homeAwaitingViewModel.selectedThreadIDs.append(draftData.threadID ?? 0)
                                                                        }
                                                                    }
                                                            )
                                                            Spacer()
                                                        }
                                                        .padding([.top , .bottom] , 10)
                                                        
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
                                                .refreshable{
                                                    homeAwaitingViewModel.getDraftsData()
                                                }
                                        }
                                        
                                        else if selectView{
                                            ZStack(alignment: .bottomTrailing) {
                                                List($homeAwaitingViewModel.draftsData,id: \.threadID) { $draftData in
                                                    VStack(alignment: .leading) {
                                                        HStack{
                                                            Button(action: {
                                                                if let threadId = draftData.threadID {
                                                                    if selectedIndices.contains(threadId) {
                                                                        selectedIndices.remove(threadId)
                                                                        homeAwaitingViewModel.selectedThreadIDs.removeAll { $0 == threadId }
                                                                    } else {
                                                                        selectedIndices.insert(threadId)
                                                                        homeAwaitingViewModel.selectedThreadIDs.append(threadId)
                                                                    }
                                                                    isSelectAll = selectedIndices.count == homeAwaitingViewModel.draftsData.count
                                                                }
                                                            }) {
                                                                Image(systemName: selectedIndices.contains(draftData.threadID ?? -1) ?  "checkmark.square.fill" : "square")
                                                                    .resizable()
                                                                    .renderingMode(.template)
                                                                    .frame(width: 20, height: 20)
                                                                    .padding(.top, 1)
                                                                    .padding(.leading, 20)
                                                                    .foregroundColor(selectedIndices.contains(draftData.threadID ?? -1) ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                                    .contentShape(Rectangle())
                                                            }
                                                            
                                                            HStack {
                                                                VStack(alignment: .leading){
                                                                    if draftData.status?.rawValue ?? "" == "draft"{
                                                                        if let recipient = draftData.recipients.first(where: { $0.type == "to" }) {
                                                                            Text(recipient.user.firstname ?? "")
                                                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                            }
                                                            Spacer()
                                                        }
                                                        .padding([.top , .bottom] , 10)
                                                        
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
                                                .padding(.bottom, 50)
                                                
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
                                                    VStack(alignment: .leading) {
                                                    HStack{
                                                        Button(action: {
                                                            selectedCheck = true
                                                            beforeLongPress = false
                                                            homeAwaitingViewModel.beforeLongPress = false
                                                            selectView = true
                                                            selectedIndices.insert(tdraftData.threadID ?? 0)
                                                            homeAwaitingViewModel.selectedThreadIDs.append(tdraftData.threadID ?? 0)
                                                            
                                                        }) {
                                                            Image("unchecked")
                                                                .renderingMode(.template)
                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                .frame(width: 34, height: 34)
                                                                .clipShape(Circle())
                                                                .padding(.leading, 20)
                                                        }
                                                                                                                
                                                        VStack(alignment: .leading){
                                                            if tdraftData.status?.rawValue ?? "" == "draft"{
                                                                if let recipient = tdraftData.recipients.first(where: { $0.type == "to" }) {
                                                                    Text(recipient.user.firstname ?? "")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                                        homeAwaitingViewModel.beforeLongPress = false
                                                                        selectView = true
                                                                        selectedIndices.insert(tdraftData.threadID ?? 0)
                                                                        homeAwaitingViewModel.selectedThreadIDs.append(tdraftData.threadID ?? 0)
                                                                    }
                                                                }
                                                        )
     
                                                    }
                                                    .padding([.top , .bottom] , 10)

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
                                            
                                            
                                            else if selectView {
                                                ZStack(alignment: .bottomTrailing) {
                                                    List($homeAwaitingViewModel.tDraftsData,id: \.threadID) { $tdraftData in
                                                        VStack(alignment: .leading) {
                                                            HStack{
                                                                Button(action: {
                                                                    if let threadId = tdraftData.threadID {
                                                                        if selectedIndices.contains(threadId) {
                                                                            selectedIndices.remove(threadId)
                                                                            homeAwaitingViewModel.selectedThreadIDs.removeAll { $0 == threadId }
                                                                        } else {
                                                                            selectedIndices.insert(threadId)
                                                                            homeAwaitingViewModel.selectedThreadIDs.append(threadId)
                                                                        }
                                                                        isSelectAll = selectedIndices.count == homeAwaitingViewModel.tDraftsData.count
                                                                    }
                                                                }) {
                                                                    Image(systemName: selectedIndices.contains(tdraftData.threadID ?? -1) ?  "checkmark.square.fill" : "square")
                                                                        .resizable()
                                                                        .renderingMode(.template)
                                                                        .frame(width: 20, height: 20)
                                                                        .padding(.top, 1)
                                                                        .padding(.leading, 20)
                                                                        .foregroundColor(selectedIndices.contains(tdraftData.threadID ?? -1) ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                                        .contentShape(Rectangle())
                                                                }
                                                                
                                                                
                                                                
                                                                
                                                                VStack(alignment: .leading){
                                                                    if tdraftData.status?.rawValue ?? "" == "draft"{
                                                                        if let recipient = tdraftData.recipients.first(where: { $0.type == "to" }) {
                                                                            Text(recipient.user.firstname ?? "")
                                                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                            .padding([.top , .bottom] , 10)
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
                                                    .padding(.bottom, 50)
                                                    
                                                    
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
                                                  VStack(alignment: .leading) {
                                                    HStack{
                                                        Button(action: {
                                                            selectedCheck = true
                                                            beforeLongPress = false
                                                            homeAwaitingViewModel.beforeLongPress = false
                                                            selectView = true
                                                            selectedIndices.insert(scheduleddata.threadID ?? 0)
                                                            homeAwaitingViewModel.selectedThreadIDs.append(scheduleddata.threadID ?? 0)
                                                        }) {
                                                            Image("unchecked")
                                                                .renderingMode(.template)
                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                                .frame(width: 34, height: 34)
                                                                .clipShape(Circle())
                                                                .padding(.leading, 20)
                                                            
                                                        }
                                                        
                                                        VStack(alignment: .leading){
                                                            if scheduleddata.status?.rawValue ?? "" == "scheduled"{
                                                                if let recipient = scheduleddata.recipients.first(where: { $0.type == "to" }) {
                                                                    Text(recipient.user.firstname ?? "")
                                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
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
                                                                        selectView = true
                                                                        selectedIndices.insert(scheduleddata.threadID ?? 0)
                                                                        homeAwaitingViewModel.selectedThreadIDs.append(scheduleddata.threadID ?? 0)
                                                                    }
                                                                }
                                                        )
                                                        
                                                    }
                                                    .padding([.top , .bottom] , 10)

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
                                                .refreshable{
                                                    homeAwaitingViewModel.getDraftsData()
                                                }
                                            }
                                            
                                            else if selectView {
                                                ZStack(alignment: .bottomTrailing) {
                                                    List($homeAwaitingViewModel.scheduleData,id: \.threadID) { $scheduleddata in
                                                        VStack(alignment: .leading) {
                                                            HStack{
                                                                Button(action: {
                                                                    if let threadId = scheduleddata.threadID {
                                                                        if selectedIndices.contains(threadId) {
                                                                            selectedIndices.remove(threadId)
                                                                            homeAwaitingViewModel.selectedThreadIDs.removeAll { $0 == threadId }
                                                                        } else {
                                                                            selectedIndices.insert(threadId)
                                                                            homeAwaitingViewModel.selectedThreadIDs.append(threadId)
                                                                        }
                                                                        isSelectAll = selectedIndices.count == homeAwaitingViewModel.scheduleData.count
                                                                    }
                                                                }) {
                                                                    Image(systemName: selectedIndices.contains(scheduleddata.threadID ?? -1) ?  "checkmark.square.fill" : "square")
                                                                        .resizable()
                                                                        .renderingMode(.template)
                                                                        .frame(width: 20, height: 20)
                                                                        .padding(.top, 1)
                                                                        .padding(.leading, 20)
                                                                        .foregroundColor(selectedIndices.contains(scheduleddata.threadID ?? -1) ? themesviewModel.currentTheme.colorAccent : themesviewModel.currentTheme.iconColor)
                                                                        .contentShape(Rectangle())
                                                                }
                                                                
                                                                
                                                                
                                                                VStack(alignment: .leading){
                                                                    if scheduleddata.status?.rawValue ?? "" == "scheduled"{
                                                                        if let recipient = scheduleddata.recipients.first(where: { $0.type == "to" }) {
                                                                            Text(recipient.user.firstname ?? "")
                                                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                                .onTapGesture {
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
                                                            .padding([.top , .bottom] , 10)
                                                            
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
                                                    .padding(.bottom, 50)
                                                    
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
                                
                                else if homeAwaitingViewModel.istLetersSelected{
                                    if homeAwaitingViewModel.isLoading {
                                        CustomProgressView()
                                    }
                                    else{
                                        VStack{
                                                Image("coming soon") // Replace with the actual image name
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .scaledToFit()
                                                    .frame(width: reader.size.height * 0.2, height: reader.size.height * 0.2)
                                            Spacer()
                                        }
                                        .background(themesviewModel.currentTheme.windowBackground)
                                    }
                                }
                                
                                else if homeAwaitingViewModel.istCardsSelected{
                                    if homeAwaitingViewModel.isLoading {
                                        CustomProgressView()
                                    }
                                    else{
                                        VStack{
                                                Image("coming soon")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .scaledToFit()
                                                    .frame(width: reader.size.height * 0.2, height: reader.size.height * 0.2)
                                            Spacer()
                                        }
                                        .background(themesviewModel.currentTheme.windowBackground)
                                    }
                                }
                                
                                
                            }
                        }
                    
                    if homeAwaitingViewModel.beforeLongPress{
                        TabViewNavigator()
                            .frame(height: 40)
                            .padding(.bottom, 10)
                    }
                }
                .toast(message: $homeAwaitingViewModel.error)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        homeAwaitingViewModel.getEmailsData()
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        showEmptyText = true
                    }
                    

                }
                
                .background(
                                    Color.clear
                                        .blur(radius: isQuickAccessVisible ? 5 : 0) // Apply blur to the background
                                )
                
                if homeAwaitingViewModel.beforeLongPress{
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
                    .padding(.bottom, 50)
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                                homeAwaitingViewModel.deleteEmailFromAwaiting(threadIDS: homeAwaitingViewModel.selectedThreadIDs)
                                showingDeleteAlert = false
                                beforeLongPress = true
                                AppBar = true
                            }
                            
                            if homeAwaitingViewModel.isEmailSelected {
                                homeAwaitingViewModel.emailData.removeAll { item in
                                    homeAwaitingViewModel.selectedThreadIDs.contains(item.threadID ?? 0)
                                }
                            }
                            
                            else if homeAwaitingViewModel.isDraftsSelected {
                                homeAwaitingViewModel.draftsData.removeAll { item in
                                    homeAwaitingViewModel.selectedThreadIDs.contains(item.threadID ?? 0)
                                }
                            }
                            else if homeAwaitingViewModel.istDraftselected {
                                homeAwaitingViewModel.tDraftsData.removeAll { item in
                                    homeAwaitingViewModel.selectedThreadIDs.contains(item.threadID ?? 0)
                                }
                            }

                            else if homeAwaitingViewModel.isScheduledSelected {
                                homeAwaitingViewModel.scheduleData.removeAll { item in
                                    homeAwaitingViewModel.selectedThreadIDs.contains(item.threadID ?? 0)
                                }
                            }
                            selectedIndices.removeAll()

                        }
                    }
                    .transition(.scale)
                }
                
                
                if isMoveSheetvisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isMoveSheetvisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            MoveTo(isMoveToSheetVisible: $isMoveSheetvisible , selectedThreadID : $homeAwaitingViewModel.selectedThreadIDs, selectedIndices: $selectedIndices)
                                .offset(y: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.height > 0 {
                                                dragOffset = value.translation.height
                                            }
                                        }
                                        .onEnded { value in
                                            let dragHeight = value.translation.height
                                            let dismissThreshold: CGFloat = 50 // lower this for more sensitivity

                                            if dragHeight > dismissThreshold {
                                                withAnimation {
                                                    isMoveSheetvisible = false
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                                .onAppear {
                                    dragOffset = 0 // ← THIS fixes the “halfway open” issue
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isMoveSheetvisible)
                        }
                    }
                }
               
                if isTagsheetvisible {
                    ZStack {
                        // Tappable background
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isTagsheetvisible = false
                                }
                            }
                        VStack {
                            Spacer() // Pushes the sheet to the bottom
                            CreateTagLabel(isTagSheetVisible: $isTagsheetvisible, isActive: $isactive, HomeawaitingViewVisible: $HomeawaitingViewVisible, selectedNewBottomTag: $selectednewDiaryTag, selectedNames: $selectednames, selectedID:  $homeAwaitingViewModel.selectedThreadIDs, isclicked: $isClicked , isCheckedLabelID: $isCheckedLabelID)
                                .offset(y: dragOffset)
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            if value.translation.height > 0 {
                                                dragOffset = value.translation.height
                                            }
                                        }
                                        .onEnded { value in
                                            let dragHeight = value.translation.height
                                            let dismissThreshold: CGFloat = 200 // lower this for more sensitivity

                                            if dragHeight > dismissThreshold {
                                                withAnimation {
                                                    isTagsheetvisible = false
                                                }
                                            } else {
                                                withAnimation {
                                                    dragOffset = 0
                                                }
                                            }
                                        }
                                )
                                .onAppear {
                                    dragOffset = 0 // ← THIS fixes the “halfway open” issue
                                }
                                .transition(.move(edge: .bottom))
                                .animation(.easeInOut, value: isTagsheetvisible)
                        }
                    }
                }
                

                if isMoreSheetvisible {
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.3))
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    isMoreSheetvisible = false
                                }
                            }

                        VStack {
                            Spacer()

                            MoreSheet(snoozetime: $snoozeTime, isMoreSheetVisible: $isMoreSheetvisible, emailId: emailId, passwordHash: passwordHash, isTagsheetvisible: $isTagsheetvisible, isSnoozeSheetvisible: $issnoozesheetvisible ,StarreEmail: $EmailStarred ,markedAs: $markAs , HomeawaitingViewVisible: $HomeawaitingViewVisible, isMoveSheetvisible: $isMoveSheetvisible)
                            .offset(y: dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        if value.translation.height > 0 {
                                            dragOffset = value.translation.height
                                        }
                                    }
                                    .onEnded { value in
                                        let dragHeight = value.translation.height
                                        let dismissThreshold: CGFloat = 200 // lower this for more sensitivity

                                        if dragHeight > dismissThreshold {
                                            withAnimation {
                                                isMoreSheetvisible = false
                                            }
                                        } else {
                                            withAnimation {
                                                dragOffset = 0
                                            }
                                        }
                                    }
                            )
                            .onAppear {
                                dragOffset = 0 // ← THIS fixes the “halfway open” issue
                            }
                            .transition(.move(edge: .bottom))
                            .animation(.easeInOut, value: isMoreSheetvisible)
                        }
                    }
                }


            }
            .sheet(isPresented: $isSheetVisible, content: {
                EmailOptionsView( replyAction: {
                    dismissSheet()
                },
                                  replyAllAction: {
                    dismissSheet()
                },
                                  forwardAction: {
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
                    homeAwaitingViewModel.getStarredEmail(selectedEmail: homeAwaitingViewModel.selectedID ?? 0)
                    dismissSheet()
                },
                                  snoozeAction: {
                    if let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == homeAwaitingViewModel.selectedID}) {
                        homeAwaitingViewModel.emailData[index].threadID
                        }
                },
                                  trashAction: {
                    dismissSheet()
                }
                )
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $isMultiSelectionSheetVisible, content: {
                MultiEmailOptionsView(markAsReadAction: {
                }, markAsUnReadAction: {
                }, createLabelAction: {
                }, moveToFolderAction: {
                }, snoozeAction: {
                }, trashAction: {
                })
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
            })
            .sheet(isPresented: $isMoveToFolder, content: {
            })
            .sheet(isPresented: $isCreateLabel, content: {
                CreateLabelView()
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.hidden)
            })
            .onChange(of: homeAwaitingViewModel.isEmailScreen || isMoreSheetvisible || isMoveSheetvisible || isTagsheetvisible) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        homeAwaitingViewModel.getEmailsData()
                        selectedIndices = []
                        homeAwaitingViewModel.selectedThreadIDs = []
                    }
                }
                else if newValue == false && homeAwaitingViewModel.istDraftselected {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        homeAwaitingViewModel.getTDraftsData()
                    }
                }
            }
            .onChange(of: homeAwaitingViewModel.isdraftEmail) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        homeAwaitingViewModel.getDraftsData()
                    }
                }
            }
            .onChange(of: homeAwaitingViewModel.isScheduleEmail) { newValue in
                if newValue == false {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        homeAwaitingViewModel.getScheduleEmailsData()
                    }
                }
            }

            .fullScreenCover(isPresented: $homeAwaitingViewModel.isEmailScreen) {
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, awaitingView: $HomeawaitingViewVisible,  emailId: homeAwaitingViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $EmailStarred , markAs: $markAs ).toolbar(.hidden)
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
            
           
            

            
        }
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
    HomeAwaitingView(imageUrl: "")
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
