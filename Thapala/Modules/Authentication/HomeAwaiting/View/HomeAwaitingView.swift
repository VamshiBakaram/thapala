//
//  HomeAwaitingView.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import SwiftUI
struct HomeAwaitingView: View {
    @State private var isMenuVisible = false
    @ObservedObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                themesviewModel.currentTheme.windowBackground
                VStack{
                    if homeAwaitingViewModel.beforeLongPress{
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
                                        self.homeAwaitingViewModel.isEmailSelected = true
                                        self.homeAwaitingViewModel.isPrintSelected = false
                                        self.homeAwaitingViewModel.isOntlineSelected = false
                                        homeAwaitingViewModel.getEmailsData()
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
                        .frame(height: 120)
                        .background(themesviewModel.currentTheme.colorPrimary)
                        
                        HStack{
                            if let selectedOption = homeAwaitingViewModel.selectedOption {
                                switch selectedOption {
                                case .email:
                                    Spacer()
                             
                                    Text("")
                                case .print:
                             
                                    Text("")
                                case .outline:
                                    Spacer()
                                    HStack{
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(self.homeAwaitingViewModel.isDraftsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                            .frame(height: 50)
                                            .onTapGesture {
                                                self.homeAwaitingViewModel.outlineSelectedOption = .draft
                                                self.homeAwaitingViewModel.isDraftsSelected = true
                                                self.homeAwaitingViewModel.istDraftselected = false
                                                self.homeAwaitingViewModel.isScheduledSelected = false
                                                self.homeAwaitingViewModel.getDraftsData()
                                            }
                                            .overlay(
                                                Group{
                                                    HStack{
                                                        VStack{
                                                            Text("Drafts")
                                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                .foregroundColor(self.homeAwaitingViewModel.isDraftsSelected ? themesviewModel.currentTheme.textColor:themesviewModel.currentTheme.inverseTextColor)
                                                        }
                                                    }
                                                }
                                            )
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(self.homeAwaitingViewModel.istDraftselected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                            .frame(height: 50)
                                            .onTapGesture {
                                                self.homeAwaitingViewModel.outlineSelectedOption = .tDraft
                                                self.homeAwaitingViewModel.isDraftsSelected = false
                                                self.homeAwaitingViewModel.istDraftselected = true
                                                self.homeAwaitingViewModel.isScheduledSelected = false
                                                self.homeAwaitingViewModel.getTDraftsData()
                                                
                                            }
                                            .overlay(
                                                Group{
                                                    HStack{
                                                        VStack{
                                                            Text("tDrafts")
                                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                .foregroundColor(self.homeAwaitingViewModel.istDraftselected ? themesviewModel.currentTheme.textColor:themesviewModel.currentTheme.inverseTextColor)
                                                        }
                                                    }
                                                }
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(self.homeAwaitingViewModel.isScheduledSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.tabBackground)
                                            .frame(height: 50)
                                            .onTapGesture {
                                                self.homeAwaitingViewModel.outlineSelectedOption = .schedule
                                                self.homeAwaitingViewModel.isDraftsSelected = false
                                                self.homeAwaitingViewModel.istDraftselected = false
                                                self.homeAwaitingViewModel.isScheduledSelected = true
                                                self.homeAwaitingViewModel.getScheduleEmailsData()
                                                
                                            }
                                            .overlay(
                                                Group{
                                                    HStack{
                                                        VStack{
                                                            Text("Scheduled")
                                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                                    .foregroundColor(self.homeAwaitingViewModel.isScheduledSelected ? themesviewModel.currentTheme.textColor : themesviewModel.currentTheme.inverseTextColor)
                                                        }
                                                    }
                                                }
                                            )
                                    }
                                    // .padding()
                                    .background(themesviewModel.currentTheme.tabBackground)
                                    .cornerRadius(25)
                                    
                                }
                            }
                        }
                        .padding()
                        
                        if let selectedOption = homeAwaitingViewModel.selectedOption {
                            switch selectedOption {
                            case .email:
                                if homeAwaitingViewModel.emailData.count == 0{
                                    Text("No Mails Found.")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                }else{
                                    VStack{
                                        List($homeAwaitingViewModel.emailData) { $data in
                                            HStack{
                                                if data.isSelected{
                                                    Image("select")
                                                        .resizable()
                                                        .frame(width: 24,height: 24)
                                                        .padding([.trailing,.leading],5)
                                                        .clipShape(Circle())
                                                    
                                                }else{
                                          
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
                                                }
                                                
                                                VStack(alignment: .leading){
                                                    Text(firstName)
                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    Text(Subject)
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
                                                            // Safely unwrap data.threadID
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
//                                                    Image(data.isStarred ? "star" : "emptystar")
//                                                        .resizable()
//                                                        .frame(width: 14, height: 14)
//                                                        .foregroundColor(.black)
//                                                        .onTapGesture {
//                                                            // Safely unwrap data.threadID
//                                                            if let threadID = data.threadID,
//                                                               let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == threadID }) {
//                                                                print("thread id:", threadID)
//                                                                homeAwaitingViewModel.emailData[index].isStarred.toggle()
//                                                                homeAwaitingViewModel.getStarredEmail(selectedEmail: threadID)
//                                                            } else {
//                                                                print("threadID is nil")
//                                                            }
//                                                        }

                                                }
                                                    .frame(height: 34)
                                            }
                                            .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                            .onTapGesture {
                                                if homeAwaitingViewModel.beforeLongPress {
                                                    homeAwaitingViewModel.selectedID = data.threadID
                                                    homeAwaitingViewModel.passwordHint = data.passwordHint
                                                    homeAwaitingViewModel.isEmailScreen = true
                                                } else {
                                                    selectEmail(data: data)
                                                }
                                            }
                                            .gesture(
                                                LongPressGesture(minimumDuration: 1.0)
                                                    .onEnded { _ in
                                                        withAnimation {
                                                            homeAwaitingViewModel.beforeLongPress = false
                                                            selectEmail(data: data)
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
                                }
                            case .print:
                                VStack{
                                    /*
                                     List(printData) { data in
                                     HStack{
                                     Image(data.image)
                                     .padding([.trailing,.leading],5)
                                     .frame(width: 34,height: 34)
                                     .clipShape(Circle())
                                     VStack(alignment: .leading){
                                     Text(data.title)
                                     .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                     Text(data.subTitle)
                                     .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                     .lineLimit(1)
                                     }
                                     Spacer()
                                     Text(data.time)
                                     }
                                     .listRowBackground(Color(red:246/255, green: 246/255, blue: 251/255))
                                     }
                                     .listStyle(PlainListStyle())
                                     .scrollContentBackground(.hidden)
                                     */
//                                    Text("Coming Soon")
//                                        .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
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
                                    
//                                    .alignmentGuide(.center); // Align both horizontally and vertically to the center
//                                           .opacity(0) // Set opacity to 0 if you want it to be invisible; adjust if needed
//                                           .position(x: 107 + 160 / 2, y: 350 + 111.02 / 2) // Position the image based on top and left constraints

                                    
                                }
                            case .outline:
                                if homeAwaitingViewModel.isDraftsSelected{
                                    if homeAwaitingViewModel.draftsData.count == 0{
                                        Text("No Mails Found.")
                                            .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                    }else{
                                        VStack{
                                            List($homeAwaitingViewModel.draftsData,id: \.self) { $data in
                                                HStack{
                                                    Image("person")
                                                        .padding([.trailing,.leading],5)
                                                        .frame(width: 34,height: 34)
                                                        .clipShape(Circle())
                                                    HStack {
                                                        VStack(alignment: .leading){
                                                            if data.status?.rawValue ?? "" == "draft"{
                                                                Text(data.firstName ?? "")
                                                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                
                                                            }
                                                            if let subject = data.parentSubject {
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
                                                        homeAwaitingViewModel.selectedID = data.threadID
                                                        homeAwaitingViewModel.passwordHint = data.passwordHint
                                                        homeAwaitingViewModel.isdraftEmail = true
                                                    }
                                                }
                                                
                                            }
                                            
                                            .listStyle(PlainListStyle())
                                            .scrollContentBackground(.hidden)
                                        }
                                    }
                                }else if homeAwaitingViewModel.istDraftselected{
                                    if homeAwaitingViewModel.tDraftsData.count == 0{
                                        Text("No Mails Found.")
                                            .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                            .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                    }else{
                                        VStack{
                                            List($homeAwaitingViewModel.tDraftsData,id: \.self) { $data in
                                                HStack{
                                                    Image("person")
                                                        .padding([.trailing,.leading],5)
                                                        .frame(width: 34,height: 34)
                                                        .clipShape(Circle())
                                                    VStack(alignment: .leading){
                                                        if data.status?.rawValue ?? "" == "draft"{
                                                            Text("Draft")
                                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                        
                                                        //                                                        Text(data.subject ?? "")
                                                        //                                                            .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                        //                                                            .lineLimit(1)
                                                        if let subject = data.subject, !subject.isEmpty {
                                                            Text(subject)
                                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .lineLimit(1)
                                                        } else{
                                                            Text("No Subject")
                                                                .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                                .lineLimit(1)
                                                        }
                                                        
                                                    }
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
                                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                .onTapGesture {
                                                    if homeAwaitingViewModel.beforeLongPress {
                                                        homeAwaitingViewModel.selectedID = data.threadID
                                                        homeAwaitingViewModel.passwordHint = data.passwordHint
                                                        homeAwaitingViewModel.isdraftEmail = true
                                                    }
                                                }
                                                
                                            }
                                            .listStyle(PlainListStyle())
                                            .scrollContentBackground(.hidden)
                                            
                                        }
                                    }
                                }else if homeAwaitingViewModel.isScheduledSelected{
                                    if homeAwaitingViewModel.scheduleData.count == 0{
                                        Text("No Mails Found.")
                                            .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                            .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                    }else{
                                        VStack{
                                            List($homeAwaitingViewModel.scheduleData,id: \.self) { $data in
                                                HStack{
                                                    Image("person")
                                                        .padding([.trailing,.leading],5)
                                                        .frame(width: 34,height: 34)
                                                        .clipShape(Circle())
                                                    VStack(alignment: .leading){
                                                        if data.status?.rawValue ?? "" == "scheduled"{
                                                            Text("Scheduled")
                                                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                        
                                                        Text(data.subject ?? "")
                                                            .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .lineLimit(1)
                                                    }
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
                                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                                .onTapGesture {
                                                    if homeAwaitingViewModel.beforeLongPress {
                                                        homeAwaitingViewModel.selectedID = data.threadID
                                                        homeAwaitingViewModel.passwordHint = data.passwordHint
                                                        homeAwaitingViewModel.isScheduleEmail = true
                                                    }
                                                }
                                                
                                            }
                                            .listStyle(PlainListStyle())
                                            .scrollContentBackground(.hidden)
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }else{
                        VStack{
                            HStack{
                                Spacer()
                                Text("\(homeAwaitingViewModel.selectedThreadIDs.count) Selected")
                                    .font(.custom(.poppinsRegular, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                
                                Spacer()
                                
                                Button {
                                    homeAwaitingViewModel.beforeLongPress.toggle()
                                    homeAwaitingViewModel.selectedThreadIDs.removeAll()
                                } label: {
                                    Text("Cancel")
                                        .foregroundColor(Color.themeColor)
                                }
                                .padding(.trailing,15)
                            }
                            
                            HStack{
                                Image(homeAwaitingViewModel.selectedThreadIDs.count != 0 ? "checkbox" : "Check")
                                    .resizable()
                                    .frame(width: 24,height: 24)
                                    .padding([.trailing,.leading],5)
                                    .onTapGesture {
                                        selectAllEmails()
                                    }
                                Image("dropdown")
                                Text("Select All")
                                    .font(.custom(.poppinsRegular, size: 14))
                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                    .onTapGesture {
                                        selectAllEmails()
                                    }
                                Spacer()
                            }
                            .padding(.leading,15)
                        }
                    
                        VStack{

                            
                            HStack(spacing:50) {
                                Button(action: {
                                    homeAwaitingViewModel.deleteEmailFromAwaiting()
                                }) {
                                    Image(systemName: "trash")
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                }
                                
                                
                                Button(action: {
                                    homeAwaitingViewModel.toggleReadStatusForSelectedEmails()
                                }) {
                                    Image(systemName: homeAwaitingViewModel.shouldDisplayOpenEnvelope ? "envelope" : "envelope.open")
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                }
                                
                                
                                Button(action: {
                                    isMoveToFolder = true
                                }) {
                                    Image(systemName: "folder")
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                }
                                
                                Button(action: {
                                    isCreateLabel = true
                                }) {
                                    Image(systemName: "tag")
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                }
                                
                                Button(action: {
                                    //  isSheetVisible = true
                                    emailSelectionSheetOptions()
                                }) {
                                    Image(systemName: "ellipsis")
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                }
                                
                            }
                            .padding([.leading,.trailing], 20)
                            
                        }
                        
                    }
                    
                    if homeAwaitingViewModel.beforeLongPress{
                        Spacer()
                        HStack{
                            Spacer()
                            /*
                             Button(action: {
                             homeAwaitingViewModel.isPlusBtn = true
                             }) {
                             Image("plus")
                             .font(Font.title.weight(.medium))
                             .foregroundColor(Color.white)
                             }
                             .padding(.trailing,15)
                             */
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
//                                    if isQuickAccessVisible {
//                                                        Color.white.opacity(0.5) // Optional: semi-transparent background
//                                                            .ignoresSafeArea()
//                                                            .blur(radius: 10) // Blur effect for the background
//                                                        QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
//                                                            .background(Color.white) // Background color for the Quick Access View
//                                                            .cornerRadius(10)
//                                                            .shadow(radius: 10)
//                                                            .padding()
//                                                    }
                                }
                                .padding(.trailing)
                                .padding(.bottom)
                        }
                    }
                    
//                    Spacer()
                    
                    TabViewNavigator()
                        .frame(height: 40)
                    
                    
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    if homeAwaitingViewModel.emailData.isEmpty {
                        homeAwaitingViewModel.getEmailsData()
                    }
                }
                .onChange(of: homeAwaitingViewModel.emailData) { newData in
                    let mappedEmails = newData.map { email in
                        firstName = email.firstname ?? ""
                        Subject = email.subject ?? ""
                        if let unixTimestamp = email.sentAt,
                           let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                            TimeSent = unixTimestamp
                        }
                        print("obtained FirstName: \(firstName)")
                        print("obtained Subject: \(Subject)")
                        print("obtained TimeSent (Unix): \(TimeSent)")
                    }
                }

//                .onAppear {
//                    if homeAwaitingViewModel.emailData.isEmpty {
//                        homeAwaitingViewModel.getEmailsData()
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 500 / 1000.0) {
//                        firstName = homeAwaitingViewModel.emailData.first?.firstname ?? ""
//                        Subject = homeAwaitingViewModel.emailData.first?.subject ?? ""
//                        if let unixTimestamp = homeAwaitingViewModel.emailData.first?.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
//                            TimeSent = unixTimestamp
//                        }
//                        print("firstName\(firstName)")
//                        print("Subject\(Subject)")
//                        print("TimeSent\(TimeSent)")
//                        
//                        
//                    }
//                }
                .background(
                                    Color.clear
                                        .blur(radius: isQuickAccessVisible ? 5 : 0) // Apply blur to the background
                                )
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
                
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
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
            .navigationDestination(isPresented: $homeAwaitingViewModel.isEmailScreen) {
                if homeAwaitingViewModel.passwordHint != nil{
                    PasswordProtectedAccessView(isPasswordProtected: $homeAwaitingViewModel.isEmailScreen, emailId: homeAwaitingViewModel.selectedID ?? 0,passwordHint: homeAwaitingViewModel.passwordHint ?? "").toolbar(.hidden)
                }else{
                    MailFullView(conveyedView: $conveyedView, PostBoxView: $PostBoxView, emailId: homeAwaitingViewModel.selectedID ?? 0, passwordHash: "").toolbar(.hidden)
                }
                
            }
            .navigationDestination(isPresented: $homeAwaitingViewModel.isComposeEmail) {
                MailComposeView(id:homeAwaitingViewModel.selectedID ?? 0).toolbar(.hidden)
            }
            .navigationDestination(isPresented: $homeAwaitingViewModel.isdraftEmail) {
                draftView(id:homeAwaitingViewModel.selectedID ?? 0).toolbar(.hidden)
            }
            .navigationDestination(isPresented: $homeAwaitingViewModel.isScheduleEmail) {
                ScheduleView(id:homeAwaitingViewModel.selectedID ?? 0).toolbar(.hidden)
            }
//            .toast(message: $homeAwaitingViewModel.error)
            
            if homeAwaitingViewModel.isPlusBtn {
                QuickAccessView(isQuickAccessVisible: $homeAwaitingViewModel.isPlusBtn)
                    .transition(.opacity)
            }
            
        }
    }
    
    private func selectEmail(data: HomeEmailsDataModel) {
        if let index = homeAwaitingViewModel.emailData.firstIndex(where: { $0.threadID == data.threadID }) {
            homeAwaitingViewModel.emailData[index].isSelected.toggle()
            if homeAwaitingViewModel.emailData[index].isSelected {
                homeAwaitingViewModel.selectedThreadIDs.append(data.threadID ?? 0)
            } else {
                homeAwaitingViewModel.selectedThreadIDs.removeAll { $0 == data.threadID }
            }
        }
    }
    
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
