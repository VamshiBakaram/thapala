//
//  themeManager.swift
//  Thapala
//
//  Created by Ahex-Guest on 22/04/25.
//

import Foundation
import SwiftUICore

struct ThemeManager {
    static func getTheme(_ theme: AppTheme) -> Theme {
        switch theme {
        case .light:
            return Theme(
                colorPrimary: Color.lightPrimary ?? Color.red, colorPrimaryDark: Color.lightPrimaryDark ?? Color.red, colorAccent: Color.lightTabBg ?? Color.red, windowBackground: Color.pureWhite ?? Color.red, textColor: Color.black, inverseTextColor: Color.pureWhite ?? Color.red, iconColor: Color.black, inverseIconColor: Color.pureWhite ?? Color.red, strokeColor: Color.lightStrokeColor ?? Color.red, tabBackground: Color.lightTabBg ?? Color.red, tabIndicatorColor: Color.pureWhite ?? Color.red, customButtonColor: Color.lightButtonSelected ?? Color.red, customButtonColorUnselected: Color.lightButtonUnselected ?? Color.red, customBackgroundTint: Color.black, colorControlNormal: Color.black, customEditTextColor: Color.pureWhite ?? Color.red, attachmentBGColor: Color.mailAttachmentColor ?? Color.red, bottomSheetBG: Color.pureWhite ?? Color.red, allBlack: Color.black, allGray: Color.gray ?? Color.red
            )
        case .dark:
            return Theme(
                colorPrimary: Color.darkPrimary ?? Color.red, colorPrimaryDark: Color.greenPrimaryDark ?? Color.red, colorAccent: Color.greenAccent ?? Color.red, windowBackground: Color.windowBackgroundDark ?? Color.red, textColor:Color.pureWhite ?? Color.red, inverseTextColor: Color.pureWhite ?? Color.red , iconColor: Color.pureWhite ?? Color.red, inverseIconColor: Color.pureWhite ?? Color.red,strokeColor: Color.lightStrokeColor ?? Color.red, tabBackground: Color.tabBackground ?? Color.red, tabIndicatorColor: Color.greenAccent ?? Color.red, customButtonColor: Color.tabBackground ?? Color.red, customButtonColorUnselected: Color.darkButton ?? Color.red, customBackgroundTint: Color.pureWhite ?? Color.red, colorControlNormal: Color.pureWhite ?? Color.red, customEditTextColor: Color.customEditTextColor ?? Color.red, attachmentBGColor: Color.lightButtonUnselected ?? Color.red, bottomSheetBG: Color.windowBackgroundDark ?? Color.red , allBlack: Color.black , allGray: Color.gray ?? Color.red
            )
        case .elegance:
            return Theme(
                colorPrimary: Color.lightPrimary ?? Color.red, colorPrimaryDark: Color.lightPrimaryDark ?? Color.red, colorAccent: Color.lightTabBg ?? Color.red, windowBackground: Color.pureWhite ?? Color.red, textColor: Color.black, inverseTextColor: Color.pureWhite ?? Color.red, iconColor: Color.black, inverseIconColor: Color.pureWhite ?? Color.red, strokeColor: Color.lightStrokeColor ?? Color.red, tabBackground: Color.lightTabBg ?? Color.red, tabIndicatorColor: Color.pureWhite ?? Color.red, customButtonColor: Color.lightButtonSelected ?? Color.red, customButtonColorUnselected: Color.lightButtonUnselected ?? Color.red, customBackgroundTint: Color.black, colorControlNormal: Color.black, customEditTextColor: Color.pureWhite ?? Color.red, attachmentBGColor: Color.mailAttachmentColor ?? Color.red, bottomSheetBG: Color.pureWhite ?? Color.red , allBlack: Color.black,allGray: Color.gray ?? Color.red
            )
        case .minimalism:
            return Theme(
                colorPrimary: Color.lightPrimary ?? Color.red, colorPrimaryDark: Color.lightPrimaryDark ?? Color.red, colorAccent: Color.lightTabBg ?? Color.red, windowBackground: Color.pureWhite ?? Color.red, textColor: Color.black, inverseTextColor: Color.pureWhite ?? Color.red, iconColor: Color.black, inverseIconColor: Color.pureWhite ?? Color.red, strokeColor: Color.lightStrokeColor ?? Color.red, tabBackground: Color.lightTabBg ?? Color.red, tabIndicatorColor: Color.pureWhite ?? Color.red, customButtonColor: Color.lightButtonSelected ?? Color.red, customButtonColorUnselected: Color.lightButtonUnselected ?? Color.red, customBackgroundTint: Color.black, colorControlNormal: Color.black, customEditTextColor: Color.pureWhite ?? Color.red, attachmentBGColor: Color.mailAttachmentColor ?? Color.red, bottomSheetBG: Color.pureWhite ?? Color.red , allBlack: Color.black,allGray: Color.gray ?? Color.red
            )
        case .inviting:
            return Theme(
                colorPrimary: Color.lightPrimary ?? Color.red, colorPrimaryDark: Color.lightPrimaryDark ?? Color.red, colorAccent: Color.lightTabBg ?? Color.red, windowBackground: Color.pureWhite ?? Color.red, textColor: Color.black, inverseTextColor: Color.pureWhite ?? Color.red, iconColor: Color.black, inverseIconColor: Color.pureWhite ?? Color.red, strokeColor: Color.lightStrokeColor ?? Color.red, tabBackground: Color.lightTabBg ?? Color.red, tabIndicatorColor: Color.pureWhite ?? Color.red, customButtonColor: Color.lightButtonSelected ?? Color.red, customButtonColorUnselected: Color.lightButtonUnselected ?? Color.red, customBackgroundTint: Color.black, colorControlNormal: Color.black, customEditTextColor: Color.pureWhite ?? Color.red, attachmentBGColor: Color.mailAttachmentColor ?? Color.red, bottomSheetBG: Color.pureWhite ?? Color.red , allBlack: Color.black,allGray: Color.gray ?? Color.red
            )
        case .tech:
            return Theme(
                colorPrimary: Color.lightPrimary ?? Color.red, colorPrimaryDark: Color.lightPrimaryDark ?? Color.red, colorAccent: Color.lightTabBg ?? Color.red, windowBackground: Color.pureWhite ?? Color.red, textColor: Color.black, inverseTextColor: Color.pureWhite ?? Color.red, iconColor: Color.black, inverseIconColor: Color.pureWhite ?? Color.red, strokeColor: Color.lightStrokeColor ?? Color.red, tabBackground: Color.lightTabBg ?? Color.red, tabIndicatorColor: Color.pureWhite ?? Color.red, customButtonColor: Color.lightButtonSelected ?? Color.red, customButtonColorUnselected: Color.lightButtonUnselected ?? Color.red, customBackgroundTint: Color.black, colorControlNormal: Color.black, customEditTextColor: Color.pureWhite ?? Color.red, attachmentBGColor: Color.mailAttachmentColor ?? Color.red, bottomSheetBG: Color.pureWhite ?? Color.red , allBlack: Color.black,allGray: Color.gray ?? Color.red
            )
        case .elegent:
            return Theme(
                colorPrimary: Color.darkPrimary ?? Color.red, colorPrimaryDark: Color.greenPrimaryDark ?? Color.red, colorAccent: Color.greenAccent ?? Color.red, windowBackground: Color.windowBackgroundDark ?? Color.red, textColor:Color.pureWhite ?? Color.red, inverseTextColor: Color.pureWhite ?? Color.red , iconColor: Color.pureWhite ?? Color.red, inverseIconColor: Color.pureWhite ?? Color.red, strokeColor: Color.white60Percent ?? Color.red, tabBackground: Color.tabBackground ?? Color.red, tabIndicatorColor: Color.greenAccent ?? Color.red, customButtonColor: Color.tabBackground ?? Color.red, customButtonColorUnselected: Color.darkButton ?? Color.red, customBackgroundTint: Color.pureWhite ?? Color.red, colorControlNormal: Color.pureWhite ?? Color.red, customEditTextColor: Color.customEditTextColor ?? Color.red, attachmentBGColor: Color.mailAttachmentColor ?? Color.red, bottomSheetBG: Color.windowBackgroundDark ?? Color.red , allBlack: Color.black,allGray: Color.gray ?? Color.red
            )
        }
    }
}


