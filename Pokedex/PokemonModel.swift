//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Nihal Memon on 9/12/22.
//

import Foundation

struct PokemonModel : Decodable, Identifiable{
    var id : Int
    var name : String
    var height : Int
    var weight : Int
    var sprites : PokemonSprite
    var types : [PokemonType]
}

struct PokemonSprite : Decodable{
    var front_default : String
    var back_default : String
    var front_shiny : String
    var back_shiny : String
    var main : String?
}

struct PokemonType : Decodable{
    var type : TypeModel
}

struct TypeModel : Decodable{
    var name : String
}
