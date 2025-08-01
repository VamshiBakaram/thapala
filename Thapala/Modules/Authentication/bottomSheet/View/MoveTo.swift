//
//  MoveTo.swift
//  Thapala
//
//  Created by Ahex-Guest on 13/05/25.
//

import SwiftUI

struct MoveTo: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject var moveToFolderViewModel = MoveToFolderViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @StateObject var themesviewModel = ThemesViewModel()
    @StateObject var homeRecordsViewModel = HomeRecordsViewModel()
    @StateObject var consoleViewModel = ConsoleNavigatiorViewModel()
    @StateObject var bottomSheetViewModel = BottomSheetViewModel()
    @Binding var isMoveToSheetVisible: Bool
    @Binding var selectedThreadID: [Int]
    @State private var isMoveVisible: Bool = true
    @State private var isMoveAlertvisible: Bool = false
    @State private var selectedMoveType: String = ""
    @State private var MainselectedTabID : [Int] = []
    @State private var lockerView: Bool = false
    @State private var newPinView: Bool = false
    @State private var newPin: String = ""
    @State private var confirmPin: String = ""
    @State private var LockerPin: String = ""
    @State private var Lockerpassword: String = ""
    @Binding var selectedIndices: Set<Int>
    var body: some View {
        ZStack {
            // Main BottomTagSheetView content
                VStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        if isMoveVisible {
                            HStack {
                                Image("back")
                                    .renderingMode(.template)
                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                    .padding(.leading, 10)
                                Text("Move to")
                                    .font(.headline)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 16)
                            }
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                .padding(.horizontal, 16)
                            
                            HStack {
                                Image("Moveto")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)
                                    .padding(.leading, 10)
                                Text("Work")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 5)
                                Spacer()
                                Button(action: {
                                    isMoveAlertvisible = true
                                    selectedMoveType = "work"
                                }) {
                                    Text("Move")
                                        .padding(.all ,5)
                                        .fontWeight(.bold)
                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                
                                .padding(.trailing , 16)
                            }
                            HStack {
                                Image("Moveto")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)
                                    .padding(.leading, 10)
                                Text("archive")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 5)
                                Spacer()
                                Button(action: {
                                    isMoveAlertvisible = true
                                    selectedMoveType = "archive"
                                }) {
                                    Text("Move")
                                        .padding(.all ,5)
                                        .fontWeight(.bold)
                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing , 16)
                            }
                            HStack {
                                Image("Moveto")
                                    .renderingMode(.template)
                                    .foregroundColor(Color.blue)
                                    .padding(.leading, 10)
                                Text("locker")
                                    .fontWeight(.bold)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.leading, 5)
                                Spacer()
                                Button(action: {
                                    isMoveVisible = false
                                    lockerView = true
                                    selectedMoveType = "locker"
                                }) {
                                    Text("Move")
                                        .padding(.all ,5)
                                        .fontWeight(.bold)
                                        .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                        .background(themesviewModel.currentTheme.colorPrimary)
                                        .cornerRadius(10)
                                }
                                .padding(.trailing , 16)
                            }
                        }
                        if lockerView {
                            if sessionManager.pin.isEmpty {
                                    VStack {
                                        HStack {
                                            Text("set Pin")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 16))
                                                .fontWeight(.bold)
                                                .padding(.leading , 16)
                                            
                                            Spacer()
                                            Button{
                                                newPinView = true
                                                newPin = ""
                                                confirmPin = ""
                                            }label: {
                                                Text("Add")
                                                    .padding()
                                                    .background(themesviewModel.currentTheme.colorPrimary)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14))
                                                    .cornerRadius(15)
                                                    .padding(.trailing,16)
                                                    .fontWeight(.bold)
                                                    .padding(.bottom,5)
                                            }
                                            
                                        }
                                        Spacer()
                                    }
                                    .padding(.top , 200)
                            }
                            else {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.black.opacity(0.3))
                                        .ignoresSafeArea(edges: .bottom)
                                    VStack {
                                        Spacer()
                                        VStack (alignment: .leading, spacing: 20){
                                            HStack {
                                                Text("Locker")
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 16))
                                                    .fontWeight(.bold)
                                                    .padding(.leading , 16)
                                                    
                                                
                                                Spacer()
                                                Image("wrongmark")
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .frame(width: 25,  height: 25)
                                                    .padding(.trailing , 16)
                                                    .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    .onTapGesture {
                                                        withAnimation {
                                                            lockerView = false
                                                            isMoveVisible = true
                                                        }
                                                    }
                                            }
                                            .padding(.top , 5)
                                            Floatingtextfield(text: $LockerPin, placeHolder: "Pin*", allowedCharacter: .defaultType)
                                                .padding(.horizontal)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            
                                            floatingtextfield(text: $Lockerpassword, placeHolder: "Password", allowedCharacter: .defaultType)
                                                .padding(.horizontal)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                            HStack {
                                                Spacer()
                                                Button{
                                                    bottomSheetViewModel.setPin = LockerPin
                                                    bottomSheetViewModel.password = Lockerpassword
                                                    homeRecordsViewModel.setPin = LockerPin
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        bottomSheetViewModel.getLockerVerify(){ success in
                                                            if success {
                                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                                    isMoveAlertvisible = true
                                                                }
                                                            }
                                                            else if bottomSheetViewModel.lockerVerifyResponse?.status == 401 {
                                                                isMoveAlertvisible = false
                                                                lockerView = true
                                                                LockerPin = ""
                                                                Lockerpassword = ""
                                                            }
                                                        }
                                                    }
                                                }label: {
                                                    Text("Submit")
                                                        .padding()
                                                        .background(themesviewModel.currentTheme.colorPrimary)
                                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                                        .font(.custom(.poppinsRegular, size: 14))
                                                        .cornerRadius(10)
                                                        .padding(.trailing,16)
                                                        .fontWeight(.bold)
                                                        .padding(.bottom,5)
                                                }
                                            }
                                            .padding(.bottom , 5)
                                            .transition(.move(edge: .bottom))
                                            .animation(.easeInOut, value: lockerView)
                                        }
                                        .frame(height: 300)
                                        .background(themesviewModel.currentTheme.windowBackground)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        
                        if newPinView {
                            ZStack {
                                Rectangle()
                                    .fill(Color.black.opacity(0.3))
                                    .ignoresSafeArea(edges: .bottom)
                                VStack {
                                    Spacer()
                                    VStack (alignment: .leading, spacing: 20){
                                        HStack {
                                            Text("set pin")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.custom(.poppinsRegular, size: 16))
                                                .fontWeight(.bold)
                                                .padding(.leading , 16)
                                            
                                            Spacer()
                                            Image("wrongmark")
                                                .resizable()
                                                .renderingMode(.template)
                                                .frame(width: 25,  height: 25)
                                                .padding(.trailing , 16)
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                .onTapGesture {
                                                    withAnimation {
                                                        newPinView = false
                                                    }
                                                }
                                        }
                                        Floatingtextfield(text: $newPin, placeHolder: "Enter New Pin*", allowedCharacter: .defaultType)
                                            .padding(.horizontal)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        
                                        Floatingtextfield(text: $confirmPin, placeHolder: "Enter New Confirm Pin", allowedCharacter: .defaultType)
                                            .padding(.horizontal)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        HStack{
                                            Text("Note:")
                                                .foregroundColor(Color.red)
                                                .padding(.leading , 16)
                                            
                                            Text("Pin must be exactly 4 digits")
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .padding(.leading , 10)
                                        }
                                        HStack {
                                            Spacer()
                                            Button{
                                                consoleViewModel.setPin(Newpin: newPin, confirmationPin: confirmPin)
                                                newPinView = false
                                                lockerView = true
                                                if newPin == confirmPin {
                                                    sessionManager.pin = newPin
                                                }
                                            }label: {
                                                Text("Submit")
                                                    .padding()
                                                    .background(themesviewModel.currentTheme.colorPrimary)
                                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                                    .font(.custom(.poppinsRegular, size: 14))
                                                    .cornerRadius(10)
                                                    .padding(.trailing,16)
                                                    .fontWeight(.bold)
                                                    .padding(.bottom,5)
                                            }
                                        }
                                    }

                                }
                                
                                .frame(height: 300)
                                .background(themesviewModel.currentTheme.windowBackground)
                                .cornerRadius(20)
                                .padding(.horizontal,10)
                                .transition(.scale)
                                .animation(.easeInOut, value: newPinView)
                            }
                        }
                            
                     }
                    .onAppear {
                        homeRecordsViewModel.getMainRecordsData()
                    }

                    .onChange(of: homeRecordsViewModel.mainRecords) { records in
                        if !records.isEmpty {
                            MainselectedTabID = records.map { $0.id }
                        }
                    }
                    



                }
                .toast(message: $bottomSheetViewModel.toastmessage)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: calculateTotalHeight())
                .background(themesviewModel.currentTheme.windowBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
             
            

            if isMoveAlertvisible {
                ZStack {
                    Color.gray.opacity(0.5) // Dimmed background
                        .ignoresSafeArea()
                        .transition(.opacity)
                    // Centered DeleteNoteAlert
                    moveAlert(isPresented: $isMoveAlertvisible) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
                            if selectedMoveType == "work" {
                                moveToFolderViewModel.moveToFolder(folderId: MainselectedTabID[0], recordName: "work", selectedThreadIDs: selectedThreadID)
                                selectedIndices = []
                            }
                            else if selectedMoveType == "archive" {
                                moveToFolderViewModel.moveToFolder(folderId: MainselectedTabID[1], recordName: "archive", selectedThreadIDs: selectedThreadID)
                                selectedIndices = []
                            }
                            else if selectedMoveType == "locker" {
                                moveToFolderViewModel.moveToLockerFolder(folderId: MainselectedTabID[2], recordName: "locker", selectedThreadIDs: selectedThreadID , password: Lockerpassword , pin: LockerPin )
                                lockerView = false
                                isMoveVisible = true
                                selectedIndices = []
                            }
                        }
                    }
                }
                .transition(.scale)
            }
       }
        .background(
            Color.black.opacity(isMoveVisible ? 0.4 : 0)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isMoveToSheetVisible = false 
                    }
                }
        )
                                         
    }
    func calculateTotalHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44   // Estimated height for each row in the list
        let maxHeight: CGFloat = 800  // Maximum height for the entire view

        var totalHeight = baseHeight

        if lockerView {
            totalHeight = 250
        } else if isMoveVisible {
            totalHeight = 200
        } else {

        }

        return min(totalHeight, maxHeight)
    }

}

//#Preview {
//    MoveTo(isMoveToSheetVisible: $isMoveToSheetVisible)
//}


struct moveAlert: View {
    @Binding var isPresented: Bool
    var onMove: () -> Void
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            // Alert card
            VStack(spacing: 24) {
                // Warning icon
                Circle()
                    .fill(Color(UIColor.systemPink).opacity(0.2))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "exclamationmark.triangle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                            .foregroundColor(.black)
                    )
                
                // Title
                Text("Confirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // Message
                Text("Do you want to save a copy of this email in your postbox as well?")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                // Buttons
                HStack(spacing: 20) {
                    // No button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("No")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color(UIColor.systemGray6))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                    
                    // Yes button
                    Button(action: {
                        onMove()
                        isPresented = false
                    }) {
                        Text("Yes")
                            .frame(width: 100)
                            .padding(.vertical, 12)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
         .background(Color.black.opacity(0.4))
         .edgesIgnoringSafeArea(.all)
    }
}


struct lockerView: View {
    
    var body: some View {
        ZStack {
            VStack {
            }
        }
    }
}
