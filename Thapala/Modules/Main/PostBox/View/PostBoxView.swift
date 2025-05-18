//
//  PostBoxView.swift
//  Thapala
//
//  Created by ahex on 08/08/24.
//

import SwiftUI

struct PostBoxView: View {
    @StateObject private var postBoxViewModel = PostBoxViewModel()
    var body: some View {
        ZStack {
            Color(red: 69/250, green: 86/250, blue: 225/250)
                .ignoresSafeArea()
            VStack {
                VStack {
                    HStack(spacing: 20) {
                        Text("Postbox")
                            .foregroundStyle(Color.white)
                            .font(.custom(.poppinsBold, size: 16))
                        Spacer()
                        Image("search")
                        Image("edit")
                        Image("notification")
                        Image("menu")
                    }
                    HStack {
                        ForEach(postBoxViewModel.postBoxOptions, id: \.self) { postBoxOption in
                            RoundedRectangle(cornerRadius: 8)
                                .frame(height: 44)
                                .foregroundStyle(postBoxOption.isSelected ? Color.white : Color(red: 69/250, green: 52/250, blue: 175/250))
                                .overlay(alignment: .center) {
                                    HStack {
                                        Image(postBoxOption.selectedImage)
                                            .resizable()
                                            .frame(width: 22, height: 22)
                                        Text(postBoxOption.name)
                                            .font(.custom(.poppinsRegular, size: 14))
                                            .foregroundStyle(postBoxOption.isSelected ? Color.black : Color.white)
                                    }
                                }
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 5)
                }
                .padding(.horizontal)
                .background(Color(red: 69/250, green: 86/250, blue: 225/250))
                ScrollView {
                    LazyVStack(spacing: 0,content: {
                        ForEach(1...55, id: \.self) { count in
                            VStack(spacing: 0) {
                                HStack(alignment: .center, spacing: 14) {
                                    Image("Ellipse 546")
                                        .resizable()
                                        .frame(width: 34, height: 34)
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Kathryn Murphy")
                                            .font(.custom(.poppinsBold, size: 14))
                                            .foregroundStyle(Color.black)
                                            .lineLimit(1)
                                        Text("The long barrow was built on land previously inhabited in the Mesolithic period. It consisted of a s")
                                            .font(.custom(.poppinsLight, size: 14))
                                            .foregroundStyle(Color.lightGrayColor)
                                            .lineLimit(1)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .padding(.leading)
                                Divider()
                            }
                            
                        }
                        
                    })
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.white)
                Spacer()
            }
            .ignoresSafeArea(edges: /*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
        }
        .overlay(alignment: .bottomTrailing, content: {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 150,height: 48)
                .overlay(alignment: .center) {
                    HStack {
                        Text("New Email")
                            .font(.custom(.poppinsBold, size: 14))
                            .foregroundStyle(Color.white)
                            .padding(.trailing, 8)
                        Spacer()
                            .frame(maxWidth: 1, maxHeight: .infinity)
                            .background(Color.white)
                        Image("dropdown 1")
                    }
                }
                .padding(.trailing)
                .padding(.bottom)
                .padding(.bottom)
        })
    }
}

#Preview {
    PostBoxView()
}
