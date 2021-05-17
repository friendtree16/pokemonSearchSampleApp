//
//  PokemonSearch.swift
//  pokemonSerch
//
//  Created by 葛 智紀 on 2021/05/16.
//

import SwiftUI

struct PokemonSearchView: View {
    @State private var name:String = ""
    @State private var toNext = false
    @State private var showingAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack{
            TextField("pokemon name",text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                if name.isEmpty {
                    self.errorMessage = "値が未入力です"
                    self.showingAlert = true
                } else {
                    self.toNext = true
                }
            }) {
                Text("検索")
            }
            .alert(isPresented: $showingAlert) {
                        Alert(title: Text(""),
                              message: Text(self.errorMessage),
                              dismissButton: .default(Text("OK")))
                    }
            
            NavigationLink(destination: PokemonDetailView(name: name.lowercased()),isActive:self.$toNext) {
                EmptyView()
            }
        }
    }
}

struct PokemonSearch_Previews: PreviewProvider {
    static var previews: some View {
        PokemonSearchView()
    }
}
