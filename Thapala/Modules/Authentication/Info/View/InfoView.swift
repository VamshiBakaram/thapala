//
//  InfoView.swift
//  Thapala
//
//  Created by Ahex-Guest on 08/10/24.
//

import SwiftUI

struct InfoView: View {
    @State private var selectedTab: String = "info"
    @State private var expandedSections: Set<String> = []
    @ObservedObject var infoViewViewModel = InfoViewViewModel()
    @ObservedObject var themesviewModel = themesViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var titles: String = ""
    @State var descriptions: String = ""
    @State private var infoItems: [ContentItem] = []
    @State private var faqItems: [FAQCategory] = []
    @State private var faqContentItems: [FAQContent] = []
    @State private var guideItems: [Guide] = []
    @State private var guideContentitems: [GuideContent] = []
    @State private var expandedIndex: Int? = nil
    @State private var expandedIndices: [String: Int?] = [:]  // Dictionary to track expanded index per category
    @State private var isQuickAccessVisible = false
    @State private var isMenuVisible = false

    var body: some View {
        GeometryReader{ reader in
            ZStack {
                VStack {
                    // Top tab buttons
                    HStack {
                        Button {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.backward")
//                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                            
                        }
                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                        .padding(.leading, 20)
                        
                        Spacer()
                    }
                    
                    
                    Spacer()
                    HStack {
                        Button(action: { selectedTab = "info" ;
                            infoViewViewModel.getInfoData(selectedOption: selectedTab)
                            print("titles \(titles)")
                            print("descriptions\(descriptions)")
                            //                    print("infoViewViewModel.guides[0].description \(infoViewViewModel.guides.)")
                        }) {
                            Text("Info")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == "info" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { selectedTab = "FAQ";
                            infoViewViewModel.getFaqData()
                            print("selected FAQ TAB \(selectedTab)")
                            faqItems = infoViewViewModel.faqcontent  // Update state immediately
                            print("FAQ Items Count: \(faqItems.count)") // Check if data is updating
                        }) {
                            
                            Text("FAQ's")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == "FAQ" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .cornerRadius(8)
                        }
                        
                        Button(action: { selectedTab = "Guide" ;
                            print("selected guide TAB \(selectedTab)")
                            infoViewViewModel.getGuideData()
                        }) {
                            Text("Guides")
                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTab == "Guide" ? themesviewModel.currentTheme.customEditTextColor : themesviewModel.currentTheme.customButtonColor)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    
                    ScrollView {
                        if selectedTab == "info"{
                            VStack(spacing: 0) {
                                ForEach(infoItems.indices, id: \.self) { index in
                                    VStack {
                                        // Header Row (Clickable)
                                        HStack {
                                            Image(systemName: expandedIndex == index ? "chevron.down" : "chevron.right")
                                                .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            Text(infoItems[index].title)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                            Spacer()
                                        }
                                        .padding()
                                        //                                .frame(maxWidth: .infinity)
                                        .background(themesviewModel.currentTheme.attachmentBGColor)
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                expandedIndex = expandedIndex == index ? nil : index
                                            }
                                        }
                                        
                                        // Description (Only show when expanded)
                                        if expandedIndex == index {
                                            HTMLTextView(htmlContent: infoItems[index].description)
                                                .foregroundColor(Color.purple)
                                                .frame(maxWidth: .infinity , minHeight: 500)
                                                .padding(.horizontal)
                                                .padding(.bottom, 10)
                                                .transition(.asymmetric(
                                                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                                                    removal: .scale(scale: 0.95).combined(with: .opacity)
                                                ))
                                        }
                                    }
                                    .padding(.horizontal,16)
                                    if index < infoItems.count - 1 {
                                        Rectangle()
                                            .fill(themesviewModel.currentTheme.AllGray) // Background color of divider
                                            .frame(height: 1) // Set divider thickness
                                            .overlay(Divider().background(Color.white)) // Add gray line inside
                                            .padding(.horizontal,16)
                                    }
                                }
                            }
                            .background(themesviewModel.currentTheme.windowBackground)
                        }
                        if selectedTab == "FAQ" {
                            VStack(spacing: 0) {
                                ForEach(faqItems, id: \.heading) { category in
                                    VStack(alignment: .leading, spacing: 0) {
                                        HStack {
                                            Text(category.heading)
                                                .foregroundColor(themesviewModel.currentTheme.textColor)
                                                .font(.headline)
                                                .padding(.leading, 16)
                                            Spacer()
                                        }
                                        .padding(.vertical, 8)
                                        
                                        ForEach(category.content.indices, id: \.self) { index in
                                            VStack(spacing: 0) {
                                                HStack {
                                                    Image(systemName: expandedIndices[category.heading] == index ? "chevron.down" : "chevron.right")
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    Text(category.content[index].title)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                                    Spacer()
                                                }
                                                .padding()
                                                .background(themesviewModel.currentTheme.attachmentBGColor)
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        if expandedIndices[category.heading] == index {
                                                            expandedIndices[category.heading] = nil  // Collapse if already expanded
                                                        } else {
                                                            expandedIndices[category.heading] = index  // Expand only this item in this category
                                                        }
                                                    }
                                                }
                                                
                                                if expandedIndices[category.heading] == index {
                                                    HTMLTextView(htmlContent: category.content[index].description)
                                                        .frame(maxWidth: .infinity, minHeight: 200)
                                                        .padding(.horizontal)
                                                        .padding(.bottom, 10)
                                                }
                                                if index < category.content.count - 1 {
                                                    Rectangle()
                                                        .fill(Color.white) // Background color of divider
                                                        .frame(height: 1) // Set divider thickness
                                                        .overlay(Divider().background(Color.white)) // Add gray line inside
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                    
                                }
                                
                            }
                        }
                        
                        
                        if selectedTab == "Guide"{
                            VStack(spacing: 0) {
                                ForEach(guideItems, id: \.heading) { category in
                                    VStack(alignment: .leading, spacing: 0) {
                                        // Header Row (Clickable)
                                        Text(category.heading)
                                            .font(.headline)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        Spacer().frame(height: 15)
                                        Text(category.description)
                                            .foregroundColor(themesviewModel.currentTheme.textColor)
                                        Spacer().frame(height: 10)
                                        ForEach(category.content.indices, id: \.self) { index in
                                            VStack(spacing: 0) {
                                                HStack {
                                                    Image(systemName: expandedIndex == index ? "chevron.down" : "chevron.right")
                                                        .foregroundColor(themesviewModel.currentTheme.iconColor)
                                                    Text(category.content[index].title)
                                                        .font(.system(size: 16, weight: .medium))
                                                        .foregroundColor(themesviewModel.currentTheme.AllBlack)
                                                    Spacer()
                                                }
                                                .padding()
                                                //.frame(maxWidth: .infinity)
                                                .background(themesviewModel.currentTheme.attachmentBGColor)
                                                .onTapGesture {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        expandedIndex = expandedIndex == index ? nil : index
                                                    }
                                                }
                                                // Description (Only show when expanded)
                                                if expandedIndex == index {
                                                    HTMLTextView(htmlContent: category.content[index].description)
                                                        .frame(maxWidth: .infinity, minHeight: 200)
                                                        .padding(.horizontal)
                                                        .padding(.bottom, 10)
                                                }
                                                if index < category.content.count - 1 {
                                                    Rectangle()
                                                        .fill(Color.white) // Background color of divider
                                                        .frame(height: 1) // Set divider thickness
                                                        .overlay(Divider().background(Color.white)) // Add gray line inside
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                    }
                    
                    VStack {
                        //                        Spacer().frame(height: 100)
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 30)
                                .fill(themesviewModel.currentTheme.colorPrimary)
                                .frame(width: 150, height: 48)
                                .overlay(
                                    HStack {
                                        Text("New Email")
                                            .font(.custom(.poppinsBold, size: 14))
                                            .foregroundColor(themesviewModel.currentTheme.inverseTextColor)
                                            .padding(.trailing, 8)
                                            .onTapGesture {
                                                infoViewViewModel.isComposeEmail = true
                                            }
                                        Spacer()
                                            .frame(width: 1, height: 24)
                                            .background(themesviewModel.currentTheme.inverseIconColor)
                                        Image("dropdown 1")
                                            .foregroundColor(themesviewModel.currentTheme.iconColor)
                                            .onTapGesture {
                                                isQuickAccessVisible = true
                                            }
                                    }
                                )
                                .padding(.trailing, 20)
                                .padding(.bottom, 20)
                        }
                    }
                    
                    
                    TabViewNavigator()
                        .frame(height: 40)
                }
                .background(themesviewModel.currentTheme.windowBackground)
                
                .onAppear {
                    if infoViewViewModel.content.isEmpty {
                        print("Api prints")
                        infoViewViewModel.getInfoData(selectedOption: selectedTab )
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if selectedTab == "info" {
                            print("on Appear info TAB")
                            infoItems = infoViewViewModel.content
                        }
                        
                    }
                    
                }
                .onChange(of: selectedTab) { newTab in
                    if newTab == "FAQ" {
                        print("FAQ Appears")
                        infoViewViewModel.getFaqData() // Fetch FAQ data when tab is selected
                    }
                }
                .onReceive(infoViewViewModel.$faqcontent) { newContent in
                    if selectedTab == "FAQ" {
                        faqItems = newContent
                        print("on Appear FAQ TAB")
                        print("FAQ Items Count: \(faqItems.count)")
                    }
                }
                .onChange(of: selectedTab) { newTab in
                    if newTab == "Guide" {
                        print("Guide Appears")
                        infoViewViewModel.getGuideData() // Fetch FAQ data when tab is selected
                    }
                }
                .onReceive(infoViewViewModel.$guideitems) { newContent in
                    if selectedTab == "Guide" {
                        guideItems = newContent
                        print("on Appear Guide TAB")
                        print("FAQ Items Count: \(guideItems.count)")
                    }
                }
                if isQuickAccessVisible {
                    Color.white.opacity(0.8) // Optional: semi-transparent background
                        .ignoresSafeArea()
                        .blur(radius: 10) // Blur effect for the background
                    QuickAccessView(isQuickAccessVisible: $isQuickAccessVisible)
                        .background(Color.white) // Background color for the Quick Access View
                        .cornerRadius(10)
                        .shadow(radius: 10)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing) // Align at the bottom right
                        .padding([.bottom, .trailing], 20)
                }
                if isMenuVisible{
                    HomeMenuView(isSidebarVisible: $isMenuVisible)
                }
            }
            .zIndex(0)
            .navigationDestination(isPresented: $infoViewViewModel.isComposeEmail) {
                MailComposeView().toolbar(.hidden)
            }
        }
    }
}




struct HTMLTextView: UIViewRepresentable {
    let htmlContent: String
    var textColor: UIColor = .gray  // default color

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.backgroundColor = .clear
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.showsVerticalScrollIndicator = false
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if let attributedString = htmlContent.htmlToAttributedString {
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            mutableAttributedString.addAttributes([
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: textColor
            ], range: NSRange(location: 0, length: mutableAttributedString.length))

            uiView.attributedText = mutableAttributedString
        }
    }
}



#Preview {
    InfoView()
}

