//
//  ContentView.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/15.
//

import SwiftUI

struct PokemonListView: View {
    
    @StateObject private var viewModel = PokemonListViewModel()
    @State private var page:Int = 0
    
    var body: some View {
        NavigationView {
            switch viewModel.pokemons {
            case .idle, .loading:
                ProgressView("loading...")
            case let .loaded(pokemons):
                List(pokemons.results, id: \.name) { pokemon in
                    NavigationLink(destination: PokemonDetailView(name: pokemon.name)) {
                        Text(pokemon.name)
                    }
                    .onAppear {
                        // 最後までスクロールしたら、追加で情報をロードする
                        if pokemons.results.last == pokemon {
                            page += 1
                            viewModel.fetchMore(page: self.page)
                        }
                    }
                }
                .navigationTitle("PokemonList")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing){
                        NavigationLink(destination:PokemonSearchView()) {
                            Text("Search")
                        }
                    }
                }
            case .failed:
                ErrorView(viewModel:viewModel)
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        
    }
    
}

private struct ErrorView: View {
    @StateObject var viewModel:PokemonListViewModel
    
    var body: some View{
        VStack {
            Group {
                Text("Failed to load repositories")
                    .padding(.top, 4)
            }
            .foregroundColor(.black)
            .opacity(0.4)
            Button(
                action: {
                    viewModel.onRetryButtonTapped()
                },
                label: {
                    Text("Retry")
                        .fontWeight(.bold)
                }
            )
            .padding(.top, 8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListView()
    }
}
