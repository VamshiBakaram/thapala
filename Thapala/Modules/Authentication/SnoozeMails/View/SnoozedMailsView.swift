//
//  SnoozedMailsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/10/24.
//
import SwiftUI

struct SnoozedMailsView:View{
    @ObservedObject var snoozedMailsViewModel = SnoozedMailsViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @State private var selectedTab = "Queue"
    @State private var beforeLongPress = true
    @State private var isMultiSelectionSheetVisible: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isMenuVisible = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    var body: some View {
        VStack{
            HStack{
                Button {
                    withAnimation {
                        isMenuVisible.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                }
                .foregroundColor(Color.black)
                Spacer()
                Text("Snoozed Mails")
                    .font(.custom(.poppinsSemiBold, size: 16))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                Spacer()
            }
            .padding(.leading,20)
            .padding(.top,12)
            
            
            HStack {
                Button(action: {
                    selectedTab = "awaited";
                    snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab);
                    print("selected Tab is : \(selectedTab)")
                    
                }) {
                    Text("Queue")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "awaited" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
//                        )
                }
                
                Button(action: {
                    selectedTab = "postbox";
                    snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab);
                    print("selected Tab is : \(selectedTab)")
                }) {
                    Text("postbox")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "postbox" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
//                        )
                }
                
                Button(action: {
                    selectedTab = "conveyed";
                    snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab);
                    print("selected Tab is : \(selectedTab)")
                }) {
                    Text("conveyed")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "conveyed" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .cornerRadius(10)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10)
//                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
//                        )
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
            )
            .background(themesviewModel.currentTheme.windowBackground) // Light ash color

            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.top)
            
            if selectedTab == "awaited" {
                QueueSnoozedMailsView
            }
            else if selectedTab == "postbox" {
                postboxMailsView
            }
            else if selectedTab == "conveyed" {
                conveyedMailsView
            }
            
            Spacer()
            
        }
        .background(themesviewModel.currentTheme.windowBackground)
        
        .onAppear {
            // Initialize with "awaited" to show QueueSnoozedMailsView on appear
            selectedTab = "awaited"
            snoozedMailsViewModel.getSnoozedEmailData(selectedTabItem: selectedTab)
        }

        .sheet(isPresented: $isMultiSelectionSheetVisible, content: {
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
                dismissSheet()
            },
                              snoozeAction: {
                print("snooze")
                dismissSheet()
            },
                              trashAction: {
                print("trash acti")
                dismissSheet()
            }
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
                List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
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
//                                 Image("star.fill")
                            }
                        }
                        //                        Text("\(email.sentAt ?? 0)")
                        //                            .padding(.top, -30)

 
         
                    }
                    .onTapGesture {
                        snoozedMailsViewModel.selectedID = email.threadId
                        snoozedMailsViewModel.passwordHint = email.passwordHint
                        snoozedMailsViewModel.isEmailScreen = true
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
                List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
                    HStack{
                        Image("checkbox")
                            .resizable()
                            .frame(width: 24,height: 24)
                            .padding([.trailing,.leading],5)
                        VStack(alignment: .leading){
                            HStack {
                                Text(email.firstname ?? "")
                                    .font(.custom(.poppinsRegular, size: 16))
                                Text(email.lastname ?? "")
                                    .font(.custom(.poppinsRegular, size: 16))
                                Spacer()
                                let unixTimestamp = email.snoozeAt ?? 0
                                if let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                                    Text(istDateStringFromTimestamp)
                                        .padding(.trailing, 20)
                                        .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                }
                            }
                            Text(email.subject ?? "")
                                .font(.custom(.poppinsLight, size: 14))
                                .lineLimit(1)
                        }
    //                    Text("\(email.sentAt ?? 0)")
    //                        .padding(.top,-30)
    //                    Spacer()
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
                
                HStack(spacing: 50) {
                    Button(action: { }) {
                        Image(systemName: "trash")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "envelope.open")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "folder")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: { }) {
                        Image(systemName: "tag")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: {
                        isMultiSelectionSheetVisible = true
                    }) {
                        Image(systemName: "ellipsis")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                }
                .padding([.leading, .trailing], 20)
            }
        }
        .navigationDestination(isPresented: $snoozedMailsViewModel.isEmailScreen) {
            if $snoozedMailsViewModel.passwordHint != nil{
                MailFullView(conveyedView: $conveyedView, PostBoxView: $PostBoxView, emailId: snoozedMailsViewModel.selectedID ?? 0, passwordHash: "").toolbar(.hidden)
            }else{
                MailFullView(conveyedView: $conveyedView, PostBoxView: $PostBoxView, emailId: snoozedMailsViewModel.selectedID ?? 0, passwordHash: "").toolbar(.hidden)
            }
        }
    }
    
    var postboxMailsView: some View {
        VStack{
        if beforeLongPress{
            List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
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
//                                 Image("star.fill")
                        }
                    }
                    //                        Text("\(email.sentAt ?? 0)")
                    //                            .padding(.top, -30)


     
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
        
        }else{
            List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
                HStack{
                    Image("checkbox")
                        .resizable()
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .frame(width: 24,height: 24)
                        .padding([.trailing,.leading],5)
                    VStack(alignment: .leading){
                        HStack {
                            Text(email.firstname ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                            Text(email.lastname ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                            Spacer()
                            Text("\(email.snoozeAt ?? 0)")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .lineLimit(1)
                                .padding(.trailing, 20)
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                        }
                        Text(email.subject ?? "")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsLight, size: 14))
                            .lineLimit(1)
                    }
//                    Text("\(email.sentAt ?? 0)")
//                        .padding(.top,-30)
//                    Spacer()
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
                
                HStack(spacing:50) {
                    Button(action: {
                       // homeAwaitingViewModel.deleteEmailFromAwaiting()
                    }) {
                        Image(systemName: "trash")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    
                    Button(action: {
                      //  homeAwaitingViewModel.toggleReadStatusForSelectedEmails()
                    }) {
                        Image(systemName: "envelope.open")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    
                    Button(action: {
                      //  isMoveToFolder = true
                    }) {
                        Image(systemName: "folder")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: {
                     //   isCreateLabel = true
                    }) {
                        Image(systemName: "tag")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: {
                        isMultiSelectionSheetVisible = true
                    }) {
                        Image(systemName: "ellipsis")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                }
                .padding([.leading,.trailing], 20)

            }
        }
    }
    
    var conveyedMailsView: some View {
        VStack{
        if beforeLongPress{
            List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
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
//                                 Image("star.fill")
                        }
                    }
                    //                        Text("\(email.sentAt ?? 0)")
                    //                            .padding(.top, -30)


     
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
        
        }else{
            List($snoozedMailsViewModel.snoozedMailsDataModel, id: \.id) { $email in
                HStack{
                    Image("checkbox")
                        .resizable()
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .frame(width: 24,height: 24)
                        .padding([.trailing,.leading],5)
                    VStack(alignment: .leading){
                        HStack {
                            Text(email.firstname ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                            Text(email.lastname ?? "")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16))
                            Spacer()
                            Text("\(email.snoozeAt ?? 0)")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .lineLimit(1)
                                .padding(.trailing, 20)
                                .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                        }
                        Text(email.subject ?? "")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsLight, size: 14))
                            .lineLimit(1)
                    }
//                    Text("\(email.sentAt ?? 0)")
//                        .padding(.top,-30)
//                    Spacer()
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
                HStack(spacing:50) {
                    Button(action: {
                       // homeAwaitingViewModel.deleteEmailFromAwaiting()
                    }) {
                        Image(systemName: "trash")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    
                    Button(action: {
                      //  homeAwaitingViewModel.toggleReadStatusForSelectedEmails()
                    }) {
                        Image(systemName: "envelope.open")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    
                    Button(action: {
                      //  isMoveToFolder = true
                    }) {
                        Image(systemName: "folder")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: {
                     //   isCreateLabel = true
                    }) {
                        Image(systemName: "tag")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                    Button(action: {
                        isMultiSelectionSheetVisible = true
                    }) {
                        Image(systemName: "ellipsis")
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                    }
                    
                }
                .padding([.leading,.trailing], 20)

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
