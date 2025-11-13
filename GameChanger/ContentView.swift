//
//  ContentView.swift
//  GameChanger
//
//  Created by Nima Khodarahmi on 07/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var message = "Shake your device for a new game!"
    @State private var games: [Game] = []
    @State private var currentGame: Game?
    var body: some View {
        
        
        VStack{
            ZStack{
                
                if let game = currentGame, let imageUrl = game.background_image { AsyncImage(url: URL(string: imageUrl))
                    { phase in switch phase {case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 300)
                            .cornerRadius(12)
                        
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                    @unknown default:
                        EmptyView()
                    }
                    }
                }
                else {
                    Image("GameChangerFirstPage")
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: 450, height: 450)
                    
 
                    VStack {
                        Text(message)
                            .foregroundColor(Color.white)
                            .bold(true)
                            .edgesIgnoringSafeArea(.all)
                            .font(.system(size: 20))
                        Image(systemName: "iphone")
                            .symbolEffect(.wiggle)
                            .font(.system(size: 35))
                            .foregroundColor(Color.white)
                    }
                }
            }.onShake {
                Task {
                    do {let fetchedGames = try await fetchGames()
                        games = fetchedGames
                        currentGame = fetchedGames.randomElement()
                    } catch {
                        print ("Error Fetching Games", error)
                        
                    }
                }
            }
            
        }
        
    }
}
#Preview {
    ContentView()
}
