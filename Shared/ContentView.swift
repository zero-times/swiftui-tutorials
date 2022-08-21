//
//  ContentView.swift
//  Shared
//
//  Created by HOA on 2022/8/21.
//

import SwiftUI

struct ContentView: View {
        
    @State var selected: String = "house"
    
    private let screens = [
        CurvedScreenContainer(title: "Base", imageSystemName: "house", child: Color.red),
        CurvedScreenContainer(title: "Search", imageSystemName: "magnifyingglass", child: Color.blue),
        CurvedScreenContainer(title: "Likes", imageSystemName: "suit.heart.fill", child: Color.yellow),
        CurvedScreenContainer(title: "Developer",imageSystemName: "person.fill", child: Color.orange),
    ]
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
       
        CurvedTabbar<CurvedScreenContainer>(screens: screens, selectedItem: $selected)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 mini")
    }
}
