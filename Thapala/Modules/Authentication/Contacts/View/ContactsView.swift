//
//  ContactsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 09/10/24.
//
import SwiftUI
struct ContactsView:View{
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var contactsViewModel = ContactsViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @State private var isMenuVisible = false
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Button {
                    withAnimation {
                        isMenuVisible.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                    
                }
                .foregroundColor(themesviewModel.currentTheme.iconColor)
                Text("Contacts")
                    .font(.custom(.poppinsSemiBold, size: 16))
                    .foregroundColor(themesviewModel.currentTheme.textColor)
                Spacer()
            }
            .padding(.leading,20)
            .padding(.top,0)
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
            List {
                ForEach(contactsViewModel.contactsData) { index in
                    VStack(spacing: 0) { // No spacing between HStack and Divider
                        HStack {
                            AsyncImage(url: URL(string: index.profile ?? "person")) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .padding(.leading,20)
                                case .failure:
                                    Image("person")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .padding(.leading,20)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text("\(index.firstname ?? "") \(index.lastname ?? "")")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsMedium, size: 12))
                                .padding(.leading, 8)
                            Spacer()
                        }
                        .padding(.leading, 15)
                        .padding(.top,0)
                        Divider()
                            .background(themesviewModel.currentTheme.textColor)
                            .padding(.horizontal, 20)
                            .padding(.top,10)
                    }
                    .listRowBackground(themesviewModel.currentTheme.windowBackground)
                    .padding(.vertical, 2) // Reduced padding between items
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            
        }
        .background(themesviewModel.currentTheme.windowBackground)
        
        if isMenuVisible{
            HomeMenuView(isSidebarVisible: $isMenuVisible)
        }
    }
}

#Preview {
    ContactsView()
}
