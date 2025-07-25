//
//  chatBoxView.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/04/25.
//
import SwiftUI

struct ChatBoxView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var homePostboxViewModel = HomePostboxViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @ObservedObject var themesviewModel = ThemesViewModel()
    @State private var messageText: String = ""
    var selectID: Int
    var roomid: String
    @State private var firstname: String = ""
    @State private var profile: String = ""
    @State private var chatMessage: [String] = []
    @State private var messages: [Message] = []
//    @State private var Getmessages: [ChatMessage] = []
    private var socketManager = WebSocketManager()
    init(selectID: Int, roomid: String, homePostboxViewModel: HomePostboxViewModel = HomePostboxViewModel()) {
        self.selectID = selectID
        self.roomid = roomid
        self._homePostboxViewModel = ObservedObject(initialValue: homePostboxViewModel)
    }
    var body: some View {
        ZStack {
            themesviewModel.currentTheme.windowBackground
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .font(.system(size: 20, weight: .bold))
                            Text("Back")
                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
                
                VStack(spacing: 0) {
                    HStack(alignment: .center) {
                        AsyncImage(url: URL(string: profile)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        Text(firstname)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.title3)
                            .fontWeight(.bold)
                        
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                    
                    ScrollViewReader { scrollProxy in
                        ScrollView {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(chatMessage.indices, id: \.self) { index in
                                    Text(chatMessage[index])
                                        .padding()
                                        .padding(.trailing , 16)
                                        .background(themesviewModel.currentTheme.attachmentBGColor)
                                        .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                        .cornerRadius(12)
                                        .id(index) // Assign unique ID for scrolling
                                }
                            }
                            .padding()
                            
                            ForEach(messages) { message in
                                HStack {
                                    if message.isSentByUser {
                                        Spacer()
                                        Text(message.text)
                                            .padding()
                                            .background(themesviewModel.currentTheme.attachmentBGColor)
                                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                            .foregroundColor(.white)
                                            .cornerRadius(12)
                                    } else {
                                        Text(message.text)
                                            .padding()
                                            .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(12)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .onChange(of: chatMessage.count) { _ in
                            // Scroll to bottom when a new message is added
                            withAnimation {
                                scrollProxy.scrollTo(chatMessage.count - 1, anchor: .bottom)
                            }
                        }
                        
                    }
                    
                    
                    HStack {
                        TextField(
                            "",
                            text: $messageText,
                            prompt: Text("Type Message here")
                                .foregroundColor(themesviewModel.currentTheme.textColor.opacity(0.5))
                        )
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(themesviewModel.currentTheme.customEditTextColor)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                        )
                        .foregroundColor(themesviewModel.currentTheme.textColor)


                        
                        Button(action: {
                            guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                            messages.append(Message(text: messageText, isSentByUser: true, timestamp: Date()))
                            messageText = ""
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                .padding()
                                .background(Circle().fill(themesviewModel.currentTheme.colorPrimary))
                        }
                    }
                    .padding()
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 2)
                )
                .padding()
            }
        }
        .onAppear {
            if homePostboxViewModel.ContactsList.isEmpty {
                homePostboxViewModel.getContactsList()
                
            }
            if homePostboxViewModel.GetChatMessage.isEmpty {
                homePostboxViewModel.getAllChats(senderID: sessionManager.userId, recieverId: selectID)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if let settings = homePostboxViewModel.ContactsList.first(where: { $0.id == selectID }) {
                    firstname = settings.firstname
                    profile = settings.profile ?? ""
                }
                chatMessage = homePostboxViewModel.GetChatMessage.map { $0.message }
            }
            socketManager.connect()
        }
        .navigationBarHidden(true)
    }
}
