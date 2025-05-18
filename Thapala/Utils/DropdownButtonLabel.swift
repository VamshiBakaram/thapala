//
//  DropdownButtonLabel.swift
//  Thapala
//
//  Created by ahex on 29/04/24.
//

import Foundation
import SwiftUI

struct DropdownButtonLabel: View {
    
    @Binding var title: String
    let placeHolder: String
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.custom(.poppinsRegular, size: 16))
                    .padding(.all, 14)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
                Image("dropdown1")
                    .padding(.trailing)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.grayColor)
            )
            Text(placeHolder)
                .modifier(TextFieldPlaceHolderLabel())
        }
    }
}

struct GreyBgDropdownButtonLabel: View {
    
    @Binding var title: String
    let placeHolder: String
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.custom(.poppinsRegular, size: 16))
                    .padding(.all, 14)
                    .foregroundStyle(Color.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                Spacer()
                Image("dropdown1")
                    .padding(.trailing)
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white)
            )
            Text(placeHolder)
                .modifier(GreyBgTextFieldPlaceHolderLabel())
        }
    }
}
