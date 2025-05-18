//
//  HomeConveyedView.swift
//  Thapala
//
//  Created by Ahex-Guest on 20/06/24.
//

import SwiftUI

struct HomeConveyedView: View {
    @State private var isMenuVisible = false
    @ObservedObject var homeConveyedViewModel = HomeConveyedViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @State private var isSheetVisible = false
    @State private var isStarred: Bool = false // Track starred state
    @State private var isQuickAccessVisible = false
    @State private var conveyedView: Bool = false
    @State private var PostBoxView: Bool = false
    let imageUrl: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    if homeConveyedViewModel.beforeLongPress{
                        VStack {
                            HStack(spacing:20){
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
                                Text("Conveyed")
                                    .padding(.leading,20)
                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                    .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                Spacer()
                                Button(action: {
                                    print("search button pressed")
                                }) {
                                    Image("magnifyingglass")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .font(Font.title.weight(.medium))
                                }
                                
                                Button(action: {
                                    print("bell button pressed")
                                }) {
                                    Image("notification")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .font(Font.title.weight(.medium))
                                }
                                
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
                                .padding(.trailing,15)
                                
                            }
                            
                            
                           
                                HStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeConveyedViewModel.isEmailsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            homeConveyedViewModel.getConveyedEmailData()
                                            self.homeConveyedViewModel.selectedOption = .emails
                                            self.homeConveyedViewModel.isEmailsSelected = true
                                            self.homeConveyedViewModel.isPrintSelected = false
                                            self.homeConveyedViewModel.isShipmentsSelected = false
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("emailG")
                                                        .renderingMode(.template)
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack(alignment:.leading){
                                                        Text("Emails")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        //   Text("Obtained")
                                                        //  .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                                                    }
                                                }
                                            }
                                        )
                                    
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeConveyedViewModel.isPrintSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homeConveyedViewModel.selectedOption = .print
                                            self.homeConveyedViewModel.isEmailsSelected = false
                                            self.homeConveyedViewModel.isPrintSelected = true
                                            self.homeConveyedViewModel.isShipmentsSelected = false
                                            
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("printIcon")
                                                        .frame(width: 20, height: 20)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    VStack(alignment:.leading){
                                                        Text("Letters")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        //   Text("Letters")
                                                        //   .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                                                    }
                                                }
                                            }
                                            
                                        )
                                    
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.homeConveyedViewModel.isShipmentsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                        .frame(width: reader.size.width/3 - 10, height: 50)
                                        .onTapGesture {
                                            self.homeConveyedViewModel.selectedOption = .shipments
                                            self.homeConveyedViewModel.isEmailsSelected = false
                                            self.homeConveyedViewModel.isPrintSelected = false
                                            self.homeConveyedViewModel.isShipmentsSelected = true
                                            
                                        }
                                        .overlay(
                                            Group{
                                                HStack{
                                                    Image("chatBox")
                                                        .frame(width: 20, height: 20)
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        .background(themesviewModel.currentTheme.tabBackground)
                                                    VStack(alignment:.leading){
                                                        Text("Shipments")
                                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        // Text("Letters")
                                                        // .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
                                                    }
                                                }
                                            }
                                            
                                        )
                                }
                                .padding([.leading,.trailing,],5)
                                .padding(.bottom , 10)
                            
                        }
                        .frame(height: 120)
                        .background(themesviewModel.currentTheme.tabBackground)
                        
                        if let selectedOption = homeConveyedViewModel.selectedOption {
                            switch selectedOption {
                            case .emails:
                                emailsView
                            case .print:
                                printView
                            case .shipments:
                                shipmentsView
                            }
                        }
                        
                    }else{
                        VStack{
                            HStack{
                                Button {
                                    homeConveyedViewModel.beforeLongPress.toggle()
                                } label: {
                                    Image(systemName: "arrow.backward")
                                        .foregroundColor(Color.black)
                                }
                                
                                Text("1 Selected")
                                    .font(.custom(.poppinsRegular, size: 16))
                                    .foregroundColor(Color(red: 51/255, green: 51/255, blue: 51/255))
                                Spacer()
                            }
                            .padding(.leading,15)
                            
                            HStack{
                                Image("Check")
                                Image("dropdown")
                                Text("Select All")
                                    .font(.custom(.poppinsRegular, size: 14))
                                    .foregroundColor(Color(red: 112/255, green: 112/255, blue: 112/255))
                                Spacer()
                            }
                            .padding(.leading,15)
                            HStack(spacing: 40) {
                                Image(systemName: "square.and.arrow.down")
                                    .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                Image(systemName: "trash")
                                    .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                Image(systemName: "envelope")
                                    .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                Image(systemName: "clock")
                                    .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                Image(systemName: "folder")
                                    .foregroundColor(Color(red: 39/255, green: 50/255, blue: 64/255))
                                Spacer()
                            }
                            .padding([.leading,.top],15)
                        }
                        .padding(.top,15)
                    }
                    

                    
                    Spacer()
