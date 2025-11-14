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
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 350, height: 300)
                            .cornerRadius(12)
                    @unknown default:
                        EmptyView()
                        
                        
                        Spacer()

                    }
                    }
                }
                else {
                    Image("GameChangerStartingPage")
                        .edgesIgnoringSafeArea(.all)

                    
                    VStack {
                        Text(message)
                            .foregroundColor(Color.white)
                            .bold(true)
                            //.edgesIgnoringSafeArea(.all)
                            .font(.system(size: 20))
                            .accessibilityLabel("Shake your device for a new game")
                            .padding()
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
                        message = "Shake Again for a New Game"

                    } catch {
                        print ("Error Fetching Games", error)
                        
                    }
                }
            }
            .accessibilityAddTraits(.isButton)
            //.accessibilityLabel("Get New Game")
            //.accessibilityHint("Triple tap to get a new random game suggestion.")
            if let game = currentGame {
                            VStack(alignment: .leading, spacing: 8) {
                                
                                Text(game.name)
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .padding(.top, 10)
                                    .accessibilityHeading(.h1)
                                HStack {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                        .accessibilityHidden (true)
                                    Text("**Rating:** \(game.rating, specifier: "%.2f /5")")
                                        .accessibilityHidden(true)
                                    Spacer()
                                    
                                    Text("**Released:** \(game.released ?? "N/A")")
                                        .accessibilityHidden(true)
                                }
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Rating: \(game.rating, specifier: "%.2f") out of five stars. Released: \(game.released ?? "Information not available")")
                                
                                let platformNames = game.platforms.prefix(4).map { $0.platform.name }.joined(separator: ", ")
                                Text("**Platforms:** \(platformNames)")
                                    .font(.subheadline)
                                    .accessibilityElement(children: .combine)
                                let genreNames = game.genres.map { $0.name }.joined(separator: ", ")
                                Text("**Genres:** \(genreNames)")
                                
                                Spacer()
                                
                                Text ("Shake Again for a New Game")
                                    .accessibilityLabel("Shake Again for a New Game")
                                    .font(.subheadline)
                                    .accessibilityElement(children: .combine)
                                    .padding(.leading, 100)

                                
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: 350, alignment: .leading)
            }
                        
                    }
        }
    }
extension View {
    func onEmulatedShake(perform action: @escaping () -> Void) -> some View {
        self.onTapGesture(count: 3) {
            action()
        }
       
    }
}
#Preview {
    ContentView()
}
