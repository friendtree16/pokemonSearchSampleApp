//
//  PokemonListViewModel.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/16.
//

import Foundation
import Combine

class PokemonListViewModel: ObservableObject {
    @Published private(set) var pokemons: Stateful<Pokemons> = .idle
    var localPokemons: Pokemons = Pokemons(count: 0, next: nil, previous: nil, results: [])
    private var cancellables = Set<AnyCancellable>()
    private let pokemonRepository: PokemonRepository
    
    init(pokemonRepository: PokemonRepository = PokemonDataRepository()) {
        self.pokemonRepository = pokemonRepository
    }
    
    // 画面描画時
    func onAppear() {
        loadData()
    }
    
    // リトライ用
    func onRetryButtonTapped() {
        loadData()
    }
    
    // データ追加ロード用
    func fetchMore(page:Int = 0) {
        if self.localPokemons.next != nil  {
            loadData(page: page)
        }
    }
    
    // データ取得用
    private func loadData(page:Int = 0) {
        pokemonRepository.fetchList(page: page)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveSubscription: { [weak self] _ in
                if page == 0 {
                    self?.pokemons = .loading
                }
            })
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                    self?.pokemons = .failed(error)
                case .finished: print("Finished")
                }
            }, receiveValue: { [weak self] pokemons in
                guard let localPokemons = self?.localPokemons else {
                    self?.pokemons = .loaded(pokemons)
                    return
                }
                
                self?.localPokemons = Pokemons(count: pokemons.count, next: pokemons.next, previous: pokemons.previous, results: localPokemons.results + pokemons.results)
                
                if let publishPokemons = self?.localPokemons {
                    self?.pokemons = .loaded(publishPokemons)
                } else {
                    self?.pokemons = .loaded(pokemons)
                }
                
            })
            .store(in: &cancellables)
    }
}
