//
//  themesViewModel.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/04/25.
//

import Foundation

class ThemesViewModel:ObservableObject{
    @Published var selectedTheme: String = ""
    @Published var sessionManager = SessionManager()
    
    var currentTheme: Theme {
        if let theme = AppTheme(rawValue: sessionManager.selectedTheme) {
            return ThemeManager.getTheme(theme)
        } else {
            return ThemeManager.getTheme(.light) // fallback
        }
    }
}
