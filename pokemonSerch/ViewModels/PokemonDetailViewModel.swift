//
//  PokemonDetailViewModel.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/16.
//

import Foundation
import Combine

class PokemonDetailViewModel: ObservableObject {
    @Published private(set) var pokemon: Stateful<PKMPokemon> = .idle
    private var cancellables = Set<AnyCancellable>()
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository = PokemonDataRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    // 画面描画時
    func onAppear(name:String) {
        loadData(name: name)
    }
    
    // リロード用
    func onRetryButtonTapped(name:String) {
        loadData(name: name)
    }
    
    private func loadData(name:String) {
        pokemonRepository.fetchDetail(name: name)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.pokemon = .loading
            })
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                    self?.pokemon = .failed(error)
                case .finished: print("Finished")
                }
            }, receiveValue: { [weak self] pokemon in
                    self?.pokemon = .loaded(pokemon)
                
            })
            .store(in: &cancellables)
    }
    
}
