//
//  PokemonDetailView.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/15.
//

import SwiftUI

struct PokemonDetailView: View {
    @StateObject private var viewModel = PokemonDetailViewModel()
    let name: String
    var body: some View {
        VStack {
            switch viewModel.pokemon {
            case .idle, .loading:
                ProgressView("loading...")
            case let .loaded(pokemon):
                if let pokemonName = pokemon.name {
                    Text(pokemonName)
                } else {
                    
                }
            case .failed:
                ErrorView(name: name,viewModel: viewModel)
            }
        }.onAppear {
            viewModel.onAppear(name: name)
        }
    }
}

private struct ErrorView: View {
    let name:String
    @StateObject var viewModel:PokemonDetailViewModel
    
    var body: some View{
        VStack {
            Group {
                Text("ポケモン名を再度確認してください")
                    .padding(.top, 4)
            }
            .foregroundColor(.black)
            .opacity(0.4)
            Button(
                action: {
                    viewModel.onRetryButtonTapped(name: name)
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

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailView(name: "test1")
    }
}
