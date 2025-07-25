//
//  snooze.swift
//  Thapala
//
//  Created by Ahex-Guest on 03/07/25.
//

import SwiftUI
import ClockTimePicker

struct BottomSnoozeView: View {
    @ObservedObject var homePlannerViewModel = HomePlannerViewModel()
    @StateObject var mailFullViewModel = MailFullViewModel()
    @StateObject private var homeAwaitingViewModel = HomeAwaitingViewModel()
    @ObservedObject var themesviewModel = ThemesViewModel()
    @Binding var isBottomSnoozeViewVisible: Bool
    @Binding var SnoozeTime: Int
    @State var comment: String = ""
    var selectedID: Int
    @State private var selectedDate = Date() // Holds the current date or time
    @State private var isDatePickerVisible = false // Controls date picker dialog
    @State private var isTimePickerVisible = false
    @ObservedObject private var options = ClockLooks()
    @State var id:Int = 0
    var body: some View {
        
        ZStack {
            VStack {
                if isBottomSnoozeViewVisible {
                    VStack(spacing: 16) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Reminder")
                                    .font(.headline)
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .padding(.top, 20)
                                    .padding(.leading, 16)
                                
                                Spacer()
                                
                                Button(action: {
                                    if let selectedDateTime = mailFullViewModel.selectedDateTime {
                                        // Convert the Date to an Int (e.g., timestamp)
                                        SnoozeTime = Int(selectedDateTime.timeIntervalSince1970)
//                                        homeAwaitingViewModel.snoozedEmail(selectedEmail: selectedID)
                                        homeAwaitingViewModel.snoozedEmail(snoozedAt: SnoozeTime, selectedThreadID: [selectedID])
                                        self.isBottomSnoozeViewVisible = false
                                    }
                                    
                                }, label: {
                                    Text("Done")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                })
                                .font(.headline)
                                .foregroundColor(themesviewModel.currentTheme.colorAccent)
                                .padding(.trailing, 16)
                                .padding(.top, 16)
                            }
                            
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 1)
                                .foregroundColor(themesviewModel.currentTheme.strokeColor)
                                .padding(.horizontal, 16)
                            
                            HStack {
                                Button(action: {
                                }, label: {
                                    Text("Tomorrow")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                })
                                .padding(.leading, 16)
                                
                                Spacer()
                                
                                Button(action: {
                                }, label: {
                                    Text("8:00 AM")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                })
                                .padding(.trailing, 16)
                            }
                            .padding(.top, 10)
                            
                            HStack {
                                Button(action: {
                                }, label: {
                                    Text("Next Week")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                })
                                .padding(.leading, 16)
                                
                                Spacer()
                                
                                Button(action: {
                                }, label: {
                                    Text("8:00 AM")
                                        .foregroundColor(themesviewModel.currentTheme.textColor)
                                })
                                .padding(.trailing, 16)
                            }
                            .padding(.top, 10)
                            
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundColor(themesviewModel.currentTheme.textColor)
                                    .frame(width: 24, height: 24)
                                    .padding(.leading, 16)
                                
                                Button(action: {
                                    isDatePickerVisible = true
                                }) {
                                    Text(mailFullViewModel.selectedDateTime != nil ? selectedDateTimeFormatted : "Select Date and Time")
                                        .foregroundColor(themesviewModel.currentTheme.colorAccent)
                                        .fontWeight(.bold)
                                        .padding()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: calculateTotalHeight())
                        .background(themesviewModel.currentTheme.windowBackground)
                        .cornerRadius(16)
                        .shadow(radius: 10)
                    }

                    .overlay(
                        Group {
                            if isDatePickerVisible {
                                DialogView(
                                    title: "Select a Date",
                                    content: {
                                        DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                            .datePickerStyle(WheelDatePickerStyle())
                                            .labelsHidden()
                                    },
                                    onCancel: {
                                        isDatePickerVisible = false
                                    },
                                    onConfirm: {
                                        isDatePickerVisible = false
                                        isTimePickerVisible = true
                                    }
                                )
                                .offset(y: -120)
                            }
                        }
                    )
                    .overlay(
                        Group {
                            if isTimePickerVisible {
                                DialogView(
                                    title: "Select a Time",
                                    content: {
                                        ClockPickerView(date: $selectedDate)
                                            .frame(width: 250, height: 250)
                                    },
                                    onCancel: {
                                        isTimePickerVisible = false
                                    },
                                    onConfirm: {
                                        isTimePickerVisible = false
                                        mailFullViewModel.selectedDateTime = selectedDate
                                    }
                                )
                                .offset(y: -120)
                            }
                        }
                    )
                }
            }
            .onAppear {
                options.withHands = true

            }
        }
        .background(
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isBottomSnoozeViewVisible = false // Dismiss the sheet
                    }
                }
        )

        
    }
    func calculateTotalHeight() -> CGFloat {
        let baseHeight: CGFloat = 200 // Base height for fixed elements
        let rowHeight: CGFloat = 44   // Estimated height for each row in the list
        let maxHeight: CGFloat = 800  // Maximum height for the entire view
        let totalHeight:CGFloat = 210
        return min(totalHeight, maxHeight)
    }
    
    private var selectedDateTimeFormatted: String {
        guard let dateTime = mailFullViewModel.selectedDateTime else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateTime)
    }
}
