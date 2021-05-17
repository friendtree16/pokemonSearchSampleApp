//
//  PokemonRepository.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/16.
//

import Foundation
import Combine

protocol PokemonRepository {
    // ポケモン一覧取得
    func fetchList(page:Int) -> AnyPublisher<Pokemons, Error>
    // ポケモン詳細取得
    func fetchDetail(name:String) -> AnyPublisher<PKMPokemon, Error>
}

struct PokemonDataRepository: PokemonRepository {
    func fetchList(page:Int) -> AnyPublisher<Pokemons,Error> {
        PokemonAPIClient().fetchList(page: page)
    }
    
    func fetchDetail(name:String) -> AnyPublisher<PKMPokemon,Error> {
        PokemonAPIClient().fetchDetail(name: name)
    }
}
