//
//  LabeledMailsView.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/10/24.
//

import SwiftUI

struct LabeledMailsView:View{
    @State private var selectedTab = "Queue"
    @State private var beforeLongPress = true
    @State private var isMultiSelectionSheetVisible: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isMenuVisible = false
    let items = [
            ("person", "Karthyl Murphy", "In the eighteenth century the German philosop....","Label Name","3:00 PM"),
            ("person", "Louis Murphy", "In the eighteenth century the German philosop....","Label Name","3:46 PM"),
            ("person", "Bench Murphy", "In the eighteenth century the German philosop....","Label Name","3:06 PM"),
            ("person", "Kahyl Murphy", "In the eighteenth century the German philosop....","Label Name","3:46 PM")
        ]
    @ObservedObject var labelledMailsViewModel = LabelledMailsViewModel()
    var body: some View {
        VStack{
            HStack{
                Button {
                    withAnimation {
                        isMenuVisible.toggle()
                    }
                } label: {
                    Image(systemName: "arrow.backward")
                }
                .foregroundColor(Color.black)
                Spacer()
                Text("Labelled Mails")
                    .font(.custom(.poppinsSemiBold, size: 16))
                Spacer()
            }
            .padding(.leading,20)
            .padding(.top,12)
            
            
            HStack {
                Button(action: {
                    selectedTab = "Queue"
                }) {
                    Text("Queue")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "Queue" ? Color.themeColor : Color.white)
                        .foregroundColor(selectedTab == "Queue" ? .white : .black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Button(action: {
                    selectedTab = "Postbox"
                }) {
                    Text("Postbox")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "Postbox" ? Color.themeColor : Color.white)
                        .foregroundColor(selectedTab == "Postbox" ? .white : .black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Button(action: {
                    selectedTab = "Conveyed"
                }) {
                    Text("Conveyed")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedTab == "Conveyed" ? Color.themeColor : Color.white)
                        .foregroundColor(selectedTab == "Conveyed" ? .white : .black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.2), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            if selectedTab == "Queue" {
                QueueSnoozedMailsView
            }
            
            Spacer()
            
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
        VStack{
        if beforeLongPress{
            List(0..<items.count, id: \.self) { index in
                HStack{
                    Image(items[index].0)
                    VStack(alignment: .leading){
                        Text(items[index].1)
                            .font(.custom(.poppinsRegular, size: 16))
                        Text(items[index].2)
                            .font(.custom(.poppinsLight, size: 14))
                            .lineLimit(1)
                        Text(items[index].3)
                            .font(.custom(.poppinsMedium, size: 14))
                            .background((Color(red: 69/255, green: 86/255, blue: 225/255)))
                            .opacity(0.36)
                            .lineLimit(1)
                    }
                    Text(items[index].4)
                        .padding(.top,-30)
                    Spacer()
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
                List(0..<items.count, id: \.self) { index in
                    HStack{
                        Image(items[index].0)
                        VStack(alignment: .leading){
                            Text(items[index].1)
                                .font(.custom(.poppinsRegular, size: 16))
                            Text(items[index].2)
                                .font(.custom(.poppinsLight, size: 14))
                                .lineLimit(1)
                            Text(items[index].3)
                                .font(.custom(.poppinsMedium, size: 14))
                                .background((Color(red: 69/255, green: 86/255, blue: 225/255)))
                                .opacity(0.36)
                                .lineLimit(1)
                        }
                        Text(items[index].4)
                            .padding(.top,-30)
                        Spacer()
                    }
                    
                    
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
                
                HStack(spacing:50) {
                    Button(action: {
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
    LabeledMailsView()
}
