//
//  AddEventViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 21/06/24.
//

import Foundation
class AddEventViewModel:ObservableObject{
    @Published var title = ""
    @Published var startDate = ""
    @Published var startTime = ""
    @Published var endDate = ""
    @Published var endTime = ""
    @Published var repeatEvent = ""
    @Published var note = ""
}
