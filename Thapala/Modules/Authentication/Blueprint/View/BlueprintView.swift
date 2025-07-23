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
    @StateObject var mailComposeViewModel = MailComposeViewModel()
    @StateObject private var appBarElementsViewModel = AppBarElementsViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @ObservedObject private var themesviewModel = themesViewModel()
    @State private var isQuickAccessVisible = false
//    @State private var isMailViewActive = false
    @State var isInsertTcode: Bool = false
    @State private var selectedTcode: String = ""
    @State private var selectedCCcode: String = ""
    @State private var selectedBCCcode: String = ""
    let imageUrl: String
    @State private var iNotificationAppBarView = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
            GeometryReader{ reader in
                ZStack{
                    VStack{
                        VStack {
                            HStack(spacing:20){
                                Image("contactW")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                    .background(
                                        Circle()
                                            .fill(themesviewModel.currentTheme.colorPrimary) // Inner background
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2) // Border
                                    )
                                    .clipShape(Circle())
                                    .padding(.leading, 16)
                                
                                Text("Blueprint")
                                    .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                    .font(.custom(.poppinsSemiBold, size: 16, relativeTo: .title))
                                
                                Spacer()
                                
                                Button(action: {
                                    appBarElementsViewModel.isSearch = true
                                    
                                    print("After appBarElementsViewModel.isSearch \(appBarElementsViewModel.isSearch)")
                                }) {
                                    Image("magnifyingglass")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .font(Font.title.weight(.medium))
                                }
                                .padding(.leading,15)
                                
                                
                                Button(action: {
                                    print("bell button pressed")
                                    iNotificationAppBarView = true
                                }) {
                                    Image("notification")
                                }
                                .padding(.leading,15)
                                
                                
                                Button(action: {
                                    print("line.3.horizontal button pressed")
                                    withAnimation {
                                        isMenuVisible.toggle()
                                    }
                                }) {
                                    Image("MenuIcon")
                                        .renderingMode(.template)
                                        .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                        .font(Font.title.weight(.medium))
                                }
                                .padding(.leading,15)
                                .padding(.trailing , 30)
                            }
                            .padding(.top , -reader.size.height * 0.01)

                                    HStack{
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.blueprintViewModel.isComposeSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                            .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
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
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .frame(width: 20, height: 20)
                                                            .padding(5)
                                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .fill(themesviewModel.currentTheme.tabBackground)
                                                            )
                                                        VStack{
                                                            Text("Compose")
                                                                .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                    }
                                                }
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.blueprintViewModel.isLettersSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                            .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
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
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .frame(width: 20, height: 20)
                                                            .padding(5)
                                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .fill(themesviewModel.currentTheme.tabBackground)
                                                            )
                                                        
                                                        VStack{
                                                            Text("Letters")
                                                                .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                    }
                                                }
                                                
                                            )
                                        
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(self.blueprintViewModel.isCardsSelected ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                            .frame(width: max(reader.size.width/3 - 10, 50), height: 50)
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
                                                            .resizable()
                                                            .renderingMode(.template)
                                                            .frame(width: 20, height: 20)
                                                            .padding(5)
                                                            .foregroundColor(themesviewModel.currentTheme.inverseIconColor)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 8)
                                                                    .fill(themesviewModel.currentTheme.tabBackground)
                                                            )
                                                        
                                                        VStack{
                                                            Text("Cards")
                                                                .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
                                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        }
                                                    }
                                                }
                                            )
                                    }
                                    .padding([.leading,.trailing,],5)
                                    .padding(.bottom , 10)
                            
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
                    .toast(message: $blueprintViewModel.error)
                    .navigationBarBackButtonHidden(true)
                    .background(themesviewModel.currentTheme.windowBackground)
                    
                    
                    

                    if isQuickAccessVisible {
                        ZStack {
                            Color.gray.opacity(0.3)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    isQuickAccessVisible = false
                                }
                            QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                                .background(Color.white) // Background color for the Quick Access View
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Align at the bottom right
                                .padding([.bottom, .trailing], 20)
                        }
                    }
                    
                    
                    
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
                .fullScreenCover(isPresented: $appBarElementsViewModel.isSearch) {
                    SearchView(appBarElementsViewModel: appBarElementsViewModel)
                        .toolbar(.hidden)
                }

                .fullScreenCover(isPresented: $blueprintViewModel.isComposeEmail) {
                    MailComposeView().toolbar(.hidden)
                        .onAppear {
                            print("MailFullView appeared")
                        }
                }

            }



    }
    var composeView:some View{
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    print("to text \(blueprintViewModel.to) ")
                    print("to cc \(blueprintViewModel.cc) ")
                    print("to bcc \(blueprintViewModel.bcc) ")
                    print("to subject \(blueprintViewModel.subject) ")
                    print("to composeEmail \(blueprintViewModel.composeEmail) ")
                    blueprintViewModel.saveToTdraft(To: [blueprintViewModel.to], CC: [blueprintViewModel.cc], BCC: [blueprintViewModel.bcc], Subject: blueprintViewModel.subject, Body: blueprintViewModel.composeEmail)
                    blueprintViewModel.to = ""
                    blueprintViewModel.cc = ""
                    blueprintViewModel.bcc = ""
                    blueprintViewModel.subject = ""
                    blueprintViewModel.composeEmail = ""
                    selectedTcode = ""
                    selectedCCcode = ""
                    selectedBCCcode = ""
                    blueprintViewModel.isArrow = false
                }) {
                    Image("addtoTDraft")
                        .renderingMode(.template)
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                    
                        .padding(.all,8)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    blueprintViewModel.to = ""
                    blueprintViewModel.cc = ""
                    blueprintViewModel.bcc = ""
                    blueprintViewModel.subject = ""
                    blueprintViewModel.composeEmail = ""
                    selectedTcode = ""
                    selectedCCcode = ""
                    selectedBCCcode = ""
                    blueprintViewModel.isArrow = false
                    blueprintViewModel.error = "delete successfully"
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
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(spacing: 10) {
                                HStack {
                                    Text("From:")
                                        .font(.custom(.poppinsRegular, size: 18, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    TextField("", text: $sessionManager.userTcode)
                                        .font(.custom(.poppinsSemiBold, size: 18, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .disabled(true)
                                }
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.AllGray)
                            }
                            
                            VStack(spacing: 2) {
                                HStack {
                                    Text("To:")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .font(.custom(.poppinsRegular, size: 18, relativeTo: .title))

                                    ZStack(alignment: .leading) {
                                        if blueprintViewModel.to.isEmpty {
                                            Text("Enter tcode")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.leading, 5)
                                        }

                                        TextField("", text: $blueprintViewModel.to)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.leading, 5)
                                            .keyboardType(.numbersAndPunctuation)
                                            .submitLabel(.done)
                                            .focused($isFocused)
                                            .onSubmit {
                                                isFocused = false
                                            }
                                            
                                            .onChange(of: blueprintViewModel.to) { newValue in
                                                if let intValue = Int(newValue) {
                                                    if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                        mailComposeViewModel.tcodeinfo[0].tCode = String(intValue)
                                                    }
                                                } else {
                                                    if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                        mailComposeViewModel.tcodeinfo[0].tCode = nil
                                                    }
                                                }
                                                if isThreeNumbers(newValue) {
                                                    mailComposeViewModel.suggest = true
                                                    mailComposeViewModel.getSerachTcode(searchKey: newValue)
                                                }
                                                else {
                                                    mailComposeViewModel.suggest = false
                                                }
                                            }
                                        
                                        if !selectedTcode.isEmpty {
                                            HStack {
                                                Text(blueprintViewModel.to)
                                                    .foregroundColor(Color.black)
                                                    .padding(.leading, 5)
                                                    .font(.custom(.poppinsSemiBold, size: 14))
                                                   
                                                Button(action: {
                                                    selectedTcode = ""
                                                    blueprintViewModel.to = ""
                                                }) {
                                                    Image(systemName: "xmark")
                                                        .renderingMode(.template)
                                                        .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                                }
                                                .padding([.leading , .trailing] , 5)

                                            }
                                            .padding(.all , 5)
                                            .background(selectedTcode.isEmpty ? Color.clear : themesviewModel.currentTheme.attachmentBGColor)
                                            .cornerRadius(5)
                                            
                                        }
                                    }
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

                                if mailComposeViewModel.suggest,
                                   let data = mailComposeViewModel.tcodesuggest?.data {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading, spacing: 0) {
                                            ForEach(data, id: \.self) { tCode in
                                                Button(action: {
                                                    if let selectedTCode = tCode.tCode {
                                                        selectedTcode = selectedTCode
                                                        blueprintViewModel.to = selectedTCode
                                                    }
                                                    mailComposeViewModel.suggest = false
                                                }) {
                                                    Text(tCode.tCode ?? "Unknown")
                                                        .foregroundColor(.black)
                                                        .font(.custom(.poppinsBold, size: 16))
                                                        .padding()
                                                        .frame(alignment: .leading)
                                                        .padding(.leading , 5)
                                                    
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                        .frame(width: 150)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 4)

                                        Spacer() // pushes box left within the parent if needed
                                    }
                                    .padding(.leading, 20)

                                }

                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.AllGray)
                            }
               
                                
                                
                                if blueprintViewModel.isArrow {
                                    VStack(spacing: 10) {
                                        HStack {
                                            Text("CC:")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 18, relativeTo: .title))

                                            ZStack(alignment: .leading) {
                                                TextField("", text: $blueprintViewModel.cc)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .padding(.leading, 5)
                                                    .keyboardType(.numbersAndPunctuation)
                                                    .submitLabel(.done)
                                                    .focused($isFocused)
                                                    .onSubmit {
                                                        isFocused = false
                                                    }
                                                    .onChange(of: blueprintViewModel.cc) { newValue in
                                                        if let intValue = Int(newValue) {
                                                            if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                                mailComposeViewModel.tcodeinfo[0].tCode = String(intValue)
                                                            }
                                                        } else {
                                                            if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                                mailComposeViewModel.tcodeinfo[0].tCode = nil
                                                            }
                                                        }
                                                        if isThreeNumbers(newValue) {
                                                            mailComposeViewModel.CCsuggest = true
                                                            mailComposeViewModel.getSerachTcode(searchKey: newValue)
                                                        }
                                                        else {
                                                            mailComposeViewModel.CCsuggest = false
                                                        }
                                                    }
                                                
                                                if !selectedCCcode.isEmpty {
                                                    HStack {
                                                        Text(blueprintViewModel.cc)
                                                            .foregroundColor(Color.black)
                                                            .padding(.leading, 5)
                                                            .font(.custom(.poppinsSemiBold, size: 14))
                                                           
                                                        Button(action: {
                                                            selectedCCcode = ""
                                                            blueprintViewModel.cc = ""
                                                        }) {
                                                            Image(systemName: "xmark")
                                                                .renderingMode(.template)
                                                                .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                                        }
                                                        .padding([.leading , .trailing] , 5)

                                                    }
                                                    .padding(.all , 5)
                                                    .background(selectedCCcode.isEmpty ? Color.clear : themesviewModel.currentTheme.attachmentBGColor)
                                                    .cornerRadius(5)
                                                    
                                                }
                                            }
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

                                        if mailComposeViewModel.CCsuggest,
                                           let data = mailComposeViewModel.tcodesuggest?.data {
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    ForEach(data, id: \.self) { tCode in
                                                        Button(action: {
                                                            if let selectedTCode = tCode.tCode {
                                                                selectedCCcode = selectedTCode
                                                                blueprintViewModel.cc = selectedTCode
                                                            }
                                                            mailComposeViewModel.CCsuggest = false
                                                        }) {
                                                            Text(tCode.tCode ?? "Unknown")
                                                                .foregroundColor(.black)
                                                                .font(.custom(.poppinsBold, size: 16))
                                                                .padding()
                                                                .frame(alignment: .leading)
                                                                .padding(.leading , 5)
                                                            
                                                        }
                                                        .buttonStyle(.plain)
                                                    }
                                                }
                                                .frame(width: 150)
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .shadow(radius: 4)

                                                Spacer() // pushes box left within the parent if needed
                                            }
                                            .padding(.leading, 20)

                                        }

                                        Rectangle()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 1)
                                            .foregroundColor(themesviewModel.currentTheme.AllGray)
                                    }
                                    
                                    VStack(spacing: 10) {
                                        HStack {
                                            Text("BCC:")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 18, relativeTo: .title))

                                            ZStack(alignment: .leading) {
                                                TextField("", text: $blueprintViewModel.bcc)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .padding(.leading, 5)
                                                    .keyboardType(.numbersAndPunctuation)
                                                    .submitLabel(.done)
                                                    .focused($isFocused)
                                                    .onSubmit {
                                                        isFocused = false
                                                    }
                                                    .onChange(of: blueprintViewModel.bcc) { newValue in
                                                        if let intValue = Int(newValue) {
                                                            if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                                mailComposeViewModel.tcodeinfo[0].tCode = String(intValue)
                                                            }
                                                        } else {
                                                            if !mailComposeViewModel.tcodeinfo.isEmpty {
                                                                mailComposeViewModel.tcodeinfo[0].tCode = nil
                                                            }
                                                        }
                                                        if isThreeNumbers(newValue) {
                                                            mailComposeViewModel.BCCsuggest = true
                                                            mailComposeViewModel.getSerachTcode(searchKey: newValue)
                                                        }
                                                        else {
                                                            mailComposeViewModel.BCCsuggest = false
                                                        }
                                                    }
                                                
                                                if !selectedBCCcode.isEmpty {
                                                    HStack {
                                                        Text(blueprintViewModel.bcc)
                                                            .foregroundColor(Color.black)
                                                            .padding(.leading, 5)
                                                            .font(.custom(.poppinsSemiBold, size: 14))
                                                           
                                                        Button(action: {
                                                            selectedBCCcode = ""
                                                            blueprintViewModel.bcc = ""
                                                        }) {
                                                            Image(systemName: "xmark")
                                                                .renderingMode(.template)
                                                                .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                                        }
                                                        .padding([.leading , .trailing] , 5)

                                                    }
                                                    .padding(.all , 5)
                                                    .background(selectedBCCcode.isEmpty ? Color.clear : themesviewModel.currentTheme.attachmentBGColor)
                                                    .cornerRadius(5)
                                                    
                                                }
                                            }
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

                                        if mailComposeViewModel.BCCsuggest,
                                           let data = mailComposeViewModel.tcodesuggest?.data {
                                            HStack(alignment: .top) {
                                                VStack(alignment: .leading, spacing: 0) {
                                                    ForEach(data, id: \.self) { tCode in
                                                        Button(action: {
                                                            if let selectedTCode = tCode.tCode {
                                                                selectedBCCcode = selectedTCode
                                                                blueprintViewModel.bcc = selectedTCode
                                                            }
                                                            mailComposeViewModel.BCCsuggest = false
                                                        }) {
                                                            Text(tCode.tCode ?? "Unknown")
                                                                .foregroundColor(.black)
                                                                .font(.custom(.poppinsBold, size: 16))
                                                                .padding()
                                                                .frame(alignment: .leading)
                                                                .padding(.leading , 5)
                                                            
                                                        }
                                                        .buttonStyle(.plain)
                                                    }
                                                }
                                                .frame(width: 150)
                                                .background(Color.white)
                                                .cornerRadius(8)
                                                .shadow(radius: 4)

                                                Spacer() // pushes box left within the parent if needed
                                            }
                                            .padding(.leading, 20)

                                        }

                                        Rectangle()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 1)
                                            .foregroundColor(themesviewModel.currentTheme.AllGray)
                                    }
                                }
                                
                            VStack(spacing: 5) {
                                ZStack(alignment: .leading) {
                                    TextEditor(text:$blueprintViewModel.subject)
                                        .scrollContentBackground(.hidden)
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .padding(4)
                                        .font(.custom(.poppinsLight, size: 14))
                                    
                                    if blueprintViewModel.subject.isEmpty {
                                        Text("Title")
                                            .font(.custom(.poppinsRegular, size: 20))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 8)
                                            .allowsHitTesting(false)
                                    }
                                }
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(themesviewModel.currentTheme.AllGray)
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
                                            .font(.custom(.poppinsRegular, size: 20))
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 8)
                                            .allowsHitTesting(false)
                                    }
                                }
                            
                        }
                        .padding([.top, .bottom], 20 )
                        .padding([.leading , .trailing] , 10)
                    }
                }
                
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
                                         .frame(width: 1, height: 35)
                                         .background(themesviewModel.currentTheme.inverseIconColor)
                                     Image("dropdown 1")
                                         .foregroundColor(themesviewModel.currentTheme.iconColor)
                                         .onTapGesture {
                                             isQuickAccessVisible = true
                                         }
                                 }
                             )
                             .padding([.bottom , .trailing] , 5)
                     }
                 
                
            }
            .background(themesviewModel.currentTheme.windowBackground)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
            )
            .padding([.leading,.trailing], 15)
            .padding(.bottom , 50)
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
