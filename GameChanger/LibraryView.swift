//
//  LibraryView.swift
//  GameChanger
//
//  Created by Nima Khodarahmi on 08/11/25.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    
                     HStack{
                        Image(systemName: "iphone")
                        Text ("Nima")
                        
                    }
                        
                        
                    }.navigationTitle(Text("Library"))
                }
            }
        }
    }

#Preview {
    LibraryView()
}
