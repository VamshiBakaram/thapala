//
//  BlueprintView.swift
//  Thapala
//
//  Created by Ahex-Guest on 25/06/24.
//

import SwiftUI

struct BlueprintView: View {
    @State private var isMenuVisible = false
    @StateObject private var blueprintViewModel = BlueprintViewModel()
    @StateObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @ObservedObject private var themesviewModel = themesViewModel()
    @State private var isQuickAccessVisible = false
//    @State private var isMailViewActive = false
    @State var isInsertTcode: Bool = false
    @State private var toText: String = ""
    let imageUrl: String
    @State private var iNotificationAppBarView = false
    var body: some View {
            GeometryReader{ reader in
                ZStack{
                    VStack{
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
                                
                                Text("Blueprint")
                                    .padding(.leading,20)
                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                    .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                    .padding(.leading,10)
                                Spacer()
                                Button(action: {
                                    print("search button pressed")
                                    print("Before appBarElementsViewModel.isSearch \(appBarElementsViewModel.isSearch)")
                                    appBarElementsViewModel.isSearch = true
                                    
                                    print("After appBarElementsViewModel.isSearch \(appBarElementsViewModel.isSearch)")
                                }) {
                                    Image("magnifyingglass")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .font(Font.title.weight(.medium))
                                }
                                
                                Button(action: {
                                    print("bell button pressed")
                                    iNotificationAppBarView = true
                                }) {
                                    Image("bell")
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
                            .padding(.top , -reader.size.height * 0.01)
                            HStack {
                                ScrollView(.horizontal,showsIndicators: false){
                                    HStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.blueprintViewModel.isComposeSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                            .frame(width: reader.size.width/3 - 10, height: 50)
                                            .onTapGesture {
                                                self.blueprintViewModel.selectedOption = .compose
                                                self.blueprintViewModel.isComposeSelected = true
                                                self.blueprintViewModel.isLettersSelected = false
                                                self.blueprintViewModel.isCardsSelected = false
                                            }
                                            .overlay(
                                                Group{
                                                    HStack{
                                                        Image("compose")
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            .background(themesviewModel.currentTheme.tabBackground)
                                                        VStack{
                                                            Text("Compose")
                                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                    }
                                                }
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.blueprintViewModel.isLettersSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                            .frame(width: reader.size.width/3 - 10, height: 50)
                                            .onTapGesture {
                                                self.blueprintViewModel.selectedOption = .letters
                                                self.blueprintViewModel.isComposeSelected = false
                                                self.blueprintViewModel.isLettersSelected = true
                                                self.blueprintViewModel.isCardsSelected = false
                                            }
                                            .overlay(
                                                Group{
                                                    HStack{
                                                        Image("printIcon")
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            .background(themesviewModel.currentTheme.tabBackground)
                                                        
                                                        VStack{
                                                            Text("Letters")
                                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                    }
                                                }
                                                
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.blueprintViewModel.isCardsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                            .frame(width: reader.size.width/3 - 10, height: 50)
                                            .onTapGesture {
                                                self.blueprintViewModel.selectedOption = .cards
                                                self.blueprintViewModel.isComposeSelected = false
                                                self.blueprintViewModel.isLettersSelected = false
                                                self.blueprintViewModel.isCardsSelected = true
                                            }
                                            .overlay(
                                                Group{
                                                    HStack{
                                                        Image("chatBox")
                                                            .frame(width: 20, height: 20)
                                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                            .background(themesviewModel.currentTheme.tabBackground)
                                                        
                                                        VStack{
                                                            Text("Cards")
                                                                .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                    }
                                                }
                                            )
                                    }
                                    .padding([.leading,.trailing])
                                }
                            }
                            
                            
                            //                        .padding(.top , -20)
                        }
                        .frame(height: reader.size.height * 0.16)
                        .background(themesviewModel.currentTheme.tabBackground)
                        
                        
                        
                        if let selectedOption = blueprintViewModel.selectedOption {
                            switch selectedOption {
                            case .compose:
                                composeView
                            case .letters:
                                lettersView
                            case .cards:
                                cardsView
                            }
                        }
                        Spacer()
                        
                        //                    Spacer().frame(height: 20)
                        
                        TabViewNavigator()
                            .frame(height: 40)
                            .padding(.bottom , 10)
                        
                    }
                    .navigationBarBackButtonHidden(true)
                    .background(themesviewModel.currentTheme.windowBackground)
                    
                    
                    
                    
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
                    
                    //                if isMailViewActive { // change on 24 march
                    //                        Color.white.opacity(0.8) // Optional: semi-transparent background
                    //                            .ignoresSafeArea()
                    //                            .blur(radius: 10) // Blur effect for the background
                    //                    TabViewNavigator(isMailViewActive: $isMailViewActive)
                    //                            .background(Color.white) // Background color for the Quick Access View
                    //                            .cornerRadius(10)
                    //                            .shadow(radius: 10)
                    //                            .padding()
                    //                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Align at the bottom right
                    //                            .padding([.bottom, .trailing], 20)
                    //                    }
                    
                    
                    
                    
                    if isMenuVisible{
                        HomeMenuView(isSidebarVisible: $isMenuVisible)
                    }
                    
                    if iNotificationAppBarView {
                        ZStack {
                            Rectangle()
                                .fill(Color.black.opacity(0.3))
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation {
                                        iNotificationAppBarView = false
                                    }
                                }
                            NotificationAppBarView()
                                .frame(height: .infinity)
                                .background(themesviewModel.currentTheme.windowBackground)
                                .cornerRadius(20)
                                .padding(.horizontal,20)
                                .padding(.bottom,50)
                                .padding(.top,80)
                                .transition(.scale)
                                .animation(.easeInOut, value: iNotificationAppBarView)
                        }
                    }
                    
                }
            }
            .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
                SearchView(appBarElementsViewModel: appBarElementsViewModel)
                    .toolbar(.hidden)
            }
            .navigationDestination(isPresented: $blueprintViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
    }
    var composeView:some View{
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                //
                let bccList = blueprintViewModel.bcc.isEmpty ? [] : [blueprintViewModel.bcc]
                let ccList = blueprintViewModel.cc.isEmpty ? [] : [blueprintViewModel.cc]
                Button(action: {
                    print("to text \(toText) ")
                    print("to cc \(ccList) ")
                    print("to bcc \(bccList) ")
                    print("to subject \(blueprintViewModel.subject) ")
                    print("to composeEmail \(blueprintViewModel.composeEmail) ")
                    blueprintViewModel.saveToTdraft(To: [toText], CC: ccList, BCC: bccList, Subject: blueprintViewModel.subject, Body: blueprintViewModel.composeEmail)
                    toText = ""
                    blueprintViewModel.cc = ""
                    blueprintViewModel.bcc = ""
                    blueprintViewModel.subject = ""
                    blueprintViewModel.composeEmail = ""
                }) {
                    Image("TickMark")
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.colorPrimary)
                        .background(themesviewModel.currentTheme.iconColor)
                    
                        .padding(.all,8)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    toText = ""
                    blueprintViewModel.cc = ""
                    blueprintViewModel.bcc = ""
                    blueprintViewModel.subject = ""
                    blueprintViewModel.composeEmail = ""
                    print("click on delete button")
                }) {
                    Image("del")
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .padding(.all,8)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            
            ZStack(alignment: .bottomTrailing) {
                ZStack(alignment: .topLeading) {
//                    TextEditor(text: $blueprintViewModel.emailEditor)
//                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
//                        .padding(.trailing, 10)
//                        .frame(minHeight: 60)
//                        .background(Color.clear)
// 
//                        .padding()
                    
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(spacing: 5) {
                                HStack {
                                    Text("From:")
                                        .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    TextField("", text: $sessionManager.userTcode)
                                        .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .disabled(true)
                                }
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.AllGray)
                                    .padding(.trailing, 20)
                            }
                            
                            VStack(spacing: 5) {
                                HStack {
                                    Text("To:")
                                        .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                    /*
                                     TextField("", text: $mailComposeViewModel.to)
                                     .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                     .keyboardType(.numberPad)
                                     */
                                    
                                    ZStack(alignment: .topLeading) {
                                        VStack {
                                            TextField(
                                                "Enter tcode",
                                                text: $toText
                                            )
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.leading, 20)
                                            .onChange(of: toText) { newValue in
                                                if let intValue = Int(newValue) {
                                                    if !$blueprintViewModel.tcodeinfo.isEmpty {
                                                        blueprintViewModel.tcodeinfo[0].tCode = String(intValue)
                                                    }
                                                } else {
                                                    if !blueprintViewModel.tcodeinfo.isEmpty {
                                                        blueprintViewModel.tcodeinfo[0].tCode = nil
                                                    }
                                                }
                                                
                                                // Update `suggest` and call API when the value has 3 or more characters
                                                if isThreeNumbers(newValue) {
                                                    blueprintViewModel.suggest = true
                                                    print("Calling getSearchTcode")
                                                    //                                                blueprintViewModel.getSerachTcode(searchKey: newValue)
                                                    print("API call completed")
                                                } else {
                                                    blueprintViewModel.suggest = false
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            Image("contacts")
                                                .renderingMode(.template)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .onTapGesture {
                                                    isInsertTcode = true
                                                }
                                            Button(action: {
                                                blueprintViewModel.isArrow.toggle()
                                                print("arrow clicked")
                                            }, label: {
                                                Image(blueprintViewModel.isArrow ? "dropup" : "dropdown")
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .frame(width: 35, height: 35)
                                            })
                                            .padding(.trailing, 20)
                                        }
                                    )
                                }
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.AllGray)
                                    .padding(.trailing, 20)
                                
                                
                                if blueprintViewModel.isArrow {
                                    VStack(spacing: 5) {
                                        HStack {
                                            Text("Cc:")
                                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            /*
                                             TextField("", text: $mailComposeViewModel.cc)
                                             .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                             */
                                            HStack {
                                                ForEach(blueprintViewModel.ccTCodes) { tCode in
                                                    HStack {
                                                        Text(tCode.code)
                                                            .padding(.leading, 5)
                                                            .padding(.vertical, 4)
                                                            .cornerRadius(8)
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        Button(action: {
                                                            blueprintViewModel.removeCcTCode(tCode)
                                                        }) {
                                                            Image(systemName: "xmark.circle.fill")
                                                                .foregroundColor(.gray)
                                                        }
                                                        .padding(.trailing,5)
                                                    }
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                    )
                                                }
                                                
                                                TextField("", text: $blueprintViewModel.cc)
                                                    .textFieldStyle(PlainTextFieldStyle())
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
//                                                    .onSubmit {
//                                                        blueprintViewModel.addCcTCode()
//                                                    }
                                            }
                                        }
                                        .overlay(
                                            HStack {
                                                Spacer()
                                                Image("contacts")
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .padding(.trailing, 60)
                                                    .onTapGesture {
                                                        isInsertTcode = true
                                                    }
                                            }
                                        )
                                        Rectangle()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 1)
                                            .foregroundColor(themesviewModel.currentTheme.AllGray)
                                            .padding(.trailing, 20)
                                    }
                                    
                                    VStack(spacing: 5) {
                                        HStack {
                                            Text("Bcc:")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                            /*
                                             TextField("", text: $mailComposeViewModel.bcc)
                                             .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                             */
                                            HStack {
                                                ForEach(blueprintViewModel.bccTCodes) { tCode in
                                                    HStack {
                                                        Text(tCode.code)
                                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                                            .padding(.leading, 5)
                                                            .padding(.vertical, 4)
                                                            .cornerRadius(8)
                                                        Button(action: {
                                                            blueprintViewModel.removeBccTCode(tCode)
                                                        }) {
                                                            Image(systemName: "xmark.circle.fill")
                                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                        }
                                                        .padding(.trailing,5)
                                                    }
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                                                    )
                                                }
                                                
                                                TextField("", text: $blueprintViewModel.bcc)
                                                    .textFieldStyle(PlainTextFieldStyle())
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                    .onSubmit {
                                                        blueprintViewModel.addBccTCode()
                                                    }
                                            }
                                        }
                                        .overlay(
                                            HStack {
                                                Spacer()
                                                Image("contacts")
                                                    .renderingMode(.template)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .padding(.trailing, 60)
                                                    .onTapGesture {
                                                        isInsertTcode = true
                                                    }
                                            }
                                        )
                                        Rectangle()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 1)
                                            .foregroundColor(themesviewModel.currentTheme.AllGray)
                                            .padding(.trailing, 20)
                                    }
                                }
                                
                                VStack(spacing: 5) {
                                    HStack {
                                        Text("Subject")
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                        TextField("", text: $blueprintViewModel.subject)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                    }
                                    Rectangle()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 1)
                                        .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                        .padding(.trailing, 20)
                                }
                                
