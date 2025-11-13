//
//  APIFetching.swift
//  GameChanger
//
//  Created by Nima Khodarahmi on 11/11/25.
//

import Foundation
import SwiftUI

struct Genre: Codable {
    let name: String
}
struct PlatformItem: Codable {
    let platform: Platform
}
struct Platform: Codable {
    let name: String
}
struct Game: Codable, Identifiable {
    let id: Int
    let name: String
    let released: String?
    let rating: Double
    let genres: [Genre]
    let platforms: [PlatformItem]
    let background_image: String?
}
struct GamesResponse: Codable {
    let results: [Game]
}


func fetchGames() async throws -> [Game] {
    guard let url = URL(string: "https://api.rawg.io/api/games?key=d3c55cab2e13412eb7fe84a3708ce353") else { throw URLError(.badURL)
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    let decodeResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
    return decodeResponse.results
}

func testFetchGames()
{
    Task {
        do {
            let games = try await fetchGames()
            for game in games{print("Game:", game.name, "| Released:", game.released ?? "N/A")
            }
            
        } catch {
            print ("Error Fetching User:", error)
        }
    }
}
