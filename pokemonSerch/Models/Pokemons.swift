//
//  Pokemons.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/15.
//

import Foundation

struct Pokemons:Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
    
    func validate() -> Bool {
        return true
    }
}
