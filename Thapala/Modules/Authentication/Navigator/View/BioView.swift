//
//  BioView.swift
//  Thapala
//
//  Created by Ahex-Guest on 29/04/25.
//

import SwiftUI

struct BioView: View {
    @ObservedObject var themesviewModel = ThemesViewModel()
    @ObservedObject var homeNavigatorViewModel = HomeNavigatorViewModel()
    @EnvironmentObject private var sessionManager: SessionManager
    @State private var firstName: String = ""
    @State private var tcode: String = ""
    @State private var phoneNumber: String = ""
    @State private var country: String = ""
    @State private var AccountcreatedOn:  String = ""
    @State private var lastLogin: String = ""
    @State private var birthDate: String = ""
    @State private var gender: String = ""
    @State private var motherTongue: String = ""
    @State private var Language: String = ""
    @State private var state:  String = ""
    @State private var city: String = ""
    let imageUrl: String
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Image("person")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .background(themesviewModel.currentTheme.windowBackground)
                                .padding(.leading,20)
                            Text("Active")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                .fontWeight(.bold)
                            Text("64922*****")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                                .fontWeight(.bold)
                        }
                        
                        Text("Name")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(firstName)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("tcode")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(tcode)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("phone")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(phoneNumber)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("origin")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(country)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("Accounted created on")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(AccountcreatedOn)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("Last Login")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(lastLogin)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                    }
                    .padding(.top, 10)
                    .padding(.leading, 5)
                    .padding() // <- Padding inside the card
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                    )
                    .padding(.horizontal, 30)
                    
                    
                }
                Spacer()
                    .frame(height: 30)
                
                
                VStack {
                    VStack(alignment: .leading) {
                        Text("Birthday")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(birthDate )
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("Gender")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(gender)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("Mother tongue")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(motherTongue)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("Language")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(Language)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("Country")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(country)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("State")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(state)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                        
                        Text("City")
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                        Text(city)
                            .foregroundColor(themesviewModel.currentTheme.textColor)
                            .font(.custom(.poppinsRegular, size: 16, relativeTo: .title))
                            .fontWeight(.bold)
                    }
                    .padding(.leading, 5)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(themesviewModel.currentTheme.strokeColor, lineWidth: 1)
                    )
                    .padding(.horizontal, 30)
                }
                
            }
        }
        .onAppear{
                homeNavigatorViewModel.getNavigatorBio(userId: sessionManager.userId)
                homeNavigatorViewModel.getLastestLogin()
                

            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                firstName = homeNavigatorViewModel.navigatorBioData?.user?.firstName ?? ""
                phoneNumber = homeNavigatorViewModel.navigatorBioData?.bio?.phoneNumber ?? ""
                country = homeNavigatorViewModel.navigatorBioData?.bio?.country ?? ""
                AccountcreatedOn = formattedDate(from: homeNavigatorViewModel.navigatorBioData?.bio?.createdAt)
                tcode = homeNavigatorViewModel.navigatorBioData?.user?.tCode ?? ""
                birthDate = formattedDate(from: homeNavigatorViewModel.navigatorBioData?.bio?.birthDate)
                gender = homeNavigatorViewModel.navigatorBioData?.bio?.gender ?? "N/A"
                motherTongue = homeNavigatorViewModel.navigatorBioData?.bio?.place ?? "N/A"
                Language = homeNavigatorViewModel.navigatorBioData?.bio?.languages ?? "N/A"
                state = homeNavigatorViewModel.navigatorBioData?.bio?.state ?? "N/A"
                city = homeNavigatorViewModel.navigatorBioData?.bio?.city ?? "N/A"
                lastLogin = formatDate(from: homeNavigatorViewModel.lastestData?.data?.first?.lastLogin ?? 0)
            }
        }
    }
    func formattedDate(from isoDate: String?) -> String {
        guard let isoDate = isoDate else { return "N/A" }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = isoFormatter.date(from: isoDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }

        return "N/A"
    }
    
    func formatDate(from timestamp: Int?) -> String {
        guard let timestamp = timestamp else { return "N/A" }

        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }


}

#Preview {
    BioView(imageUrl: "")
}

