//
//  EditProfileView.swift
//  Thapala
//
//  Created by Ahex-Guest on 29/07/24.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var editProfileViewModel = EditProfileViewModel()
    
    let imageUrl: String
    let name: String
    let tCode: String
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(Color.black)
                })

                Spacer()
            }
            ZStack {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    case .failure:
                        Image("person")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.blue)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Image(systemName: "checkmark.shield.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.green)
                    .offset(x: 35, y: -35)
            }
            
            Text(name)
                .font(.custom(.poppinsMedium, size: 14, relativeTo: .title2))
            
            HStack {
                Text("tCode: \(tCode)")
                    .font(.custom(.poppinsMedium, size: 14, relativeTo: .title2))
                Image(systemName: "questionmark.circle")
            }
            .foregroundColor(.gray)
            
            HStack(spacing: 30) {
                Button(action: {
                    // Action for Request a feature
                }) {
                    Text("Request a feature")
                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                }
                
                Text("|")
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Action for Report a problem
                }) {
                    Text("Report a problem")
                        .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                }
            }
            .foregroundColor(.gray)
            
            HStack(spacing: 20) {
                Button(action: {
                    editProfileViewModel.isToBioProfile = true
                }) {
                    Text("My Bio")
                        .frame(minWidth: 100, minHeight: 44)
                        .background(Color.themeColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Action for Sign Out
                }) {
                    Text("Sign Out")
                        .frame(minWidth: 100, minHeight: 44)
                        .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                        .foregroundColor(.gray)
                        .cornerRadius(8)
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationDestination(isPresented: $editProfileViewModel.isToBioProfile) {
            if editProfileViewModel.isToBioProfile {
                HomeNavigatorView(imageUrl: "").toolbar(.hidden)
            }
        }
    }
}

#Preview {
    EditProfileView(imageUrl: "", name: "Kathryn Murphy", tCode: "2345678765")
}

class EditProfileViewModel:ObservableObject{
    @Published var isToBioProfile:Bool = false
}
