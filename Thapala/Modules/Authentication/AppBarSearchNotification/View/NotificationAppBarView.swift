//
//  NotificationView.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/06/25.
//

import SwiftUI

struct NotificationAppBarView: View {
    @StateObject var themesviewModel = ThemesViewModel()
    @StateObject var appBarElementsViewModel = AppBarElementsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var toastMessage: String? = nil
    var body: some View {
        GeometryReader { reader in
            ZStack {
                themesviewModel.currentTheme.windowBackground
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Notifications")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsBold, size: 14))
                            .padding(.leading, 16)
                            .padding(.top,15)
                            .bold()
                        Spacer()
                    }
                    
                    Divider()
                        .frame(height: 1)
                        .background(themesviewModel.currentTheme.customEditTextColor)
                        .padding([.leading, .trailing], 16)
                    
                    if appBarElementsViewModel.notificationsData.count == 0 {
                        VStack (alignment: .center){
                            Text("No Notifications found")
                                .font(.custom(.poppinsBold, size: 16))
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                            Spacer()
                        }
                    }
                    else {
                        List(appBarElementsViewModel.notificationsData, id: \.id) { NotificationData in
                            HStack {
                                Image("notificationProfile")
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 12)
                                VStack {
                                    Text(NotificationData.title ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsBold, size: 14))
                                        .padding(.leading, 16)
                                    
                                    Text(NotificationData.body ?? "")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 12))
                                        .padding(.leading, 16)
                                        .lineLimit(1)
                                }
                                Spacer()
                                if let istDateStringFromTimestamp = convertToIST(dateInput: NotificationData.createdAt ?? "") {
                                    Text(istDateStringFromTimestamp)
                                        .font(.custom(.poppinsLight, size: 12, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(.top, 0)
                                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                                }
                                
                            }
                            .listRowBackground(themesviewModel.currentTheme.windowBackground)
                        }
                        .listStyle(PlainListStyle())
                        .scrollContentBackground(.hidden)
                    }

                }
                .toast(message: $appBarElementsViewModel.error)
                .onAppear{
                    appBarElementsViewModel.getAppBarNotifications()
                }
            }
        }
    }
}

#Preview {
    NotificationAppBarView()
}
