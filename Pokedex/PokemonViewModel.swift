//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Nihal Memon on 9/12/22.
//

import SwiftUI

class PokemonViewModel : ObservableObject{
    @Published var pokemons = [PokemonModel]()
    
    init(){
        for index in 1...650{
            getPokemon(pokemonNumber: index) { thePokemon in
                var imageURL = ""
                if(index < 10){
                    imageURL = "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/00\(index).png"
                }
                else if (index < 100){
                    imageURL = "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/0\(index).png"
                } else {
                    imageURL = "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/\(index).png"
                }
                
                var currentPokemon = thePokemon
                currentPokemon.sprites.main = imageURL
                currentPokemon.name = (currentPokemon.name.first?.uppercased())! + currentPokemon.name.dropFirst()
                currentPokemon.types[0].type.name = (currentPokemon.types[0].type.name.first?.uppercased())! + currentPokemon.types[0].type.name.dropFirst()
              //  print(currentPokemon.sprites.main)
                self.pokemons.append(currentPokemon)
            }
        }
    }
    
    func getPokemon(pokemonNumber : Int, completion: @escaping (PokemonModel) -> ()){
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonNumber)/") else {return}
        
        URLSession.shared.dataTask(with: url){ (data, _,_) in
            guard let data = data else {return}
            
            let fecthedPokemon = try! JSONDecoder().decode(PokemonModel.self, from: data)
            
            DispatchQueue.main.async {
                completion(fecthedPokemon)
            }
        }.resume()
    }
}

