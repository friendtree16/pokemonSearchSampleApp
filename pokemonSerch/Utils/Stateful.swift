//
//  Stateful.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/15.
//

import Foundation

// データロードステータス
enum Stateful<Value> {
    case idle
    case loading
    case failed(Error)
    case loaded(Value)
}
