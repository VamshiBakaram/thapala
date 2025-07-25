//
//  searchView.swift
//  Thapala
//
//  Created by Ahex-Guest on 16/06/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var themesviewModel = ThemesViewModel()
    @ObservedObject var appBarElementsViewModel: AppBarElementsViewModel
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var homeAwaitingViewModel = HomeAwaitingViewModel()
    @State private var searchMail: String = ""
    @State private var searchFor: String = ""
    @State private var beforeLongPress = true
    @State private var appBar = true
    @State private var selectedCheck = false
    @State private var toastMessage: String? = nil
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea()

                VStack {
                    // App Bar
                    HStack(alignment: .center) {
                        // Back Button
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image("backButton")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 20, height: 20)
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .padding(.leading, 16)
                        })

//                        Image("backButton")
//                            .resizable()
//                            .renderingMode(.template)
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(themesviewModel.currentTheme.iconColor)
//                            .padding(.leading, 16)
//                            .onTapGesture {
//                                appBarElementsViewModel.isSearch = false
//                            }

                        // Search Field
                        ZStack(alignment: .leading) {
                            if searchMail.isEmpty {
                                Text("Search Mails")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom("Poppins-Regular", size: 12))
                                    .padding(.leading, 49) // Adjust based on icon + padding
                            }

                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 12)

                                TextField("", text: $searchMail)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .font(.custom("Poppins-Regular", size: 12))
                                    .padding(.leading, 13)
                                    .submitLabel(.search)
                                    .onSubmit {
                                        appBarElementsViewModel.getMailsData(keyWord: searchMail, searchfor: searchFor)
                                    }
                            }
                        }
                        .padding()
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.top,20)
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                        .frame(height: 10)

                    // Label
                    HStack {
                        Text("Search in")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsMedium, size: 14))
                            .padding(.leading, 16)
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    // Filter Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            FilterButton(label: "All Mails", isSelected: appBarElementsViewModel.isAllMailsSelected, width: reader.size.width / 3 - 10) {
                                appBarElementsViewModel.isAllMailsSelected = true
                                appBarElementsViewModel.isQueueSelected = false
                                appBarElementsViewModel.ispostBoxSelected = false
                                appBarElementsViewModel.isConveyedSelected = false
                                searchFor = "allmails"
                                appBarElementsViewModel.selectedOption = .allMails
                                appBarElementsViewModel.getMailsData(keyWord: searchMail, searchfor: searchFor)
                            }

                            FilterButton(label: "Queue", isSelected: appBarElementsViewModel.isQueueSelected, width: reader.size.width / 3 - 10) {
                                appBarElementsViewModel.isAllMailsSelected = false
                                appBarElementsViewModel.isQueueSelected = true
                                appBarElementsViewModel.ispostBoxSelected = false
                                appBarElementsViewModel.isConveyedSelected = false
                                searchFor = "awaited"
                                appBarElementsViewModel.selectedOption = .Queue
                                appBarElementsViewModel.getMailsData(keyWord: searchMail, searchfor: searchFor)
                            }

                            FilterButton(label: "PostBox", isSelected: appBarElementsViewModel.ispostBoxSelected, width: reader.size.width / 3 - 10) {
                                appBarElementsViewModel.isAllMailsSelected = false
                                appBarElementsViewModel.isQueueSelected = false
                                appBarElementsViewModel.ispostBoxSelected = true
                                appBarElementsViewModel.isConveyedSelected = false
                                searchFor = "postbox"
                                appBarElementsViewModel.selectedOption = .PostBox
                                appBarElementsViewModel.getMailsData(keyWord: searchMail, searchfor: searchFor)
                            }

                            FilterButton(label: "Conveyed", isSelected: appBarElementsViewModel.isConveyedSelected, width: reader.size.width / 3 - 10) {
                                appBarElementsViewModel.isAllMailsSelected = false
                                appBarElementsViewModel.isQueueSelected = false
                                appBarElementsViewModel.ispostBoxSelected = false
                                appBarElementsViewModel.isConveyedSelected = true
                                searchFor = "conveyed"
                                appBarElementsViewModel.selectedOption = .Conveyed
                                appBarElementsViewModel.getMailsData(keyWord: searchMail, searchfor: searchFor)
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Email List
                    if beforeLongPress {
                        if appBarElementsViewModel.emailData.count == 0 {
                            VStack (alignment: .center){
                                Text("No mails found")
                                    .font(.custom(.poppinsBold, size: 16))
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                Spacer()
                            }
                        }
                        else {
                            List(appBarElementsViewModel.emailData, id: \.threadId) { EmailData in
                                HStack {
                                    Button(action: {}) {
                                        Image("unchecked")
                                            .renderingMode(.template)
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .frame(width: 34, height: 34)
                                            .clipShape(Circle())
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(EmailData.firstname ?? "")
                                            .font(.custom(.poppinsMedium, size: 16))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        
                                        
                                        Text(EmailData.subject ?? "")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 14))
                                            .lineLimit(1)
                                        
                                    }
                                    
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        if let istDateStringFromTimestamp = convertToIST(dateInput: EmailData.sentAt) {
                                            Text(istDateStringFromTimestamp)
                                                .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                                .fontWeight(.bold)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.top, 0)
                                                .frame(maxWidth: .infinity, alignment: .topTrailing)
                                        }

                                        Image(EmailData.starred == 1 ? "star" : "emptystar")
                                            .resizable()
                                            .frame(width: 14, height: 14)
                                            .foregroundColor(Color.red)
                                            .onTapGesture {
                                                if let threadID = EmailData.threadId,
                                                   let index = appBarElementsViewModel.emailData.firstIndex(where: { $0.threadId == threadID }) {
                                                    appBarElementsViewModel.emailData[index].starred = (appBarElementsViewModel.emailData[index].starred == 1) ? 0 : 1
                                                    homeAwaitingViewModel.getStarredEmail(selectedEmail: threadID)
                                                }
                                            }
                                    }
                                        .frame(height: 34)
                                }
                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                                .onTapGesture {
                                    if appBarElementsViewModel.beforeLongPress {
                                        appBarElementsViewModel.selectedemailID = EmailData.threadId
                                        appBarElementsViewModel.isEmailView = true
                                    }
                                }
                                .gesture(
                                    LongPressGesture(minimumDuration: 1.0)
                                        .onEnded { _ in
                                            withAnimation {
                                                beforeLongPress = false
                                                appBar = false
                                            }
                                        }
                                )
                            }
                            .refreshable{
                                appBarElementsViewModel.getMailsData(keyWord: searchMail, searchfor: searchFor)
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
                        }
                    }
                    else {
                        VStack{
                            List(appBarElementsViewModel.emailData, id: \.threadId) { draftData in
                                HStack{
                                    Image(selectedCheck ? "Check" : "unchecked")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                        .padding([.trailing,.leading],5)
                                        .frame(width: 34,height: 34)
                                        .clipShape(Circle())
                                        .onTapGesture{
                                            selectedCheck = true
                                        }
                                    HStack {
                                        VStack(alignment: .leading){
                                                    Text(draftData.firstname ?? "")
                                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                            }
                                                Text(draftData.subject ?? "")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                    .lineLimit(1)
                                            
                                        }
                                    Spacer()
                                    
                                    }
                                }
                                .listRowBackground(themesviewModel.currentTheme.windowBackground)
                            }
//                            .refreshable{
//                            }
                            
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
                            .background(themesviewModel.currentTheme.windowBackground)
                        }
                    
                    }
                .toast(message: $appBarElementsViewModel.error)

                    Spacer()
                }
            }
        }
    
}


struct FilterButton: View {
    var label: String
    var isSelected: Bool
    var width: CGFloat
    var action: () -> Void
    @StateObject var themesviewModel = ThemesViewModel()

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isSelected ? Color.red : Color.blue)
            .frame(width: width, height: 45)
            .overlay(
                Text(label)
                    .font(.custom(.poppinsRegular, size: 14))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
            )
            .onTapGesture {
                action()
            }
    }
}



//#Preview {
//    SearchView(, appBarElementsViewModel: <#AppBarElementsViewModel#>)
//}
