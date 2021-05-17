//
//  PokemonAPIClient.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/16.
//

import Foundation

import Combine

class PokemonAPIClient: ObservableObject {
    private let baseUrl: String = "https://pokeapi.co/api/v2/pokemon"
    
    // ポケモン一覧取得
    func fetchList(page:Int = 0) -> AnyPublisher<Pokemons,Error> {
        // 一度に取得するポケモン数
        let limit: Int = 20
        let url = URL(string: "\(baseUrl)?offset=\(page * limit)&limit=\(limit)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap {element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: Pokemons.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // ポケモン詳細取得
    func fetchDetail(name:String) -> AnyPublisher<PKMPokemon,Error> {
        let url = URL(string: "\(baseUrl)/\(name)")!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap {element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: PKMPokemon.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
}