extension Color {
    static let black = Color(hex: "#FF000000")
    static let lightBlack = Color(hex: "#CC707070")
    static let brown = Color(hex: "#707070")
    static let white = Color(hex: "#9FFFFFFF")
    static let white80 = Color(hex: "#CCFFFFFF")
    static let lightGray = Color(hex: "#A2A2A2")
    static let highlightTextColor = Color(hex: "#2196F3")
    static let appColor = Color(hex: "#4556E1")
    static let appColorSeventyOpacity = Color(hex: "#B34556E1")
    static let errorColor = Color(hex: "#EC5252")
    static let textviewBgColor = Color(hex: "#4F4556E1")
    static let hintColor = Color(hex: "#273240")
    static let pureWhite = Color(hex: "#FFFFFF")
    static let mailTypeBg = Color(hex: "#4534AF")
    static let cardBackgroundBg = Color(hex: "#A4AAAAAA")
    static let dividerColor = Color(hex: "#333333")
    static let white30Percent = Color(hex: "#4DFFFFFF")
    static let white60Percent = Color(hex: "#99FFFFFF")
    static let a64Percent = Color(hex: "#A4AAAAAA")
    static let bottomSheetBgColor = Color(hex: "#CCD1EC")
    static let successGreen = Color(hex: "#4CAF50")
    static let errorRed = Color(hex: "#F44336")
    static let cardBg = Color(hex: "#DADDF9")
    static let moreOptionTextColor = Color(hex: "#3C3C3C")
    static let lightBlue = Color(hex: "#DADDF9")
    static let lightBluish = Color(hex: "#D8D8EB")
    static let color70707066 = Color(hex: "#70707066")
    static let selectedColorCode = Color(hex: "#333333")
    static let blockContactColor = Color(hex: "#FF7474")
    static let labelBgColor = Color(hex: "#5C4556E1")
    static let borderColor = Color(hex: "#DBDBDB")
    static let noWhiteColor = Color(hex: "#F6F6FB")
    static let yesRedColor = Color(hex: "#FF0000")
    static let darkBackground = Color(hex: "#121212")
    static let darkText = Color(hex: "#FFFFFF")
    static let darkStatusBar = Color(hex: "#000000")
    
