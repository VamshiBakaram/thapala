//
//  StarredMailsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/10/24.
//

import SwiftUI

struct StarredMailsView: View {
    @ObservedObject var themesviewModel = themesViewModel()
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @State private var selectedTab = "awaited"
    @State private var beforeLongPress = true
    @State private var isMultiSelectionSheetVisible: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isMenuVisible = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    @State private var SnoozedView: Bool = false
    @ObservedObject var starredEmailViewModel = StarredEmailViewModel()
    
    var body: some View {
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
                    print("Selected Tab: \(selectedTab)") }) {
                    Text("Queue")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "awaited" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .cornerRadius(20)
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.2), lineWidth: 1))
                }
                
                Button(action: { selectedTab = "postbox";
                    starredEmailViewModel.getStarredEmailData(selectedTabItem: selectedTab);
                    print("Selected Tab: \(selectedTab)")}) {
                    Text("Postbox")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "postbox" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .cornerRadius(10)
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.2), lineWidth: 1))
                }
                
                Button(action: { selectedTab = "conveyed" ;
                    starredEmailViewModel.getStarredEmailData(selectedTabItem: selectedTab);
                    print("Selected Tab: \(selectedTab)")}) {
                    Text("Conveyed")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "conveyed" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .cornerRadius(10)
//                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black.opacity(0.2), lineWidth: 1))
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
            )
          

            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.top)
//            .background(Color.primary)
            
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
            selectedTab = "awaited"
            starredEmailViewModel.getStarredEmailData(selectedTabItem: selectedTab)
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
    
    var QueueSnoozedMailsView: some View {
        VStack {
            if beforeLongPress {
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
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.trailing, 20)
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
                                        print("thread id \(email.threadId ?? 0)")
                                    }
                            }
                        }
                        //                        Text("\(email.sentAt ?? 0)")
                        //                            .padding(.top, -30)

 
         
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .onTapGesture {
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
                        //                        Text("\(email.sentAt ?? 0)")
                        //                            .padding(.top, -30)
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
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
            }else{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
            }
        }
    }
    
    var postBoxMailsView: some View {
        VStack {
            if beforeLongPress {
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
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.trailing, 20)
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
                                        print("thread id \(email.threadId ?? 0)")
                                    }
                            }
                        }
                        //                        Text("\(email.sentAt ?? 0)")
                        //                            .padding(.top, -30)

 
         
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .onTapGesture {
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
                        //                        Text("\(email.sentAt ?? 0)")
                        //                            .padding(.top, -30)
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
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
            }else{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView ,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
            }
        }
    }
    
    var converyedMailsView: some View {
        VStack {
            if beforeLongPress {
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
                                        print("thread id \(email.threadId ?? 0)")
                                    }
                            }
                        }
                        //                        Text("\(email.sentAt ?? 0)")
                        //                            .padding(.top, -30)

 
         
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .onTapGesture {
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
                        //                        Text("\(email.sentAt ?? 0)")
                        //                            .padding(.top, -30)
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
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView, conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
            }else{
                MailFullView(isMailFullViewVisible: $mailComposeViewModel.mailFullView,conveyedView: $conveyedView, PostBoxView: $PostBoxView, SnoozedView: $SnoozedView, emailId: starredEmailViewModel.selectedID ?? 0, passwordHash: "", StarreEmail: $mailComposeViewModel.mailStars).toolbar(.hidden)
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
