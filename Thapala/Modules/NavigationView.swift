//
//  NavigationView.swift
//  Thapala
//
//  Created by ahex on 30/04/24.
//

import SwiftUI

struct NavigationScreen: View { // Renamed to avoid name conflict with NavigationView
    @EnvironmentObject var sessionManager: SessionManager
    var body: some View {
        Text("Navigator")
    }
}

#Preview {
    NavigationScreen().environmentObject(SessionManager())
}