    // Blue Theme
    static let bluePrimary = Color(hex: "#2196F3")
    static let bluePrimaryDark = Color(hex: "#1976D2")
    static let blueAccent = Color(hex: "#448AFF")
    static let blueStatusBar = Color(hex: "#2196F3")
    
    // Green Theme
    static let greenPrimary = Color(hex: "#4CAF50")
    static let greenPrimaryDark = Color(hex: "#388E3C")
    static let greenAccent = Color(hex: "#8BC34A")
    static let greenStatusBar = Color(hex: "#4CAF50")
    
    // Dark Theme
    static let windowBackgroundDark = Color(hex: "#333333")
    static let tabBackground = Color(hex: "#212121")
    static let darkButton = Color(hex: "#424242")
    static let darkButtonSelected = Color(hex: "#323232")
    static let darkPrimary = Color(hex: "#212121")
    
    // Light Theme
    static let lightPrimary = Color(hex: "#8B4513")
    static let lightPrimaryDark = Color(hex: "#FAF9F6")
    static let lightAccent = Color(hex: "#2F2F2F")
    static let lightTabBg = Color(hex: "#8B3B13")
    static let lightButtonSelected = Color(hex: "#FDF5EF")
    static let lightButtonUnselected = Color(hex: "#EFEFEF")
    static let lightStrokeColor = Color(hex: "#707070")
    static let customEditTextColor = Color(hex: "#B3B3B3")
    static let mailAttachmentColor = Color(hex: "#DADDF9")
    
    // Default
    static let defaultPrimaryLight = Color(hex: "#3747C6")
    static let gray = Color(hex: "#EFEFEF")
}

