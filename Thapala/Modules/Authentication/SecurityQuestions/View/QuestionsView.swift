//
//  QuestionsView.swift
//  Thapala
//
//  Created by ahex on 29/04/24.
//

import SwiftUI

struct QuestionsView: View {
    
    @ObservedObject var securityQuestionsViewModel : SecurityQuestionsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
                .frame(width: 45, height: 4)
                .background(Color.grayColor)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.top, 25)
            if securityQuestionsViewModel.questions.isEmpty {
                Spacer()
            }else{
                ScrollView {
                    ForEach(securityQuestionsViewModel.questions, id: \.self) { question in
                        HStack {
                            Text(question.question ?? "")
                                .font(.custom(.poppinsRegular, size: 14))
                                .padding(.vertical, 8)
                                .foregroundStyle(Color.black)
                                .padding(.horizontal, 9)
                                .overlay(content: {
                                    if (question.question ?? "") == securityQuestionsViewModel.selectedQuestion {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.themeColor.opacity(0.2))
                                    }
                                })
                            Spacer()
                        }
                        .onTapGesture {
                            securityQuestionsViewModel.selecteQuestion(question: question)
                            securityQuestionsViewModel.showQuestions()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 6)
            }
            if securityQuestionsViewModel.isAddNewQuestion {
                HStack(spacing: 2) {
                    TextField("Enter new question", text: $securityQuestionsViewModel.newQuestion)
                        .frame(maxWidth: .infinity)
                        .font(.custom(.poppinsRegular, size: 14))
                        .padding(.vertical)
                        .foregroundStyle(Color.lightGrayColor)
                        .padding(.leading)
                    Button(action: {
                        securityQuestionsViewModel.showAddNewQuestion()
                    }, label: {
                        Text("Add")
                            .frame(width: 70)
                            .font(.custom(.poppinsMedium, size: 16, relativeTo: .title))
                            .padding(.vertical, 10)
                            .foregroundStyle(Color.white)
                            .background(Color.themeColor)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.trailing, 6)
                    })
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black)
                }
                .padding(.horizontal)
            }else{
                HStack {
                    Button(action: {
                        securityQuestionsViewModel.showAddNewQuestion()
                    }, label: {
                        Text("+ Add new question")
                            .font(.custom(.poppinsMedium, size: 14))
                            .foregroundStyle(Color.themeColor)
                    })
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    QuestionsView(securityQuestionsViewModel: SecurityQuestionsViewModel())
}