                                ZStack(alignment: .leading) {
                                    TextEditor(text: $blueprintViewModel.composeEmail)
                                        .scrollContentBackground(.hidden)
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(4)
                                        .font(.custom(.poppinsLight, size: 14))
                                    if blueprintViewModel.composeEmail.isEmpty {
                                        Text("Compose email")
                                            .font(.custom(.poppinsLight, size: 14))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 8)
                                    }
                                }
                                
//                                ZStack(alignment: .leading) {
//                                        Text("Compose email")
//                                            .font(.custom(.poppinsLight, size: 14))
//                                            .foregroundColor(themesviewModel.currentTheme.textColor)
//                                            .padding(.leading, 5)
//                                            .padding(.vertical, 8)
//                                    
//                                }
//                                .frame(maxWidth: .infinity, alignment: .leading)
                                //                            Spacer()
                            }
                        }
                        .padding([.top, .bottom ,.trailing], 20 )
                        .padding(.leading , 30)
                    }
                    
                }
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
                                             blueprintViewModel.isComposeEmail = true
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
            }
            .background(themesviewModel.currentTheme.windowBackground)
            .padding()
            
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
            )
            .padding([.leading,.trailing], 10)
            
        


        }
    }
            var lettersView:some View{
                HStack{
                    Image("Letter1")
                    Image("Letter1")
                    Image("Letter1")
                }
            }
            
            var cardsView:some View{
                VStack{
                    Spacer()
                }
            }
    private func isThreeNumbers(_ input: String) -> Bool {
            let numbers = input.filter { $0.isNumber }
            return numbers.count == 3
        }
        
    
}
struct tCode: Identifiable {
    let id = UUID()
    let code: String
}
//
//
#Preview {
    BlueprintView(imageUrl: "")
        .environmentObject(SessionManager())
}
