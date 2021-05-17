//
//  pokemonSerchTests.swift
//  pokemonSerchTests
//
//  Created by 葛 智紀 on 2021/05/15.
//

import XCTest
@testable import pokemonSerch
import Combine

class PokemonListViewTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        cancellables = .init()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_onAppear_正常系() {
        let expectedToBeLoading = expectation(description: "読み込み中のステータスになること")
        let expectedToBeLoaded = expectation(description: "期待通りリポジトリが読み込まれること")
        
        let viewModel = PokemonListViewModel(
            pokemonRepository: MockPokemonRepository(pokemons: .mock1, pokemonDetail: nil)
        )
        
        viewModel.$pokemons.sink { result in
            switch result {
            case .loading: expectedToBeLoading.fulfill()
            case let.loaded(pokemons):
                if pokemons.results.count == 1 &&
                    pokemons.results.map({$0.name}) == [Pokemon.mock1.name] {
                    expectedToBeLoaded.fulfill()
                } else {
                    XCTFail("読み込み失敗")
                }
            default: break
            }
        }.store(in: &cancellables)
        
        viewModel.onAppear()
        
        wait(for: [expectedToBeLoading,expectedToBeLoaded], timeout: 2.0)
    }
    
    func test_onAppear_異常系() {
        let expectedToBeLoading = expectation(description: "読み込み中のステータスになること")
        let expectedToBeFailed = expectation(description: "エラー状態になること")
        
        let viewModel = PokemonListViewModel(
            pokemonRepository: MockPokemonRepository(error: DummyError())
        )
        
        viewModel.$pokemons.sink { result in
            switch result {
            case .loading: expectedToBeLoading.fulfill()
            case let .failed(error):
                if error is DummyError {
                    expectedToBeFailed.fulfill()
                } else {
                    XCTFail("Unexpected: \(result)")
                }
            default: break
            }
        }.store(in: &cancellables)
        
        viewModel.onAppear()
        
        wait(for: [expectedToBeLoading,expectedToBeFailed], timeout: 2.0)
    }
    
    
    
    struct MockPokemonRepository: PokemonRepository {
        let pokemons: Pokemons?
        let pokemonDetail: PKMPokemon?
        let error: Error?

        init(pokemons: Pokemons? = nil, pokemonDetail: PKMPokemon? = nil, error: Error? = nil) {
            self.pokemons = pokemons
            self.pokemonDetail = pokemonDetail
            self.error = error
        }
        
        func fetchList(page: Int) -> AnyPublisher<Pokemons, Error> {
            if let error = error {
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            
            if let pokemons = pokemons {
                return Just(pokemons)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            return Fail(error: DummyError())
                .eraseToAnyPublisher()
        }
        
        func fetchDetail(name: String) -> AnyPublisher<PKMPokemon, Error> {
            if let error = error {
                return Fail(error: error)
                    .eraseToAnyPublisher()
            }
            
            if let pokemonDetail = pokemonDetail {
                return Just(pokemonDetail)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            
            return Fail(error: DummyError())
                .eraseToAnyPublisher()
        }
    }
    struct DummyError: Error {}
}
