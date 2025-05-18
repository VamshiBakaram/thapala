//
//  SuggestTCodeView.swift
//  Thapala
//
//  Created by ahex on 09/05/24.
//

import SwiftUI

struct SuggestTCodeView: View {
    
    @ObservedObject var picktCodeViewModel : PicktCodeViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
                .frame(width: 45, height: 4)
                .background(Color.grayColor)
                .clipShape(RoundedRectangle(cornerRadius: 2))
                .padding(.top, 25)
            HStack {
                Text("Suggested postal codes :")
                    .font(.custom(.poppinsRegular, size: 16))
                    .foregroundStyle(Color.themeColor)
                    .padding(.horizontal)
                Spacer()
            }
            if picktCodeViewModel.suggestedTCodes.isEmpty {
                Spacer()
            }else{
                ScrollView {
                    ForEach(picktCodeViewModel.suggestedTCodes, id: \.self) { tCode in
                        HStack {
                            Text("\(tCode)")
                                .font(.custom(.poppinsRegular, size: 14))
                                .padding(.vertical, 8)
                                .foregroundStyle(Color.black)
                                .padding(.horizontal, 9)
                                .overlay(content: {
                                    if (String(picktCodeViewModel.tCode.joined(separator: ""))) == String(tCode) {
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(Color.themeColor.opacity(0.2))
                                    }
                                })
                            Spacer()
                        }
                        .onTapGesture {
                            picktCodeViewModel.selectetCode(code: tCode)
                            picktCodeViewModel.showtCodes()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 6)
            }
        }
    }
}

#Preview {
    SuggestTCodeView(picktCodeViewModel: PicktCodeViewModel())
}
