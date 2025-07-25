//
//  ScheduleEmailViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import Foundation
class ScheduleEmailViewModel:ObservableObject{
    @Published var error:String?
    @Published var isLoading:Bool = false
    @Published var startDate = ""
    @Published var time = ""
    @Published var isDatePickerPresented = false
    @Published var date = Date.now
    @Published var isTimePickerPresented = false
    @Published var isScheduleCreated = false
    @Published var scheduleTimeStamp:Double = 0.0
    
    func validate(){
        if startDate.isEmpty {
            error = "Please select start date"
            return
        }
        if time.isEmpty {
            error = "Please select time"
            return
        }
        self.scheduleTimeStamp = convertToTimestamp(dateString: startDate, timeString: time) ?? 0.0
        ComposeEmailData.shared.timeStap = scheduleTimeStamp
        ComposeEmailData.shared.isScheduleCreated = true
        self.isScheduleCreated = true
    }
    
}