//                    HStack{
//                        Spacer()
//                        Button(action: {
//                            homeConveyedViewModel.isPlusBtn = true
//                        }) {
//                            Image("plus")
//                                .font(Font.title.weight(.medium))
//                                .foregroundColor(Color.white)
//                        }
//                        .padding(.trailing,15)
//                    }
                    VStack {
        //                        Spacer().frame(height: 100)
                         HStack {
                             Spacer()
                             RoundedRectangle(cornerRadius: 30)
                                 .fill(themesviewModel.currentTheme.colorPrimary)
                                 .frame(width: 150, height: 48)
                                 .overlay(
                                     HStack {
                                         Text("New Email")
                                             .font(.custom(.poppinsBold, size: 14))
                                             .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                             .padding(.trailing, 8)
                                             .onTapGesture {
                                                 homeConveyedViewModel.isComposeEmail = true
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
                                 )
                                 .padding(.trailing, 20)
                                 .padding(.bottom, 20)
                         }
                     }
                    
                    TabViewNavigator()
                        .frame(height: 40)
                    
                }
                .background(themesviewModel.currentTheme.windowBackground)
                .onAppear{
                    homeConveyedViewModel.getConveyedEmailData()
                }
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                ZStack {
                    if isQuickAccessVisible {
                        Color.white.opacity(0.8)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    print("Tapped isQuickAccessVisible")
                                    isQuickAccessVisible = false
                                }
                            }

                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .padding()
                            }
                        }
                        .padding([.bottom, .trailing], 20)
                    }
                }




                
            }
            .navigationDestination(isPresented: $homeConveyedViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
//            .navigationDestination(isPresented: $homeResidenceViewModel.isDetailedData) {
//                ResidenceUserProfileView().toolbar(.hidden)
//            }
            .navigationDestination(isPresented: $homeConveyedViewModel.isEmailScreen) {
                MailFullView(conveyedView: $conveyedView, PostBoxView: $PostBoxView, emailId: homeConveyedViewModel.selectedID ?? 0, passwordHash: "").toolbar(.hidden)
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
                 //   homeAwaitingViewModel.getStarredEmail(selectedEmail: homeAwaitingViewModel.selectedID ?? 0)
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

            .toast(message: $homeConveyedViewModel.error)
        }
    }
    
    var emailsView:some View{
        List(homeConveyedViewModel.conveyedEmailData) { data in
                  HStack {
                      let image = data.senderProfile ?? "person"
                      AsyncImage(url: URL(string: image)) { phase in
                          switch phase {
                          case .empty:
                              ProgressView()
                                  .foregroundColor(Color.white)
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
                      
                      VStack(alignment: .leading) {
                          Text("\(data.firstname ?? "") \(data.lastname ?? "")")
                              .foregroundColor(themesviewModel.currentTheme.textColor)
                              .font(.custom("Poppins-Medium", size: 16))
                          Text(data.subject ?? "No Subject")
                              .foregroundColor(themesviewModel.currentTheme.textColor)
                              .font(.custom("Poppins-Regular", size: 14))
                              .lineLimit(1)
                      }
                      Spacer()
                      VStack(alignment: .trailing) {
                          if let unixTimestamp = data.sentAt, let istDateStringFromTimestamp = convertToIST(dateInput: unixTimestamp) {
                              Text(istDateStringFromTimestamp)
                                  .foregroundColor(themesviewModel.currentTheme.textColor)
                                  .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                                  .alignmentGuide(.top) { $0[.top] }
                          }
                          
                          Image(data.starred == 1 ? "star" : "emptystar")
                              .resizable()
                              .renderingMode(.template)
                              .frame(width: 14, height: 14)
                              .foregroundColor(themesviewModel.currentTheme.iconColor)
                              .onTapGesture {
                                  // Safely unwrap data.threadID
                                  if let threadID = data.threadID,
                                     let index = homeConveyedViewModel.conveyedEmailData.firstIndex(where: { $0.threadID == threadID }) {
                                      print("thread id:", threadID)
                                      // Toggle the 'starred' status between 1 and 0
                                      homeConveyedViewModel.conveyedEmailData[index].starred = (homeConveyedViewModel.conveyedEmailData[index].starred == 1) ? 0 : 1
                                      homeConveyedViewModel.getStarredEmail(selectedEmail: threadID)
                                  } else {
                                      print("threadID is nil")
                                  }
                              }
//                          Image(data.isStarred ? "star" : "emptystar")
//                              .resizable()
//                              .frame(width: 14, height: 14)
//                              .foregroundColor(.black)
//                              .onTapGesture {
//                                  // Safely unwrap data.threadID
//                                  if let threadID = data.threadID,
//                                     let index = homeConveyedViewModel.conveyedEmailData.firstIndex(where: { $0.threadID == threadID }) {
//                                      print("thread id:", threadID)
//                                      homeConveyedViewModel.conveyedEmailData[index].isStarred.toggle()
//                                      homeConveyedViewModel.getStarredEmail(selectedEmail: threadID)
//                                  } else {
//                                      print("threadID is nil")
//                                  }
//                              }

                      }
                  }
                  .listRowBackground(themesviewModel.currentTheme.windowBackground)
                  .gesture(
                      LongPressGesture(minimumDuration: 1.0)
                          .onEnded { _ in
                              withAnimation {
                                  homeConveyedViewModel.beforeLongPress = false
                              }
                          }
                  )
                  .swipeActions(edge: .leading) {
                      Button {
                          print("Deleting row")
                          homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
                          homeConveyedViewModel.deleteEmailFromConvey()
                      } label: {
                          deleteIcon
                              .foregroundColor(themesviewModel.currentTheme.iconColor)
                      }
                      .tint(Color.themeColor)
                  }
                  .swipeActions(edge: .trailing) {
                      Button {
                          isSheetVisible = true
                      } label: {
                          moreIcon
                              .foregroundColor(themesviewModel.currentTheme.iconColor)
                      }
                      .tint(Color(red:255/255, green: 128/255, blue: 128/255))
                  }
                  .onTapGesture {
                      homeConveyedViewModel.selectedID = data.threadID
                      homeConveyedViewModel.passwordHint = data.passwordHint
                      homeConveyedViewModel.isEmailScreen = true
                      conveyedView = true
                  }
              }
              .listStyle(PlainListStyle())
              .scrollContentBackground(.hidden)
//              .background(themesviewModel.currentTheme.windowBackground)
    }
    
    var printView:some View{
//                List(homeConveyedViewModel.postBoxPrintRead){ data in
//                    HStack{
//                        Image(data.image)
//                            .padding([.trailing,.leading],5)
//                            .frame(width: 34,height: 34)
//                            .clipShape(Circle())
//                        VStack(alignment: .leading){
//                            Text(data.title)
//                                .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
//                            Text(data.subTitle)
//                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
//                        }
//                        Spacer()
//                        Text(data.time)
//                            .font(.custom(.poppinsLight, size: 10, relativeTo: .title))
//                    }
//                    .gesture(
//                        LongPressGesture(minimumDuration: 1.0)
//                            .onEnded { _ in
//                                withAnimation {
//                                    homeConveyedViewModel.beforeLongPress = false
//                                  //  selectEmail(data: data)
//                                }
//                            }
//                    )
//                    .swipeActions(edge: .leading) {
//                        Button {
//                            print("Deleting row")
//                         //   homeConveyedViewModel.selectedThreadIDs.append(data.threadID ?? 0)
//                            homeConveyedViewModel.deleteEmailFromConvey()
//                        } label: {
//                            deleteIcon
//                                .foregroundStyle(.white)
//                        }
//                        .tint(Color.themeColor)
//                    }
//                    .swipeActions(edge: .trailing) {
//                        Button {
//                            isSheetVisible = true
//                        } label: {
//                            moreIcon
//                                .foregroundStyle(.white)
//                        }
//                        .tint(Color(red:255/255, green: 128/255, blue: 128/255))
//                    }
//                    .onTapGesture {
//                        homeConveyedViewModel.selectedID = homeConveyedViewModel.conveyedEmailData.first?.threadID ?? 0
//                        homeConveyedViewModel.passwordHint = homeConveyedViewModel.conveyedEmailData.first?.passwordHint
//                        homeConveyedViewModel.isEmailScreen = true
//                    }
//
//                }
//                .listStyle(PlainListStyle())
//                .scrollContentBackground(.hidden)

        ZStack {
            Color.clear // Background to help center the image
            Image("coming soon") // Replace with the actual image name
                .renderingMode(.template)
                .foregroundColor(themesviewModel.currentTheme.iconColor)
                .padding(.bottom , 10)
                .scaledToFit()
                .frame(width: 160, height: 111.02)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        
    }
    
    var shipmentsView:some View{
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
        .background(Color.clear)
    }
    private func dismissSheet() {
        presentationMode.wrappedValue.dismiss()
    }
}

//#Preview {
//    HomeConveyedView(imageUrl: "", conveyedView: <#Binding<Bool>#>)
//}

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
