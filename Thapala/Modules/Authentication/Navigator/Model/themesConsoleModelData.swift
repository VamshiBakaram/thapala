//
//  themesConsoleModelData.swift
//  Thapala
//
//  Created by Ahex-Guest on 17/04/25.
//

import Foundation
import SwiftUICore

struct Themeresponse: Codable {
    let message: String
    let theme: String
    let accentColor: String
}
// theme change payload

struct ThemePayload: Codable {
    let theme: String
    let accentColor: String
}

// themes change
enum AppTheme: String, CaseIterable, Identifiable {
    case light
    case dark
    case elegance
    case minimalism
    case inviting
    case tech
    case elegent

    var id: String { self.rawValue }
}


struct Theme {
    // Primary colors
    let colorPrimary: Color
    let colorPrimaryDark: Color
    let colorAccent: Color
    
    // Background and text
    let windowBackground: Color
    let textColor: Color
    let inverseTextColor: Color
    
    
    // Icons and strokes
    let iconColor: Color
    let inverseIconColor: Color
    let strokeColor: Color
    
    // Tabs and buttons
    let tabBackground: Color
    let tabIndicatorColor: Color
    let customButtonColor: Color
    let customButtonColorUnselected: Color
    
    // Miscellaneous
    let customBackgroundTint: Color
    let colorControlNormal: Color
    let customEditTextColor: Color
    let attachmentBGColor: Color
    let bottomSheetBG: Color
    
    let AllBlack: Color
    let AllGray: Color
}
