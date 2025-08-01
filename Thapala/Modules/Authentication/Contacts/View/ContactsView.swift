//
//  ContactsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//
import SwiftUI

struct ContactsView: View {
    @StateObject var contactsViewModel = ContactsViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @State private var isMenuVisible = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        withAnimation {
                            isMenuVisible.toggle()
                        }
                    } label: {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                    }

                    Spacer()

                    Text("Contacts")
                        .foregroundColor(themesviewModel.currentTheme.textColor)
                        .font(.custom(.poppinsSemiBold, size: 16))

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                Spacer()
                    .frame(height: 15)
                // Contact List
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(contactsViewModel.contactsData) { contact in
                            VStack(spacing: 0) {
                                HStack {
                                    let imageURL = contact.profile ?? "person"
                                    AsyncImage(url: URL(string: imageURL)) { phase in
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

                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .padding(.horizontal, 5)

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

                                        @unknown default:
                                            EmptyView()
                                        }
                                    }

                                    Text("\(contact.firstname ?? "") \(contact.lastname ?? "")")
                                        .font(.custom(.poppinsMedium, size: 16))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)

                                    Spacer()
                                }
                                .padding([.top , .bottom ] , 10)
                                .padding(.leading, 15)

                                Divider()
                                    .frame(height: 1)
                                    .background(themesviewModel.currentTheme.strokeColor.opacity(0.2))
                                    .padding(.top)
                            }
                        }
                    }
                }
            }
            .background(themesviewModel.currentTheme.windowBackground)
            .edgesIgnoringSafeArea(.bottom)

            // Side Menu Overlay
            if isMenuVisible {
                HomeMenuView(isSidebarVisible: $isMenuVisible)
                    .transition(.move(edge: .leading))
            }
        }
    }
}

#Preview {
    ContactsView()
}

