//
//  NavigatorEditViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 28/05/24.
//

import Foundation
class NavigatorEditViewModel:ObservableObject{
    @Published var firstName = "Harry Potter"
    @Published var tCode = "9876543211"
    @Published var phoneNumber = "(813)-616-324"
    @Published var birthDate = "10-11-1982"
    @Published var gender = "Male"
    @Published var preferredGender = "He/Him"
    @Published var nationality = "United States"
    @Published var language = "Hindi, English,  Telugu"
    @Published var maritalStatus = "Married"
    @Published var acccountType = "Yes"
    @Published var govtId = "Harry Potter"
    @Published var hobbies = "Gardening, Playing games,Arts, Making digital marketing templates."
}
