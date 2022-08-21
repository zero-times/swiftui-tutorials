//
//  CurvedTabbar.swift
//  swiftui tutorials (iOS)
//
//  Created by HOA on 2022/8/21.
//

import Foundation
import SwiftUI

public protocol CurvedTabbarItem: Identifiable {
    var imageSystemName: String { get }
    var title: LocalizedStringKey { get }
}

public struct CurvedTabbar<Screen: View>: View where Screen: CurvedTabbarItem {
    
    private let screens: [Screen]
    
    @Binding var selectedItem: Screen.ID
    
    @State private var centerX: CGFloat = 0
    
    public init(screens: [Screen], selectedItem: Binding<Screen.ID>) {
        self.screens = screens
        _selectedItem = selectedItem
    }
    
    
    public var body: some View {
        
        VStack(spacing: 0) {
            TabView(selection: $selectedItem) {
                
                ForEach(screens) { screen in
                    screen
                        .tag(screen.id)
                        .ignoresSafeArea(.all, edges: .top)
                }
                
            }
            
            HStack(spacing: 0) {
                ForEach(screens) { value in
                    
                    GeometryReader { reader in
                        CurvedTabbarButton(selected: $selectedItem, value: value, centerX: $centerX, rect: reader.frame(in: .global)).onAppear {
                            if value.id == screens.first?.id {
                                centerX = reader.frame(in: .global).midX
                            }
                        }
                    }
                    .frame(width: 70, height: 50)
                    
                    if value.id != screens.last?.id { Spacer(minLength:  0) }
                }
            }
            .padding(.horizontal, 25)
            .padding(.top)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 15 : UIApplication.shared.windows.first?.safeAreaInsets.bottom)
            .background(Color.white.clipShape(CurvedAnimatedShape(centerX: centerX)))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
            .padding(.top, -15)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

fileprivate struct CurvedTabbarButton<Screen: View>: View where Screen: CurvedTabbarItem {
    
    @Binding var selected: Screen.ID
    var value: Screen
    @Binding var centerX:CGFloat
    var rect: CGRect

    var body: some View {
        Button {
            withAnimation {
                selected = value.id
                centerX = rect.midX
            }
        } label: {
        
            VStack {
                Image(systemName: value.imageSystemName)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 26, height: 26)
                    .foregroundColor(selected == value.id ? Color.black : .gray)
            
                Text(value.title)
                    .font(.caption)
                    .foregroundColor(.black)
                    .opacity(selected == value.id ? 1 : 0)
            }
        }
        .padding(.top)
        .frame(width: 70, height: 50)
        .offset(y: selected == value.id ? -15 : 0)

    }
}

fileprivate struct CurvedAnimatedShape: Shape {
    
    var centerX: CGFloat
    
    // animating path ...
    var animatableData: CGFloat {
        get {
           centerX
        }
        set {
            centerX = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 15))
            
            // Curve
            path.move(to: CGPoint(x: centerX - 35, y: 15))
            
            path.addQuadCurve(to: CGPoint(x: centerX + 35, y: 15), control: CGPoint(x: centerX, y: -30))
        }
    }
}

struct CurvedScreenContainer<SCREEN: View>: View, CurvedTabbarItem {

    var id: String {
        imageSystemName
    }

    let imageSystemName: String
    
    let child: SCREEN
    
    let title: LocalizedStringKey
    
    init(title: LocalizedStringKey, imageSystemName: String, child: SCREEN) {
        self.title = title
        self.imageSystemName = imageSystemName
        self.child = child
    }
    
    var body: some View {
        child
    }
}
