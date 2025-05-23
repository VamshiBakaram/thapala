//
//  CustomProgressView.swift
//  Thapala
//
//  Created by ahex on 24/04/24.
//

import Foundation
import SwiftUI

struct CustomProgressView: View {
    @ObservedObject var themesviewModel = themesViewModel()
    
    var body: some View {
        ZStack {
            Color.clear // optional background
            ProgressView()
                .tint(themesviewModel.currentTheme.iconColor)
                .scaleEffect(1.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

