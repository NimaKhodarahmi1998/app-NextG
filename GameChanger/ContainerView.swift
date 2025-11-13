//
//  ContainerView.swift
//  GameChanger
//
//  Created by Nima Khodarahmi on 08/11/25.
//

import SwiftUI

struct ContainerView: View {
    var body: some View {
        TabView {
            Tab("Next!", systemImage: "gamecontroller.fill") {
                ContentView()
            }
            
            Tab("Library", systemImage: "books.vertical.fill") {
                LibraryView()
            }
        }
    }
}

#Preview {
    ContainerView()
} 
