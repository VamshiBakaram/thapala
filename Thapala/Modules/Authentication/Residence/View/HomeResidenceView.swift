//
//  HomeResidenceView.swift
//  Thapala
//
//  Created by Ahex-Guest on 18/06/24.
//

import SwiftUI

struct HomeResidenceView: View {
    @State private var isMenuVisible = false
    @ObservedObject var homeResidenceViewModel = HomeResidenceViewModel()
    @State private var selectedItem: UUID? = nil
    
    var body: some View {
        GeometryReader{ reader in
            ZStack{
                VStack{
                    HStack(spacing:20){
                        Text("Residence")
                            .padding(.leading,20)
                            .foregroundColor(Color.white)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Spacer()
                        Button(action: {
                            print("Pencil button pressed")
                            homeResidenceViewModel.isComposeEmail = true
                        }) {
                            Image("pencil")
                                .font(Font.title.weight(.medium))
                                .foregroundColor(Color.white)
                        }
                        
                        Button(action: {
                            print("bell button pressed")
                        }) {
                            Image("bell")
                                .font(Font.title.weight(.medium))
                                .foregroundColor(Color.white)
                        }
                        
                        Button(action: {
                            print("line.3.horizontal button pressed")
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal")
                                .font(Font.title.weight(.medium))
                                .foregroundColor(Color.white)
                        }
                        .padding(.trailing,15)
                        
                    }
                    .frame(height: 60)
                    .background(Color(red: 69/255, green: 86/255, blue: 225/255))
                    
                    ScrollView(.horizontal,showsIndicators: false){
                        HStack{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeResidenceViewModel.isDirectorySelected ? Color(red: 212/255, green: 205/255, blue: 255/255):Color(red:246/255, green: 246/255, blue: 251/255))
                                .frame(width: reader.size.width/3 - 10, height: 60)
                                .onTapGesture {
                                    self.homeResidenceViewModel.selectedOption = .directory
                                    print(reader.size.width/3 - 10)
                                    self.homeResidenceViewModel.isDirectorySelected = true
                                    self.homeResidenceViewModel.isFamilySelected = false
                                    self.homeResidenceViewModel.isAddNewGroupSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            self.homeResidenceViewModel.isDirectorySelected ? Image("directory") : Image("directoryG")
                                            VStack{
                                                Text("Directory")
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                Text("Obtained")
                                                    .font(.custom(.poppinsRegular, size: 10, relativeTo: .title2))
                                            }
                                            
                                            
                                        }
                                    }
                                )
                            
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeResidenceViewModel.isFamilySelected ? Color(red: 255/255, green: 230/255, blue: 159/255):Color(red:246/255, green: 246/255, blue: 251/255))
                                .frame(width: reader.size.width/3 - 10, height: 60)
                                .onTapGesture {
                                    self.homeResidenceViewModel.selectedOption = .family
                                    print("print clicked")
                                    self.homeResidenceViewModel.isDirectorySelected = false
                                    self.homeResidenceViewModel.isFamilySelected = true
                                    self.homeResidenceViewModel.isAddNewGroupSelected = false
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            self.homeResidenceViewModel.isFamilySelected ? Image("family") : Image("familyG")
                                            //  .padding()
                                            VStack{
                                                Text("Family")
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                                Text("Confidents")
                                                    .font(.custom(.poppinsRegular, size: 10, relativeTo: .title2))
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(self.homeResidenceViewModel.isAddNewGroupSelected ? Color(red: 184/255, green: 242/255, blue: 241/255):Color(red:246/255, green: 246/255, blue: 251/255))
                                .frame(width: reader.size.width/3 - 10, height: 60)
                                .onTapGesture {
                                    self.homeResidenceViewModel.selectedOption = .addNewGroup
                                    print("outline clicked")
                                    self.homeResidenceViewModel.isDirectorySelected = false
                                    self.homeResidenceViewModel.isFamilySelected = false
                                    self.homeResidenceViewModel.isAddNewGroupSelected = true
                                }
                                .overlay(
                                    Group{
                                        HStack{
                                            self.homeResidenceViewModel.isAddNewGroupSelected ? Image("addGroup") : Image("addGroupG")
                                            //  .padding()
                                            VStack{
                                                Text("Add new group")
                                                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                                            }
                                        }
                                    }
                                )
                        }
                        .padding([.leading,.trailing])
                    }
                    HStack{
                        Spacer()
                        if let selectedOption = homeResidenceViewModel.selectedOption {
                            switch selectedOption {
                            case .directory:
                                Text("12 Directory")
                                    .foregroundColor(Color(red: 69/255, green: 86/255, blue: 225/255))
                                    .font(.custom(.poppinsMedium, size: 10, relativeTo: .title))
                               
                            case .family:
                                Text("\(12) Family")
                                    .foregroundColor(Color(red: 69/255, green: 86/255, blue: 225/255))
                                    .font(.custom(.poppinsMedium, size: 10, relativeTo: .title))
                            case .addNewGroup:
                                Text("")
                            }
                        }
                    }
                    .padding()
                    
                    if let selectedOption = homeResidenceViewModel.selectedOption {
                        switch selectedOption {
                        case .directory:
                                VStack{
                                    List($homeResidenceViewModel.directoryData) { $data in
                                        HStack{
                                            Image("person")
                                                .padding([.trailing,.leading],5)
                                                .frame(width: 34,height: 34)
                                                .clipShape(Circle())
                                                .onTapGesture {
                                                    homeResidenceViewModel.isDetailedData = true
                                                }
                                            VStack(alignment: .leading){
                                                Text("Jane Copper")
                                                    .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                                                    .onTapGesture {
                                                        homeResidenceViewModel.isDetailedData = true
                                                    }
                                                Text("Design")
                                                    .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                    .lineLimit(1)
                                                    .onTapGesture {
                                                        homeResidenceViewModel.isDetailedData = true
                                                    }
                                                Text("Location,Hyderbad")
                                                    .font(.custom(.poppinsRegular, size: 14,relativeTo: .title))
                                                    .lineLimit(1)
                                                    .onTapGesture {
                                                        homeResidenceViewModel.isDetailedData = true
                                                    }
                                            }
                                            Spacer()
                                            Button {
                                                
                                                print("Add contact presses Direct")
                                            } label: {
                                                Text("Add Contact")
                                                    .font(.custom(.poppinsRegular, size: 8,relativeTo: .title))
                                                    .padding(.all,5)
                                                    .background(Color(red: 212/255, green: 205/255, blue: 255/255))
                                                    .cornerRadius(18)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            
                                            
                                            Button {
                                                print("Directory clicked")
                                            } label: {
                                                Image("move")
                                                    .font(.custom(.poppinsRegular, size: 8,relativeTo: .title))
                                                    .padding(.all,5)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                        .padding()
                                        .border(selectedItem == data.id ? Color.blue : Color.gray, width: 1)
                                        .cornerRadius(2)
                                        .onTapGesture {
                                            selectedItem = data.id
                                        }
                                        .listRowSeparator(.hidden)
                                    }
                                    .listStyle(PlainListStyle())
                                    .scrollContentBackground(.hidden)
                                }
//                            }
                        case .family:
                            VStack{
                                Text("Coming Soon")
                                    .font(.custom(.poppinsMedium, size: 25, relativeTo: .title))
                                
                            }
                        case .addNewGroup:
                                VStack{
                                    
                                }
                        }
                    }
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            homeResidenceViewModel.isCreateNewGroup = true
                        }) {
                            Image("plus")
                                .font(Font.title.weight(.medium))
                                .foregroundColor(Color.white)
                        }
                        .padding(.trailing,15)
                    }
                }
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
                
            }
            .navigationDestination(isPresented: $homeResidenceViewModel.isComposeEmail) {
              //  MailComposeView().toolbar(.hidden)
            }
            .navigationDestination(isPresented: $homeResidenceViewModel.isDetailedData) {
                ResidenceUserProfileView().toolbar(.hidden)
            }
            .toast(message: $homeResidenceViewModel.error)
            
            if homeResidenceViewModel.isCreateNewGroup {
                Color.black
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                AddNewGroupView(isNewGroupVisible: $homeResidenceViewModel.isCreateNewGroup)
                    .transition(.opacity)
            }
        }
    }
    
    var addContactView: some View {
        VStack(spacing: 16) {
            Button {
               
            } label: {
                Text("Family")
                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    .foregroundColor(Color(red: 60/255, green: 60/255, blue: 60/255))
            }
            Button {
               
            } label: {
                Text("Services")
                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    .foregroundColor(Color(red: 60/255, green: 60/255, blue: 60/255))
            }
            Button {
             
            } label: {
                Text("Personal")
                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    .foregroundColor(Color(red: 60/255, green: 60/255, blue: 60/255))
            }
            
            Button {
               
            } label: {
                Text("Friends")
                    .font(.custom(.poppinsRegular, size: 14, relativeTo: .title))
                    .foregroundColor(Color(red: 60/255, green: 60/255, blue: 60/255))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    HomeResidenceView()
}
