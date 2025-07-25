//
//  ScheduleEmailView.swift
//  Thapala
//
//  Created by Ahex-Guest on 07/06/24.
//

import SwiftUI

struct ScheduleEmailView: View {
    
    @Binding var isScheduleVisible: Bool
    @ObservedObject private var scheduleEmailViewModel = ScheduleEmailViewModel()
    @ObservedObject var viewModel = MailComposeViewModel()
    
    var body: some View {
        ZStack{
            Color(red: 0, green: 0, blue: 0)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    isScheduleVisible = false
                }
            VStack{
                Spacer()
                VStack{
                    HStack{
                        Text("Schedule mail")
                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                            .padding(.top,25)
                            .padding(.horizontal)
                        Spacer()
                        Button(action: {
                            self.isScheduleVisible = false
                        }, label: {
                            Image("cross")
                        })
                        .padding(.top,25)
                        .padding(.trailing, 15)
                        
                    }
                    HStack {
                        Text("When do you want your message")
                            .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                            .padding(.horizontal)
                            .padding(.top,10)
                        Spacer()
                    }
                    
                    HStack {
                        Text("to be sent ?")
                            .font(.custom(.poppinsLight, size: 14, relativeTo: .title))
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    
                    FloatingTextField(text: $scheduleEmailViewModel.startDate, placeHolder: "Start Date", allowedCharacter: .defaultType)
                        .padding(.horizontal)
                        .padding(.top,10)
                        .onTapGesture {
                            scheduleEmailViewModel.isDatePickerPresented = true
                        }
                    
                    if scheduleEmailViewModel.isDatePickerPresented {
                        VStack {
                            /*
                             DatePicker(
                             "Select a date",
                             selection: $scheduleEmailViewModel.date,
                             displayedComponents: [.date]
                             )
                             .datePickerStyle(WheelDatePickerStyle())
                             .labelsHidden()
                             .padding()
                             
                             Button("Done") {
                             let formatter = DateFormatter()
                             formatter.dateStyle = .medium
                             scheduleEmailViewModel.startDate = formatter.string(from: scheduleEmailViewModel.date)
                             scheduleEmailViewModel.isDatePickerPresented = false
                             }
                             */
                            DatePicker(
                                "Select a date",
                                selection: $scheduleEmailViewModel.date,
                                in: Date()...,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .padding()
                            
                            Button("Done") {
                                let formatter = DateFormatter()
                                formatter.dateStyle = .medium
                                scheduleEmailViewModel.startDate = formatter.string(from: scheduleEmailViewModel.date)
                                scheduleEmailViewModel.isDatePickerPresented = false
                            }
                            .padding([.top,.bottom],8)
                            .padding([.leading,.trailing],12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom,10)
                        }
                        .transition(.opacity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding()
                    }
                    FloatingTextField(text: $scheduleEmailViewModel.time, placeHolder: "Time", allowedCharacter: .defaultType)
                        .padding(.horizontal)
                        .padding(.top,10)
                        .onTapGesture {
                            scheduleEmailViewModel.isTimePickerPresented = true
                        }
                    
                    if scheduleEmailViewModel.isTimePickerPresented {
                        VStack {
                            DatePicker(
                                "Select a time",
                                selection: $scheduleEmailViewModel.date,
                                displayedComponents: [.hourAndMinute]
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .padding()
                            Button("Done") {
                                let formatter = DateFormatter()
                                formatter.timeStyle = .short
                                scheduleEmailViewModel.time = formatter.string(from: scheduleEmailViewModel.date)
                                scheduleEmailViewModel.isTimePickerPresented = false
                            }
                            .padding([.top,.bottom],8)
                            .padding([.leading,.trailing],12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom,10)
                        }
                        .transition(.opacity)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            scheduleEmailViewModel.startDate = ""
                            scheduleEmailViewModel.time = ""
                        }, label: {
                            Text("Reset")
                        })
                        .padding(.all,10)
                        .frame(width:100)
                        .background(Color.white)
                        .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 1)
                                )
                        .foregroundColor(.black)
                        Button(action: {
                            scheduleEmailViewModel.validate()
                            if scheduleEmailViewModel.isScheduleCreated {
                                self.isScheduleVisible = false
                            }
                        }, label: {
                            Text("Set")
                        })
                        .padding(.all,10)
                        .frame(width:100)
                        .background(Color.themeColor)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding([.bottom,.top],20)
                    }
                    .padding(.trailing,20)
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15.3))
            }
        }
        .toast(message: $scheduleEmailViewModel.error)
        
    }
}

#Preview {
    ScheduleEmailView(isScheduleVisible: .constant(false))
}
