//
//  ContentView.swift
//  GameChanger
//
//  Created by Nima Khodarahmi on 07/11/25.
//

import SwiftUI

struct ContentView: View {
    private func fetchRandomGame() {
        Task {
            do {let fetchedGames = try await fetchGames()
                games = fetchedGames
                currentGame = fetchedGames.randomElement()
                
                
            } catch {
                print ("Error Fetching Games", error)
                
            }
        }
    }
    
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
                            .background(.regularMaterial, in: .rect(cornerRadius: 18))
                            .frame(width: 350, height: 320)
                            .clipShape(.rect(cornerRadius: 20))
                            .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                        
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 320)
                            .cornerRadius(12)
                    @unknown default:
                        EmptyView()
                        
                    }
                    }
                }
                else {
                    Image("GameChangerStartingPage")
                        .edgesIgnoringSafeArea(.all)
                    
                    
                    VStack {
                        
                        Text("Shake your device")
                            .foregroundColor(Color.white)
                            .bold(true)
                            .edgesIgnoringSafeArea(.all)
                            .font(.system(size: 15))
                        
                        Text("or double tap the screen")
                            .foregroundColor(Color.white)
                            .bold(true)
                            .edgesIgnoringSafeArea(.all)
                            .font(.system(size: 15))
                        
                        Text("for a New Game")
                            .foregroundColor(Color.white)
                            .bold(true)
                            .edgesIgnoringSafeArea(.all)
                            .font(.system(size: 15))
                        
                    }.accessibilityElement(children: .combine)
                        .accessibilityLabel("Shake your device or double tap the screen for a new game")
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(100)
                    
                }
            }
            
            if let game = currentGame {
                
                VStack (alignment: .leading) {
                    
                    HStack {
                        
                        Text(game.name)
                            .font(.title)
                            .fontWeight(.heavy)
                            .accessibilityHeading(.h1)
                            

                    }.font(.headline)
                        .foregroundColor(.secondary)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(Text(game.name))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(5)
                    
                    
                    HStack{
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .accessibilityHidden (true)
                        Text("**Rating:** \(game.rating, specifier: "%.2f out of 5")")
                        
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    
                    HStack{
                        
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                            .accessibilityHidden(true)
                        Text("**Released:** \(game.released ?? "N/A")")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    
                    
                    let platformNames = game.platforms.prefix(4).map { $0.platform.name }.joined(separator: ", ")
                    
                    HStack{
                        Image(systemName: "display")
                            .foregroundColor(.blue)
                            .accessibilityHidden(true)
                        Text("**Platforms:** \(platformNames)")
                            .font(.subheadline)
                            .accessibilityElement(children: .combine)
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    
                    HStack{
                        let genreNames = game.genres.map { $0.name }.joined(separator: ", ")
                        
                        Image(systemName: "tag")
                            .foregroundColor(.purple)
                            .accessibilityHidden(true)
                        Text("**Genres:** \(genreNames)")
                    }.frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                    
                    
                    
                }.frame (width: 350, height: 250)
                    .background(.regularMaterial, in: .rect(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.6), radius: 10, y: 5)

                
                Spacer()
                
            }
            
        }.onShake {fetchRandomGame()}
            .accessibilityAddTraits(.isButton)
            .onEmulatedShake { fetchRandomGame() }
    }
}
extension View {
    func onEmulatedShake(perform action: @escaping () -> Void) -> some View {
        self.onTapGesture(count: 2) {
            action()
        }
        
    }
}
#Preview {
    ContentView()
}
