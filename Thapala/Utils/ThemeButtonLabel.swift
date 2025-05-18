//
//  ThemeButtonLabel.swift
//  Thapala
//
//  Created by ahex on 23/04/24.
//

import Foundation
import SwiftUI

struct ThemeButtonLabel: View {
    let title: String
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .frame(height: 16)
            .font(.custom(.poppinsMedium, size: 14, relativeTo: .title))
            .padding()
            .foregroundStyle(Color.white)
            .background(Color.themeColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
